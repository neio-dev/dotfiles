local Extension = require("harbor.extensions.extension")
local buffer = require("harbor.buffer")

local harbor_lualine = Extension:new("lualine")
harbor_lualine.__index = harbor_lualine

local function pretty_name(ship, is_active)
    local name = ship.value and ship:format_name() or "x"

    if is_active then
        name = "[  " .. name .. "]"
    end

    return name
end

local function get_fleet(name, fleet, opt)
    local line = name .. " "
    opt = opt or {}
    local curr_buf = buffer:get_current()


    for index, ship in ipairs(fleet) do
        local is_active = ship.value and curr_buf.name == ship.value
        line = line .. " "

        if opt.show_index then
            line = line .. index .. " "
        end

        line = line .. pretty_name(ship, is_active) .. (index ~= #fleet and " | " or "")
    end

    return line
end

function harbor_lualine:setup()
    local ext = function()
        local harbor = require("harbor")
        local bay_fleet = get_fleet(" Bay", harbor.bay:get())
        local dock_fleet = get_fleet(" Dock: ", harbor.dock:get(), { show_index = true })
        return bay_fleet .. " ||| " .. dock_fleet
    end

    print("Harbor: Lualine extension loaded ⚓")

    return ext
end

return harbor_lualine
