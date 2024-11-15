return {
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	config = function ()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				terraform = { "terraform_fmt" },
				java = { "google-java-format" },
				go = { "gofmt", "goimports" },
				powershell = { "posh" },
			},
			vim.keymap.set("n", "<leader>cf", function() conform.format() end, { desc = "Conform Format" })
		})
	end

}
