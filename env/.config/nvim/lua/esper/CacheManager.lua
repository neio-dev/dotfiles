local CacheManager = {}

CacheManager.registry = {}

CacheManager.save = function()
end

CacheManager.get = function(registry_entry_name)
    if CacheManager.registry[registry_entry_name] then
        return CacheManager.registry[registry_entry_name]
    end

    return nil
end

return CacheManager
