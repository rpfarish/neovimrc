return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	keys = {
		{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Search [P]roject [F]iles" },
		{ "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Search Git [P]roject Files" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
		{ "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "[S]earch [S]elect Telescope" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
		{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
		{ "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
		{ "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
		{ "<leader>l", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme picker" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
		-- Custom keymaps that need functions
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_ivy({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},
		{ "<leader>gd", desc = "[G]rep Git [D]iff" }, -- Setup in config
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Setup telescope FIRST (before setting keymaps)
		require("telescope").setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						width = 0.99,
						height = 0.99,
						preview_width = 0.45,
					},
				},
			},
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
				diagnostics = {
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							width = 0.99,
							height = 0.99,
							preview_width = 0.4,
						},
					},
					line_width = "full",
					trim_text = false,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Load extensions
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- Only set the git diff keymap here (complex custom picker)
		vim.keymap.set("n", "<leader>gd", function()
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local action_state = require("telescope.actions.state")
			local actions = require("telescope.actions")
			local entry_display = require("telescope.pickers.entry_display")

			local diff_output = vim.fn.systemlist("git diff --unified=0")
			local results = {}
			local current_file = nil
			local current_line = nil

			for _, line in ipairs(diff_output) do
				if line:match("^%+%+%+ b/(.+)") then
					current_file = line:match("^%+%+%+ b/(.+)")
				elseif line:match("^@@") then
					local new_line = line:match("%+(%d+)")
					if new_line then
						current_line = tonumber(new_line)
					end
				elseif line:match("^%+") and not line:match("^%+%+%+") and current_file and current_line then
					local content = line:sub(2)
					if content:match("%S") then
						table.insert(results, {
							file = current_file,
							lnum = current_line,
							text = content,
						})
					end
					current_line = current_line + 1
				elseif line:match("^%-") and not line:match("^%-%-%-") then
					-- Don't increment for removed lines
				elseif current_line and not line:match("^[@@+%-%\\]") then
					current_line = current_line + 1
				end
			end

			if #results == 0 then
				print("No changes found in git diff")
				return
			end

			local displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 30 },
					{ width = 6 },
					{ remaining = true },
				},
			})

			local make_display = function(entry)
				return displayer({
					entry.filename,
					{ entry.lnum, "TelescopeResultsLineNr" },
					entry.text,
				})
			end

			pickers
				.new({}, {
					prompt_title = "Git Diff Changes (type to filter)",
					finder = finders.new_table({
						results = results,
						entry_maker = function(entry)
							return {
								value = entry,
								display = make_display,
								ordinal = entry.text,
								filename = entry.file,
								lnum = entry.lnum,
								text = entry.text,
							}
						end,
					}),
					previewer = conf.grep_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, map)
						actions.select_default:replace(function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.cmd("edit +" .. selection.lnum .. " " .. selection.filename)
							vim.cmd("normal! zz")
						end)

						-- Helper function to send to quickfix (DRY)
						local function send_to_qflist(get_entries_fn)
							local qf_entries = get_entries_fn()
							vim.fn.setqflist(qf_entries, "r")
							actions.close(prompt_bufnr)
							vim.cmd("copen")
							print(string.format("Sent %d results to quickfix", #qf_entries))
						end

						-- Send filtered to quickfix
						local function get_filtered_entries()
							local current_picker = action_state.get_current_picker(prompt_bufnr)
							local qf_entries = {}
							for entry in current_picker.manager:iter() do
								table.insert(qf_entries, {
									filename = entry.filename,
									lnum = entry.lnum,
									text = entry.text,
								})
							end
							return qf_entries
						end

						map({ "i", "n" }, "<C-q>", function()
							send_to_qflist(get_filtered_entries)
						end)

						-- Send selected to quickfix
						local function get_selected_entries()
							local picker = action_state.get_current_picker(prompt_bufnr)
							local selections = picker:get_multi_selection()
							local qf_entries = {}

							if #selections == 0 then
								local selection = action_state.get_selected_entry()
								table.insert(qf_entries, {
									filename = selection.filename,
									lnum = selection.lnum,
									text = selection.text,
								})
							else
								for _, selection in ipairs(selections) do
									table.insert(qf_entries, {
										filename = selection.filename,
										lnum = selection.lnum,
										text = selection.text,
									})
								end
							end
							return qf_entries
						end

						map({ "i", "n" }, "<M-q>", function()
							send_to_qflist(get_selected_entries)
						end)

						return true
					end,
				})
				:find()
		end, { desc = "[G]rep Git [D]iff" })
	end,
}
