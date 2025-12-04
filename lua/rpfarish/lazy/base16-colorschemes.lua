return {
	{
		"RRethy/base16-nvim",
		lazy = true,
		-- config = function()
		-- 	vim.cmd.colorscheme("base16-rose-pine")
		-- end,
	},
	{
		lazy = true,
		"nvim-telescope/telescope.nvim",
		-- Set your default base16 colorscheme
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>l", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme picker" },
		},
		config = function()
			require("telescope").setup({
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
			})
		end,
	},
}
