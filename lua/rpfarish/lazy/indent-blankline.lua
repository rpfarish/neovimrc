return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewfile" },
	config = function()
		local hooks = require("ibl.hooks")

		-- Define a single highlight group for active scope
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#8f8f8f" }) -- soft gray
			-- other color is #3b4261 darker gray
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "NONE", nocombine = true })
		end)

		require("ibl").setup({
			indent = {
				highlight = { "IblIndent" }, -- Required, even if visually hidden
				char = "│", -- default line character
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				highlight = { "IblScope" }, -- Only highlight the current scope
			},
		})
	end,
}
