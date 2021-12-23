local cap = require("lsp-configs")

lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    capabilities = cap.get_cap(),
    cmd = {"gopls","serve"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	}
  }

vim.cmd('autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)')
