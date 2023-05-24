local M = {}

M.opts = {
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
}

local function register_keymaps()
	local wk = require("which-key")

	wk.register({
		f = {
            t = {
                ":Telescope<CR>",
                "run telescope"
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
			o = {
				function()
					require("telescope.builtin").live_grep({ cwd = "~/org" })
				end,
				"live grep orgmode",
			},
			G = {
				function()
					require("telescope").extensions.advanced_git_search.show_custom_functions()
				end,
				"git search",
			},
		},
	}, { prefix = "<leader>" })
end

M.config = function(plugin, opts)
	require("telescope").load_extension("advanced_git_search")
	require("telescope").setup(M.opts)
	register_keymaps()
end

return M
