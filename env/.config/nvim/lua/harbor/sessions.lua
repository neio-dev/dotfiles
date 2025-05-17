---@class SessionManager
local SessionManager = {}
SessionManager.__index = SessionManager

function SessionManager:new(harbor)
    local instance = setmetatable({})
    instance.harbor = harbor
    return instance
end

function SessionManager:save_current()

end

function SessionManager:load()
end

return SessionManager
