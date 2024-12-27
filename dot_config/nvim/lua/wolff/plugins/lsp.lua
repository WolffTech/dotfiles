return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"nvimtools/none-ls.nvim",
		"L3MON4D3/LuaSnip",
	},


	config = function()
		local cmp = require('cmp')
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities())

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"vtsls",
				"powershell_es",
				"arduino_language_server",
				"clangd",
				"htmx",
				"html",
				"marksman",
				"pylyzer",
				"terraformls",
				"jsonls",
				"gopls",
				"csharp_ls",
				"sqls",
				"docker_compose_language_service",
			},

		require("fidget").setup({}),
		require("mason").setup(),

			handlers = {
				function(server_name) -- default handler (optional)

					require("lspconfig")[server_name].setup {
						capabilities = capabilities
					}
				end,

				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup {
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								}
							}
						}
					}
				end,

				["terraformls"] = function ()
					local lspconfig = require("lspconfig")
					lspconfig.terraformls.setup {
						capabilities = capabilities,
						cmd = { 'terraform-ls', 'serve' },
					}
				end,

				["marksman"] = function ()
					local lspconfig = require("lspconfig")
					lspconfig.marksman.setup {
						capabilities = capabilities,
					}
				end
			}
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For 'luasnip'
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				["<C-i>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
				{ name = 'Property'},
			}, {
				{ name = 'buffer' },
			}),
			window = {
				completion = cmp. config.window.bordered(),
				documentation = cmp. config.window.bordered(),
			},

		})

		vim.diagnostic.config({
			update_in_insert = false,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end
}
