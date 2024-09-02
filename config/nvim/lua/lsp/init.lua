local servers = {
	"clojure-lsp",
	"lua-language-server",
	"nixd",
}

local keyset = function(mode, lhs, rhs, desc)
	local opts = { noremap = true, silent = true, nowait = true, desc = desc }
	vim.keymap.set(mode, lhs, rhs, opts)
end

local on_attach = function(client)
	client.flags.debounce_text_changes = 300
	client.server_capabilities.documentFormattingProvider = false

	keyset("n", "gd", vim.lsp.buf.definition, "definition")
	keyset("n", "gt", vim.lsp.buf.type_definition, "type definition")
	keyset("n", "gr", vim.lsp.buf.references, "references")
	keyset("n", "gss", function()
		vim.cmd.split()
		vim.lsp.buf.definition()
	end, "split definition")
	keyset("n", "gsv", function()
		vim.cmd.split()
		vim.lsp.buf.definition()
	end, "vsplit definition")
	keyset("n", "K", vim.lsp.buf.hover, "hover")
	keyset("n", "<C-k>", vim.lsp.buf.signature_help, "signature help")
	keyset("n", "<leader>lR", vim.lsp.buf.rename, "rename")
	keyset("n", "<leader>lq", vim.diagnostic.setqflist, "quickfix diagnostics")
	keyset("n", "<leader>li", vim.lsp.buf.implementation, "implementation")
	keyset("n", "<leader>lt", vim.lsp.buf.type_definition, "type definition")
	keyset("n", "<leader>lr", vim.lsp.buf.references, "references")
	keyset("n", "<leader>lc", vim.lsp.buf.incoming_calls, "incoming calls")

	keyset("n", "]W", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, "next error")

	keyset("n", "[W", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, "prev error")

	keyset("n", "]w", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	end, "next warn")

	keyset("n", "[w", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	end, "prev warn")
end

for _, s in pairs(servers) do
	local server_config_ok, mod = pcall(require, "lsp.servers." .. s)
	if not server_config_ok then
		require("notify")("The LSP '" .. s .. "' does not have a config.", "warn")
	else
		mod.setup(on_attach, {})
	end
end

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	update_in_insert = false,
	float = {
		header = "",
		source = true,
		focusable = true,
	},
})

local signs = { Error = "!", Warn = "?", Hint = "*", Info = "i" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
