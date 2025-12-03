local M = {}

local state = {
	term = {
		buf = -1,
		win = -1,
	},
}

vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

-- Open the bottom floating panel
function M.open(opts)
	opts = opts or {}
	local height = opts.height or math.floor(vim.o.lines * 0.50)
	local width = vim.o.columns

	local buf
	if vim.api.nvim_buf_is_valid(state.term.buf) then
		buf = state.term.buf
		print("Reusing buffer: " .. buf) -- Debug
	else
		buf = vim.api.nvim_create_buf(false, true)
		state.term.buf = buf
		print("Created new buffer: " .. buf) -- Debug
	end

	-- open window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = vim.o.lines - height,
		col = 0,
		width = width,
		height = height,
		style = "minimal",
		border = "none",
	})

	state.term.win = win

	-- start terminal if needed
	if vim.bo[buf].buftype ~= "terminal" then
		vim.cmd("terminal")
	end

	return buf
end

function M.toggle()
	if not vim.api.nvim_win_is_valid(state.term.win) then
		M.open()
	else
		vim.api.nvim_win_hide(state.term.win)
	end
end

-- run a command inside the terminal
function M.run(cmd)
	local buf = M.open()

	local chan = vim.b[buf].terminal_job_id
	if not chan then
		return vim.notify("Terminal not started?", vim.log.levels.ERROR)
	end

	-- send command + newline
	vim.fn.chansend(chan, cmd .. "\n")
end

-- Add this function
function M.reset()
	if vim.api.nvim_buf_is_valid(state.term.buf) then
		vim.api.nvim_buf_delete(state.term.buf, { force = true })
	end
	state.term.buf = -1
end

return M
