require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
    indent = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    }
}

vim.api.nvim_exec([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
]], false)
