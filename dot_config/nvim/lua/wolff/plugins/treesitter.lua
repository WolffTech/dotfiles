return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = 'main',
	config = function()
		local ts = require("nvim-treesitter")

		-- Setup with default install directory
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Pre-install these parsers
		ts.install({
			"javascript", "typescript", "html", "css", "c", "lua", "rust",
			"vim", "vimdoc", "query", "c_sharp", "arduino", "bash", "cmake",
			"dockerfile", "go", "java", "json", "markdown", "markdown_inline",
			"python", "sql", "terraform", "zig", "todotxt", "templ", "yaml",
			"powershell",
		})

		-- Enable treesitter features for all filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype

				-- Try to start treesitter highlighting
				local ok = pcall(vim.treesitter.start, buf)

				-- Auto-install parser if not available
				if not ok and ft ~= "" then
					local lang = vim.treesitter.language.get_lang(ft) or ft
					ts.install({ lang })
				end

				-- Enable treesitter-based indentation
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Register templ filetype
		vim.treesitter.language.register("templ", "templ")
	end,
}

