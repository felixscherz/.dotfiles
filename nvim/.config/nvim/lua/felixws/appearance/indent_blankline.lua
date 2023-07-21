local M = {}

M.config = function()
	require("indent_blankline").setup({
		show_current_context = true,
		filetype_exclude = {
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
	})
end

return M
