---@class Diff
local M = {}

---@return Diff
function M:new()
    self.__index = self
    local instance = setmetatable({}, self)

    return instance
end

---Attach buf to the diff instance
---@param buf any
function M:attach(buf)
end

---Show Diff
function M:show()
end

---Hide Diff
function M:hide()
end

return M
