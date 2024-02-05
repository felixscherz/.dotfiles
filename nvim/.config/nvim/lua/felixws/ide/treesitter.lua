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
		"make",
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
		enable = true,
	},
	indent = { enable = true, disable = { "yaml" } },
}

M.config = function(plugin, opts)
	require("nvim-treesitter.configs").setup(M.opts)
end
return M
