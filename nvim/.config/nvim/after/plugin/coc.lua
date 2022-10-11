vim.cmd("command! -nargs=0 Format :call CocAction('format')")
vim.cmd("command! -nargs=0 SortImports :CocCommand python.sortImports")
vim.cmd("xmap <leader>f  <Plug>(coc-format-selected)")
vim.cmd("nmap <leader>f  <Plug>(coc-format-selected)")
vim.cmd("command! -nargs=0 Prettier :CocCommand prettier.formatFile")


local home = os.getenv("HOME")
vim.cmd(string.format("call coc#config('python.pythonPath', '%s/.nvim-python3/bin/python3')", home))
vim.cmd(string.format("call coc#config('python.formatting.yapfPath', '%s/.nvim-python3/bin/yapf')", home))
