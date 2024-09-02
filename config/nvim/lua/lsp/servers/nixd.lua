return {
	setup = function(opt_modifier, on_attach)
		require("lspconfig").nixd.setup(opt_modifier({
			on_attach = on_attach,
		}))
	end,
}
