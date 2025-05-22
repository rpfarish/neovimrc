return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = {
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
					"🏞️ To go touch grass, please press :q (or ZZ 💪 like a real man).",
				},
				shortcut_type = "letter",
				mru = {
					cwd_only = true,
				},
				shortcut = {
					{
						desc = "󰢻 Config", -- Cog/gear icon for configuration
						group = "Define",
						action = "edit ~/.config/nvim/lua/rpfarish/lazy/init.lua",
						key = "c",
					},
					{
						desc = "󰈔 Files", -- Document/file icon
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = "󰒲 Lazy", -- Download/package icon
						group = "Number",
						action = "Lazy",
						key = "l",
					},
					{
						desc = "󰒋 Mason", -- Box/package icon
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
-- 󰌵 (language/code icon)
-- 󰅩 (bracket/code icon)
-- 󱐋 (tools/wrench icon)
-- 󰍉 (diagnostic/check icon)
-- 󰛥 (
-- 󰒋
-- 󰏔
