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

		-- Function to find an unmatched closing parenthesis using treesitter
		local function find_unmatched_close_paren_with_ts()
			-- Get current cursor position
			local bufnr = vim.api.nvim_get_current_buf()
			local row, col = unpack(vim.api.nvim_win_get_cursor(0))
			row = row - 1 -- Convert to 0-indexed for treesitter

			-- Get parser and syntax tree
			local parser = vim.treesitter.get_parser(bufnr)
			if not parser then
				return false
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
			while containing_node and containing_node:parent() do
				local parent = containing_node:parent()
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

			-- Get text from cursor to the end of the containing node
			local lines = vim.api.nvim_buf_get_lines(bufnr, row, end_row + 1, false)
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
