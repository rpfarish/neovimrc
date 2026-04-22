return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-treesitter/nvim-treesitter",
	},

	opts = {
		lang = "python3",
		cn = {
			enabled = false,
		},
	},

	config = function(_, opts)
		require("leetcode").setup(opts)

		-- Only define mappings if :Leet exists
		if package.loaded["leetcode"] then
			vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>", {
				desc = "LeetCode Run",
			})

			vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", {
				desc = "LeetCode Submit",
			})

			vim.keymap.set("n", "<leader>d", "<cmd>Leet desc<CR>", {
				desc = "LeetCode Toggle Description",
			})

			vim.keymap.set("n", "<leader>rp", function()
				vim.cmd("w")
				vim.fn.jobstart({ "python3", vim.fn.expand("%") }, {
					stdout_buffered = true,
					on_stdout = function(_, data)
						if data then
							print(table.concat(data, "\n"))
						end
					end,
				})
			end)
		end
	end,
}
