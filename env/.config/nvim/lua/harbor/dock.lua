local Fleet = require("harbor.fleet")
local Ship = require("harbor.ship")
local Bay = require("harbor.bay")
local Harbor = require("harbor.harbor")

---@class Dock: Fleet
---@field bay Bay
---@field harbor Harbor
local Dock = setmetatable({}, { __index = Fleet })
Dock.__index = Dock

---comment
---@param harbor Harbor
---@return Dock
function Dock:new(harbor)
    ---@class Dock
    local instance = Fleet.new(self, "Dock", 4)
    instance.harbor = harbor
    return instance
end

function Dock:set(ship, index)
    ship = Fleet.set(self, ship, index)

    local bay = self.harbor.bay
    print("debug bay", self.harbor, bay)
    if bay ~= nil then
        local bay_ship_index = bay:get_ship_index(ship.value)
        if bay_ship_index ~= nil then
            bay:set(EMPTY, bay_ship_index)
        end
    end
end

return Dock
