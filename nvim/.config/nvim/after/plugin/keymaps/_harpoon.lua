local wk = require("which-key")
wk.register({
	name = "harpoon",
	a = { require("harpoon.mark").add_file, "add harpoon mark" },
	w = { require("harpoon.ui").toggle_quick_menu, "harpoon ui" },
	i = { require("harpoon.ui").nav_next, "harpoon next" },
	o = { require("harpoon.ui").nav_prev, "harpoon prev" },
}, { prefix = "<leader>" })
