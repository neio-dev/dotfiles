local M = {}

function M.print(percent, opts)
    local remaining_width = opts.width - (4 + #tostring(percent))
    local actual_percent = remaining_width * (percent / 100)
    actual_percent = math.floor(actual_percent)
    return "[" ..
    string.rep("=", actual_percent) .. string.rep("-", remaining_width - actual_percent) .. "] " .. percent .. "%"
end

return M
