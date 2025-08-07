-- Redo:
vim.keymap.set("n", "U", "<C-r>")

-- Move 10 lines:
vim.keymap.set("n", "K", "10<Up>")
vim.keymap.set("n", "J", "10<Down>")

-- Separate Window:
vim.keymap.set("n", "ss", "<C-w>s")
vim.keymap.set("n", "sv", "<C-w>v")

-- Move Window:
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
vim.keymap.set("n", "sh", "<C-w>h")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Leader
vim.g.mapleader = ";"
