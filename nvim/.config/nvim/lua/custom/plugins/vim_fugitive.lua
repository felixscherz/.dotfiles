return {
	"tpope/vim-fugitive",
	event = { "BufReadPre", "BufNewFile" },
	enabled = true,
	cmd = "Git",
	keys = { "<leader>g" },
	config = function()
		local wk = require("which-key")
		wk.add({
			name = "diffget",
			{ "gdh", ":diffget //2<CR>", desc = "get left diff" },
			{ "gdl", ":diffget //3<CR>", desc = "get right diff" },
		})

		local function branch_name()
			return vim.fn.system("git branch --show-current | tr -d '\n'")
		end

		wk.add({
			name = "git",
			{ "gpu", ":Git push<CR>", desc = "git push" },
			{ "gpd", ":Git pull<CR>", desc = "git pull" },
			{ "gc", ":Git commit<CR>", desc = "git commit" },
			{
				"gcm",
				function()
					local keys = vim.api.nvim_replace_termcodes(':Git commit -m ""<Left>', false, false, true)
					vim.api.nvim_feedkeys(keys, "n", {})
				end,
				desc = "git commit -m",
			},
			{ "gca", ":Git commit --amend --no-edit<CR>", desc = "git commit amend" },
			{
				"gb",
				function()
					vim.api.nvim_feedkeys(":Git switch ", "n", {})
				end,
				desc = "git switch",
			},
			{ "gs", ":Git<CR>", desc = "git status" },
			{
				"gu",
				function()
					vim.api.nvim_feedkeys(string.format(":Git push -u origin %s", branch_name()), "n", {})
				end,
				desc = "git set upstream",
			},
		})
	end,
}
