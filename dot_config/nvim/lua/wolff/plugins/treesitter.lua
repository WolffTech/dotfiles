return {
	"romus204/tree-sitter-manager.nvim",
	lazy = false,
	config = function()
		require("tree-sitter-manager").setup({
			auto_install = true,
			highlight = true,
			ensure_installed = {
				"javascript", "typescript", "html", "css", "c", "lua", "rust",
				"vim", "vimdoc", "query", "c_sharp", "arduino", "bash", "cmake",
				"dockerfile", "go", "java", "json", "markdown", "markdown_inline",
				"python", "sql", "terraform", "zig", "todotxt", "templ", "yaml",
				"powershell", "nix", "gitcommit",
			},
		})
	end,
}
