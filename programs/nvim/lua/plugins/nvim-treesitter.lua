return {
	"nvim-treesitter/nvim-treesitter",
	lazy = true,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "vim", "clojure", "javascript", "html", "vimdoc" },
			sync_install = true,
			highlight = { enable = true },
			indent = { enable = false },
		})
	end,
}
