-- Key Remaps

-- Set Leader
vim.g.mapleader = " "

-- Clear searched term
vim.keymap.set("n", "<leader><space>", ":noh<cr>")

-- Remap Vim Explore
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)

-- Remap MarkdownPreview
vim.keymap.set("n", "<leader>mp", vim.cmd.MarkdownPreview)

-- Easy insertion of a trailing ; or , from insert mode
vim.keymap.set("n", ";;", "<Esc>A;<Esc>")
vim.keymap.set("n", ",,", "<Esc>A,<Esc>")

-- Switch between windows in normal mode
vim.keymap.set("n", "<leader>wh", "<C-W>h")
vim.keymap.set("n", "<leader>wj", "<C-W>j")
vim.keymap.set("n", "<leader>wk", "<C-W>k")
vim.keymap.set("n", "<leader>wl", "<C-W>l")

-- Move selected VLine
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Forces cursor to stay in place when using J
vim.keymap.set("n", "J", "mzJ`z")

-- Force cursor to stay in middle of screen when half page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Force search terms to stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Allows pasting without loosing original item in clipboard
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank into the System Clipboard with <leader>y or just neovim with y
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Paste from clipboard in FireNVim
-- insert mode mapping
vim.api.nvim_set_keymap('i', '<D-v>', '<C-r>+', { noremap = true })

-- normal mode mapping
vim.api.nvim_set_keymap('n', '<D-v>', '"+p', { noremap = true })

-- visual mode mapping
vim.api.nvim_set_keymap('v', '<D-v>', '"+p', { noremap = true })

-- Delete line in vertical edit without copying deleted line
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- QuickFix Navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace the word the cursor is on
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make currently open file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>")

-- Set windows size to 15 lines
vim.api.nvim_set_keymap('n', '<leader>l', ':set lines=15<CR>', { noremap = true, silent = true })
