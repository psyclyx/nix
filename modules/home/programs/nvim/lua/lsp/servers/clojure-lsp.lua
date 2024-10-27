local lspconfig = require("lspconfig")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "conjure-log*",
	callback = function()
		-- Detach all LSP clients from Conjure log files
		-- and disable diagnostics if they're on
		local clients = vim.lsp.get_clients()
		for _, c in ipairs(clients) do
			vim.lsp.buf_detach_client(0, c.id)
		end
	end,
	desc = "Turns off LSP for Conjure's buffer",
})

return {
	setup = function(opt_modifier, on_attach)
		local opts = opt_modifier({
			on_attach = on_attach,
			root_dir = lspconfig.util.root_pattern("project.clj"),
			init_options = {
				["text-document-sync-kind"] = "incremental",
				["source-aliases"] = { "dev", "repl", "base" },
			},
		})
		lspconfig.clojure_lsp.setup(opts)
	end,
}
