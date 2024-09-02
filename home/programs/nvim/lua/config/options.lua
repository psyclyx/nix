-- formatting
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = true

-- visual
vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.pumblend = 30

-- autoload .nvim.lua
vim.o.exrc = true
vim.o.secure = true

-- autocommands
vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })

-- :h 'shada'
vim.o.shada = "'1000,<50,s10,h"
