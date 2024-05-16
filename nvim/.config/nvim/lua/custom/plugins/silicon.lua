return {
	"narutoxy/silicon.lua",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local colors = require("tokyonight.colors").setup()
		require("silicon").setup({
			theme = "Visual Studio Dark+",
			windowControls = false,
			padHoriz = 0,
			padVert = 0,
			linePad = 1,
			bgColor = colors.bg,
			shadowBlurRadius = 0,
		})
	end,
}

-- available themes in silicon.lua
--  local default_themes = {
-- "1337",
-- "Coldark-Cold",
-- "Coldark-Dark",
-- "DarkNeon",
-- "Dracula",
-- "GitHub",
-- "Monokai Extended",
-- "Monokai Extended Bright",
-- "Monokai Extended Light",
-- "Monokai Extended Origin",
-- "Nord",
-- "OneHalfDark",
-- "OneHalfLight",
-- "Solarized (dark)",
-- "Solarized (light)",
-- "Sublime Snazzy",
-- "TwoDark",
-- "Visual Studio Dark+",
-- "ansi",
-- "base16",
-- "base16-256"}
--
