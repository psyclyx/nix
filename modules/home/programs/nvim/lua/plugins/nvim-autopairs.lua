return {
	"windwp/nvim-autopairs",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		disable_filetype = { "TelescopePrompt" },
		check_ts = true,
		map_bs = false,
		map_cr = false,
	},
}
