return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		local npairs = require("nvim-autopairs")

		npairs.setup({
			check_ts = true,
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			enable_moveright = true,
		})

		-- Simpler fallback function that doesn't use treesitter
		local function find_unmatched_close_paren_simple()
			local bufnr = vim.api.nvim_get_current_buf()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			row = row - 1 -- Convert to 0-indexed

			-- Get lines from current position to end of file
			local num_lines = vim.api.nvim_buf_line_count(bufnr)
			local lines = vim.api.nvim_buf_get_lines(bufnr, row, num_lines, false)
			if #lines == 0 then
				return false
			end

			-- Modify first line to start from cursor position
			lines[1] = lines[1]:sub(col + 1)

			local stack = 0
			for l = 1, #lines do
				local text = lines[l]
				for i = 1, #text do
					local c = text:sub(i, i)
					if c == "(" then
						stack = stack + 1
					elseif c == ")" then
						if stack == 0 then
							local result_row = row + l
							local result_col = i
							if l == 1 then
								result_col = col + i
							end
							return { result_row, result_col - 1 }
						else
							stack = stack - 1
						end
					end
				end
			end

			return false
		end

		-- Function to find an unmatched closing parenthesis using treesitter
		local function find_unmatched_close_paren_with_ts()
			-- Get current cursor position
			local bufnr = vim.api.nvim_get_current_buf()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			row = row - 1 -- Convert to 0-indexed for treesitter

			-- Check if we're in a filetype that should be skipped
			local filetype = vim.bo.filetype
			if filetype == "TelescopePrompt" or filetype == "spectre_panel" then
				return false
			end

			-- Check if treesitter parser exists for this filetype
			local lang = vim.treesitter.language.get_lang(filetype)
			if not lang then
				-- Fallback to a simpler approach if no parser is available
				return find_unmatched_close_paren_simple()
			end

			-- Safely get parser
			local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
			if not ok or not parser then
				-- Fallback if parser creation fails
				return find_unmatched_close_paren_simple()
			end

			local tree = parser:parse()[1]
			local root = tree:root()

			-- Find the node at the cursor position
			local node_at_cursor = root:named_descendant_for_range(row, col, row, col)
			if not node_at_cursor then
				return false
			end

			-- Find the closest ancestor that might contain our brackets
			local containing_node = node_at_cursor
			while containing_node do
				local parent = containing_node:parent()
				if not parent then
					break
				end

				local start_row, start_col, end_row, end_col = parent:range()

				-- Check if this parent extends beyond our cursor position
				if end_row > row or (end_row == row and end_col > col) then
					containing_node = parent
				else
					break
				end
			end

			if not containing_node then
				return false
			end

			-- Look for closing parenthesis in the node's text
			local start_row, start_col, end_row, end_col = containing_node:range()

			local num_lines = vim.api.nvim_buf_line_count(bufnr)

			-- Get text from cursor to the end of the containing node
			local lines = vim.api.nvim_buf_get_lines(bufnr, row, num_lines, false)
			if #lines == 0 then
				return false
			end

			-- Process first line (from cursor position)
			local text = lines[1]:sub(col + 1)
			local stack = 0

			-- Check current line first
			for i = 1, #text do
				local c = text:sub(i, i)
				if c == "(" then
					stack = stack + 1
				elseif c == ")" then
					if stack == 0 then
						-- Found unmatched closing bracket on current line
						return { row + 1, col + i }
					else
						stack = stack - 1
					end
				end
			end

			-- Check subsequent lines
			for l = 2, #lines do
				text = lines[l]
				for i = 1, #text do
					local c = text:sub(i, i)
					if c == "(" then
						stack = stack + 1
					elseif c == ")" then
						if stack == 0 then
							-- Found unmatched closing bracket on another line
							return { row + l, i - 1 }
						else
							stack = stack - 1
						end
					end
				end
			end

			return false
		end

		-- Custom mapping for opening parenthesis
		vim.keymap.set("i", "(", function()
			local match_pos = find_unmatched_close_paren_with_ts()

			if match_pos then
				-- Store current position
				local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

				-- Insert opening bracket at current position
				vim.api.nvim_buf_set_text(0, cursor_row - 1, cursor_col, cursor_row - 1, cursor_col, { "(" })

				-- Move to the matched closing bracket
				vim.api.nvim_win_set_cursor(0, match_pos)

				return ""
			else
				-- Use normal nvim-autopairs behavior
				return "("
			end
		end, { expr = true, noremap = true })
	end,
}
