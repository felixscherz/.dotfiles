---@type vim.lsp.Config
return {
	root_dir = vim.fs.root(0, {
		"pyproject.toml",
		"ruff.toml",
		".ruff.toml",
		"setup.py",
		"setup.cfg",
		".git",
	}),
	init_options = {
		settings = {
			format = {
				args = { "--line-length=120" },
			},
			lint = {
				args = { "--line-length=120" },
			},
		},
	},
}
