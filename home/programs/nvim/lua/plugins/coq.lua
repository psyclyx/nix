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
				recommended = false,
				manual_complete = "<C-.>",
			},
		}
	end,
	config = function()
		local opts = { expr = true, noremap = true, silent = true }
		-- https://github.com/ms-jpq/coq_nvim/blob/f1d2f27a322f41cb80802bacaa9377babead4662/coq/server/registrants/options.py#L82,
		-- without the BS/CR mappings
		vim.keymap.set("i", "<Esc>", "pumvisible() ? '<c-e><esc>' : '<esc>'", opts)
		vim.keymap.set("i", "<C-c>", "pumvisible() ? '<c-e><c-c>' : '<c-c>'", opts)
		vim.keymap.set("i", "<C-w>", "pumvisible() ? '<c-e><c-w>' : '<c-w>'", opts)
		vim.keymap.set("i", "<C-u>", "pumvisible() ? '<c-e><c-u>' : '<c-u>'", opts)
		vim.keymap.set("i", "<Tab>", "pumvisible() ? '<c-n>' : '<tab>'", opts)
		vim.keymap.set("i", "<S-Tab>", "pumvisible() ? '<c-p>' : '<bs>'", opts)
	end,
}
