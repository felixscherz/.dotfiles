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
			bold = false
		}
	end
})

