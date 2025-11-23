---@class Extension
---@field name string
---@field setup fun(self, ...): nil
local Extension = {}

---comment
---@param name string
---@return Extension
function Extension:new(name)
    self.__index = self
    return setmetatable({
        name = name
    }, self)
end

return Extension
