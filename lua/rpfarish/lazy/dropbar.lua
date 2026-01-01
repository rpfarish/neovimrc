return {
	"Bekaboo/dropbar.nvim",
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	config = function()
		local dropbar = require("dropbar")
		local dropbar_api = require("dropbar.api")
		vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
		vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

		dropbar.setup({
			sources = {
				path = {
					enable = true, -- remove file path entirely
				},
				lsp = {
					max_depth = 4,
					valid_symbols = {
						-- High-signal only
						"Namespace",
						"Class",
						"Method",
						"Function",
						"Constructor",
						"Field",
						"Property",
						"Variable",
						"Constant",
					},
				},
			},
			icons = {
				kinds = {
					symbols = {
						Folder = "",
					},
				},
			},
		})
	end,
}
