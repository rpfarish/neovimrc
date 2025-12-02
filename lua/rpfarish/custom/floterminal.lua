vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

local state = {
	term = {
		buf = -1,
		win = -1,
	},
}

local function open_bottom_terminal(opts)
	opts = opts or {}
	local height = opts.height or math.floor(vim.o.lines * 0.25)
	local width = vim.o.columns

	-- Create or reuse the buffer
	local buf
	if vim.api.nvim_buf_is_valid(state.term.buf) then
		buf = state.term.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
		state.term.buf = buf
	end

	-- Open a bottom split that looks like VSCode’s terminal panel
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

	-- Start terminal if buffer is not already a terminal
	if vim.bo[buf].buftype ~= "terminal" then
		vim.cmd("terminal")
	end
end

local function toggle_terminal()
	if not vim.api.nvim_win_is_valid(state.term.win) then
		open_bottom_terminal()
	else
		vim.api.nvim_win_hide(state.term.win)
	end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>af", toggle_terminal, { desc = "Toggle [A] [F]loating terminal panel" })
