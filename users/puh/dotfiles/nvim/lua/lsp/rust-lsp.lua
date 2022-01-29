local cap = require("lsp-configs")
local lsp_status = require("lsp-status")
local api = vim.api

require'lspconfig'.rust_analyzer.setup({
    capabilities = cap.get_cap(),
    on_attach = function(client)
        local old_request = client.request
        if not client.request_hijacked then
            client.request_hijacked = true
            client.request = function(method, params, old_handler, bufnr)
                local handler = old_handler
                if method == "textDocument/completion" then
                    handler = function(err, response, ctx)
                        if not(err or response == nil) then
                            for i, v in pairs(response.items) do
                                if v.kind == 5 and v.detail then
                                    response.items[i].label = response.items[i].label .. ": " .. v.detail
                                end
                                if v.label and v.detail and v.kind > 1 and v.kind < 5 and not string.find(v.label, "!") then
                                    local start = string.find(v.label, "(…)")
                                    local alt_start = string.find(v.label, "()")
                                    if string.sub(v.detail, 1, 3) == "fn(" then
                                        if start ~= nil then
                                            response.items[i].label = string.sub(v.label, 1, start - 2) .. string.sub(v.detail, 3) .. string.sub(v.label, start + 4)
                                        elseif alt_start ~= nil then
                                            response.items[i].label = string.sub(v.label, 1, alt_start - 4) .. string.sub(v.detail, 3);
                                        end
                                    end
                                end
                            end
                        end
                        return old_handler(err, response, ctx)
                    end

                end
                return old_request(method, params, handler, bufnr)
            end
        end
        lsp_status.on_attach(client)
    end,
    settings = {
        ["rust-analyzer"] = {
            ["completion"] = {
                ["autoimport"] = {
                    ["enabled"] = true
                }
            },
            ["checkOnSave"] = {
                ["command"] = "clippy"
            },
            ["cargo-watch"] = {
                ["enable"] = true
            },
            ["cargo"] = {
                ["loadOutDirsFromCheck"] = true
            },
            ["diagnostics"] = {
                ["enableExperimental"] = true
            },
            ["inlayHints"] = {
                ["typeHintsSeparator"] = "‣ "
            }
        }
    },
})


-- Workaround for Cargo.toml file, because rust-analyzer not attached to .toml buffers
function RustReloadWorkspace()
    local directory = api.nvim_eval("expand('%:p:h')")
    local lsp_list = vim.lsp.get_active_clients()

    for i, lsp in pairs(lsp_list) do
        for ii, folder in pairs(lsp.workspaceFolders) do
            if lsp_list[i].name == "rust_analyzer" and folder.name == directory then
                lsp.request('rust-analyzer/reloadWorkspace', nil,
                    function(err, result, _)
                        if err then error(tostring(err)) end
                        vim.notify("[Workspace reloaded]: " .. directory)
                    end)
            end
        end
    end
end

function OpenCargo()
    local uri = vim.uri_from_bufnr(0)
    vim.lsp.buf_request(0, 'experimental/openCargoToml', { textDocument = { uri = uri } },
        function (err, result, _)
            if err then error(tostring(err)) end
            api.nvim_command('e '..vim.uri_to_fname(result.uri))
        end
    )
end
vim.cmd('autocmd BufWritePost Cargo.toml lua RustReloadWorkspace()')
-- vim.cmd('autocmd BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require\'lsp_extensions\'.inlay_hints{ aligned = true, prefix = " > ", highlight = "InlayHint", enabled = {"TypeHint", "ChainingHint"}}')
