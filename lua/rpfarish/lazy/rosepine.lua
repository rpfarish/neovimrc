return {
	"rose-pine/neovim",
	lazy = false,
	name = "rose-pine-moon",
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			highlight_groups = {
				Comment = { italic = false },
			},
		})
		vim.cmd("colorscheme rose-pine-moon")
	end,
}
