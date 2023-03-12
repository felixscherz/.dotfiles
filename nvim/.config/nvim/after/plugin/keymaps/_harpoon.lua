local wk = require("which-key")
wk.register({
	name = "harpoon",
	a = { function() require("harpoon.mark").add_file() end, "add harpoon mark" },
	w = { function() require("harpoon.ui").toggle_quick_menu() end, "harpoon ui" },
	i = { function() require("harpoon.ui").nav_next() end, "harpoon next" },
	o = { function() require("harpoon.ui").nav_prev() end, "harpoon prev" },
}, { prefix = "<leader>" })
