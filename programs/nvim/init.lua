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
	"nvim-telescope/telescope.nvim",
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
	local builtin = require("telescope.builtin")
	local wk = require("which-key")
	wk.register({
		["<leader>"] = {
			f = {
				name = "+file",
				f = { "<cmd>:Explore<cr>", "Explore" },
				F = { builtin.find_files, "Find file" },
				g = { builtin.git_files, "Git files" },
				r = { builtin.oldfiles, "Recent files" },
			},
			b = {
				name = "+buffer",
				b = { builtin.buffers, "buffers" },
				d = { "<cmd>bd!<cr>", "Kill current buffer" },
				D = { "<cmd>%bd!|e#|bd#<cr>|'\"", "Kill other buffers" },
			},
			g = {
				name = "+git",
				g = { "<cmd>vert Git<cr>", "Status" },
			},
			s = {
				name = "+search",
				s = { builtin.live_grep, "Grep" },
			},
		},
	})
end
