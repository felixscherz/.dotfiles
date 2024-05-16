return {
	"jackMort/ChatGPT.nvim",
	event = "VeryLazy",
	config = function()
		if os.getenv("OPENAI_API_KEY") ~= nil then
			require("chatgpt").setup({
				openai_params = { max_tokens = 1000 },
				chat = {
					keymaps = {
						close = { "<C-c>" },
						yank_last = "<C-y>",
						yank_last_code = "<C-k>",
						scroll_up = "<C-u>",
						scroll_down = "<C-d>",
						toggle_settings = "<C-o>",
						new_session = "<C-n>",
						cycle_windows = "<Tab>",
						select_session = "<Enter>",
						rename_session = "r",
						delete_session = "d",
					},
				},
				popup_input = {
					submit = "<C-s>",
				},
			})
		end
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
