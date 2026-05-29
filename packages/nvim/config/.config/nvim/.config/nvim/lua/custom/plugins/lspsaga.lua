return {
	"nvimdev/lspsaga.nvim",
	opts = {
		lightbulb = { enable = false },
		hover = {
			max_width = 0.6,
			max_height = 0.3,
		},
	},
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
