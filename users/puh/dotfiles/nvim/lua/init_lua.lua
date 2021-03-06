if not vim.g.vscode then
    -- general settings
    require('theme')
end
require('settings')

if not vim.g.vscode then
    vim.g.rooter_patterns = {"*.sln","Cargo.toml",".git"}

    -- lsp
    require('lsp')
    require('lsp.python-lsp')
    require('lsp.rust-lsp')
    require('lsp.clangd-lsp')
    require('lsp.golang-lsp')
    require('lsp.react')
    require('lsp.lua-lsp')
    require('lsp.csharp')
    require('lsp.nix')

    -- dap
    require('vimspector')

    require('nv-compe')
    require('nv-lsptrouble')
    require('fzf')

    require('uml')

    -- require('airline')
    require('lsp_status')

    -- status bar
    require('nv-galaxyline.my')

    -- lang-specific
    require('langs.rust')

    require('nv-treesitter')
end
