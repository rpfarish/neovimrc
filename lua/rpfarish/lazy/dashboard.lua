return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = {
					" ",
					" ",
					" ",
					"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
					"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
					"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
					"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
					" ",
					" ",
				},
				center = {
					{
						icon = "  ",
						desc = "Find File              ",
						action = "Telescope find_files",
						key = "f",
					},
					{
						icon = "  ",
						desc = "Recent Files           ",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						icon = "  ",
						desc = "Find Word              ",
						action = "Telescope live_grep",
						key = "g",
					},
					{
						icon = "  ",
						desc = "New File               ",
						action = "enew",
						key = "n",
					},
					{
						icon = "  ",
						desc = "Configuration          ",
						action = "e ~/.config/nvim/init.lua",
						key = "c",
					},
					{
						icon = "  ",
						desc = "Quit Neovim            ",
						action = "qa",
						key = "q",
					},
				},
				footer = {
					" ",
					"🚀 Have a nice coding session!",
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
