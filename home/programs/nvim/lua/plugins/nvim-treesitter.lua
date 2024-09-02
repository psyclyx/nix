return {
	"nvim-treesitter/nvim-treesitter",
	lazy = true,
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = false },
		})
	end,
}
