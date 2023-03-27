local wk = require("which-key")
wk.register({
	name = "diffget",
	["gdh"] = { ":diffget //2<CR>", "get left diff" },
	["gdl"] = { ":diffget //3<CR>", "get right diff" },
})

wk.register({
	name = "git",
	g = {
		["pu"] = { ":Git push<CR>", "git push" },
		["pd"] = { ":Git pull<CR>", "git pull" },
		["c"] = { ":Git commit<CR>", "git commit" },
		["cm"] = {
			function()
                local keys = vim.api.nvim_replace_termcodes(':Git commit -m ""<Left>', false, false, true)
				vim.api.nvim_feedkeys(
					keys,
					"n",
					{}
				)
			end,
			"git commit -m",
		},
		["ca"] = { ":Git commit --amend --no-edit<CR>", "git commit amend" },
		b = {
			function()
				vim.api.nvim_feedkeys(":Git switch ", "n", {})
			end,
			"git switch",
		},
		s = { ":Git<CR>", "git status" },
	},
}, { prefix = "<leader>" })
