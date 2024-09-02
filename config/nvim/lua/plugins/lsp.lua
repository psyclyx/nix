return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "ms-jpq/coq_nvim", optional = true },
			{
				"ray-x/lsp_signature.nvim",
				opts = {
					floating_window = false,
					hint_prefix = {
						above = "↙ ",
						current = "← ",
						below = "↖ ",
					},
				},
				keys = {
					{
						"<M-/>",
						function()
							require("lsp_signature").toggle_float_win()
						end,
						mode = { "n", "i" },
					},
				},
			},
		},
		lazy = false,
		config = function()
			require("lsp")
		end,
		keys = {
			{ "gd", vim.lsp.buf.definition, desc = "definition" },
			{ "gt", vim.lsp.buf.type_definition, desc = "type definition" },
			{ "gr", vim.lsp.buf.references, desc = "references" },
			{
				"gss",
				function()
					vim.cmd.split()
					vim.lsp.buf.definition()
				end,
				desc = "split definition",
			},
			{
				"gsv",
				function()
					vim.cmd.vsplit()
					vim.lsp.buf.definition()
				end,
				desc = "vsplit definition",
			},
			{ "K", vim.lsp.buf.hover, desc = "hover" },
			{ "<leader>lR", vim.lsp.buf.rename, desc = "rename symbol" },
			{ "<leader>lq", vim.diagnostic.setqflist, desc = "quickfix diagnostics" },
			{ "<leader>li", vim.lsp.buf.implementation, desc = "implementation" },
			{ "<leader>lt", vim.lsp.buf.type_definition, desc = "type definition" },
			{ "<leader>lr", vim.lsp.buf.references, desc = "references" },
			{ "<leader>lc", vim.lsp.buf.incoming_calls, desc = "incoming calls" },
			{
				"]W",
				function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "next error",
			},
			{
				"[W",
				function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end,
				desc = "prev error",
			},
			{
				"]w",
				function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
				end,
				desc = "next warn",
			},
			{
				"[w",
				function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
				end,
				desc = "prev warn",
			},
			{ "[d", vim.diagnostic.goto_prev, "prev diagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "next diagnostic" },
			{ "<C-w>d", vim.diagnostic.float, mode = { "n", "i" }, desc = "show diagnostic" },
		},
	},
	{
		"folke/which-key.nvim",
		optional = true,
		opts_extend = { "spec" },
		opts = {
			spec = {
				{ "<leader>l", group = "+lsp" },
			},
		},
	},
}
