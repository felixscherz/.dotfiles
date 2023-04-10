local M = {}

M.setup = function()
	vim.o.timeout = true
	vim.o.timeoutlen = 900
	require("which-key").setup()
end

return M
