local M = {}

M.config = function()
	require("ibl").setup({
		exclude = {
			filetypes = {
				"fugitive",
				"zsh",
				"git",
				"neo-tree",
				"lspinfo",
				"checkhealth",
				"help",
				"man",
				"conf",
				"",
			},
		},
	})
end

return M
