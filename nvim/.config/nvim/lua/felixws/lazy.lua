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
		main = "ibl",
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
		branch = "v3.x",
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
		enabled = true,
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
		lazy = false,
	},

	{
		"stevearc/dressing.nvim",
		opts = require("felixws.appearance.dressing").opts,
		event = "VeryLazy",
	},

	-- show markdown in browser
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		cmd = "MarkdownPreview",
		config = function()
			vim.fn.stdpath("data")
			vim.g.mkdp_highlight_css = vim.fn.stdpath("config") .. "/assets/tokyo-night-dark.css"
		end,
		ft = { "markdown" },
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
		event = { "BufReadPost" },
		config = require("felixws.ide.lsp").config,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		config = function(_, opts)
			require("mason").setup(opts)
		end,
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "◍",
					package_pending = "◍",
					package_uninstalled = "◍",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		},
	}, -- simple to use language server installer
	{ "williamboman/mason-lspconfig.nvim" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = require("felixws.ide.treesitter").config,
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"mfussenegger/nvim-dap",
		event = "BufReadPre",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"nvim-telescope/telescope-dap.nvim",
			{ "leoluz/nvim-dap-go", module = "dap-go" },
			{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
		},
		config = function()
			require("felixws.ide.dap.dap").setup()
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("felixws.ide.refactoring").setup()
		end,
		event = "BufReadPre",
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
			require("zen-mode").setup({
				window = {
					height = 1.0,
					options = {
						number = true,
					},
				},
				plugins = {
					twilight = { enabled = false },
					tmux = { enabled = true },
					alacritty = {
						enabled = true,
						font = "14.0",
					},
				},
			})
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
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			if os.getenv("OPENAI_API_KEY") ~= nil then
				require("chatgpt").setup({
					openai_params = { max_tokens = 1000 },
					chat = {
						keymaps = {
							close = { "<C-c>" },
							yank_last = "<C-y>",
							yank_last_code = "<C-k>",
							scroll_up = "<C-u>",
							scroll_down = "<C-d>",
							toggle_settings = "<C-o>",
							new_session = "<C-n>",
							cycle_windows = "<Tab>",
							select_session = "<Enter>",
							rename_session = "r",
							delete_session = "d",
						},
					},
					popup_input = {
						submit = "<C-s>",
					},
				})
			end
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		opts = {
			name = { "venv", ".venv" },
		},
		event = "VeryLazy",
		keys = {
			{
				"<leader>vs",
				"<cmd>:VenvSelect<cr>",
			},
			{
				"<leader>vc",
				"<cmd>:VenvSelectCached<cr>",
			},
		},
	},
}, {
	defaults = {
		lazy = true,
	},
	ui = {
		border = "rounded",
	},
})
