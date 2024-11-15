return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = "v3.x",
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'MunifTanjim/nui.nvim',
		'3rd/image.nvim',
	},

	config = function()
		vim.keymap.set("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
		vim.keymap.set("n", "<leader>fr", "<cmd>Neotree refresh<cr>", { desc = "Refresh file explorer" })
	end,
}
