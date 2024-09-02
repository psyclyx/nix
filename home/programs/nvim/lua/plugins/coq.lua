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
			display = {
				preview = {
					positions = {
						north = 4,
						south = 3,
						west = 2,
						east = 1,
					},
				},
			},
		}
	end,
}
