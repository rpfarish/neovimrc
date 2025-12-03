vim.keymap.set("n", "<F5>", function()
	require("rpfarish.custom.attach").run_current()
end, { buffer = true })
