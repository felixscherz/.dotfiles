---@type vim.lsp.Config
return {
	settings = {
		basedpyright = {
			typeCheckingMode = "standard",
			analysis = {
				useLibraryCodeForTypes = true,
			},
			autoSearchPaths = true,
			diagnosticMode = "openFilesOnly",
		},
	},
}
