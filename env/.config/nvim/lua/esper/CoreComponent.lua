local Builder = require "esper.Builder"

local function CoreComponent(children)
    -- generate hash, return object to render hash
    local maker = Builder:new(children)

    return maker
end

return CoreComponent
