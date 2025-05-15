local Ship = require("harbor.ship")
local buffer = require("harbor.buffer")

local EMPTY = {}

---@class Fleet
---@field name string
---@field ships {[string]: Ship}
local Fleet = {
}

Fleet.__index = Fleet

---@param name string
---@param length number
function Fleet.new(self, name, length)
    local instance = setmetatable({
        name = name,
        ships = {},
    }, self)

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

local function input_index(length)
    while true do
        local input = vim.fn.input("Choose index between 1 and " .. length)
        local index = tonumber(input)
        if index and index >= 1 and index <= length and index == math.floor(index) then
            return index
        else
            print("Invalid input. Please enter an integer between 1 and " .. length)
        end
    end
end

---@param ship? Ship
---@param index? number
function Fleet:add(ship, index)
    local idx = index or self:get_next_empty_idx()
    if ship == nil then
        local buf = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)

        ship = Ship:new(name)
    end

    if (idx == nil) then
        idx = input_index(#self.ships)
        -- if active buffer is already docked. should swap with other buffer 3 > 4 4 > 3
        -- else, previous docked should go to temp 
    end

    print("debug2", idx, ship)
    self.ships[idx or 1] = ship
end

---@param options {index?: number, name?: string}
function Fleet:remove(options)
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

    if bufnr ~= -1 then
        vim.api.nvim_set_current_buf(bufnr)
    else
        vim.cmd("edit " .. path)
    end
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

return Fleet
