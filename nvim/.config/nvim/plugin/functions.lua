local function insertFullPath()
	local filepath = vim.fn.expand("%:.")
	vim.fn.setreg("+", filepath) -- write to clippoard
end

local function insertFullPathWithLines()
	local filepath = vim.fn.expand("%:.")
	local begin_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if begin_line > end_line then
		begin_line, end_line = end_line, begin_line
	end
	local result
	if begin_line == end_line then
		result = filepath .. ":" .. begin_line
	else
		result = filepath .. ":" .. begin_line .. "-" .. end_line
	end
	vim.fn.setreg("+", result) -- write to clipboard
end

vim.keymap.set("n", "<leader>pc", insertFullPath, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>pc", insertFullPathWithLines, { noremap = true, silent = true })
