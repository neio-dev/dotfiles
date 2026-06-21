local M = {}

M.instanceof = function(object, class)
    if not object then return false end

    local mt = getmetatable(object)
    while mt do
        if mt.class_name == class then
            return true
        end

        mt = getmetatable(mt)
    end

    return false
end

M.is_object_empty = function(obj)
    for _, _ in pairs(obj) do
        return false
    end

    return true
end

M.has_property = function(obj, ...)
    if not obj then return false end

    for index, value in ipairs({ ... }) do
        if obj[value] then
            return true
        end
    end

    return false
end

M.T = function(get_base)
    return function(...)
        local base = get_base
        local output = {}

        for _, part in ipairs({ ... }) do
            output[#output + 1] = "%#" .. (part[2] or base) .. "#" .. part[1] .. "%#" .. base .. "#"
        end

        return table.concat(output, "")
    end
end

---@param str string
---@return integer
M.fnv1a = function(str)
    local hash = 2166136261
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        hash = (hash * 16777619) % 4294967296
    end
    return hash
end

M.serialize_style = function(style)
    local serialized = table.concat({ style.fg or "", style.bg or "", tostring(style.bold or ""), tostring(style.italic or
        ""), tostring(style.underline or "") })

    return serialized
end

M.object_get_keys = function(obj)
    local keys = {}

    for key, _ in pairs(obj) do
        table.insert(keys, key)
    end

    return keys
end

M.serialize_object = function(obj)
    local s = "{"

    local keys = M.object_get_keys(obj)
    -- sorting to prevent serialization differences because of arbitrary table order in lua
    table.sort(keys)

    for _, key in ipairs(keys) do
        if #s > 1 then s = s .. "," end
        s = s .. key .. ":" .. obj[key]
    end

    return s .. "}"
end

return M
