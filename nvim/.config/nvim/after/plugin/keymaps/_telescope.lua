local builtin = require("telescope.builtin")
local wk = require("which-key")

wk.register({
	f = {
		f = { builtin.find_files, "find files" },
		g = { builtin.live_grep, "live grep" },
		b = { builtin.buffers, "search buffers" },
		h = { builtin.help_tags, "serach tags" },
	},
}, { prefix = "<leader>" })
