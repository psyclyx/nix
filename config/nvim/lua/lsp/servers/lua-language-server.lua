return {
	setup = function(opt_modifier, on_attach)
		require("lspconfig").lua_ls.setup(opt_modifier({
			on_attach = on_attach,
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
		}))
	end,
}
