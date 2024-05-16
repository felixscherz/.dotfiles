local M = {}

M.opts = {
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
}

return M
