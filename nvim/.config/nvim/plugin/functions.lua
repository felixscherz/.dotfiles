local function insertFullPath()
	local filepath = vim.fn.expand("%:.")
	vim.fn.setreg("+", filepath) -- write to clippoard
end

vim.keymap.set("n", "<leader>pc", insertFullPath, { noremap = true, silent = true })
