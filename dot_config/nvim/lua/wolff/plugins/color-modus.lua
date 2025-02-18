return {
	"miikanissi/modus-themes.nvim",
	priority = 1000,

	config = function ()
		require("modus-themes").setup({
			style = "auto",
			variant = "default", -- Theme comes in four variants `default`, `tinted`, `deuteranopia`, and `tritanopia`
			transparent = true, -- Transparent background (as supported by the terminal)
			dim_inactive = false, -- "non-current" windows are dimmed
			hide_inactive_statusline = false, -- Hide statuslines on inactive windows. Works with the standard **StatusLine**, **LuaLine** and **mini.statusline**
			line_nr_column_background = false, -- Distinct background colors in line number column. `false` will disable background color and fallback to Normal background
			sign_column_background = true, -- Distinct background colors in sign column. `false` will disable background color and fallback to Normal background
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
		})
	-- Override highlight groups to ensure full transparency
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

	vim.cmd('colorscheme modus')
	end
}

