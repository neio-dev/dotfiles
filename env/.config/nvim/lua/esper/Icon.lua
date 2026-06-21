local Component = require("esper.Component")

---@enum IconLib
local ICONS_LIB = {
    facebook = "facebook",
    react = "react",
    cog = "cog",
    terminal = "terminal",
    folder = "folder",
    folder_add = "folder_add",
    add = "add",
    splith = "splith",
    splitv = "splitv",
    cut = "cut",
    copy = "copy",
    paste = "paste",
    trash = "trash",
    time = "time",
    random = "random",
    hash = "hash",
    at = "at",
    star = "star",
    keyboard = "keyboard",
    ligthning = "ligthning",
    pen = "pen",
    times = "times",
    leftarrow = "leftarrow",
}

local icons = {
    [ICONS_LIB.facebook] = "",
    [ICONS_LIB.react] = "",
    [ICONS_LIB.cog] = "",
    [ICONS_LIB.terminal] = "",
    [ICONS_LIB.folder] = "",
    [ICONS_LIB.add] = "",
    [ICONS_LIB.folder_add] = "",
    [ICONS_LIB.splith] = "",
    [ICONS_LIB.splitv] = "",
    [ICONS_LIB.cut] = "",
    [ICONS_LIB.copy] = "",
    [ICONS_LIB.paste] = "",
    [ICONS_LIB.trash] = "",
    [ICONS_LIB.time] = "󱑃",
    [ICONS_LIB.random] = "",
    [ICONS_LIB.hash] = "",
    [ICONS_LIB.at] = "",
    [ICONS_LIB.star] = "",
    [ICONS_LIB.keyboard] = "󰌌",
    [ICONS_LIB.ligthning] = "󱐋",
    [ICONS_LIB.pen] = "",
    [ICONS_LIB.times] = "",
    [ICONS_LIB.leftarrow] = "",
}

local function get_icon(icon_name)
    return icons[icon_name]
end

---comment
---@param icon_name IconLib|string
---@return Component
local function Icon(icon_name)
    local icon = icon_name

    if string.sub(icon_name, 1, 1) ~= "\\" then 
        icon = get_icon(icon)
    else
        local hex = icon:match("\\u(%x+)")
        local codepoint = tonumber(hex, 16)
        icon = vim.fn.nr2char(codepoint)
    end

    local instance = Component:new(
        "icon",
        { icon .. " " }
    )
    instance.name = "icon"
    -- override Component  default behavior and add behavior specific for div here
    return instance
end

return Icon
