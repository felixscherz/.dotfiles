return {
	"nvimdev/lspsaga.nvim",
	opts = { lightbulb = { enable = false } },
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
}
