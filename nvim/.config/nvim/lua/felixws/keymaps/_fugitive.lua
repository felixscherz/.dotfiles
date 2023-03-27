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
		["cm"] = { ":Git commit -m ", "git commit -m" },
		["ca"] = { ":Git commit --amend --no-edit<CR>", "git commit amend" },
		b = { ":Git switch ", "git switch" },
		s = { ":Git<CR>", "git status" },
	},
}, { prefix = "<leader>" })
