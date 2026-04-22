local term = require("rpfarish.custom.floterminal")
local commands = require("rpfarish.custom.commands")

local M = {}

local function run(cmd)
	term.reset()

	if not cmd then
		return vim.notify("No run command defined", vim.log.levels.WARN)
	end

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":wa<CR>", true, false, true), "nx", false)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", false)
	vim.api.nvim_feedkeys("i", "t", false)
	term.run(cmd)
end

function M.run_current()
	local get_cmd = commands.get()
	run(get_cmd())
end

function M.run_main()
	local cmd = commands.main()
	run(cmd)
end

return M
