local M = {}

M.config = function()
	require("indent_blankline").setup({
		show_current_context = true,
		filetype_exclude = {
			"fugitive",
			"git",
			"neo-tree",
			"lspinfo",
			"checkhealth",
			"help",
			"man",
			"",
		},
	})
end

return M
