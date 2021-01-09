" init.vim file for ubuntu created on 5.12.2020
" plug directory: ~/.local/share/nvim/site/autoload/plug.vim

call plug#begin(stdpath('data') . '/plugged')
"appearance
    Plug 'joshdick/onedark.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'terryma/vim-smooth-scroll'
    Plug 'mhinz/vim-startify'
    Plug 'Yggdroot/indentLine'

"navigation
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'jremmen/vim-ripgrep'

"completion/templating
    Plug 'davidhalter/jedi-vim'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'ervandew/supertab'
    Plug 'jiangmiao/auto-pairs'
    Plug 'scrooloose/nerdcommenter'
    Plug 'SirVer/ultisnips'
    Plug 'vim-utils/vim-man'
    Plug 'dense-analysis/ale'

"command extention
    Plug 'tpope/vim-surround'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'mbbill/undotree'

"git
    Plug 'tpope/vim-fugitive'

"LaTeX
    Plug 'lervag/vimtex'

call plug#end()

set fileencoding=utf-8
set encoding=utf-8

set relativenumber
set smartindent
set expandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set nowrap
set scrolloff=8
set cmdheight=2
set nohlsearch
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.local/share/nvim/undodir
set undofile
set hidden
set incsearch
set clipboard^=unnamed,unnamedplus

syntax on
set number
set cursorline
set colorcolumn=80
highlight ColoColumn ctermbg=0 guibg=lightgrey
colorscheme onedark
set background=dark

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python3'

let mapleader=' '
 
"remap movement across windows
nnoremap <silent><leader>h :wincmd h<CR>
nnoremap <silent><leader>j :wincmd j<CR>
nnoremap <silent><leader>k :wincmd k<CR>
nnoremap <silent><leader>l :wincmd l<CR>
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>
nnoremap <silent> <Leader>< :resize -5<CR>
nnoremap <silent> <Leader>> :resize +5<CR>
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 10, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 10, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 15, 4)<CR>

nnoremap <leader><F2> :vsplit<CR>:terminal python %<CR> 
nnoremap <leader><F3> :vnew<CR>:terminal python<CR>

"remaps for plugins
nnoremap <leader>t :tabnew<CR>:Startify<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :NERDTree <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<space>
