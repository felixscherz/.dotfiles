return {
	"boyanangelov/startup-tips.nvim",
	event = "VimEnter",
	config = function()
		require("startup_tips").setup()
	end,
	enabled = false,
}
