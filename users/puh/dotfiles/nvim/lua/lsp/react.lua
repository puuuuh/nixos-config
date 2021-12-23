local cap = require("lsp-configs")

lspconfig = require "lspconfig"
lspconfig.tsserver.setup {}
lspconfig.vuels.setup{}

vim.cmd('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)')
