local colors = require("neo64.colors")

return function()
    local fzf_hl = {
        FzfLuaCursorLine = { fg = colors.dg, bg = colors.mg },
    }

    return fzf_hl
end
