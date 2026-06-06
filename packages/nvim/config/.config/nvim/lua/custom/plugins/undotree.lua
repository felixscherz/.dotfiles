return {
	"mbbill/undotree",
	lazy = false,
	keys = { "<leader>u" },

	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", name = "UndoTree" },
		})
	end,
}
