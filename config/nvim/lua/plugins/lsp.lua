return {
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = false },
		},
		ft = "lua",
		opts = { library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		} },
	},
	"onsails/lspkind.nvim",
	{ "hrsh7th/cmp-nvim-lsp", lazy = false },
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	{ "hrsh7th/cmp-nvim-lsp-document-symbol", lazy = false },
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"JMarkin/cmp-diag-codes",
	"saadparwaiz1/cmp_luasnip",
}
