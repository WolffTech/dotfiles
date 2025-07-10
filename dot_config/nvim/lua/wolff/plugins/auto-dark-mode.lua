return {
	"f-person/auto-dark-mode.nvim",
	opts = {
		update_interval = 3000,
		fallback = "dark",
		set_dark_mode = function()
			vim.g.my_theme_mode = "dark"
			vim.cmd("doautocmd User MyThemeChanged")
		end,
		set_light_mode = function()
			vim.g.my_theme_mode = "light"
			vim.cmd("doautocmd User MyThemeChanged")
		end,
	}
}
