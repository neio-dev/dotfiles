local Ship = require("harbor.ship")

---@class SessionManager
local SessionManager = {}
SessionManager.__index = SessionManager

local function fnv1a(str)
    local hash = 2166136261
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        hash = (hash * 16777619) % 4294967296
    end
    return hash
end

function SessionManager:new(harbor)
    local instance = setmetatable({
        path = vim.fn.getcwd(),
        dir = vim.fn.stdpath("data") .. "/harbor"
    }, self)
    instance.harbor = harbor
    return instance
end

---@param fleet_data {}
---@param list_name PossibleList
function SessionManager:parse_fleet(fleet_data, list_name)
    local parsed_fleet_data = {}

    ---@type Ship[]
    for index, iterated_ship in ipairs(fleet_data[list_name]) do
        local ship = (iterated_ship.value == nil) and (EMPTY) or (Ship:new(iterated_ship.value, iterated_ship.position, list_name))
        table.insert(
            parsed_fleet_data,
            ship
        )
    end

    return parsed_fleet_data
end

function SessionManager:load()
    local filepath = self:get_session_path()
    if vim.fn.filereadable(filepath) == 0 then return end
    local lines = vim.fn.readfile(filepath)
    if lines == nil then return end

    local json_string = table.concat(lines, "\n")

    ---@type SavedData
    local data = vim.fn.json_decode(json_string)

    if data.bay then
        self.harbor.bay.ships = self:parse_fleet(data, "bay")
    end

    if data.dock then
        self.harbor.dock.ships = self:parse_fleet(data, "dock")
    end
end

function SessionManager:save()
    local json = vim.fn.json_encode
    local filepath = self:get_session_path()
    local data = { dock = self.harbor.dock:get(), bay = self.harbor.bay:get() }
    vim.fn.writefile({ json(data) }, filepath)
end

function SessionManager:get_session_path()
    return self.dir .. "/" .. fnv1a(self.path) .. ".json"
end

return SessionManager
