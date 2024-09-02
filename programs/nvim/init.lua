local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	{ "neoclide/coc.nvim", branch = "release" },
	"nvim-telescope/telescope.nvim",
	"fannheyward/telescope-coc.nvim",
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"stevearc/conform.nvim",
	"guns/vim-sexp",
	"tpope/vim-fugitive",
	"tpope/vim-sensible",
	{ "catppuccin/nvim", name = "catppuccin" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "clojure", "javascript", "html", "vimdoc" },
				sync_install = true,
				highlight = { enable = true },
				indent = { enable = false },
			})
		end,
	},
	"Olical/conjure",
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"pablopunk/fixquick.nvim",
		event = "BufEnter",
		config = true,
	},
})

vim.cmd.colorscheme("catppuccin-macchiato")

require("lualine").setup()

require("conform").setup({
	formatters_by_ft = {
		clojure = { "cljstyle" },
		lua = { "stylua" },
	},
	format_on_save = {
		timeout_ms = 3000,
	},
})

do
	local o = vim.o
	local g = vim.g

	o.expandtab = true
	o.smartindent = true
	o.tabstop = 4
	o.shiftwidth = 4
	o.wrap = true
	o.cursorline = true
	o.number = true
	o.relativenumber = true
	o.signcolumn = "number"

	g.mapleader = " "
	g.maplocalleader = ","
end

do
	local telescope = require("telescope")

	telescope.setup({
		defaults = {
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					width = 1.0,
					height = 0.4,
				},
			},
		},
		pickers = {
			buffers = {
				theme = "ivy",
			},
			find_files = {
				theme = "ivy",
			},
			git_files = {
				theme = "ivy",
			},
			live_grep = {
				theme = "ivy",
			},
			oldfiles = {
				theme = "ivy",
			},
			quickfix = {
				theme = "ivy",
			},
			quickfixhistory = {
				theme = "ivy",
			},
		},
		extensions = {
			coc = {
				theme = "ivy",
				layout_config = { height = 0.4 },
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
	})

	telescope.load_extension("fzf")
end

do
	local builtin = require("telescope.builtin")
	local themes = require("telescope.themes")
	local wk = require("which-key")

	local function ivy(f)
		return function()
			f(themes.get_ivy({ layout_config = { height = 0.4 } }))
		end
	end

	wk.register({
		["<leader>"] = {
			f = {
				name = "+file",
				f = { "<cmd>:Explore<cr>", "Explore" },
				F = { ivy(builtin.find_files), "Find file" },
				g = { ivy(builtin.git_files), "Git files" },
				r = { ivy(builtin.oldfiles), "Recent files" },
			},
			b = {
				name = "+buffer",
				b = { ivy(builtin.buffers), "buffers" },
				d = { "<cmd>bd!<cr>", "Kill current buffer" },
				D = { "<cmd>%bd!|e#|bd#<cr>|'\"", "Kill other buffers" },
			},
			g = {
				name = "+git",
				g = { "<cmd>vert Git<cr>", "Status" },
			},
			s = {
				name = "+search",
				s = { ivy(builtin.live_grep), "Grep" },
			},
			q = {
				name = "+quickfix",
				l = { ivy(builtin.quickfix), "list" },
				h = { ivy(builtin.quickfixhistory), "history" },
			},
			c = {
				name = "+CoC",
				c = { ":Telescope coc commands<CR>", "commands" },
				s = { ":Telescope coc document_symbols<CR>", "symbols" },
				r = { ":Telescope coc references<CR>", "references" },
			},
			r = { builtin.resume, "resume last telescope picker" },
		},
	})
end
