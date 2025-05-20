-- lsp_cache.lua - Create this as a new file in your Neovim config directory
local M = {}

-- Cache directory for LSP state
local cache_dir = vim.fn.stdpath("cache") .. "/lsp_workspace_cache/"

-- Ensure cache directory exists
vim.fn.mkdir(cache_dir, "p")

-- Table to track active servers and their states
M.server_states = {}

-- Setup LSP with caching
function M.create_enhanced_setup(original_setup)
	return function(server_name, config)
		-- Default config if none provided
		config = config or {}

		-- Cache file path for this server
		local cache_file = cache_dir .. server_name .. ".json"

		-- Add initialization options if not present
		config.init_options = config.init_options or {}

		-- Try to load cached state
		local cached_state = nil
		if vim.fn.filereadable(cache_file) == 1 then
			local content = vim.fn.readfile(cache_file)
			local ok, decoded = pcall(vim.fn.json_decode, table.concat(content, "\n"))
			if ok and decoded then
				cached_state = decoded

				-- Apply cached state to initialization options
				if cached_state.workspaceFolders then
					config.init_options.workspaceFolders = cached_state.workspaceFolders
				end

				if cached_state.configuration then
					config.init_options.configuration = cached_state.configuration
				end
			end
		end

		-- Add on_exit handler to save state
		local original_on_exit = config.on_exit
		config.on_exit = function(code, signal, client_id)
			-- Save state before server exits
			if M.server_states[server_name] then
				local state_to_save = {
					workspaceFolders = M.server_states[server_name].workspaceFolders,
					configuration = M.server_states[server_name].configuration,
				}

				local encoded = vim.fn.json_encode(state_to_save)
				vim.fn.writefile({ encoded }, cache_file)
			end

			-- Call original handler if it exists
			if original_on_exit then
				original_on_exit(code, signal, client_id)
			end
		end

		-- Track state changes with callbacks
		local original_on_attach = config.on_attach
		config.on_attach = function(client, bufnr)
			-- Initialize state tracking
			M.server_states[server_name] = {
				client_id = client.id,
				workspaceFolders = client.workspaceFolders,
				configuration = {},
			}

			-- Call original handler if it exists
			if original_on_attach then
				original_on_attach(client, bufnr)
			end
		end

		-- Register capability for workspace configuration changes
		config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
		config.capabilities.workspace = config.capabilities.workspace or {}
		config.capabilities.workspace.configuration = true
		config.capabilities.workspace.didChangeConfiguration = { dynamicRegistration = true }

		-- Set up notification handler for configuration changes
		config.handlers = config.handlers or {}
		config.handlers["workspace/configuration"] = function(err, result, ctx)
			if M.server_states[server_name] then
				M.server_states[server_name].configuration = result
			end
			return result
		end

		-- Call the original setup function with our enhanced config
		return original_setup(server_name, config)
	end
end

return M
