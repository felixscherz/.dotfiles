local M = {}

M.opts = {
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
}

M.config = function(plugin, opts)
	require("nvim-treesitter.configs").setup(M.opts)
end
return M
