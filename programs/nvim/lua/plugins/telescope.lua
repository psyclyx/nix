return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				border = true,
				borderchars = {
					prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
					results = { " " },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				sorting_strategy = "ascending",
				layout_strategy = "bottom_pane",
				layout_config = {
					height = 0.4,
				},
				winblend = 30,
			},
			extensions = {
				coc = {
					prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
					push_cursor_on_edit = true, -- save the cursor position to jump back in the future
					timeout = 3000, -- timeout for coc commands
				},
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		keys = {
			{ "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "buffers" },
			{ "<leader>cc", "<cmd>Telescope coc commands<cr>", desc = "commands" },
			{ "<leader>cr", "<cmd>Telescope coc references<cr>", desc = "references" },
			{ "<leader>cs", "<cmd>Telescope coc document_symbols<cr>", desc = "symbols" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "git files" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
			{ "<leader>r", "<cmd>Telescope resume<cr>", desc = "resume telescope" },
			{ "<leader>ss", "<cmd>Telescope live_grep", desc = "grep" },
		},
	},
	"fannheyward/telescope-coc.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
