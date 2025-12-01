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

-- Track transparency state
local transparency_enabled = false

-- Function to toggle transparency
local function toggle_transparency()
	if transparency_enabled then
		vim.cmd([[
            highlight Normal guibg=#1a1b26
            highlight NonText guibg=#1a1b26
            highlight NormalFloat guibg=#1a1b26
            highlight SignColumn guibg=#1a1b26
            highlight EndOfBuffer guibg=#1a1b26
        ]])
		transparency_enabled = false
		print("Transparency disabled")
	else
		vim.cmd([[
            highlight Normal guibg=NONE blend=90
            highlight NonText guibg=NONE blend=90
            highlight NormalFloat guibg=NONE
            highlight SignColumn guibg=NONE
            highlight EndOfBuffer guibg=NONE
        ]])
		transparency_enabled = true
		print("Transparency enabled")
	end
end
-- Create the autocmd to apply transparency on colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		if transparency_enabled then
			vim.cmd([[
                highlight Normal guibg=NONE blend=90
                highlight NonText guibg=NONE blend=90
            ]])
		end
	end,
})

-- Set up the keymap to toggle transparency
vim.keymap.set("n", "<leader>tt", toggle_transparency, { desc = "[T]oggle [T]ransparency" })
