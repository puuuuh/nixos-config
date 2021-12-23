local dap = require('dap')

vim.api.nvim_exec([[
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F8> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F7> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F6> :lua require'dap'.step_out()<CR>
nnoremap <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader><F9> :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
]], false)

local filename = "launch.json"

local template = [[{
    "configurations": [
        {
            "type": "CodeLLDB",
            "request": "launch",
            "name": "example",
            "program": "${workspaceFolder}",
            "cwd": "${workspaceFolder}",
            "args": []
        }
    ]
}]];

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end

local function read_file(path)
    local file = io.open(path, "rb") -- r read mode and b binary mode
    if not file then error("file not found") end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return vim.fn.json_decode(content)
end

local function open_or_create(path)
    vim.api.nvim_command('e '..path)
    local l = vim.api.nvim_buf_line_count(0)
    if l == 0 or (l == 1 and #vim.api.nvim_buf_get_lines(0, 0, 1, true)[1] == 0) then
        vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(template, '\n'))
    end
end

local function start_with()
    local status, res = pcall(read_file, filename)
    if not status or res == nil then
        open_or_create(filename)
        error("Invalid config file or file not found: "..res)
        return
    end
    local configs = res.configurations
    local i = 1
    if #configs > 1 then
        local variants = {"Select configuration: "}
        table.sort(configs, function(l, r) return l.name < r.name end)
        for k, v in pairs(configs) do
            table.insert(variants, tostring(k) .. ": " .. v.name)
        end
        i = vim.fn.inputlist(variants)
    end
    if i < 1 or i > #configs then
        print("Invalid config index, abort")
        return
    end
    dap.run(configs[i])
end

return {
    start_with = start_with,
}
