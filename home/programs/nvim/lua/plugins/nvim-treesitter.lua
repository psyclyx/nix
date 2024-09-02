return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
	dependencies = {
		"oncomouse/nvim-treesitter-endwise",
		opts = true,
	},
}
