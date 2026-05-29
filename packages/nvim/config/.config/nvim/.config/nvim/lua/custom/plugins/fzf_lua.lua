return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = { "fzf-native" },
	cmd = { "FzfLua" },
	-- keys = {
	--     {"<leader>fg", "<cmd>:FzfLua live_grep<CR>"},
	--     {"<leader>ff", "<cmd>:FzfLua files<CR>"}
	-- }
}
