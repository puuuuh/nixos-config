local saga = require 'lspsaga'
saga.init_lsp_saga{
	use_saga_diagnostic_sign = true,
	error_sign = '⛔',
	warn_sign = '⚠',
	hint_sign = '❗',
	infor_sign = '',
	dianostic_header_icon = '   ',
	code_action_icon = ' ',
	code_action_prompt = {
		enable = true,
		sign = true,
		sign_priority = 20,
		virtual_text = true,
	},
	finder_definition_icon = '  ',
	finder_reference_icon = '  ',
	finder_action_keys = {
		open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
	},
	code_action_keys = {
		quit = 'q',exec = '<CR>'
	},
	rename_action_keys = {
		quit = '<C-c>',exec = '<CR>'  -- quit can be a table
	},
	definition_preview_icon = '  ',
	border_style = 1,
}


vim.cmd('nnoremap <silent> gh <cmd>lua require\'lspsaga.provider\'.lsp_finder()<CR>')

-- code action
vim.cmd('nnoremap <silent><leader>ca :Lspsaga code_action<CR>')
vim.cmd('vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>')
