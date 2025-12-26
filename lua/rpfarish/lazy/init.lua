return {
	"tpope/vim-sleuth",

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>pf", desc = "Search [P]roject [F]iles" },
			{ "<C-p>", desc = "Search Git [P]roject Files" },
			{ "<leader>sh", desc = "[S]earch [H]elp" },
			{ "<leader>sk", desc = "[S]earch [K]eymaps" },
			{ "<leader>sf", desc = "[S]earch [F]iles" },
			{ "<leader>ss", desc = "[S]earch [S]elect Telescope" },
			{ "<leader>sw", desc = "[S]earch current [W]ord" },
			{ "<leader>sg", desc = "[S]earch by [G]rep" },
			{ "<leader>sd", desc = "[S]earch [D]iagnostics" },
			{ "<leader>sr", desc = "[S]earch [R]esume" },
			{ "<leader>s.", desc = '[S]earch Recent Files ("." for repeat)' },
			{ "<leader><leader>", desc = "[ ] Find existing buffers" },
			{ "<leader>/", desc = "[/] Fuzzily search in current buffer" },
			{ "<leader>s/", desc = "[S]earch [/] in Open Files" },
			{ "<leader>sn", desc = "[S]earch [N]eovim files" },
			{ "<leader>l", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme picker" },
			{ "<leader>:", desc = "Command history" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Search [P]roject [F]iles" })
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search Git [P]roject Files" })

			-- Command history with telescope (replaces q:)
			vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command history" })

			-- Add this in your telescope config section, after the other keymaps
			vim.keymap.set("n", "<leader>gi", function()
				local word = vim.fn.expand("<cword>")
				local filetype = vim.bo.filetype

				-- definition patterns by language
				local patterns = {
					python = "^\\s*(def|class) " .. word,
					javascript = "^\\s*(function|const|let|var|class) " .. word,
					typescript = "^\\s*(function|const|let|var|class|interface|type) " .. word,
					lua = "^\\s*(function|local function) .*" .. word,
					rust = "^\\s*(fn|struct|enum|trait|impl) " .. word,
					c = "^\\s*\\w+\\s+" .. word .. "\\s*\\(",
					cpp = "^\\s*\\w+\\s+" .. word .. "\\s*\\(",
				}

				local pattern = patterns[filetype] or word

				builtin.live_grep({
					default_text = pattern,
					prompt_title = "find definition: " .. word,
					attach_mappings = function(prompt_bufnr, map)
						local actions = require("telescope.actions")
						local action_state = require("telescope.actions.state")

						-- Override the default select action
						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()

							if not selection then
								actions.close(prompt_bufnr)
								return
							end

							local target_file = selection.filename

							-- Close telescope first
							actions.close(prompt_bufnr)

							-- Schedule everything after Telescope is fully closed
							vim.schedule(function()
								-- Open the file in a buffer without switching to it
								vim.fn.bufadd(target_file)
								vim.fn.bufload(target_file)

								vim.notify(
									"Loaded buffer: " .. vim.fn.fnamemodify(target_file, ":t"),
									vim.log.levels.INFO
								)

								-- Wait for LSP to process the buffer, then trigger completion
								vim.defer_fn(function()
									-- Make sure we're in insert mode for completion
									if vim.fn.mode() ~= "i" then
										vim.cmd("startinsert!")
									end
									require("blink.cmp").show()
								end, 300) -- Increased delay slightly
							end)
						end)

						return true
					end,
				})
			end, { desc = "[g]oto definition via [f]ind" })

			require("telescope").setup({
				defaults = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							width = 0.99,
							height = 0.99,
							preview_width = 0.5,
						},
					},
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
						layout_strategy = "vertical",
						layout_config = {
							height = 0.35,
							width = 0.50,
							prompt_position = "top",
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"mfussenegger/nvim-lint",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			{
				"saghen/blink.cmp",
				dependencies = "rafamadriz/friendly-snippets",
				version = "*",
				opts = {
					keymap = {
						preset = "default", -- Keep <C-y> for accepting
						-- Tab does "soft" accept - only accepts if completion menu is visible
						["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
						["<CR>"] = { "select_and_accept", "snippet_forward", "fallback" },
						["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
					},
					appearance = {
						use_nvim_cmp_as_default = true,
						nerd_font_variant = "mono",
					},
					sources = {
						default = { "lsp", "path", "snippets", "buffer" },
					},
					completion = {
						accept = {
							auto_brackets = {
								enabled = true,
							},
						},
						menu = {
							draw = {
								treesitter = { "lsp" },
							},
						},
						documentation = {
							auto_show = true,
							auto_show_delay_ms = 200,
						},
					},
					signature = {
						enabled = true,
					},
				},
				opts_extend = { "sources.default" },
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("rpfarish-lsp-attach", { clear = true }),
				callback = function(event)
					-- print("attaching lsp!!!")
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Find references for the word under your cursor.
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- Highlight same words on hover
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("rpfarish-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("rpfarish-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "rpfarish-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
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
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				marksman = {
					filetypes = { "markdown", "md" },
				},
				markdownlint = {},
				isort = {},
				black = {},
				clangd = {},
				autopep8 = {},
				prettierd = {},
				prettier = {},
				-- ty = {},
				ruff = { -- Add ruff server configuration
					cmd = { "ruff", "server" },
					settings = {
						ruff = {
							lint = {
								select = {
									"E", -- pycodestyle errors
									"W", -- pycodestyle warnings
									"F", -- pyflakes
									"I", -- isort
									"N", -- pep8-naming
									"UP", -- pyupgrade
									"ANN", -- flake8-annotations
									"B", -- flake8-bugbear
									"A", -- flake8-builtins
									"COM", -- flake8-commas
									"C4", -- flake8-comprehensions
									"DTZ", -- flake8-datetimez
									"T10", -- flake8-debugger
									"EM", -- flake8-errmsg
									"ISC", -- flake8-implicit-str-concat
									"ICN", -- flake8-import-conventions
									"G", -- flake8-logging-format
									"PIE", -- flake8-pie
									"T20", -- flake8-print
									"PT", -- flake8-pytest-style
									"Q", -- flake8-quotes
									"RSE", -- flake8-raise
									"RET", -- flake8-return
									"SLF", -- flake8-self
									"SIM", -- flake8-simplify
									"TID", -- flake8-tidy-imports
									"ARG", -- flake8-unused-arguments
									"PTH", -- flake8-use-pathlib
									"PL", -- pylint
									"TRY", -- tryceratops
									"RUF", -- ruff-specific rules
									"NPY201", -- numpy 2.0 migration rules
								},
							},
							-- Optional: Add custom Ruff settings here
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "workspace",
								typeCheckingMode = "standard",
								autoImportCompletions = true,
								indexing = true,
								-- Prefer original definitions
								importFormat = "absolute",
								completeFunctionParens = true,
							},
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
							procMacro = {
								enable = true,
							},
							inlayHints = {
								chainingHints = { enable = true },
								parameterHints = { enable = true },
								typeHints = { enable = true },
							},
						},
					},
				},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				ts_ls = {},
				--

				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnostics = {
								globals = { "vim" }, -- Recognize 'vim' global
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"autopep8",
				"black",
				"clangd",
				"cssls",
				"isort",
				"lemminx",
				-- "lua_ls",
				"markdownlint",
				"marksman",
				"prettier",
				"prettierd",
				"pyright",
				"ruff",
				"rust_analyzer",
				"stylelint",
				"stylua",
				"ts_ls",
				"xmlformatter",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			-- Add this to your plugin setup

			-- Then in your config:
			require("lint").linters_by_ft = {
				markdown = { "markdownlint" },
			}

			-- Auto-trigger linting
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						-- Skip lua_ls here, we'll set it up manually
						if server_name == "lua_ls" then
							return
						end
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
			require("mason").setup({
				PATH = "append", -- Prioritize system packages over Mason's
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { awk = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 5000,
						lsp_format = "never",
					}
				end
			end,
			format_after_save = function(bufnr)
				local enable_filetypes = { awk = true }
				if enable_filetypes[vim.bo[bufnr].filetype] then
					return { timeout_ms = 5000, lsp_format = "never" }
				end
				return nil
			end,
			formatters_by_ft = {
				markdown = { "prettierd", "prettier" },
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = { "autopep8", "isort", "black" },
				c = { "clangd" },
				rust = { "rustfmt" },
				-- You can use 'stop_after_first' to run the first available formatter from the list
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				xml = { "xmlformatter" },
				json = { "prettierd", "prettier", stop_after_first = true },
				awk = { "awk" },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				toml = { "prettierd", "prettier", stop_after_first = true },
			},

			formatters = {
				awk = {
					command = "gawk",
					args = { "-o-", "-f", "$FILENAME" },
				},
			},
		},
	},

	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "InsertEnter", -- Only load when actually entering insert mode
		version = "1.*",

		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				event = "InsertEnter",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			-- snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },

			signature = {
				implementation = "lua",
				use_typo_resistance = true,
				use_frecency = true,
				use_proximity = true,
				-- This enables more flexible matching
				max_items = 200,
			},
		},
	},

	-- {
	-- 	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000, -- Make sure to load this before all the other start plugins.
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("tokyonight").setup({
	-- 			styles = {
	-- 				comments = { italic = false },
	-- 				-- sidebars = "transparent",
	-- 				-- floats = "transparent",
	-- 			},
	-- 		})
	--
	-- 		-- 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
	-- 		vim.cmd.colorscheme("tokyonight-night")
	-- 	end,
	-- },

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		event = "VeryLazy", -- Load later in the startup process
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			require("mini.move").setup({
				mappings = {
					-- Move visual selection in Visual mode
					left = "<C-A-h>",
					right = "<C-A-l>",
					down = "<C-A-j>",
					up = "<C-A-k>",

					-- Move current line in Normal mode
					line_left = "<C-A-h>",
					line_right = "<C-A-l>",
					line_down = "<C-A-j>",
					line_up = "<C-A-k>",
				},
			})

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				local recording = vim.fn.reg_recording()
				local rec_status = recording ~= "" and " REC @" .. recording or ""
				return "%2l:%-2v" .. rec_status
			end
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"python",
					"rust",
					"css",
					"cpp",
					"c",
					"javascript",
					"typescript",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
				},
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	require("rpfarish.lazy.todo-comments"),
	require("rpfarish.lazy.harpoon"),
	require("rpfarish.lazy.undotree"),
	require("rpfarish.lazy.indent-blankline"),
	require("rpfarish.lazy.dashboard"),
	require("rpfarish.lazy.tjoil"),
	require("rpfarish.lazy.trouble"),
	require("rpfarish.lazy.autopairs"),
	require("rpfarish.lazy.markdown"),
	require("rpfarish.lazy.ufo"),
	require("rpfarish.lazy.base16-colorschemes"),
	require("rpfarish.lazy.rosepine"),
	require("rpfarish.lazy.vim-be-good"),
	require("rpfarish.lazy.which-key"),
	require("rpfarish.lazy.git-signs"),
	-- require("rpfarish.lazy.git-signs-oil"),
	-- require("rpfarish.lazy.oil-git"),
	-- require("rpfarish.lazy.oil-diag"),
}
