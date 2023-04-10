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
		config = require("felixws.keymaps.whichkey"),
		lazy = false,
	},

	{
		"kdheepak/tabline.nvim",
		enabled = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("tabline").setup({
				options = {
					show_tabs_only = true,
				},
			})
		end,
		lazy = false,
	},

	-- vertical bars to show indentation
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
				-- show_current_context_start = true,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
		lazy = false,
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
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
		config = function()
			require("felixws.plugins.neotree")
		end,
		keys = { { "<leader>pv", "<cmd>Neotree<CR>" } },
	},

	-- fuzzy finder telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "aaronhallaert/advanced-git-search.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
					live_grep = {
						glob_pattern = { "!.git/" },
					},
				},
				extensions = {
					advanced_git_search = {
						diff_plugin = "fugitive",
					},
				},
			})
			require("telescope").load_extension("advanced_git_search")
		end,
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
		config = function()
			require("orgmode").setup_ts_grammar()
			require("orgmode").setup({
				org_agenda_files = { "~/org/**/*", "~/org/refile.org" },
				org_default_notes_file = "~/org/refile.org",
				org_capture_templates = {
					t = { description = "Task", template = "* TODO %?\n  %u\n  %a", target = "~/org/todos/todos.org" },
					m = {
						description = "Meeting",
						template = "* MEETING %u %?:meeting:\n  %U",
						target = "~/org/meetings/meetings.org",
					},
					c = {
						description = "Code",
						template = "* CODE %?:code:\n  %U\n%a\n#+begin_src\n%x\n#+end_src",
						target = "~/org/code/code.org",
					},
				},
			})
		end,
		keys = { "<leader>o" },
	},

	{
		"stevearc/dressing.nvim",
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
			require("felixws.cmp")
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
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "-rP", "--log-level", "DEBUG" },
					}),
					require("neotest-plenary"),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
					require("neotest-rust")({ args = { "--no-capture" } }),
				},
				quickfix = {
					enabled = false,
				},
			})
		end,
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
		config = function()
			require("felixws.lsp")
		end,
	}, -- enable LSP
	{ "williamboman/mason.nvim", event = { "VeryLazy" } }, -- simple to use language server installer
	{ "williamboman/mason-lspconfig.nvim", event = { "VeryLazy" } }, -- simple to use language server installer

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
					"yaml",
					"org",
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
					additional_vim_regex_highlighting = { "org" },
				},
				indent = { enable = true },
				context_commentstring = { enable = true, enable_autocmd = false },
			})
		end,
		event = { "BufReadPost", "BufNewFile" },
	},

	-- icons (hopefully)
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
		event = "InsertEnter",
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
		event = { "BufReadPre", "BufNewFile" },
	},

	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup()
		end,
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
})
