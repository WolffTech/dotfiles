return {
	"folke/todo-comments.nvim",
	event = {"BufRead", "BufNewFile"},
	dependencies = { "nvim-lua/plenary.nvim", },

	config = function ()
		local todo_comments = require("todo-comments")

		vim.keymap.set("n", "<leader>tn", function() todo_comments.jump_next() end, { desc = "Next TODO" })
		vim.keymap.set("n", "<leader>tp", function() todo_comments.jump_prev() end, { desc = "Previous TODO" })

		todo_comments.setup()
	end
}
