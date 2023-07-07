local M = {}

M.config = function()
	require("indent_blankline").setup({
		show_current_context = true,
        filetype_exclude = {'fugitive'}
	})
end

return M
