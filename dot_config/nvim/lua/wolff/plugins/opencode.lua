return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		-- Required for `snacks` provider.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
	},
	config = function()
		-- Map vim background to OpenCode theme
		local function get_opencode_theme()
			if vim.o.background == "light" then
				return "catppuccin"
			else
				return "catppuccin-macchiato"
			end
		end

		---@type opencode.Opts
		vim.g.opencode_opts = {
			-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			provider = {
			snacks = {
				-- Pass through necessary environment variables for system theme detection
				-- env = {
				-- 	COLORTERM = vim.env.COLORTERM or "truecolor",
				-- 	TERM = vim.env.TERM,
				-- 	TERM_PROGRAM = vim.env.TERM_PROGRAM,
				-- 	TERMINFO = vim.env.TERMINFO,
				-- },
				win = {
						position = "right",
						enter = false,
						wo = {
							winbar = "",
						},
						bo = {
							filetype = "opencode_terminal",
						},
					},
				},
			},
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

	-- <leader>oa: Opens OpenCode prompt with "@this: " pre-filled and auto-submits the current context
	-- Works in normal and visual mode to include selected text or current buffer
	vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "OpenCode: Ask" })
	-- <leader>os: Opens a picker to select from available OpenCode actions
	vim.keymap.set({ "n", "x" }, "<leader>os", function() require("opencode").select() end, { desc = "OpenCode: Select action" })
	-- <leader>ot: Toggles the OpenCode terminal window visibility
	-- Works in normal and terminal mode for easy access from within the terminal
	vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end, { desc = "OpenCode: Toggle" })

	-- <leader>or: Operator to add a range to OpenCode with "@this " prefix
	-- Use with motions like "or{" to add surrounding block or "orip" for inner paragraph
	vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end, { expr = true, desc = "OpenCode: Add range" })
	-- <leader>ol: Adds the current line to OpenCode with "@this " prefix
	-- The "_" suffix makes it operate on the current line only
	vim.keymap.set("n", "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "OpenCode: Add line" })

	-- <leader>ou: Scrolls the OpenCode terminal window up by half a page
	vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end, { desc = "OpenCode: Half page up" })
	-- <leader>od: Scrolls the OpenCode terminal window down by half a page
	vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "OpenCode: Half page down" })

	-- Dynamically inject theme based on vim.o.background before opening terminal
	local opencode = require("opencode")
	local config = require("opencode.config")

	local original_toggle = opencode.toggle
	opencode.toggle = function(...)
		if config.provider and config.provider.opts then
			config.provider.opts.env = config.provider.opts.env or {}
			config.provider.opts.env.OPENCODE_CONFIG_CONTENT = vim.json.encode({
				theme = get_opencode_theme()
			})
		end
		return original_toggle(...)
	end

	local original_ask = opencode.ask
	opencode.ask = function(...)
		if config.provider and config.provider.opts then
			config.provider.opts.env = config.provider.opts.env or {}
			config.provider.opts.env.OPENCODE_CONFIG_CONTENT = vim.json.encode({
				theme = get_opencode_theme()
			})
		end
		return original_ask(...)
	end
	end,
}
