local wk = require("which-key")
wk.register({
	name = "UndoTree",
	u = { "<cmd>UndotreeToggle<CR>", "clip buffer" },
}, { prefix = "<leader>" })
