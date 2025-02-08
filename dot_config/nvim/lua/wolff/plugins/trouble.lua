return {
	"folke/trouble.nvim",
	opts = {
		use_diagnostic_signs = true,
		action_keys = {
			open_in_telescope = true,
		},
	},
	cmd = "Trouble",
	keys = {
			{
			"<leader>dd",
			function()
				require("trouble").refresh()
				local ok, telescope = pcall(require, "telescope.builtin")
				if ok then
					telescope.diagnostics({
						severity_limit = "hint",
						no_sign = false,
						wrap_results = true,
						layout_config = {
							width = 0.9,
							height = 0.8,
							preview_cutoff = 1,
						}
					})
				else
					vim.notify("Telescope not loaded!", vim.log.levels.ERROR)
				end
			end,
			desc = "Show All Diagnostics (Telescope)",
		},
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
	config = function()
		require('trouble').setup({
			modes = {
				diagnostics = {
					mode = "document_diagnostics",
					use_diagnostic_signs = true,
					merge = true,
				}
			}
		})
	end
}
