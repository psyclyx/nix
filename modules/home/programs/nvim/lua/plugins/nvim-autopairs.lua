return {
	"windwp/nvim-autopairs",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		disable_filetype = { "TelescopePrompt" },
		check_ts = true,
		enable_check_bracket_line = false,
		map_bs = false,
		map_cr = false,
	},
	config = function(opts)
		local Rule = require("nvim-autopairs.rule")
		local npairs = require("nvim-autopairs")
		local cond = require("nvim-autopairs.conds")

		npairs.setup(opts)

		npairs.add_rules({
			Rule("(", ")", { "clojure", "lisp" })
				:with_pair(cond.not_add_quote_inside_quote())
				:with_pair(cond.is_bracket_line())
				:with_pair(cond.is_bracket_in_quote(), 1)
				:with_pair(cond.not_after_regex([=[\\]=]))
				:use_undo(true)
				:with_move(cond.move_right())
				:with_move(cond.is_bracket_line_move()),
		})

		npairs.get_rule("(")[1].not_filetypes = { "clojure", "lisp" }
	end,
}
