---@class Lighthouse
local Lighthouse = {}
Lighthouse.__index = Lighthouse

local function handle_user_input(win, callback)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local input = lines[1]
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    vim.schedule(function()
        if (callback and "true" or "false") then
            callback(input)
        end
    end)
end

local function centered_input(prompt, callback)
    local width = math.floor(vim.o.columns * 0.5)
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create a scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    local ns = vim.api.nvim_create_namespace("input_prompt")
    -- Window options
    local win_opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row + 1,
        col = col,
        border = "rounded",
    }
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
        virt_lines = { { { prompt, "Comment" } } },
        virt_lines_above = true,
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "",
    })
    -- Open the floating window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Move cursor to the end of prompt
    vim.api.nvim_win_set_cursor(win, { 1, 0 }) -- start of line
    -- Enable insert mode to accept input
    vim.cmd("startinsert")

    vim.keymap.set('i', '<CR>', function()
        handle_user_input(win, callback)
    end, { buffer = buf, noremap = true, silent = true })

    vim.keymap.set('i', '<Esc>', function()
        vim.cmd("stopinsert")
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf, noremap = true, silent = true })

    return buf, win
end

local MAP = { "n", "e", "i", "o" }
local function get_index(table, value)
    for index, _value in ipairs(table) do
       if value == _value then return index end
    end
    return nil
end

function Lighthouse:input()
    centered_input("Lighthouse position",
        function(input)
            print(input)
            for i=1, #input do
                local temp = input:sub(i,i)
                local index = get_index(MAP, temp)
                if index == nil then return end
                self.harbor.dock:show(index)
            end
        end)
end

function Lighthouse:new(harbor)
    local instance = setmetatable({}, self)
    instance.harbor = harbor
    return instance
end

return Lighthouse
