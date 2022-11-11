require("tokyonight").setup({
	transparent = true,
    styles = {sidebars = "transparent"},
    dim_inactive = true,
    on_colors = function(colors)
        colors.border = colors.blue
		colors.diff.delete = colors.git.delete
		colors.bg_highlight = "NONE"
	end,
	on_highlights = function(hl, _)
		hl.CursorLine = {
			color = hl.CursorLine.color,
			bold = true
		}
	end
})

require("lualine").setup({
	options = {
		-- ... your lualine config
		theme = "tokyonight",
		-- ... your lualine config
	},
})

vim.cmd("colorscheme tokyonight")

vim.api.nvim_set_hl(0, "Search", { link = "IncSearch" })
