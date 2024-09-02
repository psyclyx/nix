local ft = { "clojure", "fennel" }
return {
	{
		"Olical/conjure",
		ft = ft,
		init = function()
			vim.g["conjure#mapping#doc_word"] = "gk"
			vim.g["conjure#filetypes"] = ft
		end,
	},
}
