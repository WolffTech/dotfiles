vim.opt.nu = true
vim.opt.relativenumber = true

vim.cmd([[
	set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»
	set list
	set guifont=JetBrainsMono\ Nerd\ Font
	set guicursor= 
]])

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.wrap = false
vim.opt.spell = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim.undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = ture

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "
