return {
	"hrsh7th/nvim-cmp", -- The completion plugin
	config = function()
		local cmp_status_ok, cmp = pcall(require, "cmp")
		if not cmp_status_ok then
			return
		end

		local snip_status_ok, luasnip = pcall(require, "luasnip")
		if not snip_status_ok then
			return
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = {
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<Tab>"] = cmp.config.disable,
				["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
				-- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<C-y>"] = cmp.mapping(
					cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
					{ "i", "c" }
				),
			},
			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(_, item)
					local icons = {
						Array = " ",
						Boolean = " ",
						Class = " ",
						Color = " ",
						Constant = " ",
						Constructor = " ",
						Copilot = " ",
						Enum = " ",
						EnumMember = " ",
						Event = " ",
						Field = " ",
						File = " ",
						Folder = " ",
						Function = " ",
						Interface = " ",
						Key = " ",
						Keyword = " ",
						Method = " ",
						Module = " ",
						Namespace = " ",
						Null = " ",
						Number = " ",
						Object = " ",
						Operator = " ",
						Package = " ",
						Property = " ",
						Reference = " ",
						Snippet = " ",
						String = " ",
						Struct = " ",
						Text = " ",
						TypeParameter = " ",
						Unit = " ",
						Value = " ",
						Variable = " ",
					}
					if icons[item.kind] then
						item.kind = icons[item.kind] .. item.kind
					end
					return item
				end,
			},
			sources = {
				{ name = "nvim_lua" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer", keyword_length = 5 },
			},
			confirm_opts = {
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			},
			window = {
				documentation = cmp.config.window.bordered(),
			},
			experimental = {
				ghost_text = false,
				native_menu = false,
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
	end,
	dependencies = {
		"hrsh7th/cmp-buffer", -- buffer completions
		"hrsh7th/cmp-path", -- path completions
		"hrsh7th/cmp-cmdline", -- cmdline completions
		"saadparwaiz1/cmp_luasnip", -- snippet completions
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	event = { "InsertEnter" },
}
