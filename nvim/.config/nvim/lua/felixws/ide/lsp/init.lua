local M = {}

M.config = function(plugin, opts)
	local status_ok, _ = pcall(require, "lspconfig")
	if not status_ok then
		return
	end

	require("felixws.ide.lsp.mason")
	require("felixws.ide.lsp.handlers").setup()
	require("felixws.ide.lsp.null-ls")
end

return M
