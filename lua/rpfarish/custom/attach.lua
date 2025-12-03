local term = require("rpfarish.custom.floterminal")
local commands = require("rpfarish.custom.commands")

local M = {}

function M.run_current()
	-- Reset the terminal buffer to force fresh start
	term.reset()

	local get_cmd = commands.get()
	local cmd = get_cmd()
	if not cmd then
		return vim.notify("No run command defined for this filetype", vim.log.levels.WARN)
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", false)
	vim.api.nvim_feedkeys("i", "t", false)
	term.run(cmd)
end

return M
