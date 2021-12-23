vim.cmd('nnoremap <silent> gd <cmd>lua require("telescope.builtin").lsp_definitions()<CR>')
vim.cmd('nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>')
vim.cmd('nnoremap <silent> gr <cmd>lua require("telescope.builtin").lsp_references()<CR>')
vim.cmd('nnoremap <silent> gi <cmd>lua require("telescope.builtin").lsp_implementations()<CR>')
vim.cmd('nnoremap <silent> ca <cmd>lua vim.lsp.buf.code_action()<CR>')
vim.cmd('nnoremap <silent> rn <cmd>lua vim.lsp.buf.rename()<CR>')
vim.cmd('nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>')

vim.cmd('nnoremap <silent> J <cmd>lua vim.lsp.buf.signature_help()<CR>')

vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', 'q', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap=true, silent=true})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 5,
      prefix = ' ⚠ ',
      severity_limit = "Warning",
    },
  }
)

vim.lsp.handlers["window/showMessage"] = function (_, _, result)
    print(result.message)
end

vim.lsp.handlers["textDocument/signatureHelp"] = function(_, method, result, _, bufnr)
end

-- vim.lsp.diagnostic.set_loclist()


