return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "aaronhallaert/advanced-git-search.nvim" },
	cmd = "Telescope",
	keys = { "<leader>f" },
	opts = {
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
	},
	config = function(_, opts)
		require("telescope").load_extension("advanced_git_search")
		require("telescope").setup(opts)
		local wk = require("which-key")

		wk.register({
			f = {
				t = {
					":Telescope<CR>",
					"run telescope",
				},
				f = {
					function()
						require("telescope.builtin").find_files()
					end,
					"find files",
				},
				g = {
					function()
						require("telescope.builtin").live_grep()
					end,
					"live grep",
				},
				b = {
					function()
						require("telescope.builtin").buffers()
					end,
					"search buffers",
				},
				h = {
					function()
						require("telescope.builtin").help_tags()
					end,
					"serach tags",
				},
				G = {
					function()
						require("telescope").extensions.advanced_git_search.show_custom_functions()
					end,
					"git search",
				},
			},
		}, { prefix = "<leader>" })
	end,
}
