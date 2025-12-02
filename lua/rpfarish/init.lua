require("rpfarish.remap")
require("rpfarish.set")

require("rpfarish.custom.floterminal")

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", { --xclip
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("rpfarish-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
-- Automatically rename tmux window to current file
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function()
		if vim.env.TMUX then
			local filename = vim.fn.expand("%:t")
			if filename == "" then
				filename = "[No Name]"
			end
			vim.fn.system("tmux rename-window '" .. filename .. "'")
		end
	end,
})
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup(require("rpfarish.lazy"))
