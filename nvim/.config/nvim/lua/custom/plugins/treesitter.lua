return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
	event = { "BufReadPost", "BufNewFile" },
	lazy = false,
	opts = {
		ensure_installed = {
			"lua",
			"vim",
			"vimdoc",
			"python",
			"rst",
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
			"diff",
			"comment",
			"gitattributes",
			"luadoc",
			"make",
			"http",
			"jq",
			"html",
			"css",
			"htmldjango",
			"pymanifest",
			"cmake",
			"ini",
			"dockerfile",
			"git_config",
			"gitcommit",
			"gitignore",
		},
		incremental_selection = {
			enable = true,
			disable = { "markdown" },
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				scope_incremental = "<CR>",
				node_decremental = "<BS>",
			},
		},
		highlight = {
			additional_vim_regex_highlighting = false,
			enable = true,
			disable = function(_, bufnr)
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				return file_size > 256 * 1024
			end,
		},
		indent = { enable = true, disable = { "yaml" } },
	},
}
