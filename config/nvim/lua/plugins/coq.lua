return {
	"ms-jpq/coq_nvim",
	branch = "coq",
	dependencies = {
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
	},
	init = {
		keymap = {
			manual_complete = "<S-space>",
		},
	},
}
