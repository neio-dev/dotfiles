local Fleet = require("harbor.fleet")

---@class Dock: Fleet
---@field bay Bay
---@field harbor Harbor
local Dock = setmetatable({}, { __index = Fleet })
Dock.__index = Dock

---@param harbor any
---@return Dock
function Dock:new(harbor)
    ---@class Dock
    local instance = Fleet.new(self, harbor, "Dock", 4)
    return instance
end

function Dock:set(ship, index)
    ship = Fleet.set(self, ship, index)

    local bay = self.harbor.bay
    if bay ~= nil and ship ~= nil then
        local bay_ship_index = bay:get_ship_index(ship.value)
        if bay_ship_index ~= nil then
            bay:set(EMPTY, bay_ship_index)
        end
    end
end

function Dock:remove(target)
    local previous_ship = Fleet.remove(self, target)
    local bay = self.harbor.bay
    if bay ~= nil and previous_ship ~= nil then
        bay:set(previous_ship)
    end
end

return Dock
