local M = {}

local function get_lualine_theme()
    local config = require("lualine").get_config()
    local theme_name = config.options.theme
    if type(theme_name) == "string" then
        return require("lualine.themes." .. theme_name)
    elseif type(theme_name) == "table" then
        return theme_name
    elseif type(theme_name) == "function" then
        return theme_name()
    else
        return require("lualine.themes.auto")
    end
end

function M.get_highlight(mode, part)
    local theme = get_lualine_theme()

    return theme[mode] and theme[mode][part] or { fg = "#ffffff", bg = "#000000" }
end

function M.invert(group)
    if not group then return {} end

    return { fg = group.bg, bg= group.fg, gui = group.gui }
end

function M.ligthen(group)
    if not group or not group.bg then return group end

    return { fg = group.fg, bg = "#303030", gui = group.gui }
end


return M

