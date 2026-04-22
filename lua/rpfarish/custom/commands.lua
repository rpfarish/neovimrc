local cmds = {}

-- per-filetype (current file)
cmds.python = function()
	return "uv run " .. vim.fn.expand("%")
end

cmds.rust = function()
	return "cargo run"
end

cmds.javascript = function()
	return "node " .. vim.fn.expand("%")
end
cmds.typescript = cmds.javascript

cmds.default = function()
	return nil
end

local M = {}

function M.get()
	local ft = vim.bo.filetype
	return cmds[ft] or cmds.default
end

-- project entry point
function M.main()
	local ft = vim.bo.filetype

	if ft == "python" then
		return "uv run main.py"
	end

	if ft == "rust" then
		return "cargo run"
	end

	return nil
end

return M
