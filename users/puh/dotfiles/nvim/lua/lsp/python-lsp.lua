local cap = require("lsp-configs")

require'lspconfig'.pylsp.setup{
    capabilities = cap.get_cap(),
}



