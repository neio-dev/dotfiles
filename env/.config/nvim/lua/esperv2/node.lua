local inline_renderer = require "esperv2.inline_renderer"
local utils           = require "esperv2.utils"
---@class Node
---@field style function
---@field layout function
---@field render function
---@field renderer InlineRenderer
---@field children {}
---@field style_tbl Style
---@field props_tbl {}
---@field layout_tbl Layout
---@field parent? Node
local Node            = {}
Node.__index          = Node
Node.class_name       = "Node"

function Node:new(children)
    local instance = setmetatable({
        children = {},
        style_tbl = {},
        layout_tbl = {},
        props_tbl = {},
    }, self)

    instance.children = children
    instance.renderer = inline_renderer:new(instance)
    return instance
end

---@class Style
---@field bg string
---@field color string

---comment
---@param style Style
---@return Node
function Node:style(style)
    for key, value in pairs(style) do
        self.style_tbl[key] = value
    end

    return self
end

---@class Layout
---@field padding number
---@field gap number
---@field margin number
---@field border number
---@field width "fill" | "auto"

---comment
---@param layout Layout
---@return Node
function Node:layout(layout)
    for key, value in pairs(layout) do
        self.layout_tbl[key] = value
    end

    return self
end

function Node:props(props)
    for key, value in pairs(props) do
        self.props_tbl[key] = value
    end

    return self
end

function Node:render()
    return self.renderer:render()
end

return Node
