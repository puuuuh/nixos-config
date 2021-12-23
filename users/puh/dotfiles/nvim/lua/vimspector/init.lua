
vim.api.nvim_set_var("vimspector_sidebar_width", 40)
vim.api.nvim_set_var("vimspector_code_minwidth", 85)
vim.api.nvim_set_var("vimspector_terminal_minwidth", 40)
vim.api.nvim_set_var("vimspector_terminal_maxwidth", 40)

vim.fn.sign_define("vimspectorBP",
    {text = "● ", texthl = "BP"})
vim.fn.sign_define("vimspectorBPCond",
    {text = "● ", texthl = "BP"})
vim.fn.sign_define("vimspectorBPDisabled",
    {text = "● ", texthl = "SignColumn"})
vim.fn.sign_define("vimspectorPC",
    {text = " ▶", texthl = "SignColumn", linehl="CursorLine"})
vim.fn.sign_define("vimspectorPCBP",
    {text = "●▶", texthl = "SignColumn", linehl="CursorLine"})

vim.api.nvim_set_var("vimspector_enable_mappings", "HUMAN")

vim.api.nvim_exec([[
hi bp_style guifg=#FF0000 gui=bold
function CustomiseVimspectorUI()	
  q
  call win_gotoid( g:vimspector_session_windows.variables )
  wincmd J
  resize 10
endfunction

augroup MyVimspectorUICustomisation
  autocmd!
  autocmd User VimspectorUICreated call CustomiseVimspectorUI()
augroup END
]], false)

