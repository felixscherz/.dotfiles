return {
	"selimacerbas/mdkite.nvim",
	dependencies = { "selimacerbas/kitehost.nvim" },
	ft = { "markdown" },
	config = function()
		require("mdkite").setup({
			-- all optional; sane defaults shown
			instance_mode = "multi", -- "takeover" (one tab) or "multi" (tab per instance)
			port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
			open_browser = true,
			default_theme = "dark", -- "dark" or "light"; initial preview theme
			debounce_ms = 300,
		})
	end,
}
