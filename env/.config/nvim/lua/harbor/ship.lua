---@class Ship
---@field value string
---@field position { x: number, y: number }
local Ship = {}

Ship.__index = Ship

---@param name string
function Ship:new(name)
    local ship = setmetatable({
        value = name,
    }, self)

    return ship
end

function Ship:format_name()
   return self.value:match("([^/]+)$")

end

return Ship
