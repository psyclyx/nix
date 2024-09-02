return {
	"windwp/nvim-autopairs",
	dependencies = { "nvim-treesitter/nvim-treesitter", "ms-jpq/coq_nvim" },
	opts = {
		disabled_filetype = { "TelescopePrompt", "clojure" },
		check_ts = true,
		map_bs = false,
		map_cr = false,
	},
	config = function(opts)
		local npairs = require("nvim-autopairs")
		npairs.setup(opts)
		local CR = function()
			if vim.fn.pumvisible() ~= 0 then
				if vim.fn.complete_info({ "selected" }).selected ~= -1 then
					return npairs.esc("<c-y>")
				else
					return npairs.esc("<c-e>") .. npairs.autopairs_cr()
				end
			else
				return npairs.autopairs_cr()
			end
		end

		local BS = function()
			if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
				return npairs.esc("<c-e>") .. npairs.autopairs_bs()
			else
				return npairs.autopairs_bs()
			end
		end

		vim.keymap.set("i", "<cr>", CR, { expr = true, noremap = true })
		vim.keymap.set("i", "<bs>", BS, { expr = true, noremap = true })
	end,
}
