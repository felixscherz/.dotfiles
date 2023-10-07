local servers = {
	"lua_ls",
	"pyright",
	"jsonls",
	"rust_analyzer",
	"ruff_lsp",
	"yamlls",
    "bashls",
    "clangd",
    "ansiblels",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("felixws.ide.lsp.handlers").on_attach,
		capabilities = require("felixws.ide.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "felixws.ide.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
