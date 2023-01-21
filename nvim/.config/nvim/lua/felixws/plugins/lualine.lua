require("lualine").setup({
	options = {
		theme = "tokyonight",
		globalstatus = true,
	},
	sections = {
		lualine_c = {
			...,
			"lsp_progress",
		},
	},
})
