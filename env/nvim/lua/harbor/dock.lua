local Fleet = require("harbor.fleet")
local Ship = require("harbor.ship")

---@class Dock: Fleet
local Dock = setmetatable({}, { __index=Fleet })
Dock.__index = Dock

function Dock:new()
    local instance = Fleet.new(self, "Dock", 4)
    return instance
end

return Dock
