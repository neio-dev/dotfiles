local Div = require("esper.core.components.Div")

local function Pill(children)
    return Div {
            table.remove(children, 1),
            children[1],
            children[#children],
        }
        :layout { padding = 1, corner = "rounded" }
end

return Pill
