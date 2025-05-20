return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
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
						key_format = "[%s]",
					},
					{
						icon = "  ",
						desc = "Recent Files           ",
						action = "Telescope oldfiles",
						key = "r",
						key_format = "[%s]",
					},
					{
						icon = "  ",
						desc = "Find Word              ",
						action = "Telescope live_grep",
						key = "g",
						key_format = "[%s]",
					},
					{
						icon = "  ",
						desc = "New File               ",
						action = "enew",
						key = "n",
						key_format = "[%s]",
					},
					{
						icon = "  ",
						desc = "Configuration          ",
						action = "e ~/.config/nvim/init.lua",
						key = "c",
						key_format = "[%s]",
					},
					{
						icon = "  ",
						desc = "Quit Neovim            ",
						action = "qa",
						key = "q",
						key_format = "[%s]",
					},
				},
				footer = {
					" ",
					"🚀 Have a nice coding session!",
				},
				shortcut_type = "letter",
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = " Lazy",
						group = "Number",
						action = "Lazy",
						key = "l",
					},
					{
						desc = " Mason",
						group = "@property",
						action = "Mason",
						key = "m",
					},
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
