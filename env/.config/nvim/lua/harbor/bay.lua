local Fleet = require("harbor.fleet")

---@class Bay: Fleet
local Bay = setmetatable({}, { __index=Fleet })
Bay.__index = Bay

function Bay:new()
    local instance = Fleet.new(self, "Bay", 3, RESOLVE.prepend)
    return instance
end

return Bay
