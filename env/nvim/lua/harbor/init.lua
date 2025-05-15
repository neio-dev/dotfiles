local Dock = require("harbor.dock")
local Bay = require("harbor.bay")
local Commands = require("harbor.commands")

---@class Harbor
---@field dock Dock
---@field bay Bay
local Harbor = {}

function Harbor:new()
    return setmetatable({
        dock = Dock:new(),
        bay = Bay:new(),
    }, self)
end

local the_harbor = Harbor:new()

function the_harbor.setup(self, partial_config)
    if self ~= the_harbor then
        partial_config = self
        self = the_harbor
    end
    print("Harbor plugin loaded  🚢")
    Commands:init()
end

return the_harbor
