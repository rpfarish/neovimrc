return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	event = "VimEnter",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		-- Add current file to harpoon list
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })

		-- Toggle harpoon quick menu
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Jump to harpoon file 1
		vim.keymap.set("n", "<C-j>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })

		-- Jump to harpoon file 2
		vim.keymap.set("n", "<C-k>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })

		-- Jump to harpoon file 3
		vim.keymap.set("n", "<C-l>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })

		-- Jump to harpoon file 4
		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Navigate to previous buffer in harpoon list
		vim.keymap.set("n", "<leader>j", function()
			harpoon:list():prev()
			vim.cmd("normal! zz")
		end, { desc = "Harpoon: Prev file" })

		-- Navigate to next buffer in harpoon list
		vim.keymap.set("n", "<leader>k", function()
			harpoon:list():next()
			vim.cmd("normal! zz")
		end, { desc = "Harpoon: Next file" })
	end,
}
