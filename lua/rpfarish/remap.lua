local keymap = vim.keymap
local set = keymap.set

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Terminal
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Search & Highlighting
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Clipboard & Deletion
set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole register" })

-- Text Manipulation
set("n", "J", "mzJ`z", { desc = "Join lines keeping cursor position" })

-- Navigation
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Jump through quickfix list
set("n", "<C-S-j>", "<cmd>cnext<CR>zz", { desc = "Next in quickfix" })
set("n", "<C-S-k>", "<cmd>cprev<CR>zz", { desc = "Prev in quickfix" })

-- Tmux commands
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- LSP
set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- Better indenting
set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Oil.nvim Configuration
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		set("n", "<C-r>", function()
			require("oil.actions").refresh.callback()
		end, { buffer = true, silent = true, desc = "Refresh oil" })
		pcall(keymap.del, "n", "<C-l>", { buffer = true })
	end,
	desc = "Configure oil.nvim keymaps",
})

-- Transparency Toggle
local transparency_enabled = false

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

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		if transparency_enabled then
			vim.cmd([[
				highlight Normal guibg=NONE blend=90
				highlight NonText guibg=NONE blend=90
			]])
		end
	end,
	desc = "Maintain transparency on colorscheme change",
})

set("n", "<leader>tt", toggle_transparency, { desc = "[T]oggle [T]ransparency" })
