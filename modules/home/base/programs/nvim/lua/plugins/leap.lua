return {
	{
		"ggandor/leap.nvim",
		config = function()
			local l = require("leap")
			local lts = require("leap.treesitter")

			l.create_default_mappings()
			l.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

			vim.keymap.set({ "n", "x", "o" }, "ga", function()
				lts.select()
			end)
		end,
	},
	{ "ggandor/flit.nvim", dependencies = { "ggandor/leap.nvim" }, opts = true },
}
