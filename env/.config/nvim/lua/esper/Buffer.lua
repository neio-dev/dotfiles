local Builder = require("esper.Builder")
local buf_renderer = require("esper.buf_renderer")

local function Buffer(children)
    return Builder:new(children, buf_renderer:new())
end

return Buffer
