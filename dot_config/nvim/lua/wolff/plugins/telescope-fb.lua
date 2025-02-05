return {
	"nvim-telescope/telescope-file-browser.nvim",
	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },

	vim.keymap.set("n", "<space>fm", ":Telescope file_browser<CR>", { desc = "Open File Browser" })
}
