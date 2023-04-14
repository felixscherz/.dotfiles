local M = {}

M.config = function()
	vim.o.timeout = true
	vim.o.timeoutlen = 900
	require("which-key").setup()
end

return M
