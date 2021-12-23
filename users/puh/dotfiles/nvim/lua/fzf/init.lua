vim.api.nvim_set_keymap('n', '<Leader>;', ':Buffers<CR>', {})
vim.api.nvim_set_keymap('n', '<C-p>', ':Files<CR>', {})

vim.api.nvim_exec(
[[
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always'.shellescape(<q-args>), 1, \   <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

function! FZF_list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'source': FZF_list_cmd(), 'options': '--tiebreak=index'}, <bang>0)


]], false)
