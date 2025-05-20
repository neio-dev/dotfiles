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

function Dock:set(_ship, index)
    local fleet = Fleet.set(self, _ship, index)
    if fleet.ship == nil or fleet.ship == EMPTY then return end
    index = self:get_ship_index(fleet.ship and fleet.ship.value or nil)

    local bay = self.harbor.bay
    if bay ~= nil and fleet.ship ~= nil then
       local bay_ship_index = bay:get_ship_index(fleet.ship.value)
       print("bay REMOVE", bay_ship_index, fleet.ship.value)
        if bay_ship_index ~= nil then
            bay:remove(bay_ship_index)
        end
        if fleet.previous_ship ~= nil and fleet.previous_ship ~= EMPTY then
            print("fleet.previous ship", fleet.previous_ship.value, index)
            bay:set(fleet.previous_ship)
        end
     end
end

function Dock:show(index)
    self.harbor.bay:close_split()
    Fleet.show(self, index)
end

function Dock:remove(target)
    local previous_ship = Fleet.remove(self, target)
    local bay = self.harbor.bay
    if bay ~= nil and previous_ship ~= nil then
        bay:set(previous_ship)
    end
end

return Dock
