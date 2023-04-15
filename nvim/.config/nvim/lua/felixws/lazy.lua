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
		opts = require("felixws.appearance.tokyonight").opts,
	},
	{
		"folke/which-key.nvim",
		config = require("felixws.keymaps.whichkey").config,
		lazy = false,
	},

	-- vertical bars to show indentation
	{
		"lukas-reineke/indent-blankline.nvim",
		config = require("felixws.appearance.indent_blankline").config,
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
		config = require("felixws.appearance.lualine").config,
		lazy = false,
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = require("felixws.navigation.neotree").config,
		keys = { { "<leader>pv", "<cmd>Neotree<CR>" } },
	},

	-- fuzzy finder telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "aaronhallaert/advanced-git-search.nvim" },
		config = require("felixws.navigation.telescope").config,
		cmd = "Telescope",
		keys = { "<leader>f" },
	},

	-- deal with surrounds
	{
		"tpope/vim-surround",
		event = "InsertEnter",
	},

	-- show undo history
	{ "mbbill/undotree", lazy = false },

	-- git plugin
	{
		"tpope/vim-fugitive",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Git",
		keys = { "<leader>g" },
	},

	-- highlight substitution
	{
		"markonm/traces.vim",
		event = { "BufReadPre", "BufNewFile" },
	},
	--orgmode
	{
		"nvim-orgmode/orgmode",
		config = require("felixws.navigation.orgmode").config,
		keys = { "<leader>o" },
	},

	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				win_options = {
					winblend = 0,
				},
			},
		},
		event = "VeryLazy",
	},

	-- show markdown in browser
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
		cmd = "MarkdownPreview",
	},

	-- coerce between different cases (camelCase snake_case)
	{
		"tpope/vim-abolish",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- cmp plugins
	{
		"hrsh7th/nvim-cmp", -- The completion plugin
		config = function()
			require("felixws.ide.cmp")
		end,
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		event = { "InsertEnter" },
	},

	{ "jose-elias-alvarez/null-ls.nvim", event = { "VeryLazy" } },

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-vim-test",
			"rouge8/neotest-rust",
		},
		config = require("felixws.ide.neotest").config,
		keys = { "<leader>n" },
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = { "InsertEnter" },
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		event = { "VeryLazy" },
		config = require("felixws.ide.lsp").config,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
	}, -- simple to use language server installer
	{ "williamboman/mason-lspconfig.nvim" }, -- simple to use language server installer

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require("felixws.ide.treesitter").config,
		event = { "BufReadPost", "BufNewFile" },
	},

	-- icons (hopefully)
	{
		"lewis6991/gitsigns.nvim",
		event = "InsertEnter",
	},

	-- take screenshots of code
	{
		"narutoxy/silicon.lua",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"norcalli/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"ThePrimeagen/harpoon",
		keys = { "<leader>m" },
	},

	-- collection of small plugins (highlight current word)
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup()
		end,
		lazy = false,
	},

	-- run curl commands from inside vim
	"diepm/vim-rest-console",

	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
		lazy = false,
	},
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("trouble").setup()
			end,
			ft = { "qf" },
		},
	},
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup()
		end,
		cmd = "ZenMode",
	},
	{
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup()
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		lazy = false,
	},
}, {
	defaults = {
		lazy = true,
	},
	ui = {
		border = "rounded",
	},
})
