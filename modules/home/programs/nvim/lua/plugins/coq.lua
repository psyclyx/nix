return {
	"ms-jpq/coq_nvim",
	branch = "coq",
	dependencies = {
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		"windwp/nvim-autopairs",
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
		local npairs = require("nvim-autopairs")

		local CR = function()
			if vim.fn.pumvisible() ~= 0 then
				if vim.fn.complete_info({ "selected" }).selected ~= -1 then
					return npairs.esc("<C-y>")
				else
					return npairs.esc("<C-e>") .. npairs.autopairs_cr()
				end
			else
				return npairs.autopairs_cr()
			end
		end

		local BS = function()
			if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
				return npairs.esc("<C-e>") .. npairs.autopairs_bs()
			else
				return npairs.autopairs_bs()
			end
		end

		local opts = { expr = true, noremap = true, silent = true, replace_keycodes = false }

		vim.keymap.set("i", "<ESC>", "pumvisible() ? '<c-e><esc>' : '<esc>'", opts)
		vim.keymap.set("i", "<C-c>", "pumvisible() ? '<c-e><c-c>' : '<c-c>'", opts)
		vim.keymap.set("i", "<C-w>", "pumvisible() ? '<c-e><c-w>' : '<c-w>'", opts)
		vim.keymap.set("i", "<C-u>", "pumvisible() ? '<c-e><c-u>' : '<c-u>'", opts)
		vim.keymap.set("i", "<TAB>", "pumvisible() ? '<c-n>' : '<tab>'", opts)
		vim.keymap.set("i", "<S-TAB>", "pumvisible() ? '<c-p>' : '<bs>'", opts)
		vim.keymap.set("i", "<CR>", CR, opts)
		vim.keymap.set("i", "<BS>", BS, opts)
	end,
}
