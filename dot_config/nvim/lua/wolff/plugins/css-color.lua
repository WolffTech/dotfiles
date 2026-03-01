return {
	'NvChad/nvim-colorizer.lua',
	event = {"BufRead", "BufNewFile"},
	config = function()
		require('colorizer').setup ({
			filetypes = { "*" },
			options = {
				parsers = {
					css = false,
					css_fn = false,
					names = { enable = false },
					hex = {
						rgb = true,
						rrggbb = true,
						rrggbbaa = false,
						aarrggbb = false,
					},
					rgb = { enable = false },
					hsl = { enable = false },
					tailwind = { enable = false },
					sass = { enable = false, parsers = { "css" }, },
				},
				display = {
					mode = 'background',
					virtualtext = { char = "■" },
				},
				always_update = false,
			},
			buftypes = {},
		})
	end,
}
