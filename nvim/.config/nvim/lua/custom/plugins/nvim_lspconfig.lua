return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost" },
	config = require("custom.ide.lsp").config,
	dependencies = { "b0o/schemastore.nvim" },
}
