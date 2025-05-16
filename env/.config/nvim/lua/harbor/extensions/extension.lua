---@class Extension
---@field name string
---@field setup fun(self): nil
local Extension = {}
Extension.__index = Extension

---comment
---@param name string
---@return Extension
function Extension:new(name)
    return setmetatable({
        name = name
    }, self)
end

return Extension
