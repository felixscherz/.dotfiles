local wk = require("which-key")
local neotest = require("neotest")

wk.register({
	["nt"] = {
		name = "neotest",
		o = { neotest.summary.open, "open summary" },
		p = { neotest.output_panel.open, "open panel" },
		r = { neotest.run.run, "run test" },
		f = {
			function()
				neotest.run.run(vim.fn.expand("%"))
			end,
			"run file",
		},
		s = { neotest.run.stop, "stop test" },
		a = { neotest.run.attach, "attach to test" },
	},
}, { prefix = "<leader>" })
