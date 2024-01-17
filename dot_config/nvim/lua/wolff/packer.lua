-- This file can be loaded by calling `lua require('olugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
  'nvim-telescope/telescope.nvim', tag = '0.1.4',
-- or                            , branch = '0.1.x',
  requires = { {'nvim-lua/plenary.nvim'} }
}

	use({
		'projekt0n/github-nvim-theme', tag = 'v0.0.7',
		config = function()
			require('github-theme').setup({
				theme_style = "dark_default",
				function_style = "italic",
				sidebars = {"qf", "vista_kind", "terminal", "packer"},
				transparent = "false"
			})
		end
	})

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},             -- Required
			{                                      -- Optional
			'williamboman/mason.nvim',
			run = function()
				pcall(vim.cmd, 'MasonUpdate')
			end,
		},
		{'williamboman/mason-lspconfig.nvim'}, -- Optional

		-- Autocompletion
		{'hrsh7th/nvim-cmp'},     -- Required
		{'hrsh7th/cmp-nvim-lsp'}, -- Required
		{'L3MON4D3/LuaSnip'},     -- Required
	}
}

use({
	"iamcco/markdown-preview.nvim",
	run = function() vim.fn["mkdp#util#install"]() end,
})

use({
	'goolord/alpha-nvim',
	requires = { 'nvim-tree/nvim-web-devicons' },
	config = function ()
		require'alpha'.setup(require'alpha.themes.startify'.config) end
})

use({
	"folke/which-key.nvim",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		require("which-key").setup {
		}
	end
})

use({
	'gorbit99/codewindow.nvim',
	config = function()
		local codewindow = require('codewindow')
		codewindow.setup()
		codewindow.apply_default_keybinds()
	end,
})

use {
	'glacambre/firenvim',
	run = function() vim.fn['firenvim#install'](0) end 
}

use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
use('nvim-treesitter/playground')
use('theprimeagen/harpoon')
use('mbbill/undotree')
use('tpope/vim-fugitive')
use('ap/vim-css-color')
use('feline-nvim/feline.nvim')
use('vim-airline/vim-airline')
use('vim-airline/vim-airline-themes')
use('ms-jpq/chadtree')
use('ms-jpq/coq_nvim')
use('kdheepak/lazygit.nvim')
use('ThePrimeagen/vim-be-good')

end)
