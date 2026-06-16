return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
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
			"mermaid",
			"javascript",
			"typescript",
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
			"cpp",
			"cuda",
			"editorconfig",
			"embedded_template",
			"git_rebase",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"gowork",
			"hcl",
			"helm",
			"java",
			"javadoc",
			"jinja",
			"jinja_inline",
			"json",
			"kotlin",
			"latex",
			"nginx",
			"pem",
			"regex",
			"requirements",
			"ssh_config",
			"starlark",
			"tmux",
		},
	},
	config = function(_, opts)
		require("nvim-treesitter").setup(opts)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("custom_treesitter_highlight", { clear = true }),
			pattern = "*",
			callback = function(ev)
				local buf_name = vim.api.nvim_buf_get_name(ev.buf)
				local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
				if file_size <= 256 * 1024 then
					pcall(vim.treesitter.start, ev.buf)
				end
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("custom_treesitter_indent", { clear = true }),
			pattern = "*",
			callback = function()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
