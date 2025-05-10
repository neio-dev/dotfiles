local ls = require('luasnip')
local temp_snippets = {}

function _G.record_snippet_to_register(register)
    local start_line = vim.fn.line(".")
    local snippet_lines = {}

    vim.api.nvim_buf_attach(0, false, {
    on_lines = function (_,_,_,first,last)
        for i = first, last do
            local line = vim.fn.getline(i)
            table.insert(snippet_lines, line)
        end
    end})

    local snippet_content = {}
    for i, line in ipairs(snippet_lines) do
        table.insert(snippet_content, t(line))
        table.insert(snippet_content, i == #snippet_lines and "" or t({"",""}))
    end

    temp_snippets[register] = { s(register, snippet_content) }
    print("Snipped recorded to register #"..register)
    
end

vim.api.nvim_set_keymap('n', '<leader>s', ':lua record_dynamic_snippet(vim.fn.input())<CR>', { noremap = true, silent = true })

