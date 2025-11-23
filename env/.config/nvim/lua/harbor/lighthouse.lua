local utils = require("harbor.utils")

---@class Lighthouse
local Lighthouse = {}
Lighthouse.__index = Lighthouse

local function handle_user_input(win, callback)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local input = lines[1]
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    vim.schedule(function()
        if (callback ~= nil) then
            callback(input)
        end
    end)
end

function Lighthouse:centered_input(prompt, on_input, callback, on_cancel)
    local full_input = ""
    local width = math.floor(vim.o.columns * 0.5)
    local height = 1
    local row = math.floor((vim.o.lines - height) / 2) - 1
    local col = math.floor((vim.o.columns - width) / 2)
    local current_win = vim.schedule(function() vim.api.nvim_get_current_win() end)

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
    local last_width = 0
    vim.api.nvim_create_autocmd({ "TextChangedI" }, {
        buffer = buf,
        callback = function(args)
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local input = lines[1]
            --print("TextChangedI", input)
            local char = string.sub(input, #input, #input)
            --print("TextChangedI", char)
            if #input <= last_width then
                char = "__backspace"
            end
            if on_input and #input > 0 then
                vim.schedule(function()
                    on_input(char, input, win)
                end)
            end
            last_width = #input
        end,
    })
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
        if on_cancel ~= nil then on_cancel() end
    end, { buffer = buf, noremap = true, silent = true })

    self.prompt_win = win
    return buf, win
end

local MAP = { "n", "e", "i", "o" }
local function get_index(table, value)
    for index, _value in ipairs(table) do
        if value == _value then return index end
    end
    return nil
end

function Lighthouse:focus_input()
    if self.prompt_win then
        vim.api.nvim_set_current_win(self.prompt_win)
    end
end

function Lighthouse:input()
    local session_name = "harbor_temp_session.vim"
    vim.cmd("mksession! /tmp/" .. session_name)
    self.initial_win = vim.api.nvim_get_current_win()
    self.lighthouse_ships = {}
    local reset = false
    local last_win = nil
    self:centered_input(
        "Lighthouse position",
        function(input, full_input, prompt_win)
            -- SHOW WINDOW
            self:handle_input_win(input)

            -- SHOW SHIP
            vim.schedule(function()
                self:input_execution(input)
            end)
        end,
        nil,
        function()
            vim.cmd("silent! source /tmp/" .. session_name)
        end
    )
end

function Lighthouse:handle_input_win(input)
    if #self.lighthouse_ships == 0 then
        vim.api.nvim_set_current_win(self.initial_win)
        table.insert(self.lighthouse_ships, self.initial_win)
    else
        local is_horizontal = input == string.upper(input)
        vim.api.nvim_set_current_win(self.lighthouse_ships[#self.lighthouse_ships])
        vim.schedule(function()
            vim.cmd(is_horizontal and "vert split" or "belowright split")
        end)
        vim.schedule(function()
            vim.cmd("wincmd " .. (is_horizontal and "l" or "j"))
        end)
    end
end

function Lighthouse:input_execution(input)
    if string.lower(input) == "h" then
        self.harbor.bay:show(1)
    else
        -- OPEN ONE OF dock
        local index = get_index(MAP, string.lower(input))
        if self.harbor.dock:get(index) then
            self.harbor.dock:show(index)
        end
    end

    -- back to prompt
    vim.schedule(function() self:focus_input() end)
end

function Lighthouse:new(harbor)
    local instance = setmetatable({}, self)
    instance.harbor = harbor
    return instance
end

return Lighthouse
