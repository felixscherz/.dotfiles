local wk = require("which-key")
wk.register({
	name = "harpoon",
	m = {
		a = {
			function()
				require("harpoon.mark").add_file()
			end,
			"add harpoon mark",
		},
		w = {
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			"harpoon ui",
		},
	},
}, { prefix = "<leader>" })
