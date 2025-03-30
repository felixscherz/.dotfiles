return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"aaronhallaert/advanced-git-search.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = "Telescope",
	keys = { "<leader>f" },
	opts = {
		defaults = {
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
			},
			preview = {
				filesize_limit = 0.5,
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},
			live_grep = {
				glob_pattern = { "!.git/" },
			},
		},
		extensions = {
			advanced_git_search = {
				diff_plugin = "fugitive",
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	},
	config = function(_, opts)
		require("telescope").load_extension("advanced_git_search")
		require("telescope").setup(opts)
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
					require("telescope.builtin").live_grep()
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
			{ "<leader>ft", ":Telescope<CR>", desc = "run telescope" },
		})
		require("telescope").load_extension("fzf")
	end,
}
