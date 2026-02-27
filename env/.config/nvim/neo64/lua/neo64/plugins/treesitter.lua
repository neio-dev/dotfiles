local colors = require("neo64.colors")

return function()
    local treesitter_hl = {
        ["@variable"] = { fg = colors.white },
        ["@tag"] = { fg = colors.white },
        ["@tag.builtin"] = { fg = colors.fg },
        ["@tag.attribute"] = { fg = colors.fg },
        ["@function"] = { fg = colors.yellow },
        ["@punctuation"] = { fg = colors.yellow },
        ["@constructor"] = { fg = colors.yellow },
        ["@property"] = { fg = colors.fg },
        ["@variable.member"] = { fg = colors.fg },
        ["@keyword"] = { fg = colors.fg },
        ["@keyword.function"] = { fg = colors.lightgreen },
    }

    return treesitter_hl
end
