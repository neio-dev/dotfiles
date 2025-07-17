require("holotapes.types")

---@class Holotapes
local Holotapes = {}
Holotapes.__index = Holotapes

function Holotapes:new()
    ---@class Holotapes
    local instance = setmetatable({
    }, self)
    return instance
end

local the_holotapes = Holotapes:new()

return the_holotapes
