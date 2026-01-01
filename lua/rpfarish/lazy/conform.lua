return { -- Autoformat
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
				return { timeout_ms = 500, lsp_format = "never" }
			end
			return nil
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			markdown = { "prettierd" },
			css = { "prettierd" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			typescript = { "prettierd" },
			jsonc = { "prettierd" },
			json = { "prettierd" },
			python = { "ruff_check", "ruff_format" },
			rust = { "rustfmt" },
			toml = { "taplo" },
		},

		formatters = {
			ruff_check = {
				command = "ruff",
				args = {
					"check",
					"--select",
					"I,F", -- I=imports, F=pyflakes (unused imports/vars)
					"--fix",
					"--stdin-filename",
					"$FILENAME",
					"-",
				},
				stdin = true,
			},
		},
	},
}
