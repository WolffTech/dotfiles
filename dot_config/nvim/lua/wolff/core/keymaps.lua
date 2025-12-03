-- set leader
vim.g.mapleader = " "

-- flaot lsp diagnostics
vim.keymap.set("n", "xl", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostics in Float"})

-- switch between leading tabs and spaces
vim.keymap.set("n", "<leader>ti", toggle_indent, { desc = "Toggle between tabs and spaces" })
vim.keymap.set("n", "<leader>tl", toggle_indent_length, { desc = "Toggle indent length between 4 and 2" })

-- clear searched term
vim.keymap.set('n', '<leader>nh', ':noh<cr>', { desc = "Clear searched term" })

-- Easy insertion of a trailing ; or , from insert mode
vim.keymap.set("n", ";;", "<Esc>A;<Esc>", { desc = "Insert a trailing semicolon" })
vim.keymap.set("n", ",,", "<Esc>A,<Esc>", { desc = "Insert a trailing comma" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number under cursor" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number under cursor" })

-- window managemnet
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>wb", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close window" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>", { desc = "Previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<cr>", { desc = "Open buffer in new tab" })

-- Switch between windows in normal mode
vim.keymap.set("n", "<leader>wh", "<C-W>h", { desc = "Switch to window on the left" })
vim.keymap.set("n", "<leader>wj", "<C-W>j", { desc = "Switch to window below" })
vim.keymap.set("n", "<leader>wk", "<C-W>k", { desc = "Switch to window above" })
vim.keymap.set("n", "<leader>wl", "<C-W>l", { desc = "Switch to window on the right" })

-- Move selected VLine
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Delete line without copying deleted line
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete line without copying" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete line without copying" })

-- Yank into the System Clipboard with <leader>y or just neovim with y
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank into neovim clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank into neovim clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into System clipboard" })
vim.keymap.set("v", "<leader>Y", "\"+Y", { desc = "Yank into System clipboard" })

-- Force search terms to stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Replace the word the cursor is on
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor for entire file" })

-- Make currently open file executable
vim.keymap.set("n", "<leader>xc", "<cmd>!chmod +x %<CR>", { desc = "Make file executable" })

-- Set the working directory to the path of the current buffer's directory
vim.keymap.set('n', '<leader>sp', function()
    local current_file_dir = vim.fn.expand('%:p:h')
    vim.cmd('cd ' .. current_file_dir)
    print("Working directory set to: " .. current_file_dir)
end, { desc = "Set working directory to current file's directory" })

-- Set windows size to 15 lines
vim.api.nvim_set_keymap('n', '<leader>ll', ':set lines=15<CR>:set spell<CR>', { noremap = true, silent = true, desc = "Set window size to 15 lines and enable spell checking" })

-- Paste from clipboard in FireNVim
-- insert mode mapping
vim.api.nvim_set_keymap('i', '<D-v>', '<C-r>+', { noremap = true })

-- normal mode mapping
vim.api.nvim_set_keymap('n', '<D-v>', '"+p', { noremap = true })

-- visual mode mapping
vim.api.nvim_set_keymap('v', '<D-v>', '"+p', { noremap = true })

-- set spell
vim.keymap.set("n", "<leader>ss", "<cmd>set spell<cr>", { desc = "Enable Spellchecking"})
