return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- todo: set up cmp-git
		"neovim/nvim-lspconfig",
		"cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"JMarkin/cmp-diag-codes",
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",
	},
	opts = function(_, opts)
		cmp = require("cmp")
		luasnip = require("luasnip")
		opts.snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		}
		opts.mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		})
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{
				name = "diag-codes",
				option = { in_comment = true },
			},
			{ name = "vsnip" },
		}, {
			{ name = "buffer" },
		})
	end,
	config = function(_, opts)
		cmp = require("cmp")
		cmp.setup(opts)
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "nvim_lsp_document_symbol" },
			}, {
				{ name = "buffer" },
			}),
		})
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")
        lspconfig.clojure-lsp.setup {
            capabilities = capabilities
        }
	end,
	event = "InsertEnter",
}
