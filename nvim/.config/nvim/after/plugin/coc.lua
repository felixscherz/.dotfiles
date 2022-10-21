vim.cmd("command! -nargs=0 Format :call CocAction('format')")
vim.cmd("command! -nargs=0 SortImports :CocCommand python.sortImports")
vim.cmd("xmap <leader>f  <Plug>(coc-format-selected)")
vim.cmd("nmap <leader>f  <Plug>(coc-format-selected)")
vim.cmd("command! -nargs=0 Prettier :CocCommand prettier.formatFile")

vim.cmd[[nmap <silent> gd <Plug>(coc-definition)]]
vim.cmd[[nmap <silent> gy <Plug>(coc-type-definition)]]
vim.cmd[[nmap <silent> gi <Plug>(coc-implementation)]]
vim.cmd[[nmap <silent> gr <Plug>(coc-references)]]


local home = os.getenv("HOME")
vim.cmd(string.format("call coc#config('python.pythonPath', '%s/.nvim-python3/bin/python3')", home))
vim.cmd(string.format("call coc#config('python.formatting.yapfPath', '%s/.nvim-python3/bin/yapf')", home))
vim.cmd(string.format("call coc#config('python.formatting.blackPath', '%s/.nvim-python3/bin/black')", home))
vim.cmd(string.format("call coc#config('python.sortImports.path', '%s/.nvim-python3/bin/isort')", home))

vim.cmd[[
" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
]]
