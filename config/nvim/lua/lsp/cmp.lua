-- https://github.com/harrisoncramer/nvim/blob/main/lua/lsp/cmp.lua

local cmp_status_ok, cmp = pcall(require, "cmp")
local lspkind_status_ok, lspkind = pcall(require, "lspkind")
local luasnip_status_ok, luasnip = pcall(require, "luasnip")

if not (cmp_status_ok and lspkind_status_ok) then
	vim.api.nvim_err_writeln("CMP dependencies not yet installed!")
	return
end

lspkind.init({})

if cmp_status_ok then
	cmp.setup({
		preselect = cmp.PreselectMode.None,
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				show_labelDetails = true,
				maxwidth = 50,
				before = function(entry, vim_item)
					if entry.source.name == "nvim_lsp" then
						-- Display which LSP servers this item came from.
						local lspserver_name = nil
						pcall(function()
							lspserver_name = entry.source.source.client.name
							vim_item.menu = lspserver_name
						end)
					end
					vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
					return vim_item
				end,
			}),
		},
		mapping = {
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
			["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
			["<Tab>"] = cmp.mapping(cmp.mapping.complete({}), { "i", "c" }),
			["<S-Down>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<S-Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		},
		sources = cmp.config.sources(
			{ { name = "nvim_lsp_signature_help" }, { name = "diag-codes" } },
			{ { name = "nvim_lsp" }, { name = "lazydev", group_index = 0 } },
			{ { name = "luasnip" }, { name = "buffer" } }
		),
	})
	cmp.setup.cmdline({ "/", "?" }, {
		view = {
			entries = "custom",
			selection_order = "near_cursor",
		},
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
end
