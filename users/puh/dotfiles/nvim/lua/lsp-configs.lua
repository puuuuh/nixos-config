local confmodule = {}

function confmodule.get_cap()
    local cap = vim.lsp.protocol.make_client_capabilities()
    cap.textDocument.completion.completionItem.snippetSupport = true
    cap.textDocument.completion.completionItem.resolveSupport = {
        properties = { "additionalTextEdits" }
    }
    return cap
end

return confmodule
