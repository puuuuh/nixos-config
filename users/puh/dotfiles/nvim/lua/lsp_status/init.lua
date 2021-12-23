local lsp_status = require("lsp-status")

lsp_status.register_progress()
lsp_status.config {
  current_function = false,
  status_symbol = " ",
  indicator_ok = "",
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'I',
  indicator_hint = 'H',
}
