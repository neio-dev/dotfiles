local Div = require("esper.core.components.Div")
local Icon = require("esper.Icon")
local colors = require("esper.colors")

local function StatusLine()
    return Div {
            Div { "[No Name]", "[-]" },
            Div { "10:16", "test-diff_comparison.sh", "[-]" }:layout { gap = 1 },
            Div {
                "28:1",
                Div { "NORMAL" }
                    :layout { corner_left = "rounded", padding = 1 }
                    :style { bg = colors.accent, color = colors.light, bold = true },
                "//test-diff-comparison.sh",
                "[-]",
                Icon "star",
                Icon "terminal",
                "sh",
                Div {
                    Div { "3%%" }
                        :style { bg = colors.light, color = colors.accent, bold = true }
                        :layout { padding = 2 },
                    Div { "4:45" }
                        :style { bg = colors.accent, color = colors.light, }
                        :layout { padding = 2, corner_right = "rounded" },
                }
            }:layout { gap = 1, padding = 1 },
        }
        :style { bg = colors.darker, color = colors.light }
        :layout({ padding = 1, gap = 8 })
end

return StatusLine 
