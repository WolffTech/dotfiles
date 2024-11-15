return {
	"echasnovski/mini.files",
	lazy = false,
	keys = {
		{ "<leader>fm", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Open mini.files (Directory of Current File)" }
	},

	config = function()
		require("mini.files").setup()
	end,
}
