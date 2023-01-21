local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = {
			transparent = true,
			styles = { sidebars = "transparent" },
			dim_inactive = true,
			on_colors = function(colors)
				colors.border = colors.blue
				colors.diff.delete = colors.git.delete
				colors.bg_highlight = "NONE"
			end,
			on_highlights = function(hl, _)
				hl.CursorLine = {
					color = hl.CursorLine.color,
					bold = false,
				}
			end,
		},
	},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup()
		end,
	},

	-- vertical bars to show indentation
	"Yggdroot/indentLine",

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	},

	-- fuzzy finder telescope + plenary as dependency
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" } },

	-- deal with surrounds
	"tpope/vim-surround",

	-- show undo history
	"mbbill/undotree",

	-- git plugin
	"tpope/vim-fugitive",

	-- highlight substitution
	"markonm/traces.vim",

	-- vimwiki for notetaking
	{
		"vimwiki/vimwiki",
		init = function()
			require("felixws.plugins.vimwiki")
		end,
	},

	-- spotify integration with vim
	-- "HendrikPetertje/vimify",

	-- show markdown in browser
	-- install without yarn or npm
	{ "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

	-- coerce between different cases (camelCase snake_case)
	"tpope/vim-abolish",

	-- cache lua for quicker startup
	"lewis6991/impatient.nvim",

	-- cmp plugins
	"hrsh7th/nvim-cmp", -- The completion plugin
	"hrsh7th/cmp-buffer", -- buffer completions
	"hrsh7th/cmp-path", -- path completions
	"hrsh7th/cmp-cmdline", -- cmdline completions
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp-signature-help",

	"jose-elias-alvarez/null-ls.nvim",

	{
		"nvim-neotest/neotest",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-vim-test",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
					require("neotest-plenary"),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
				},
			})
		end,
	},

	-- snippets
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- LSP
	"neovim/nvim-lspconfig", -- enable LSP
	"williamboman/mason.nvim", -- simple to use language server installer
	"williamboman/mason-lspconfig.nvim", -- simple to use language server installer

	-- treesitter

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- icons (hopefully)
	"lewis6991/gitsigns.nvim",

	-- take screenshots of code
	{
		"narutoxy/silicon.lua",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	"norcalli/nvim-colorizer.lua",

	"ThePrimeagen/harpoon",

	-- collection of small plugins (highlight current word)
	"echasnovski/mini.nvim",

	-- run curl commands from inside vim
	"diepm/vim-rest-console",

	-- presentation in nvim
	"sotte/presenting.vim",
})
