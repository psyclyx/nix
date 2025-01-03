return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			clojure = { "cljstyle" },
			lua = { "stylua" },
			nix = { "alejandra" },
		},
		format_on_save = {
			timeout_ms = 3000,
		},
	},
}
