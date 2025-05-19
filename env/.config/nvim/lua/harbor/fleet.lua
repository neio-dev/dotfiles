local Ship = require("harbor.ship")
local buffer = require("harbor.buffer")
local icons = require("harbor.icons")
-- Used in place of nil to keep table functions usable
-- e.g. nil will stop a for loop at nil index
EMPTY = {}

---@enum RESOLVE
RESOLVE = {
    replace = "replace",
    prepend = "prepend",
}

---@class Fleet
local Fleet = {
}

Fleet.__index = Fleet

---@param harbor Harbor
---@param name string
---@paam length number
function Fleet.new(self, harbor, name, length, resolve)
    local instance = setmetatable({
        name = name,
        ships = {},
        resolve = resolve or RESOLVE.replace,
    }, self)
    instance.harbor = harbor
    for i = 1, length do
        instance.ships[i] = EMPTY
    end

    return instance
end

---@param index? integer
---@return Ship[]|Ship?
function Fleet:get(index)
    if index then
        return self.ships[index] or nil
    end

    return self.ships
end

---input the user for ship index
---@private
---@param length number
---@return number?
function Fleet:input_index(length)
    print(icons.ask .. " Choose index between 1 and " .. length .. ": ")
    while true do
        local input
        if #self.ships < 10 then
            input = vim.fn.getchar()
            local input_char = vim.fn.nr2char(input)
            if input == 27 or input_char == "q" then
                return nil
            end
            input = input_char
        else
            input = vim.fn.input("")
        end

        local index = tonumber(input)
        if index and index >= 1 and index <= length and index == math.floor(index) then
            return index
        else
            print(icons.error .. " Invalid input. Please enter an integer between 1 and " .. length)
        end
    end
end

---@param ship? Ship
---@param index? number
---@return Ship?
function Fleet:set(ship, index)
    local previous_ship = nil
    local idx = index or self:get_next_empty_idx()
    if ship == nil then
        local curr_buf = buffer:get_current()

        ship = Ship:new(curr_buf.name, curr_buf.cursor)
    end


    if (idx == nil) then
        if self.resolve == RESOLVE.replace then
            idx = self:input_index(#self.ships)
            if idx == nil then return nil end
            previous_ship = self.ships[idx or 1]
            local previous_idx = self:get_ship_index(ship.value)
            if previous_idx ~= nil then
                local inverted_ship = self.ships[idx]
                self.ships[previous_idx] = inverted_ship or EMPTY
            end
        elseif self.resolve == RESOLVE.prepend then
            idx = 1
            for i = #self.ships - 1, 1, -1 do
                self.ships[i + 1] = self.ships[i]
            end
        end
        -- if active buffer is already docked. should swap with other buffer 3 > 4 4 > 3
    end

    self.ships[idx or 1] = ship
    if ship.__index == Ship then
        print(icons.check .. " " .. ship:format_name() .. " moved to index " .. (idx or 1))
    end
    self.harbor.sessions:save()
    return { ship = ship, previous_ship = previous_ship }
end

---@param target? number|string|Ship
function Fleet:remove(target)
    local index = nil
    if target == nil then
        local curr_name = buffer:get_current().name
        index = self:get_ship_index(curr_name)
    elseif type(target) == "number" then
        index = target
    elseif type(target) == "string" then
        index = self:get_ship_index(target)
    elseif getmetatable(target) == Ship then
        index = self:get_ship_index(target.value)
    end

    if index == nil then
        error(icons.error .. " Invalid target for removal: must be either index, path string, or Ship containing .value")
    end

    local previous_ship = self.ships[index]

    if self.resolve == RESOLVE.replace then
        self:set(EMPTY, index)
    elseif self.resolve == RESOLVE.prepend then
        -- [b, d, g]
        --
        -- index = 1, i = 2, l= 2
        -- self.ships[1] = self.ships[2]
        -- self.ships[2] = self.ships[3]
        for i = index + 1, #self.ships do
            self.ships[i - 1] = self.ships[i] 
        end

        self.ships[#self.ships] = EMPTY
    end
    return previous_ship
end

---@private
function Fleet:find_and_focus_win(taeget_path)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_path = vim.api.nvim_buf_get_name(buf)

        if buf_path == target_path then
            vim.api.nvim_set_current_win(win)
        end
    end
end

---comment
---@param index number
function Fleet:show(index)
    local ship = self.ships[tonumber(index)]
    if ship == EMPTY then
        return
    end

    local path = ship.value
    local bufnr = vim.fn.bufnr(path)
    -- self:find_and_focus_win(path)
    if bufnr ~= -1 then
        vim.api.nvim_set_current_buf(bufnr)
    else
        vim.cmd("edit " .. path)
    end
end

---comment
---@param name? string|{}
---@return number?
function Fleet:get_ship_index(name)
    local found_index = nil

    for index, ship in ipairs(self.ships) do
        if type(name) == "string" and ship.value == name then
            found_index = index
            break
        end
    end

    return found_index
end

---@private
---@return number?
function Fleet:get_next_empty_idx()
    local found = nil

    for i, v in ipairs(self.ships) do
        if v == EMPTY then
            found = i
            break
        end
    end

    return found
end

---@return number?
function Fleet:get_next_populated_idx(starting_index)
    local found = nil
    for i = starting_index + 1, #self.ships, 1 do
        if self.ships[i] ~= EMPTY then
            found = i
            break
        end
    end

    if found == nil then
        for i = 1, starting_index - 1, 1 do
            if self.ships[i] ~= EMPTY then
                found = i
                break
            end
        end
    end

    return found
end

function Fleet:cycle()
    local curr_buf = buffer:get_current()
    local curr_index = self:get_ship_index(curr_buf.name)
    local next_index = self:get_next_populated_idx(curr_index or 0)
    if next_index ~= nil then
        self:show(next_index)
    end
end

return Fleet
