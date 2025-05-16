--  update timer
vim.opt.updatetime = 50

-- turn off LSP logging
vim.lsp.set_log_level("off")

-- netrw liststyle
vim.cmd("let g:netrw_liststyle = 3")

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "

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

-- when leaving vim fix the cursor. without this I was always having the cursor be a block when leaving neovim
vim.cmd([[
  au VimLeave * set guicursor=a:hor20-blinkwait800
]])

-- switch indenting between tabs/spaces and persist.
local config_file = vim.fn.stdpath("data") .. "/indent_config"

local function save_indent_config(expandtab, shiftwidth)
	local mode = expandtab and "spaces" or "tabs"
	local file_contents = { mode, tostring(shiftwidth) }
	vim.fn.writefile(file_contents, config_file)
end

local function load_indent_config()
	if vim.fn.filereadable(config_file) == 1 then
		local lines = vim.fn.readfile(config_file)
		local expandtab = false
		local shiftwidth = 4
		if #lines >= 1 then
			 expandtab = (lines[1] == "spaces")
		end
		if #lines >= 2 then
			 local sw = tonumber(lines[2])
			 if sw == 2 or sw == 4 then
				 shiftwidth = sw
			 else
				 shiftwidth = 4
			 end
		end
		return { expandtab = expandtab, shiftwidth = shiftwidth }
	end
	return { expandtab = false, shiftwidth = 4 }
end

local indent_config = load_indent_config()

vim.opt.expandtab = indent_config.expandtab
vim.opt.tabstop = indent_config.shiftwidth			-- Visual width for tabs
vim.opt.softtabstop = indent_config.shiftwidth		-- Editing (insertion/deletion) width for tabs
vim.opt.shiftwidth = indent_config.shiftwidth			-- Automatic indent width
vim.opt.autoindent = true
vim.opt.smartindent = true

local function toggle_indent()
	vim.opt.expandtab = not vim.opt.expandtab:get()
	if vim.opt.expandtab:get() then
		vim.notify("Switched to using spaces: pressing Tab now inserts " .. vim.opt.shiftwidth:get() .. " spaces")
	else
		vim.notify("Switched to using tabs: pressing Tab now inserts a literal tab (visual width: " .. vim.opt.shiftwidth:get() .. ")")
	end
	save_indent_config(vim.opt.expandtab:get(), vim.opt.shiftwidth:get())
end

local function toggle_indent_length()
	local current = vim.opt.shiftwidth:get()
	local new_width = (current == 4) and 2 or 4
	vim.opt.tabstop = new_width
	vim.opt.softtabstop = new_width
	vim.opt.shiftwidth = new_width

	if vim.opt.expandtab:get() then
		vim.notify("Switched indent width: pressing Tab now inserts " .. new_width .. " spaces")
	else
		vim.notify("Switched indent width: literal tabs with visual width " .. new_width)
	end

	save_indent_config(vim.opt.expandtab:get(), new_width)
end

_G.toggle_indent = toggle_indent
_G.toggle_indent_length = toggle_indent_length

-- sets
vim.cmd([[
	set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»
	set list
	set ttimeout
	set notimeout
	tnoremap <Esc> <C-\><C-n>
]])
