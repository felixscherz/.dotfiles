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
				colors.diff.delete = colors.git.delete
				colors.gitSigns = colors.git
				colors.none = "NONE"
			end,
			on_highlights = function(hl, c)
				hl.TelescopeNormal = {
					bg = c.none,
				}
				hl.TelescopeBorder = {
					bg = c.none,
				}
				hl.DiagnosticVirtualTextError.bg = c.none
				hl.DiagnosticVirtualTextInfo.bg = c.none
				hl.DiagnosticVirtualTextWarn.bg = c.none
				hl.DiagnosticVirtualTextHint.bg = c.none
				hl.CursorLine = {
					color = hl.CursorLine.color,
					bold = false,
				}
			end,
		},
	},
}
