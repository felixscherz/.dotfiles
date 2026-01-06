---@type vim.lsp.Config
return {
	root_dir = vim.fs.root(0, {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	}),
	settings = {
		basedpyright = {
			typeCheckingMode = "standard",
			autoSearchPaths = true,
			diagnosticMode = "openFilesOnly",
			useLibraryCodeForTypes = true,
		},
	},
}
