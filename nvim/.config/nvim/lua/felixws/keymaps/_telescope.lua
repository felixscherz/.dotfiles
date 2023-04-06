local wk = require("which-key")

wk.register({
	f = {
		f = { function() require("telescope.builtin").find_files() end, "find files" },
		g = { function() require("telescope.builtin").live_grep() end, "live grep" },
		b = { function() require("telescope.builtin").buffers() end, "search buffers" },
		h = { function() require("telescope.builtin").help_tags() end, "serach tags" },
		o = { function() require("telescope.builtin").live_grep({cwd = "~/org"}) end, "live grep orgmode" },
        G = { function() require("telescope").extensions.advanced_git_search.show_custom_functions() end, "git search"}
	},
}, { prefix = "<leader>" })
