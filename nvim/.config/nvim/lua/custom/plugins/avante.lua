return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = "39787969c769204861f1339e52ffcdd00e648220",
	config = function()
		local opts = {
			provider = vim.env.OPENAI_API_BASE and "openai" or "copilot",
			copilot = {
				timeout = 60000,
			},
			openai = {
				endpoint = vim.env.OPENAI_API_BASE or "https://api.openai.com/v1",
				model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
				timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
				temperature = 0,
				max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
				--reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
			},
			behaviour = {
				use_cwd_as_project_root = true,
			},
			hints = { enabled = false },
			system_prompt = function()
				local hub = require("mcphub").get_hub_instance()
				if hub then
					return hub:get_active_servers_prompt() or ""
				end
			end,

			custom_tools = { require("mcphub.extensions.avante").mcp_tool() },
		}
		require("avante").setup(opts)
	end,
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		-- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		"ravitemer/mcphub.nvim",
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
		},
	},
}
