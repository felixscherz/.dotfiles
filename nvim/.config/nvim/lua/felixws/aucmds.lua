local cmd = vim.cmd

-- Highlight on yank
cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

cmd([[
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
]])
