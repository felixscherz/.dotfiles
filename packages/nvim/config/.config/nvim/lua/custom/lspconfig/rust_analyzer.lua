---@type vim.lsp.Config
return {
	settings = {
		["rust-analyzer"] = {
			files = {
				excludeDirs = { ".tox", ".venv", "venv", ".git" },
			},
		},
	},
}
