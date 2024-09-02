return {
	"guns/vim-sexp",
	{
		"tpope/vim-fugitive",
		keys = { { "<leader>g", "<cmd>vert Git<cr>", desc = "git status", silent = true } },
	},
	"tpope/vim-sensible",
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	"Olical/conjure",
	{
		"pablopunk/fixquick.nvim",
		event = "BufEnter",
		config = true,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
