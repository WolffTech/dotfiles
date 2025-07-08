return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"moyiz/blink-emoji.nvim",
			"ray-x/cmp-sql",
			'ribru17/blink-cmp-spell'
		},

		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<C-Z>"] = { "accept", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					draw = { gap = 2 },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					},
				},
			},
			signature = { enabled = true },

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "spell" },
				providers = {
					spell = {
						name = 'Spell',
						module = 'blink-cmp-spell',
						opts = {
							enable_in_context = function()
								local curpos = vim.api.nvim_win_get_cursor(0)
								local captures = vim.treesitter.get_captures_at_pos(
									0,
									curpos[1] - 1,
									curpos[2] - 1
								)
								local in_spell_capture = false
								for _, cap in ipairs(captures) do
									if cap.capture == 'spell' then
										in_spell_capture = true
									elseif cap.capture == 'nospell' then
										return false
									end
								end
								return in_spell_capture
							end,
						},
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
