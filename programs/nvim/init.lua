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
	{ "echasnovski/mini.icons", version = false },
	"nvim-lua/plenary.nvim",
	{
		"neoclide/coc.nvim",
		branch = "release",
		init = function()
			vim.g.coc_global_extensions = { "coc-clojure", "coc-json" }
		end,
	},
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
		opts = {
			icons = { mappings = false },
		},
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

require("mini.icons").setup()

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
	o.pumblend = 30
    o.exrc = true
    o.secure = true

	g.mapleader = " "
	g.maplocalleader = ","
end

do
	local telescope = require("telescope")

	telescope.setup({
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
	})

	telescope.load_extension("fzf")
end

do
	local builtin = require("telescope.builtin")
	local wk = require("which-key")

	wk.add({
		{ "<leader>b", group = "buffer" },
		{ "<leader>bD", "<cmd>%bd!|e#|bd#<cr>|'\"", desc = "Kill other buffers" },
		{ "<leader>bb", builtin.buffers, desc = "buffers" },
		{ "<leader>bd", "<cmd>bd!<cr>", desc = "Kill current buffer" },
		{ "<leader>c", group = "CoC" },
		{ "<leader>cc", ":Telescope coc commands<CR>", desc = "commands" },
		{ "<leader>cr", ":Telescope coc references<CR>", desc = "references" },
		{ "<leader>cs", ":Telescope coc document_symbols<CR>", desc = "symbols" },
		{ "<leader>f", group = "file" },
		{ "<leader>ff", builtin.find_files, desc = "Find file" },
		{ "<leader>fe", "<cmd>:Explore<cr>", desc = "Explore" },
		{ "<leader>fg", builtin.git_files, desc = "Git files" },
		{ "<leader>fr", builtin.oldfiles, desc = "Recent files" },
		{ "<leader>g", group = "git" },
		{ "<leader>gg", "<cmd>vert Git<cr>", desc = "Status" },
		{ "<leader>r", builtin.resume, desc = "resume last telescope picker" },
		{ "<leader>s", group = "search" },
		{ "<leader>ss", builtin.live_grep, desc = "Grep" },
	})
end
