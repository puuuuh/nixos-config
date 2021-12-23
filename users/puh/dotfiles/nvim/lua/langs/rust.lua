vim.cmd("au Filetype rust set colorcolumn=100")

vim.api.nvim_exec([[
map <esc>OH <home>
cmap <esc>OH <home>
imap <esc>OH <home>
map <esc>OF <end>
cmap <esc>OF <end>
imap <esc>OF <end>
]], false)

vim.api.nvim_set_keymap('n', '<F1>',  ':Crun<CR>G', { })
vim.api.nvim_set_keymap('n', '<home>',  ':RustDebugBuild<CR>', { })
vim.api.nvim_set_keymap('n', '<end>',  ':RustDebugTest<CR>', { })
vim.api.nvim_set_keymap('n', '<Insert>',  ":lua OpenCargo()<CR>", { })

vim.g.cargo_shell_command_create_buffer='vnew'
vim.g.cargo_one_buffer = 1
-- vim.g.rustfmt_autosave = 1

