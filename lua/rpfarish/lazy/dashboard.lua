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
				project = {
					limit = 2,
					enable = true,
				},
				mru = {
					limit = 7,
					cwd_only = true,
				},
				shortcut = {
					{
						desc = "󰢻 Config",
						group = "Define",
						action = function()
							vim.cmd("cd ~/.config/nvim")
							vim.cmd("edit lua/rpfarish/lazy/init.lua")
						end,
						key = "c",
					},
					{
						desc = "󰈔 New File",
						group = "Label",
						action = "enew",
						key = "n",
					},
					{
						desc = "󰒲 Lazy",
						group = "Number",
						action = "Lazy",
						key = "l",
					},
					{
						desc = "󰒋 Mason",
						group = "@property",
						action = "Mason",
						key = "m",
					},
				},
			},
		})

		-- Additional filter to prevent ~ from being added to projects list
		vim.api.nvim_create_autocmd("User", {
			pattern = "DashboardReady",
			callback = function()
				-- This hooks into the dashboard after it's loaded
				local home = vim.fn.expand("~")
				vim.v.oldfiles = vim.tbl_filter(function(file)
					return not vim.startswith(file, home .. "/.") and file ~= home
				end, vim.v.oldfiles or {})
			end,
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
