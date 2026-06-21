local Instantiator = {}

function Instantiator:make(hash_maker)
    return {
         new_instance = nil,
    }
end

return Instantiator
