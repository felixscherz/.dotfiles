"init.vim file for ubuntu created on 5.12.2020
" plug directory: ~/.local/share/nvim/site/autoload/plug.vim

call plug#begin(stdpath('data') . '/plugged')
    "theme for nvim
    Plug 'joshdick/onedark.vim' 
    "airline plugin to display git branch etc
    Plug 'vim-airline/vim-airline'
    "display homepage
    Plug 'mhinz/vim-startify'
    "display vertical bars for line indentation
    Plug 'Yggdroot/indentLine'
    "filetree navigation
    Plug 'preservim/nerdtree'
    "git status flags for nerdtree
    Plug 'Xuyuanp/nerdtree-git-plugin' 
    "replace ripgrep: search pattern in files
    Plug 'mileszs/ack.vim'
    "command line fuzzy finder
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    "handle and generate tags 
    Plug 'ludovicchabant/vim-gutentags'
    "completion and formatting engine, need to install language servers
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "helps with suing tab completion
    Plug 'ervandew/supertab'
    "automatically open/close brackets, put cursor in the middle
    Plug 'jiangmiao/auto-pairs'
    "handle comments, <leader>cc comments highlighted lines
    Plug 'scrooloose/nerdcommenter'
    "view man pages in vim
    Plug 'vim-utils/vim-man'
    "expand abbreviation (ex: html:5 <c-<>, -> create html template)    
    Plug 'mattn/emmet-vim'
    "deal with surrounds
    Plug 'tpope/vim-surround'
    "show undo history
    Plug 'mbbill/undotree'
    "git plugin for vim
    Plug 'tpope/vim-fugitive'
call plug#end()

" #############################################################################
" setup venvs for nvim python
let g:python3_host_prog = '~/.nvim-python3/bin/python3'

" #############################################################################
" settings
"encoding to be used when showing files
set encoding=utf-8
"encoding to be used when saving files
set fileencoding=utf-8
"turn on relative linenumbers
set relativenumber
set number
"smart indents on new line
set smartindent
"use a number of spaces for tab
set expandtab
"number of spaces a tab accounts for
set tabstop=4 softtabstop=4
"spaces to shift
set shiftwidth=4
"don't wrap text
set nowrap
"minimum number of lines to keep below the cursor
set scrolloff=8
"number of lines for command window
set cmdheight=2
"stop highlighting for search
set nohlsearch
"only use case sensitive search if pattern includes upppercase characters
set smartcase
"don't create swapfiles
set noswapfile
"don't create backup beofre saving (use undotree)
set nobackup
"directory to save undo history
set undodir=~/.local/share/nvim/undodir
set undofile
"buffers become hidden when abandoned
set hidden
"turn on incremental serach
set incsearch
"couple yank with clipboard
set clipboard^=unnamed,unnamedplus
"turn off concealing of text modifiers 
set conceallevel=0
" appearance 
syntax on
"turn on horizontal cursorline
set cursorline
"set vertical bar to guide line width
set colorcolumn=80
"change color of the bar
highlight ColoColumn ctermbg=0 guibg=lightgrey
"set colorscheme
colorscheme onedark
"set background
set background=dark
"time for CursorHold to take effect
set updatetime=300

" #############################################################################
"  filetype plugins
" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType html,css,scss,js setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType php setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType scss setl iskeyword+=@-@

" #############################################################################
" general remaps
" spacebar as leader key
let mapleader=' '

" quick sourcing of vimrc
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
 
" easier movement across windows
nnoremap <silent><leader>h :wincmd h<CR>
nnoremap <silent><leader>j :wincmd j<CR>
nnoremap <silent><leader>k :wincmd k<CR>
nnoremap <silent><leader>l :wincmd l<CR>
" easier resizing of windows
nnoremap <silent><Leader>+ :vertical resize +5<CR>
nnoremap <silent><Leader>- :vertical resize -5<CR>
nnoremap <silent><Leader>< :resize -5<CR>
nnoremap <silent><Leader>> :resize +5<CR>
" remapping yank rest of line
nnoremap Y y$ 
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" hotkeys to run python code
nnoremap <leader><F2> :vsplit<CR>:terminal python3 %<CR> 
nnoremap <leader><F3> :vnew<CR>:terminal python3<CR>

" #############################################################################
" plugin settings
" fzf remaps
nnoremap <leader>f :Files 
nnoremap <leader>b :Buffers 

" startify customizations
nnoremap <leader>t :tabnew<CR>:Startify<CR>

" undotree customizations
nnoremap <leader>u :UndotreeShow<CR>

" NERDTree customizations
nnoremap <leader>pv :NERDTree <bar> :vertical resize 30<CR>
let NERDTreeShowLineNumbers=1

" ack customizations to search patterns
nnoremap <leader>ps :Ack<space>

" Fugitive Conflict Resolution
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" gutentags config
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_ctags_exclude = [
      \ '*.git', '*.svg', '*.hg',
      \ '*/tests/*',
      \ 'build',
      \ 'dist',
      \ '*sites/*/files/*',
      \ 'bin',
      \ 'node_modules',
      \ 'bower_components',
      \ 'cache',
      \ 'compiled',
      \ 'docs',
      \ 'example',
      \ 'bundle',
      \ 'vendor',
      \ '*.md',
      \ '*-lock.json',
      \ '*.lock',
      \ '*bundle*.js',
      \ '*build*.js',
      \ '.*rc*',
      \ '*.json',
      \ '*.min.*',
      \ '*.map',
      \ '*.bak',
      \ '*.zip',
      \ '*.pyc',
      \ '*.class',
      \ '*.sln',
      \ '*.Master',
      \ '*.csproj',
      \ '*.tmp',
      \ '*.csproj.user',
      \ '*.cache',
      \ '*.pdb',
      \ 'tags*',
      \ 'cscope.*',
      \ '*.css',
      \ '*.less',
      \ '*.scss',
      \ '*.exe', '*.dll',
      \ '*.mp3', '*.ogg', '*.flac',
      \ '*.swp', '*.swo',
      \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
      \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
      \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
      \ ]

" coc.nvim settings
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" help pyright to find project root
autocmd FileType python let b:coc_root_patterns = ['pyrightconfig.json']

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

command! -nargs=0 SortImports :CocCommand python.sortImports

" disable quote conceal in json files
let g:indentLine_conceallevel = 0

