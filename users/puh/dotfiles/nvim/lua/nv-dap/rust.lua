local dap = require('dap')
local uv = vim.loop

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dap.adapters.cpptools = {
  type = 'executable',
  command = '/home/puh/.cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.adapters.CodeLLDB = function(callback)
    local stdout = nil
    local stderr = nil
    local stdin = nil
    local uv_err
    stdout, uv_err = uv.new_pipe(false)
    if uv_err then
        print('Failed to open stdout pipe: ' .. uv_err)
        return
    end

    stderr, uv_err = uv.new_pipe(false)
    if uv_err then
        print('Failed to open stderr pipe: ' .. uv_err)
        return
    end

    local handle, pid = uv.spawn("/home/puh/.dap/adapter/codelldb",
        { stdio = { nil, stdout, stderr }}, function(code, signal)
    end)
    uv.read_start(stdout, function(err, header)
        assert(not err, err)
        if header then
            local port = tonumber(string.sub(header, 18))
            vim.schedule(vim.schedule_wrap(function()
                callback({
                    type = 'server',
                    host = "127.0.0.1",
                    port = port,
                })
            end))
        end
    end)
end

dap.configurations.rust = {
    {
        name = "Launch",
        type = "CodeLLDB",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},

        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = false,
    },
}

local opts = {
    tools = { -- rust-tools options
        -- Automatically set inlay hints (type hints)
        autoSetHints = false,

        -- Whether to show hover actions inside the hover window
        -- This overrides the default hover handler 
        hover_with_actions = false,

        runnables = {
            -- whether to use telescope for selection menu or not
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        debuggables = {
            -- whether to use telescope for selection menu or not
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },
    }
}
require('rust-tools').setup(opts)

-- Dirty hack to use codelldb instead of lldb
dap.adapters.rt_lldb = dap.adapters.CodeLLDB
