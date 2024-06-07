return {
	"linux-cultist/venv-selector.nvim",
	branch = "regexp",
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
	opts = {
		name = { "venv", ".venv" },
	},
	event = "VeryLazy",
	keys = {
		{
			"<leader>vs",
			"<cmd>:VenvSelect<cr>",
		},
		{
			"<leader>vc",
			"<cmd>:VenvSelectCached<cr>",
		},
	},
}
