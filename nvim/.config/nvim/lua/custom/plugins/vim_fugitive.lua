return {
	"tpope/vim-fugitive",
	event = { "BufReadPre", "BufNewFile" },
	enabled = true,
	cmd = "Git",
	keys = { "<leader>g" },
}
