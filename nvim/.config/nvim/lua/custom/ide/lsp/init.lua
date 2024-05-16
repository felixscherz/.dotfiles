local M = {}

M.config = function(plugin, opts)
	local status_ok, _ = pcall(require, "lspconfig")
	if not status_ok then
		return
	end

	require("custom.ide.lsp.mason")
	require("custom.ide.lsp.handlers").setup()
	require("custom.ide.lsp.null-ls")
end

return M
