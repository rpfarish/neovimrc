vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "[P]roject [V]iew" })
vim.keymap.set("i", "jj", "<esc>", { desc = "Escape to normal mode" })
vim.keymap.set("x", "<leader>p", [["_dP]])
