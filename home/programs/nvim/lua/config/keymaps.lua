-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>bD", "<cmd>%bd!|e#|bd#<cr>|'\"", { silent = true, desc = "kill other buffers" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd!<cr>", { silent = true, desc = "kill current buffer" })
vim.keymap.set("n", "<leader>fe", "<cmd>:Explore<cr>", { silent = true, desc = "explore" })
