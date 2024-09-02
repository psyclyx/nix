---@diagnostic disable: missing-fields
-- https://github.com/harrisoncramer/nvim/blob/main/lua/lsp/cmp.lua

local cmp = require("cmp")
--local lspkind = require("lspkind")
local luasnip = require("luasnip")
--require("cmp_nvim_lsp_document_symbol")
--equire("cmp_cmdline")

--lspkind.init({})

-- cmp.setup.cmdline("/", {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = { { name = "buffer" } },
-- })
--
-- cmp.setup.cmdline(":", {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = { { name = "cmdline" } },
-- 	matching = { disallow_symbol_nonprefix_matching = false },
-- })

cmp.setup({
	--	preselect = cmp.PreselectMode.None,
	completeopt = "menu,menuone,noinsert,noselect",
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	-- formatting = {
	--		format = lspkind.cmp_format({
	--			mode = "symbol_text",
	--			show_labelDetails = true,
	--			maxwidth = 50,
	--			before = function(entry, vim_item)
	--				if entry.source.name == "nvim_lsp" then
	--					-- Display which LSP servers this item came from.
	--					local lspserver_name = nil
	--					pcall(function()
	--						lspserver_name = entry.source.source.client.name
	--						vim_item.menu = lspserver_name
	--					end)
	--				end
	--				vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind) or vim_item.kind
	--				return vim_item
	--			end,
	--		}),
	--	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		-- { name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		--	{ name = "conjure", max_item_count = 5 },
		--	{ name = "luasnip" },
		--	{ name = "buffer" },
	}),
})
