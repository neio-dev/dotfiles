local Extension = require("doro.extensions.extension")
local utils = require("doro.utils")

local doro_lualine = Extension:new("lualine")


function doro_lualine:setup(doro)
    local ext = function()
        return table.concat({
                "DORO",
                ("[" .. doro.pomo.flow[doro.pomo.current] .. "]"),
                (utils.print_time(doro.pomo.timer.target - doro.pomo.timer.elapsed)),
            },
            " ")
    end

    return ext
end

return doro_lualine
