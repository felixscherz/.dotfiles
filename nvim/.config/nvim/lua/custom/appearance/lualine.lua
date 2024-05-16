local M = {}

M.config = function()
	require("lualine").setup({
		options = {
			theme = "tokyonight",
			globalstatus = true,
		},
		sections = {
			lualine_c = {
				"lsp_progress",
			},
		},
	})
end

return M
