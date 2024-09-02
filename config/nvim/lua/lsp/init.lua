local servers = {
	"clojure-lsp",
	"lua-language-server",
	"nixd",
}

local on_attach = function(client)
	client.server_capabilities.documentFormattingProvider = false
end

local coq_status_ok, coq = pcall(require, "coq")
local identity = function(x)
	return x
end
local opt_modifier = coq_status_ok and coq.ensure_capabilities or identity
for _, s in pairs(servers) do
	local server_config_ok, mod = pcall(require, "lsp.servers." .. s)
	if not server_config_ok then
		require("notify")("The LSP '" .. s .. "' does not have a config.", "warn")
	else
		mod.setup(opt_modifier, on_attach)
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
