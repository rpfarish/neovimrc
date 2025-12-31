return {
	"rose-pine/neovim",
	lazy = false,
	priority = 1000,
	name = "rose-pine-moon",
	config = function()
		require("rose-pine").setup({
			highlight_groups = {
				Comment = { italic = false },
			},
		})
		vim.cmd("colorscheme rose-pine-moon")
	end,
}
