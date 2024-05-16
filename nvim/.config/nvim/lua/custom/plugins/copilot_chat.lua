return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	opts = {
		debug = true, -- Enable debugging
		-- See Configuration section for rest
	},
	cmd = { "CopilotChatOpen", "CopilotChatToggle" },
	kyes = { "<leader>cp" },
	config = function(_, opts)
		require("CopilotChat").setup(opts)
		require("which-key").register({
			name = "copilot",
			["cp"] = { ":CopilotChatToggle<CR>", "toggle copilot chat window" },
		}, { prefix = "<leader>" })
	end,
}
