local wk = require("which-key")

wk.add({
	name = "kulala",
	{
		"<leader>r",
		function()
			require("kulala").run()
		end,
	},
})
