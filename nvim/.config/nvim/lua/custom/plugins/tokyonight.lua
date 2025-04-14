return {
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
			vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "markdownCode" })
		end,
		opts = {
			transparent = true,
			styles = { sidebars = "transparent", floats = "transparent" },
			dim_inactive = true,
			on_colors = function(colors)
				colors.border = colors.blue
			end,
		},
	},
}
