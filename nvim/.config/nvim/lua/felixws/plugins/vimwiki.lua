vim.cmd([[
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md',
                      \ 'template_path': '$HOME/vimwiki/templates',
                      \ 'template_default': 'default',
                      \ 'template_ext': '.html',
                      \ 'customwiki2html': '$HOME/.local/share/nvim/site/pack/packer/start/vimwiki/autoload/vimwiki/customwiki2html.sh'}]
]])

vim.cmd([[
command! Diary VimwikiDiaryIndex
augroup vimwikigroup
    autocmd!
    " automatically update links on read diary
    autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
augroup end
]])

vim.cmd([[
let g:markdown_fenced_languages = ['go','perl','sh', 'python', 'cpp', 'c', 'javascript', 'vim']
]])
