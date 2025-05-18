local Fleet = require("harbor.fleet")

---@class Bay: Fleet
local Bay = setmetatable({}, { __index=Fleet })
Bay.__index = Bay

---@param harbor Harbor
---@return Bay
function Bay:new(harbor)
    ---@class Bay
    local instance = Fleet.new(self, harbor,"Bay", 3, RESOLVE.prepend)
    return instance
end

return Bay
