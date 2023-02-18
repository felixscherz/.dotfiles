local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
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
				colors.gitSigns = colors.git
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
			vim.o.timeoutlen = 900
			require("which-key").setup()
		end,
	},

	{
		"kdheepak/tabline.nvim",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("tabline").setup({
				options = {
					show_tabs_only = true,
				},
			})
		end,
	},

	-- vertical bars to show indentation
	"Yggdroot/indentLine",

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", "arkav/lualine-lsp-progress" },
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

	-- neorg
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		opts = {
			load = {
				["core.defaults"] = {}, -- Loads default behaviour
				["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
				["core.norg.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/notes",
						},
					},
				},
			},
		},
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

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

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"help",
					"python",
					"markdown",
					"markdown_inline",
					"rust",
					"norg",
					"yaml",
					"norg_meta",
					"mermaid",
					"javascript",
					"toml",
					"bash",
					"terraform",
					"sql",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<CR>",
						node_decremental = "<BS>",
					},
				},
				highlight = {
					enable = true,
                    additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	-- icons (hopefully)
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- take screenshots of code
	{
		"narutoxy/silicon.lua",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup()
		end,
	},

	-- collection of small plugins (highlight current word)
	"echasnovski/mini.nvim",

	-- run curl commands from inside vim
	"diepm/vim-rest-console",

	-- presentation in nvim
	"sotte/presenting.vim",
})
