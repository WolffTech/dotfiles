return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = true,
			float = {
				transparent = true,
				solid = false,
			},
			show_end_of_buffer = true,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = {},
				loops = {},
				functions = {"italic"},
				keywords = { "bold" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = { "bold" },
				operators = {},
			},
			lsp_styles = {},
			color_overrides = {},
			custom_highlights = function(colors)
				return {
					LineNr = { fg = colors.overlay1 },
					CursorLineNr = { fg = colors.lavender, bold = true },
					CursorLine = { bg = "NONE" },
				}
			end,
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}

