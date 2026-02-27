local colors = require("neo64.colors")

return function()
    local markup_hl = {
        -- TITLE
        RenderMarkdownH1Bg = { fg = colors.fg, bg = colors.yellow },
        RenderMarkdownH2Bg = { bg = colors.blue, fg = colors.fg },
        RenderMarkdownH3Bg = { bg = colors.blue, fg = colors.fg },
        RenderMarkdownH4Bg = { bg = colors.blue, fg = colors.fg },
        RenderMarkdownH5Bg = { bg = colors.blue, fg = colors.fg },
        RenderMarkdownH6Bg = { bg = colors.blue, fg = colors.fg },
        ["@markup.quote"] = { fg = colors.lightgreen },
        ["@markup.raw"] = { fg = colors.lightgreen, bg = colors.bg },
        -- TABLE
        RenderMarkdownTableHead = { fg = colors.white, bg = colors.mg },
        RenderMarkdownTableRow = { fg = colors.white, bg = colors.mg },
        RenderMarkdownTableFill = { bg = colors.mg },
        -- CHECKED
        RenderMarkdownUnchecked = { bg = colors.mg, fg = colors.white },
        RenderMarkdownChecked = { bg = colors.mg, fg = colors.white },
        RenderMarkdownTodo = { bg = colors.mg, fg = colors.white },
        ["@comment.markdown"] = { fg = colors.white, bg = colors.bg },

        -- CODE
        RenderMarkdownCode = { bg = colors.mg },
        RenderMarkdownCodeInfo = { bg = colors.white },
        RenderMarkdownCodeBorder = { bg = colors.white },
    }

    return markup_hl
end
