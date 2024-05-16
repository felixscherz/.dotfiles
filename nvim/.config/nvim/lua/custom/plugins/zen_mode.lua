return {
	"folke/zen-mode.nvim",
	config = function()
		require("zen-mode").setup({
			window = {
				height = 1.0,
				options = {
					number = true,
				},
			},
			plugins = {
				twilight = { enabled = false },
				tmux = { enabled = true },
				kitty = {
					enabled = true,
					font = "+4",
				},
			},
		})
	end,
	cmd = "ZenMode",
}
