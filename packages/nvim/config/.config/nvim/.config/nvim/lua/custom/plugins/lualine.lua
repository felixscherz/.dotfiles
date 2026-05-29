return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"arkav/lualine-lsp-progress",
		"nvim-telescope/telescope-symbols.nvim",
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "tokyonight",
				globalstatus = true,
			},
			sections = {
				lualine_c = {
					"lsp_progress",
				},
			},
		})
	end,
	lazy = false,
}
