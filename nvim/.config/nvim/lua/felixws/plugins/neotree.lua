-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
	close_if_last_window = false,
	popup_border_style = "rounded",
	window = {
		width = 35,
		mappings = {
			["m"] = {
				"move",
				-- some commands may take optional config options, see `:h neo-tree-mappings` for details
				config = {
					show_path = "absolute", -- "none", "relative", "absolute"
				},
			},
			["c"] = {
				"copy",
				-- some commands may take optional config options, see `:h neo-tree-mappings` for details
				config = {
					show_path = "absolute", -- "none", "relative", "absolute"
				},
			},
		},
	},
	enable_git_status = true,
	git_status_async = true,
	filesystem = {
        find_by_full_path_words = true,
		hijack_netrw_behavior = "open_default",
		filtered_items = {
            hide_dotfiles = false,
			hide_by_name = {
				".DS_Store",
				"thumbs.db",
				"node_modules",
			},
            always_show = {
                ".gitlab-ci.yml",
                ".gitignore",
                ".pre-commit-config.yaml"
            }
		},
		use_libuv_file_watcher = true,
	},
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		indent = {
			indent_size = 2,
			padding = 1, -- extra padding on left hand side
			-- indent guides
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			-- expander config, needed for nesting files
			with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "ﰊ",
			-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
			-- then these will never be used.
			default = "*",
			highlight = "NeoTreeFileIcon",
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = true,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				-- Change type
				added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
				modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
				deleted = "✖", -- this can only be used in the git_status source
				renamed = "", -- this can only be used in the git_status source
				-- Status type
				untracked = "",
				ignored = "",
				unstaged = "",
				staged = "",
				conflict = "",
			},
		},
	},
	event_handlers = {
		{
			event = "vim_buffer_enter",
			handler = function()
				if vim.bo.filetype == "neo-tree" then
					vim.cmd("setlocal number")
					vim.cmd("setlocal nu")
					vim.cmd("setlocal relativenumber")
				end
			end,
		},
	},
})
