local AbstractHasher = {}
AbstractHasher.__index = AbstractHasher

function AbstractHasher.new(self)
    local instance = setmetatable({
        initial_value = nil,
        hash = nil,
    }, self)

    return instance
end

function AbstractHasher:hash(obj)
    self.initial_value = obj

    return self.hash
end

return AbstractHasher
