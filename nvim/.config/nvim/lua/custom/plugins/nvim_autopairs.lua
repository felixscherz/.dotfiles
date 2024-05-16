return {
	"windwp/nvim-autopairs",
	config = function()
		require("nvim-autopairs").setup()
	end,
	event = { "BufReadPre", "BufNewFile", "InsertEnter" },
}
