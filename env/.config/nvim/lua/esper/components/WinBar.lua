local Div = require("esper.core.components.Div")
local omap = require("esper.core.functions.omap")
local map = require("esper.core.functions.map")
local colors = require("esper.colors")

local selected = 2

---@param props {name: string, index: number}
---@return Component
local function ShipName(props)
    local name, index = props.name, props.index
    local is_selected = index == selected
    local function withSelected(name, index)
        if selected == index then
            return "[" .. name .. "]"
        end

        return name
    end

    return Div { withSelected(name, index) }
        :layout { padding = 1 }
        :style { color = is_selected and "white" or colors.accent, bg = colors.darker, bold = is_selected }
        :on("click", function()
            -- print(v, index)
            selected = index
        end)
end

local function FleetName(str)
    return Div { str }
        :style { bg = colors.light, color = colors.darker, bold = true }
        :layout { corner = "lightshade", border = 1, border_style = "double", padding = 1 }
end

local function WinBar()
    local fleets = {
        BAY = { "text_renderer.lua", "Component.lua", "Icon.lua", "utils.lua" },
        DOCK = { "test.lua", "Component.lua", "x", "x" }
    }

    return Div {
            omap(fleets):for_each(function(fleet, fleet_name)
                return Div {
                    FleetName(fleet_name),
                    Div {
                        map(fleet)
                            :for_each(function(v, i)
                                return ShipName { name = v, index = i }
                            end),
                    }
                        :layout { gap = 2 }
                }
            end),
        }
        :style { color = colors.light, bg = colors.darker }
        :layout { gap = 2 }
end

return WinBar
