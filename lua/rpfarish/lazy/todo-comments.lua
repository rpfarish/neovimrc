return {
	"folke/todo-comments.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = { signs = false },
	config = function(_, opts)
		local todo = require("todo-comments")
		todo.setup(opts)

		-- Force highlighting on buffer enter
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			callback = function(ev)
				vim.schedule(function()
					local bufnr = ev.buf
					if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_line_count(bufnr) > 0 then
						local ok, highlight = pcall(require, "todo-comments.highlight")
						if ok and highlight and highlight.highlight_buf then
							highlight.highlight_buf(bufnr)
						end
					end
				end)
			end,
		})
	end,
}
