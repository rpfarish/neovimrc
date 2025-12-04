return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Documents/obsidian/notes/",
				},
				-- {
				-- 	name = "work",
				-- 	path = "~/vaults/work",
				-- },
			},
		},
	},
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
		keys = {
			{ "<leader>mp", ":Glow<CR>", desc = "Markdown Preview with Glow" },
		},
	},
	-- {
	-- "iamcco/markdown-preview.nvim",
	-- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- build = "cd app && npm install",
	-- init = function()
	-- 	vim.g.mkdp_filetypes = { "markdown" }
	-- end,
	-- ft = { "markdown" },
	-- keys = {
	-- 	{ "<leader>mP", ":MarkdownPreview<CR>", desc = "Markdown Preview" },
	-- 	{ "<leader>ms", ":MarkdownPreviewStop<CR>", desc = "Markdown Stop" },
	-- 	{ "<leader>mT", ":MarkdownPreviewToggle<CR>", desc = "Markdown Toggle" },
	-- },
	-- },
	{
		enabled = false,
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
