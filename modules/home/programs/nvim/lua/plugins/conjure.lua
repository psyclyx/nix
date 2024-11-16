local ft = { "clojure", "fennel", "lua" }
return {
	{
		"Olical/conjure",
		ft = ft,
		init = function()
			vim.g["conjure#mapping#doc_word"] = "gk"
			vim.g["conjure#filetypes"] = ft
			vim.g["conjure#extract#tree_sitter#enabled"] = true
		end,
		keys = {
			{ "<localleader>csa", ":ConjureShadowSelect app<cr>", desc = "shadow select app", ft = "clojure" },

			{ "<localleader>csr", ":ConjureShadowSelect app<cr>", desc = "shadow select revl", ft = "clojure" },

			{ "<localleader>css", ":ConjureShadowSelect app<cr>", desc = "shadow select stories", ft = "clojure" },
		},
	},
	{ "clojure-vim/clojure.vim", lazy = false },
	{
		"PaterJason/nvim-treesitter-sexp",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			set_cursor = true,
		},
	},
}
