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
		"powershell", "nix", "gitcommit",
	})

	-- Enable treesitter features for all filetypes
	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			local buf = args.buf
			local ft = vim.bo[buf].filetype

			-- Try to start treesitter highlighting
			local ok, err = pcall(vim.treesitter.start, buf)

			-- Auto-install parser if not available
			if not ok and ft ~= "" then
				local lang = vim.treesitter.language.get_lang(ft) or ft

				-- Check if parser is already installed
				local parser_installed = pcall(vim.treesitter.language.add, lang)

				if not parser_installed then
					-- Notify user and attempt to install
					vim.notify(
						string.format("Treesitter parser for '%s' not found. Installing...", lang),
						vim.log.levels.INFO
					)

					-- Install parser asynchronously
					vim.schedule(function()
						local install_ok = pcall(ts.install, { lang })
						if install_ok then
							vim.notify(
								string.format("Treesitter parser for '%s' installed successfully!", lang),
								vim.log.levels.INFO
							)
							-- Retry starting treesitter
							pcall(vim.treesitter.start, buf)
						else
							vim.notify(
								string.format("Failed to install Treesitter parser for '%s'", lang),
								vim.log.levels.WARN
							)
						end
					end)
				end
			end

			-- Enable treesitter-based indentation
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end,
	})

	-- Register custom filetypes
	vim.treesitter.language.register("templ", "templ")
	vim.treesitter.language.register("nix", "nix")
	vim.treesitter.language.register("gitcommit", "gitcommit")
	end,
}

