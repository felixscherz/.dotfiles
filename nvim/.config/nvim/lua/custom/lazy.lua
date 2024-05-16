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
	spec = {
		{ import = "custom/plugins" },
		{
			"folke/which-key.nvim",
			config = require("custom.keymaps.whichkey").config,
			lazy = false,
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
				require("custom.ide.cmp")
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

		{ "nvimtools/none-ls.nvim", event = { "VeryLazy" } },

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
			config = require("custom.ide.neotest").config,
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
			config = require("custom.ide.lsp").config,
			dependencies = { "b0o/schemastore.nvim" },
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
			config = require("custom.ide.treesitter").config,
			event = { "BufReadPost", "BufNewFile" },
			lazy = false,
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
				{ "nvim-neotest/nvim-nio", commit = "7fa5545299fc7a48d5ec74d27f414b862060095f" },
			},
			config = function()
				require("custom.ide.dap.dap").setup()
			end,
		},
		{
			"ThePrimeagen/refactoring.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("custom.ide.refactoring").setup()
			end,
			event = "BufReadPre",
		},
		-- icons (hopefully)
		{
			"lewis6991/gitsigns.nvim",
			event = "InsertEnter",
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
						kitty = {
							enabled = true,
							font = "+4",
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
		{
			"nvimdev/lspsaga.nvim",
			opts = { lightbulb = { enable = false } },
			event = "LspAttach",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			branch = "canary",
			dependencies = {
				{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
				{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			},
			opts = {
				debug = true, -- Enable debugging
				-- See Configuration section for rest
			},
			cmd = { "CopilotChatOpen", "CopilotChatToggle" },
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
