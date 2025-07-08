return {
	{
	'projekt0n/github-nvim-theme',
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
			require('github-theme').setup({
				options = {
					transparent = true,
					dim_inactive = false,
					styles = {
						comments = 'italic',
						functions = 'italic',
						keywords = 'bold',
						variables = 'NONE',
						conditionals = 'NONE',
						constants = 'NONE',
						numbers = 'NONE',
						operators = 'NONE',
						strings = 'NONE',
						types = 'bold',
					},
					darken = {
						floats = true,
						sidebars = {
							enable = true,
							lists = {},
						},
					},
				}
		})

		vim.cmd('colorscheme github_dark_default')
	end,
	}
}
