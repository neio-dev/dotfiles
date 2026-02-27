local colors = require("neo64.colors")

local function setup_lualine()
    local lualine = require("lualine")

    if not lualine then
        return
    end

    lualine.setup({
        options = {
            theme = {
                normal = {
                    a = { fg = colors.bg, bg = colors.dg },     -- default
                    b = { fg = colors.yellow, bg = colors.bg }, -- active
                    c = { fg = colors.bg, bg = colors.fg },     -- accent
                },
                insert = {
                    a = { fg = colors.fg, bg = colors.yellow },     -- default
                    b = { fg = colors.yellow, bg = colors.fg }, -- active
                    c = { fg = colors.yellow, bg = colors.fg },     -- accent
                },
                inactive = {
                    a = { bg = colors.fg, fg = colors.dg }, -- separator
                },
            }
        }
    })
end

return setup_lualine
