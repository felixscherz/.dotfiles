local wk = require("which-key")

wk.register({
	["nt"] = {
		name = "neotest",
		o = {
			function()
				require("neotest").summary.open()
			end,
			"open summary",
		},
		p = { function() require("neotest").output_panel.open() end, "open panel" },
		r = { function() require("neotest").run.run() end , "run test" },
		f = {
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			"run file",
		},
		s = { function() require("neotest").run.stop() end, "stop test" },
		a = { function() require("neotest").run.attach() end, "attach to test" },
	},
}, { prefix = "<leader>" })
