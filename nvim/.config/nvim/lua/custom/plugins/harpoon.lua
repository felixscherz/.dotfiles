return {
	"ThePrimeagen/harpoon",
	keys = { "<leader>m" },
	config = function()
		require("harpoon").setup()
		local wk = require("which-key")
		wk.add({
			name = "harpoon",
			{
				"<leader>ma",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "add harpoon mark",
			},
			{
				"<leader>mw",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "harpoon ui",
			},
		})
	end,
}
