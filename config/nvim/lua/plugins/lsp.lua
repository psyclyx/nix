return {
	"neovim/nvim-lspconfig",
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0,
			})
		end,
	},
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
		},
		ft = "lua",
		opts = { library = {
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		} },
	},
	"onsails/lspkind.nvim",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-nvim-lsp-document-symbol",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"JMarkin/cmp-diag-codes",
	"saadparwaiz1/cmp_luasnip",
}
