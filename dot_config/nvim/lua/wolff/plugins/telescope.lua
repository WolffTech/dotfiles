return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/todo-comments.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		defaults = {
			layout_stragety = "horizontal",
			layout_config = { prompt_position = "top" },
			sorting_strategy = "assending",
			winblend = 0,
		},
	},

	config = function()
		require('telescope').setup({})
		require('telescope').load_extension('fzf')

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
		vim.keymap.set('n', '<C-f>', builtin.git_files, { desc = "Find git files" })
		vim.keymap.set('n', '<leader>fs', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Grep string" })
		vim.keymap.set('n', '<leader>ft', "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
		vim.keymap.set('n', '<leader>fn', "<cmd>Telescope notify<cr>", { desc = "Preview notifications" })
	end
}
