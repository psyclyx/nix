return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			icons = { mappings = false },
			spec = {
				{ "<leader>b", group = "buffer" },
				-- { "<leader>c", group = "CoC" },
				{ "<leader>f", group = "file" },

				{ "<leader>s", group = "search" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
