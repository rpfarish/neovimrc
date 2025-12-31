return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	event = "VeryLazy", -- Load later in the startup process
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		--  - g[(  - [G]o to left [(] open paren
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		require("mini.move").setup({
			mappings = {
				-- Move visual selection in Visual mode
				right = "<C-A-l>",
				left = "<C-A-h>",
				down = "<C-A-j>",
				up = "<C-A-k>",

				-- Move current line in Normal mode
				line_left = "<C-A-h>",
				line_right = "<C-A-l>",
				line_down = "<C-A-j>",
				line_up = "<C-A-k>",
			},
		})

		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			local mode = vim.fn.mode()
			local recording = vim.fn.reg_recording()
			local rec_status = recording ~= "" and " REC @" .. recording or ""

			-- Show line count in visual modes
			if mode:match("[vV\22]") then -- v, V, or Ctrl-V
				local starts = vim.fn.line("v")
				local ends = vim.fn.line(".")
				local lines = ends - starts + (ends >= starts and 1 or -1)
				return "%2l:%-2v [" .. lines .. "]" .. rec_status
			end

			return "%2l:%-2v" .. rec_status
		end
	end,
}
