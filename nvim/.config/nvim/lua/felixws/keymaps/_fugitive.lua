local wk = require("which-key")
wk.register({
	["gdh"] = { ":diffget //2<CR>", "get left diff" },
	["gdl"] = { ":diffget //3<CR>", "get right diff" },
})
