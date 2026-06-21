local function map(tbl)
    local M = {}

    M.args = tbl

    function M:for_each(callback)
        local output = {}

        for index, value in ipairs(M.args) do
            table.insert(output, callback(value, index))
        end

        return output
    end

    return M
end

return map
