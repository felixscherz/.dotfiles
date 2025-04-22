return {
	branch = "main",
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
		{ "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
	},
	enabled = true,
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		-- See Configuration section for options
	},
	event = "VeryLazy",
	-- See Commands section for default commands if you want to lazy load on them
}
