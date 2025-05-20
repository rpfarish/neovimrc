return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	opts = {
		-- Oil will take over directory buffers (e.g. `vim .` or `:e /some/path/`)
		default_file_explorer = true,

		-- Id is automatically added at the beginning, and name at the end
		-- See :help oil-columns
		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtime",
		},

		-- Buffer-local options to use for oil buffers
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},

		-- Window-local options to use for oil buffers
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},

		-- Send deleted files to trash instead of permanently deleting them
		delete_to_trash = true,

		-- Skip the confirmation popup for simple operations
		skip_confirm_for_simple_edits = false,

		-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
		prompt_save_on_select_new_entry = true,

		-- Oil will automatically delete hidden buffers after this delay
		-- Set to false to disable cleanup
		cleanup_delay_ms = 2000,

		-- Keymaps in oil buffer. Can be a function(bufnr)
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			-- ["<C-h>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			-- ["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},

		-- Set to false to disable all of the above keymaps
		use_default_keymaps = true,

		view_options = {
			show_preview = true,
			-- Show files and directories that start with "."
			show_hidden = false,
			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function(name, bufnr)
				return false
			end,
			sort = {
				-- sort order can be "asc" or "desc"
				-- see :help oil-columns to see which columns are sortable
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},

		-- Configuration for the floating window in oil.open_float
		float = {
			-- Padding around the floating window
			padding = 2,
			max_width = 0,
			max_height = 0,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- This is the config that will be passed to nvim_open_win.
			-- Override any of the values above by adding them to this table
			override = function(conf)
				return conf
			end,
		},

		-- Configuration for the actions floating preview window
		preview = {
			-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_width and max_width can be a single value or a list of mixed integer/float types.
			-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
			max_width = 0.9,
			-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
			min_width = { 40, 0.4 },
			-- optionally define an integer/float for the exact width of the preview window
			width = nil,
			-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- min_height and max_height can be a single value or a list of mixed integer/float types.
			-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
			max_height = 0.9,
			-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
			min_height = { 5, 0.1 },
			-- optionally define an integer/float for the exact height of the preview window
			height = nil,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
			-- Whether the preview window is automatically updated when the cursor is moved
			update_on_cursor_moved = true,
		},

		-- Configuration for the progress notification
		progress = {
			-- How frequently to update the progress notification
			update_rate = 100,
			-- The minimum progress needed to show the progress notification
			min_progress = 0.1,
			-- Whether to show a progress notification for copy/move operations
			show_progress = true,
		},

		config = function(_, opts)
			-- Create a keymap to toggle the oil file explorer
			vim.keymap.set("n", "\\", function()
				require("oil").toggle_float()
			end, { desc = "Toggle Oil File Explorer" })
			require("oil").setup(opts)
		end,
	},
}
