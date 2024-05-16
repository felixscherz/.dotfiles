local wk = require("which-key")
wk.register({
	name = "copilot",
	["cp"] = { ":CopilotChatToggle<CR>", "toggle copilot chat window" },
}, { prefix = "<leader>" })
