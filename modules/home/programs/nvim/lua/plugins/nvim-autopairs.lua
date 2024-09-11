return {
	"windwp/nvim-autopairs",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		disable_filetype = { "TelescopePrompt" },
		check_ts = true,
		check_bracket_line = true,
		map_bs = false,
		map_cr = false,
	},
}
