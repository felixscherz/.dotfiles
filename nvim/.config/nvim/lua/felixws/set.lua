vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

vim.opt.cursorline = true

vim.opt.wrap = false
vim.opt.scrolloff = 8

vim.g.mapleader = " "

vim.opt.hidden = true

vim.opt.termguicolors = true

vim.opt.clipboard = vim.opt.clipboard ^ { "unnamed", "unnamedplus" }
