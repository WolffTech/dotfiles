return {
	"nvim-lualine/lualine.nvim",
	dependencies = {"nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
	config = function()

		vim.g.gitblame_display_virtual_text = 0
		vim.g.gitblame_message_template = 'Git: <summary> - <sha> - <author>'
		vim.g.gitblame_date_format = '%d/%m/%Y %H'
		vim.g.gitblame_message_when_not_committed = "*Uncommitted Changes* - You"

		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count
		local git_blame = require("gitblame")

		local colors = {
			grey = '#757575',
			gold = '#afaf5f',
			pink = '#af5f5f',
			blue = '#5f87af',
			orange = '#d75f00',
			fg = '#FFFFFF',
			mg = '#4B4B4B',
			bg = '#101010',
			xg = '#212121',
			middle  = '#bcbcbc',
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.grey, fg = colors.bg, gui = "bold" },
				b = { bg = colors.mg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				x = { bg = colors.xg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.gold, fg = colors.bg, gui = "bold" },
				b = { bg = colors.mg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				x = { bg = colors.xg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.pink, fg = colors.bg, gui = "bold" },
				b = { bg = colors.mg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				x = { bg = colors.xg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.grey, fg = colors.bg, gui = "bold" },
				b = { bg = colors.mg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				x = { bg = colors.xg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.mg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
				x = { bg = colors.xg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.bg, fg = colors.middle, gui = "bold" },
				b = { bg = colors.bg, fg = colors.middle },
				c = { bg = colors.bg, fg = colors.middle },
			},
		}

		-- configure lualine with modified theme
		lualine.setup {
			options = {
				icons_enabled = true,
				theme = my_lualine_theme,
				component_separators = { left = ' ', right = ' '},
				section_separators = { left = '', right = ''},
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				}
			},
			sections = {
				lualine_a = {'mode'},
				lualine_b = {'branch', 'diff', 'diagnostics'},
				lualine_c = {
					{ 'filename' },
					{
						git_blame.get_current_blame_text,
						cond = git_blame.is_blame_text_available,
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = colors.orange },
					},
					{ 'encoding' },
					{ 'fileformat' },
					{ 'filetype' },
				},
				lualine_y = {'progress'},
				lualine_z = {'location'}
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {'filename'},
				lualine_x = {'location'},
				lualine_y = {},
				lualine_z = {}
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {}
		}
	end,
}
