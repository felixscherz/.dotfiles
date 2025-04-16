return {
	"tpope/vim-fugitive",
	event = { "BufReadPre", "BufNewFile" },
	enabled = true,
	cmd = "Git",
	keys = { "<leader>g" },
	config = function()
		local wk = require("which-key")

		local function branch_name()
			return vim.fn.system("git branch --show-current | tr -d '\n'")
		end

		wk.add({
			name = "git",
			{ "<leader>gpu", ":Git push<CR>", desc = "git push" },
			{ "<leader>gpd", ":Git pull<CR>", desc = "git pull" },
			{ "<leader>gc", ":Git commit<CR>", desc = "git commit" },
			{
				"<leader>gcm",
				function()
					local keys = vim.api.nvim_replace_termcodes(':Git commit -m ""<Left>', false, false, true)
					vim.api.nvim_feedkeys(keys, "n", false)
				end,
				desc = "git commit -m",
			},
			{ "<leader>gca", ":Git commit --amend --no-edit<CR>", desc = "git commit amend" },
			{
				"<leader>gb",
				function()
					vim.api.nvim_feedkeys(":Git switch ", "n", false)
				end,
				desc = "git switch",
			},
			{ "<leader>gs", ":Git<CR>", desc = "git status" },
			{
				"<leader>gu",
				function()
					vim.api.nvim_feedkeys(string.format(":Git push -u origin %s", branch_name()), "n", false)
				end,
				desc = "git set upstream",
			},
		})
	end,
}
