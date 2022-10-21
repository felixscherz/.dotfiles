-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use 'ellisonleao/gruvbox.nvim'
  use 'shinchu/lightline-gruvbox.vim'


  -- vertical bars to show indentation
  use 'Yggdroot/indentLine'

  -- statusline (maybe use lualine in the future?)
  use 'itchyny/lightline.vim'

  -- filetree navigation
  use 'preservim/nerdtree'
  -- git status flags for nerdtree
  use 'Xuyuanp/nerdtree-git-plugin'

  use 'jiangmiao/auto-pairs'

  use {'neoclide/coc.nvim', branch = 'release'}
  use 'folke/lsp-colors.nvim'

  -- fuzzy finder telescope + plenary as dependency
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'


  -- deal with surrounds
  use 'tpope/vim-surround'


  -- show undo history
  use 'mbbill/undotree'

  -- tab completion
  use 'ervandew/supertab'

  -- git plugin
  use 'tpope/vim-fugitive'

  -- highlight substitution
  use 'markonm/traces.vim'

  -- lightspeed navigation
  -- use 'ggandor/lightspeed.nvim'

  -- vimwiki for notetaking
  use 'vimwiki/vimwiki'

  -- spotify integration with vim
  use 'HendrikPetertje/vimify'

  -- show markdown in browser
  -- install without yarn or npm
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
  end)

