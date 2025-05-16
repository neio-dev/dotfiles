local Ship = require("harbor.ship")
local buffer = require("harbor.buffer")

-- Used in place of nil to keep table functions usable
-- e.g. nil will stop a for loop at nil index
EMPTY = {}

---@enum RESOLVE
RESOLVE = {
    replace = "replace",
    prepend = "prepend",
}

---@class Fleet
---@field name string
---@field ships {[string]: Ship}
---@field resolve? RESOLVE.replace|RESOLVE.prepend
local Fleet = {
}

Fleet.__index = Fleet

---@param name string
---@param length number
function Fleet.new(self, name, length, resolve)
    local instance = setmetatable({
        name = name,
        ships = {},
        resolve = resolve or RESOLVE.replace,
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

---input the user for ship index
---@private
---@param length number
---@return number
function Fleet:input_index(length)
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
---@return Ship
function Fleet:set(ship, index)
    local idx = index or self:get_next_empty_idx()
    if ship == nil then
        local curr_buf = buffer:get_current()

        ship = Ship:new(curr_buf.name)
    end


    if (idx == nil) then
        if self.resolve == RESOLVE.replace then
            idx = self:input_index(#self.ships)
        elseif self.resolve == RESOLVE.prepend then
            idx = 1
            for i = #self.ships - 1, 1, -1 do
               self.ships[i + 1] = self.ships[i]
            end
        end
        -- if active buffer is already docked. should swap with other buffer 3 > 4 4 > 3
    end

    self.ships[idx or 1] = ship

    return ship
end

---@param target number|string|Ship
function Fleet:remove(target)
    local index = nil
    if type(target) == "number" then
        index = target
    elseif type(target) == "string" then
        index = self:get_ship_index(target)
    elseif getmetatable(target) == Ship then
        index = self:get_ship_index(target.value)
    end

    if index == nil then
        error("Invalid target for removal: must be either index, path string, or Ship containing .value")
    end

    self:set(EMPTY, index)
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

---comment
---@param name string|{}
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

function Fleet:cycle()
    local next_index = 1
    local curr_buf = buffer:get_current()
    local curr_index = self:get_ship_index(curr_buf.name)
    if curr_index and curr_index + 1 <= #self.ships then
        next_index = curr_index + 1
    end
    self:show(next_index)
end

return Fleet
