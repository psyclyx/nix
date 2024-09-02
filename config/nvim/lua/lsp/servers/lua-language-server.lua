return {
	setup = function(on_attach, capabilities)
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						ignoreDir = { "node_modules" },
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
}
