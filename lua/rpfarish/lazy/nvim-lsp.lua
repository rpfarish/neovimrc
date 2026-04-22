return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"mfussenegger/nvim-lint",
			{ "j-hui/fidget.nvim", opts = {} },
			{
				"saghen/blink.cmp",
				event = "InsertEnter",
				version = "*",
				dependencies = { "folke/lazydev.nvim" },
				opts = {
					keymap = {
						preset = "default",
						["<Tab>"] = { "select_and_accept", "fallback" },
						["<CR>"] = { "select_and_accept", "fallback" },
						["<S-Tab>"] = { "select_prev", "fallback" },
					},
					sources = {
						default = { "lsp", "path", "buffer", "lazydev" },
						providers = {
							lazydev = {
								module = "lazydev.integrations.blink",
								score_offset = 100,
							},
						},
					},
					completion = {
						menu = { draw = { treesitter = { "lsp" } } },
						documentation = {
							auto_show = true,
							auto_show_delay_ms = 200,
						},
					},
					signature = { enabled = true },
					fuzzy = { implementation = "prefer_rust_with_warning" },
				},
				opts_extend = { "sources.default" },
			},
		},
		config = function()
			local highlight_group = vim.api.nvim_create_augroup("rpfarish-lsp-highlight", { clear = true })
			local attach_group = vim.api.nvim_create_augroup("rpfarish-lsp-attach", { clear = true })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = attach_group,
				callback = function(event)
					local buf = event.buf

					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
					end

					-- Keymaps
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- === Document Highlight (0.12 correct) ===
					local has_highlight = false
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
						if client.server_capabilities.documentHighlightProvider then
							has_highlight = true
							break
						end
					end

					if has_highlight then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = buf,
							group = highlight_group,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = buf,
							group = highlight_group,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							buffer = buf,
							callback = function()
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = highlight_group,
									buffer = buf,
								})
							end,
						})
					end

					-- === Inlay Hints (0.12 API) ===
					local has_inlay = false
					for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
						if client.server_capabilities.inlayHintProvider then
							has_inlay = true
							break
						end
					end

					if has_inlay then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
								{ bufnr = buf }
							)
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostics
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				marksman = { filetypes = { "markdown", "md" } },
				clangd = {},
				ruff = { cmd = { "ruff", "server" } },
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = { command = "clippy" },
							procMacro = { enable = true },
						},
					},
				},
				ts_ls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
						},
					},
				},
				taplo = {},
			}

			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
			})

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("lint").linters_by_ft = {
				markdown = { "markdownlint" },
				css = { "stylelint" },
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.config(server_name, server)
						vim.lsp.enable(server_name)
					end,
				},
			})

			require("mason").setup({
				PATH = "append",
				ui = {
					border = "rounded",
				},
			})
		end,
	},
}
