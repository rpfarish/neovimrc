local cmds = {}

-- python
cmds.python = function()
	-- local file = vim.fn.expand("%")
	return "uv run main.py"
end

-- rust
cmds.rust = function()
	return "cargo run"
end

-- javascript / typescript
cmds.javascript = function()
	return "node " .. vim.fn.expand("%")
end
cmds.typescript = cmds.javascript

-- fallback
cmds.default = function()
	return nil
end

local M = {}

function M.get()
	local ft = vim.bo.filetype
	return cmds[ft] or cmds.default
end

return M
