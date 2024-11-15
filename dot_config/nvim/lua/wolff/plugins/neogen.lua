return {
	"danymat/neogen",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local neogen = require("neogen")

		neogen.setup({
			snippet_engine = "luasnip"
		})

		vim.keymap.set("n", "<leader>nf", function() neogen.generate({ type = "func" }) end, { desc = "Generate function" })
		vim.keymap.set("n", "<leader>nt", function() neogen.generate({ type = "type" }) end, { desc = "Generate type" })
		vim.keymap.set("n", "<leader>nc", function() neogen.generate({ type = "class" } )end, { desc = "Generate class" })
	end,
}
