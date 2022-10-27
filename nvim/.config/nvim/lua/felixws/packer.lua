-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

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

  --use {'neoclide/coc.nvim', branch = 'release'}
  --use 'folke/lsp-colors.nvim'

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

  -- coerce between different cases (camelCase snake_case)
  use 'tpope/vim-abolish'


  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/mason.nvim" -- simple to use language server installer
  use "williamboman/mason-lspconfig.nvim" -- simple to use language server installer
  end)

