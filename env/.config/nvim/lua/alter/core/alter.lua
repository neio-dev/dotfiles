local diff = require "alter.domain.diff"
local Alter = {}

function Alter:new()
    self.__index = self
    local instance = setmetatable({}, self)

    return instance
end

function Alter:setup(config)
    local opts = config or {}
    self.diff = diff:new()
end

return Alter
