-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- colorscheme
	use("folke/tokyonight.nvim")

	-- vertical bars to show indentation
	use("Yggdroot/indentLine")

	-- statusline (maybe use lualine in the future?)
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	-- fuzzy finder telescope + plenary as dependency
	use("nvim-lua/plenary.nvim")
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" } })

	-- deal with surrounds
	use("tpope/vim-surround")

	-- show undo history
	use("mbbill/undotree")

	-- tab completion
	-- use("ervandew/supertab")

	-- git plugin
	use("tpope/vim-fugitive")

	-- highlight substitution
	use("markonm/traces.vim")

	-- lightspeed navigation
	-- use 'ggandor/lightspeed.nvim'

	-- vimwiki for notetaking
	use("vimwiki/vimwiki")

	-- spotify integration with vim
	use("HendrikPetertje/vimify")

	-- show markdown in browser
	-- install without yarn or npm
	use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install" })

	-- coerce between different cases (camelCase snake_case)
	use("tpope/vim-abolish")

	-- cache lua for quicker startup
	use("lewis6991/impatient.nvim")

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-nvim-lsp-signature-help")

	use("jose-elias-alvarez/null-ls.nvim")

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/mason.nvim") -- simple to use language server installer
	use("williamboman/mason-lspconfig.nvim") -- simple to use language server installer

	-- treesitter

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- icons (hopefully)
	use("nvim-tree/nvim-web-devicons")
	use("lewis6991/gitsigns.nvim")

	-- take screenshots of code
	-- Lua
	use({
		"narutoxy/silicon.lua",
		requires = { "nvim-lua/plenary.nvim" },
	})

	use("norcalli/nvim-colorizer.lua")

    use("ThePrimeagen/harpoon")

    -- collection of small plugins (highlight current word)
    use("echasnovski/mini.nvim")

    -- run curl commands from inside vim
    use("diepm/vim-rest-console")
end)
