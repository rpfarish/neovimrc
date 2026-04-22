vim.keymap.set("n", "<F5>", function()
	require("rpfarish.custom.attach").run_main()
end, { buffer = true })

vim.keymap.set("n", "<F10>", function()
	require("rpfarish.custom.attach").run_current()
end, { buffer = true })
