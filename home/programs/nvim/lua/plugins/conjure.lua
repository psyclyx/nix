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
	},
}
