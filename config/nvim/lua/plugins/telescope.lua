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
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "find files" },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "git files" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "recent files" },
			{ "<leader>r", "<cmd>Telescope resume<cr>", desc = "resume telescope" },
			{ "<leader>ss", "<cmd>Telescope live_grep<cr>", desc = "grep" },
		},
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
}
