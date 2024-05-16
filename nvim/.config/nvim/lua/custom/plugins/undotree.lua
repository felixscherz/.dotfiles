return {
	"mbbill/undotree",
	lazy = false,
	keys = { "<leader>u" },

	config = function()
		local wk = require("which-key")
		wk.register({
			name = "UndoTree",
			u = { "<cmd>UndotreeToggle<CR>", "clip buffer" },
		}, { prefix = "<leader>" })
	end,
}
