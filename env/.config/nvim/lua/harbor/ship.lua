---@class Ship
local Ship = {}

Ship.__index = Ship

---@param name string
---@param cursor_position? CursorPosition 
function Ship:new(name, cursor_position)
    local ship = setmetatable({
        value = name,
        position = cursor_position or { col = 0, row = 0}
    }, self)
    return ship
end

function Ship:format_name()
   return self.value:match("([^/]+)$")
end

return Ship
