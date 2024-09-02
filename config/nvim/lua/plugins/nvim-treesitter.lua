return {
	"nvim-treesitter/nvim-treesitter",
	lazy = true,
	config = function()
		require("nvim-treesitter.configs").setup({
			highlight = { enable = true },
			indent = { enable = false },
		})
	end,
}
