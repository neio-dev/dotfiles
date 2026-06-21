local AbstractHasher = require "esper.AbstractHasher"
local utils          = require "esper.utils"

local InstanceHasher = setmetatable({}, { __index = AbstractHasher })
InstanceHasher.__index = InstanceHasher

function InstanceHasher:new()
    local instance = AbstractHasher.new(self)

    return instance
end

function InstanceHasher:hash(obj)
    local serialized_object = utils.serialize_object(obj)
end

return InstanceHasher
