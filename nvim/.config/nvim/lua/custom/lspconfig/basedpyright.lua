---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			typeCheckingMode = "standard",
			autoSearchPaths = true,
			diagnosticMode = "openFilesOnly",
			useLibraryCodeForTypes = true,
		},
	},
}
