return {
	"windwp/nvim-autopairs",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		disable_filetype = { "TelescopePrompt", "clojure" },
		check_ts = true,
		map_bs = false,
		map_cr = false,
	},
}
