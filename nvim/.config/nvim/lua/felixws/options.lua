local options = {
	nu = true,
	number = true,
	relativenumber = true,
	hidden = true,
	termguicolors = true,
	clipboard = vim.opt.clipboard ^ { "unnamed", "unnamedplus" },
	swapfile = false,
	backup = false,
	updatetime = 50,
	smartindent = true,
	tabstop = 4,
	softtabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	scrolloff = 8,
	sidescrolloff = 8,
	cursorline = true,
	wrap = false,
	colorcolumn = "120",
	conceallevel = 0,
	hlsearch = true,
	incsearch = true,
	ignorecase = true,
	smartcase = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.g.mapleader = " "

vim.g.python3_host_prog = "~/.nvim-python3/bin/python3"
