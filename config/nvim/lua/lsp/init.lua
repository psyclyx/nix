local servers = {
	"clojure-lsp",
	"lua-language-server",
	"nixd",
}

local on_attach = function(client)
	client.flags.debounce_text_changes = 300
	client.server_capabilities.documentFormattingProvider = false
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
