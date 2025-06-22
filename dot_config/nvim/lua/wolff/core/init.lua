require("wolff.core.options")
require("wolff.core.keymaps")

local augroup = vim.api.nvim_create_augroup
local WolffGroup = augroup('Wolff', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = 'templ',
		terraform = 'tf',
	}
})

autocmd('TextYankPost', {
	group = yank_group,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank({
			higroup = 'IncSearch',
			timeout = 40,
		})
	end,
})

autocmd({"BufWritePre"}, {
	group = WolffGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})
