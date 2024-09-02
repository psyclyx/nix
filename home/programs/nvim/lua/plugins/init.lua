return {
	"rcarriga/nvim-notify",
	{ "guns/vim-sexp", ft = { "clojure" } },
	{
		"tpope/vim-fugitive",
		lazy = false,
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
	{
		"nvim-lualine/lualine.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
