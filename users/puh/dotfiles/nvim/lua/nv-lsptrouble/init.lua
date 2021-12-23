local trouble = require("trouble")

trouble.setup {}

vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>LspTroubleDocumentToggle<cr>",
  {silent = true, noremap = true}
)

vim.api.nvim_set_keymap("n", "<leader>xz", "<cmd>LspTroubleWorkspaceToggle<cr>",
  {silent = true, noremap = true}
)

