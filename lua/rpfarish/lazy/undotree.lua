return {
	"mbbill/undotree",
	init = function()
		-- Open undotree in a vertical split on the right
		-- Load Undotree layout setting if it exists
		local data_path = vim.fn.stdpath("data")
		local undotree_dir = data_path .. "/undotree"
		local undotree_config_file = undotree_dir .. "/layout.lua"

		if vim.fn.filereadable(undotree_config_file) == 1 then
			dofile(undotree_config_file)
		else
			vim.g.undotree_WindowLayout = 1
		end

		vim.g.undotree_HelpLine = 0

		vim.g.undotree_SetFocusWhenToggle = 1

		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_SplitWidth = 30
	end,
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [U]ndo Tree" })

		local function toggle_undotree_layout()
			if vim.g.undotree_WindowLayout == 1 then
				vim.g.undotree_WindowLayout = 2
			else
				vim.g.undotree_WindowLayout = 1
			end

			vim.cmd.UndotreeToggle()
			vim.cmd.UndotreeToggle()

			local data_path = vim.fn.stdpath("data")
			local undotree_dir = data_path .. "/undotree"
			local undotree_config_file = undotree_dir .. "/layout.lua"

			if vim.fn.isdirectory(undotree_dir) == 0 then
				vim.fn.mkdir(undotree_dir, "p", "0o700")
			end

			local file = io.open(undotree_config_file, "w")

			if file then
				file:write("vim.g.undotree_WindowLayout = " .. vim.g.undotree_WindowLayout)
				file:close()
				print("Undotree layout set to " .. vim.g.undotree_WindowLayout .. " (saved)")
			else
				print("Undotree layout set to " .. vim.g.undotree_WindowLayout .. " (couldn't save)")
			end
		end

		vim.keymap.set("n", "<leader>U", toggle_undotree_layout, { desc = "Toggle [U]ndotree Layout" })
		vim.keymap.set("n", "<Esc><Esc>", function()
			vim.cmd("UndotreeHide")
		end, { desc = "Hide Undotree" })
	end,
}
