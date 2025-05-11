local data = assert(vim.fn.stdpath("data")) --[[@as string]]
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"davvid/telescope-git-grep.nvim",
		"nvim-telescope/telescope-smart-history.nvim",
	},
	cmd = "Telescope",
	keys = { "<leader>f" },
	opts = {
		defaults = {
			preview = {
				filesize_limit = 5,
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},
		},
		extensions = {
			advanced_git_search = {
				diff_plugin = "fugitive",
			},
			fzf = {},
			history = {
				path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
				limit = 100,
			},
			git_grep = {
				regex = "extended",
			},
		},
	},
	config = function(_, opts)
		require("telescope").load_extension("advanced_git_search")
		require("telescope").setup(opts)
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("smart_history")
		require("telescope").load_extension("git_grep")
		local wk = require("which-key")
		wk.add({

			{
				"<leader>fG",
				function()
					require("telescope").extensions.advanced_git_search.show_custom_functions()
				end,
				desc = "git search",
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "search buffers",
			},
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "find files",
			},
			{
				"<leader>fg",
				function()
					require("git_grep").live_grep()
				end,
				desc = "live grep",
			},
			{
				"<leader>fh",
				function()
					require("telescope.builtin").help_tags()
				end,
				desc = "search tags",
			},
			{
				"<leader>fds",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "search lsp document symbols",
			},
			{
				"<leader>cs",
				function()
					require("telescope.builtin").lsp_document_symbols()
				end,
				desc = "search lsp document symbols",
			},
			{
				"<leader>gf",
				function()
					require("git_grep").live_grep()
				end,
				desc = "live git grep",
			},
			{ "<leader>ft", ":Telescope<CR>", desc = "run telescope" },
		})
	end,
}
