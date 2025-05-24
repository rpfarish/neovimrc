vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "[P]roject [V]iew" })
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "[P]roject [V]iew" })

vim.keymap.set("i", "jj", "<esc>", { desc = "Escape to normal mode" })
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
-- NOTE: Window navigation
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		-- Create a buffer-local mapping for netrw refresh that uses a different key
		vim.api.nvim_buf_set_keymap(0, "n", "<C-r>", "<Plug>NetrwRefresh", { silent = true })

		-- Safely try to delete the <C-l> mapping, ignoring errors if it doesn't exist
		pcall(vim.api.nvim_buf_del_keymap, 0, "n", "<C-l>")

		-- Make our global C-l mapping work in netrw by explicitly defining it for this buffer
	end,
	desc = "Handle netrw keys to avoid conflicts with harpoon",
})
