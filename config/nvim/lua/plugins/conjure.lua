return {
	{
		"Olical/conjure",
		ft = { "clojure", "fennel" },
		lazy = true,
		init = function()
			vim.g["conjure#mapping#doc_word"] = "gk"
			vim.g["conjure#filetypes"] = { "clojure", "fennel" }
		end,

		-- Optional cmp-conjure integration
		dependencies = { "PaterJason/cmp-conjure" },
	},
}
