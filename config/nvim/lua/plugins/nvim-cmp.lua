return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		-- todo: set up cmp-git
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"JMarkin/cmp-diag-codes",
		{
			"L3MON4D3/LuaSnip",
			lazy = true,
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
			["<Tap>"] = cmp.mapping.complete(),
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
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
		local capabilities = require("cmp_nvim_lsp").default_capabilities({ dynamicRegistration = true })
		local lspconfig = require("lspconfig")
		lspconfig.clojure_lsp.setup({
			capabilities = capabilities,
		})
		lspconfig.nixd.setup({
			capabilities = capabilities,
		})
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})
	end,
	event = "InsertEnter",
}
