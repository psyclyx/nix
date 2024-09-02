return {
	"ms-jpq/coq_nvim",
	branch = "coq",
	dependencies = {
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
	},
	build = ":COQdeps",
	init = function()
		vim.g.coq_settings = {
			auto_start = "shut-up",
			keymap = {
				manual_complete = "<C-_>",
			},
			completion = {
				replace_suffix_threshold = 0,
			},
			limits = {
				completion_auto_timeout = 1,
				completion_manual_timeout = 3,
			},
		}
	end,
}
