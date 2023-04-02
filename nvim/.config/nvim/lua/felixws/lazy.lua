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
			"nvim-tree/nvim-web-devicons",
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
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
				-- show_current_context_start = true,
			})
		end,
		events = { "BufReadPre", "BufNewFile" },
        lazy=true,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
		events = { "BufReadPre", "BufNewFile" },
		lazy = true,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		keys = { "<leader>pv" },
		lazy = true,
	},

	-- fuzzy finder telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
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
			})
		end,
		lazy = true,
		keys = { "<leader>f" },
	},

	-- deal with surrounds
	{
		"tpope/vim-surround",
		lazy = true,
		event = "InsertEnter",
	},

	-- show undo history
	"mbbill/undotree",

	-- git plugin
	{
		"tpope/vim-fugitive",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
	},

	-- highlight substitution
	{
		"markonm/traces.vim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
	},

	-- highlights for markdown and orgmode
	{
		"lukas-reineke/headlines.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = true, -- or `opts = {}`
		enabled = false,
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
		lazy = true,
		keys = { "<leader>o" },
	},

	{ "stevearc/dressing.nvim", event = "VeryLazy", lazy = true },

	-- show markdown in browser
	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
		cmd = "MarkdownPreview",
		lazy = true,
	},

	-- coerce between different cases (camelCase snake_case)
	{
		"tpope/vim-abolish",
		events = { "BufReadPre", "BufNewFile" },
		lazy = true,
	},

	-- cmp plugins
	{
		"hrsh7th/nvim-cmp", -- The completion plugin
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions
			"hrsh7th/cmp-cmdline", -- cmdline completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
	},

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
			"rouge8/neotest-rust",
		},
		ft = { "python", "rust" },
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
					require("neotest-rust")({}),
				},
			})
		end,
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		events = { "VeryLazy" },
		lazy = true,
	},

	-- LSP
	{ "neovim/nvim-lspconfig", events = { "VeryLazy" }, lazy = true }, -- enable LSP
	{ "williamboman/mason.nvim", events = { "VeryLazy" }, lazy = true }, -- simple to use language server installer
	{ "williamboman/mason-lspconfig.nvim", events = { "VeryLazy" }, lazy = true }, -- simple to use language server installer

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
			})
		end,
		events = { "BufReadPre", "BufNewFile" },
		lazy = true,
	},

	-- icons (hopefully)
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
		event = "InsertEnter",
		lazy = true,
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
		events = { "BufReadPre", "BufNewFile" },
		lazy = true,
	},

	{
		"ThePrimeagen/harpoon",
		config = function()
			require("harpoon").setup()
		end,
		keys = { "<leader>m" },
		lazy = true,
	},

	-- collection of small plugins (highlight current word)
	"echasnovski/mini.nvim",

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
}, {
	defaults = {
		lazy = false,
	},
})
