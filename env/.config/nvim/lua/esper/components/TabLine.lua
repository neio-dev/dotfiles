local Div    = require("esper.core.components.Div")
local colors = require("esper.colors")
local Icon   = require("esper.Icon")

local colors = {
    bg = "#14131D",
    active = "#191B28",
    fg_light = "#646DA6",
}

function Tab(children)
    return Div { children, Icon("times") }
        :layout { gap = 2, corner_left = "angleup", corner_right = "angledown", padding = 2 }
        :style { bg = colors.active, color = colors.fg_light }
end

local function TabLine()
    return Div {
            Div { "2", Icon "leftarrow" }
                :layout { gap = 1 },
            Tab {
                Icon("react")
                    :style { color = "red" },
                Div { "doc.lua" }
                    :style { color = "orange" }
            }
                :style { color = "white" }
                :props { id = 2 },
            Tab { Icon("react"):style { color = "cyan" }, "math.md" }:style { color = "red" },
            Tab { "image.md" },
            Tab { "picker.md" },
        }
        :layout { padding = 2, gap = 0 }
        :style { bg = colors.bg, color = colors.fg_light }
end

return TabLine
