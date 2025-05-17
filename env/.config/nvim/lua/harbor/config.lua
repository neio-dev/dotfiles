local Config = {}
Config.__index = Config

function Config:new()
    local instance = setmetatable({}, self)
    return instance
end

local config = Config:new()

return config
