local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require "felixws.lsp.mason"
require("felixws.lsp.handlers").setup()
require "felixws.lsp.null-ls"
