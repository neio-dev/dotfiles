for name, _ in pairs(package.loaded) do
    if name:match("^esperv2") then
        package.loaded[name] = nil
    end
end

local Node = require("esperv2.node")
local View = require("esperv2.view")

local function Box(children)
    return Node:new(children)
end

local function Title(children)
    return Box(children)
        :style { color = "yellow", bg = "blue" }
        :layout {
            padding = 1,
        }
end


local File = View(function(children, props)
    props = props or {}

    return (props.active and "[*] " or "") .. children .. (props.icon and props.icon:render() or "")
end)

function Map(tbl)
    return function(fn)
        local _tbl = {}
        for index, value in ipairs(tbl) do
            table.insert(_tbl, fn(value, index, #tbl == index))
        end
        return _tbl
    end
end

local function WinBar()
    local active = 2

    return Box {
        Title { "[BAY]" },
        Box {
            Map { "Dist.lua", "builder.lua", "TEXT_RENDERER.lua", "node.lua" } (function(eachFile, index, is_last)
                return {
                    File(eachFile):props { active = active == index, icon = Box { "t", "t" }:layout { padding = 2 }},
                    not is_last and "|"
                }
            end),
        }:layout { gap = 1 },
        Title { "|||" },
        Title { "[DOCK]" },
        Box {
            Map { "Dist.lua", "builder.lua", "TEXT_RENDERER.lua", "node.lua" } (function(eachFile, index, is_last)
                return {
                    "[" .. index .. "]",
                    File(eachFile):props {},
                    not is_last and "|"
                }
            end),
        }:layout { gap = 1 },
    }:style {
        color = "black",
        bg = "lavender"
    }:layout {
        gap = 1,
        padding = 2,
        border = 3
    }
end

vim.o.winbar = (WinBar():render())

return Box
