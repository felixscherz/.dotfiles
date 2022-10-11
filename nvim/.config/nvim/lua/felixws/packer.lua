-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'
  use 'joshdick/onedark.vim'

  -- vertical bars to show indentation
  use 'Yggdroot/indentLine'

  -- statusline
  use 'vim-airline/vim-airline'
  -- filetree navigation
  use 'preservim/nerdtree'
  -- git status flags for nerdtree
  use 'Xuyuanp/nerdtree-git-plugin'

  use 'jiangmiao/auto-pairs'

  use {'neoclide/coc.nvim', branch = 'release'}

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
  end)

