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

local function centered_input(prompt, on_input, callback, on_cancel)
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
            print("TextChangedI", input)
            local char = string.sub(input, #input, #input)
            print("TextChangedI", char)
            if #input <= last_width then
                char = "__backspace"
            end
            if on_input then
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
    local session_name = "harbor_temp_session.vim"
    vim.cmd("mksession! /tmp/" .. session_name)
    local current_win = vim.api.nvim_get_current_win()
    local lighthouse_ships = { current_win }
    local reset = false
    local last_win = nil
    centered_input(
        "Lighthouse position",
        function(input, full_input, prompt_win)
            last_win = lighthouse_ships[#lighthouse_ships]
            if input == "__backspace" then
                print("BSPACE", unpack(lighthouse_ships))
                vim.schedule(function()
                    local l_win = lighthouse_ships[#lighthouse_ships]
                    if l_win then
                        print("SHIIIIIPS", unpack(lighthouse_ships))
                        vim.api.nvim_win_close(l_win, true)
                        table.remove(lighthouse_ships, #lighthouse_ships)
                    end
                end)
                return
            end
            if not reset then
                for _, iwin in ipairs(vim.api.nvim_list_wins()) do
                    if iwin ~= prompt_win and iwin ~= current_win then
                        vim.schedule(function() pcall(vim.api.nvim_win_close, iwin, true) end)
                    end
                end
                reset = true
            end
            print('input', input)
            local temp = input
            if prompt_win == vim.api.nvim_get_current_win() then
                pcall(vim.api.nvim_set_current_win, last_win or current_win)
            end
            if string.lower(temp) == "h" then
                if #full_input > 1 then
                    local is_horizontal = "H" == temp
                    vim.cmd(is_horizontal and "belowright split" or "vsplit")
                    vim.cmd("wincmd l")
                end

                self.harbor.bay:show(1)
                goto continue
            end

            local index = get_index(MAP, string.lower(temp))
            print("INDEX", index, temp)
            if index == nil then return end
            print("INDEX", index, temp)
            if #full_input > 1 then
                local is_horizontal = string.upper(MAP[index]) == temp
                local wins_before = vim.api.nvim_list_wins()

                vim.schedule(function()
                    vim.cmd(is_horizontal and "belowright split" or "vsplit")
                    vim.cmd("wincmd l")
                    local wins_after = vim.api.nvim_list_wins()
                    local new_win

                    for _, win in ipairs(wins_after) do
                        local is_new = true
                        for _, old_win in ipairs(wins_before) do
                            if win == old_win then
                                is_new = false
                                break
                            end
                        end
                        if is_new then
                            new_win = win
                            break
                        end
                    end

                    if new_win then
                        table.insert(lighthouse_ships, new_win)
                    end
                end)
            end

            vim.schedule(function() self.harbor.dock:show(index)
            vim.schedule(function()
                vim.api.nvim_set_current_win(prompt_win)
            end)

            ::continue::
        end,
        nil,
        function()
            print("ON CANCEL")
            vim.cmd("silent! source /tmp/" .. session_name)
        end
    )
end

function Lighthouse:new(harbor)
    local instance = setmetatable({}, self)
    instance.harbor = harbor
    return instance
end

return Lighthouse
