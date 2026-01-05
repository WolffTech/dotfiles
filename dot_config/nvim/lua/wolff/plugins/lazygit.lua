return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	},

	config = function()
		vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { noremap = true, silent = true })
		-- Keymaps for LazyGit buffer only
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lazygit",
			callback = function(args)
				local buf = args.buf
				local opts = { buffer = buf, noremap = true, silent = true }
				-- close buffer with 'q'
				vim.keymap.set("n", "q", "<cmd>close<CR>", opts)
				-- Remap Esc to work properly in lazygit buffer
				vim.keymap.set({ "i", "n", "t" }, "<Esc>", "<Esc>", opts)
			end,
		})
	end,
}
