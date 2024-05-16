return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	cmd = "MarkdownPreview",
	config = function()
		vim.fn.stdpath("data")
		vim.g.mkdp_highlight_css = vim.fn.stdpath("config") .. "/assets/tokyo-night-dark.css"
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}
