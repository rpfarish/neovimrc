local opt = vim.opt
local g = vim.g

-- Global settings
g.have_nerd_font = true
g.python3_host_prog = "/usr/bin/python3"

-- UI
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.colorcolumn = "80"
opt.cmdheight = 0
opt.conceallevel = 0

-- Editing
opt.mouse = "a"
opt.breakindent = true
opt.wrap = false
opt.scrolloff = 8
opt.confirm = true

-- Indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Files & Undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.expand("~/.vim/undodir")

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Timing
opt.updatetime = 100
opt.timeoutlen = 300

-- Clipboard (scheduled to avoid startup delay)
vim.schedule(function()
	opt.clipboard = "unnamedplus"
end)

-- Enable faster Lua module loading
vim.loader.enable()
