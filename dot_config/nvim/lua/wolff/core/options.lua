--  update timer
vim.opt.updatetime = 50

-- netrw liststyle
vim.cmd("let g:netrw_liststyle = 3")

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- tabs & indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true

-- line wrapping
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.linebreak = true

-- undo directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- remap for dealing with word wrapping
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffer on bottom of neovim
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@") -- allow @ in file names

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- term colors
vim.opt.termguicolors = true
-- vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = { "indent", "eol", "start" } -- allow backspace on indent, eol or insert mode start position

-- window split
vim.opt.splitright = true
vim.opt.splitbelow = true

-- firenvim config
vim.g.firenvim_config = {
	globalSettings = {},
	localSettings = {
		['.*'] = {
			takeover = 'never'
		}
	}
}

-- When leaving vim fix the cursor
-- without this I was always having the cursor be a block when leaving vim
vim.cmd([[
  au VimLeave * set guicursor=a:hor20-blinkwait800
]])

-- sets
vim.cmd([[
	set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»
	set list
	set ttimeout
	set notimeout
	tnoremap <Esc> <C-\><C-n>
]])
