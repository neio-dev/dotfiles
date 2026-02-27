local Extension = require("doro.extensions.extension")
local utils = require("doro.utils")
local T = utils.T
local doro_lualine = Extension:new("lualine")
local function get_active_highlight(doro)
    local doro_mode = doro.pomo.flow[doro.pomo.current]
    -- print(doro_mode)
    local vim_mode = vim.fn.mode()
    local mode_map = {
        n = "normal",
        i = "insert",
        v = "visual",
        V = "visual",
        [""] = "visual", -- Visual block
        c = "command",
        R = "replace",
        t = "terminal",
    }

    local doro_mode_map = {
        [doro.pomo.S] = "visual",
        [doro.pomo.W] = "insert",
        [doro.pomo.L] = "replace",
    }

    local mode = mode_map[vim_mode] or "normal"
    mode = doro_mode_map[doro_mode]
    return {
        default = "lualine_b_" .. mode,
        active = "lualine_a_" .. mode,
        accent = "lualine_c_" .. mode,
        sep = "lualine_a_inactive",
    }
end


function doro_lualine:setup(doro)
    local ext = function()
        local hl = get_active_highlight(doro)
        local line = T(hl.sep,
            { "[DORO] " },
            { " " .. doro.pomo.flow[doro.pomo.current] .. " ", hl.default },
            { " " .. utils.print_time(doro.pomo.timer.target - doro.pomo.timer.elapsed) .. " ", hl.accent }
        )

        return string.upper(line)
    end

    return ext
end

return doro_lualine
