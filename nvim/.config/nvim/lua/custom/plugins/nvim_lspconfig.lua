local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover({border='rounded'})<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"gl",
		'<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
		opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cf", "<cmd>lua vim.lsp.buf.format {async=true}<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ic", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>re", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>ih",
		"",
		vim.tbl_extend("keep", opts, {
			callback = function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
			end,
		})
	)
end
local on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Clear All the References",
		})
	end

	lsp_keymaps(bufnr)
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost" },
	config = function()
		require("neoconf").setup()

		local config = {
			virtual_text = true,
			update_in_insert = true,
			underline = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}

		vim.diagnostic.config(config)

		local servers = {
			"lua_ls",
			"basedpyright",
			"jsonls",
			"rust_analyzer",
			"ruff",
			"yamlls",
			"bashls",
			"clangd",
			"ansiblels",
			"jdtls",
			"clangd",
			"terraformls",
			"autotools_ls",
			"bzl",
			"gopls",
			"cmake",
			"ts_ls",
		}

		-- silence Server cancelled the request warning that happens with rust_analyzer: https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
		for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
			local default_diagnostic_handler = vim.lsp.handlers[method]
			vim.lsp.handlers[method] = function(err, result, context, _config)
				if err ~= nil and err.code == -32802 then
					return
				end
				return default_diagnostic_handler(err, result, context, _config)
			end
		end

		require("mason-lspconfig").setup({
			ensure_installed = servers,
			automatic_enable = false,
		})

		local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
		if not lspconfig_status_ok then
			return
		end

		local opts = {}

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		for _, server in pairs(servers) do
			opts = {
				on_attach = on_attach,
				capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
			}

			server = vim.split(server, "@")[1]

			local require_ok, conf_opts = pcall(require, "custom.lspconfig." .. server)
			if require_ok then
				opts = vim.tbl_deep_extend("force", conf_opts, opts)
			end

			lspconfig[server].setup(opts)
		end
	end,
	dependencies = { "b0o/schemastore.nvim", "williamboman/mason-lspconfig.nvim" },
}
