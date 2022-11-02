require("tokyonight").setup({
	transparent = true,
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
