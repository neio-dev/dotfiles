local inline_stylizer = require "esperv2.inline_stylizer"

---@class InlineRenderer
---@field node Node
---@field stylizer InlineStylizer
local InlineRenderer = {}
InlineRenderer.__index = InlineRenderer

---comment
---@param node Node
---@return InlineRenderer
function InlineRenderer:new(node)
    local instance = setmetatable({
        node = node,
        stylizer = inline_stylizer:new(node),
    }, self)

    return instance
end

function InlineRenderer:gap(children)
    local gap = self.node.layout_tbl.gap or 0
    local render = ""

    for index, child in ipairs(children) do
        render = render .. (index > 1 and string.rep(" ", gap) or "") .. child
    end

    return render
end

function InlineRenderer:pad(str)
    local render = str

    local pad = string.rep(" ", self.node.layout_tbl.padding or 0)
    render = pad .. render .. pad

    return render
end

function InlineRenderer:border(str)
    local render = str

    local pad = string.rep("|", self.node.layout_tbl.border or 0)
    render = pad .. render .. pad

    return render
end

function InlineRenderer:corner(str)
    local render = str

    return render
end

function InlineRenderer:fit(str)
    local render = str
    local clean = str:gsub("%%#.-#", "")
    if self.node.layout_tbl.width == "fill" then
        local win_width = vim.fn.winwidth(0)
        local missing = win_width - string.len(clean)
        missing = missing - (self.node.layout_tbl.border * 2)
        -- missing = missing - (self.node.layout_tbl.padding * 2)
        -- missing = missing - (self.node.layout_tbl.gap * (#self.node.children - 1))

        render = render .. str.rep(" ", missing)
    end

    return render
end

function InlineRenderer:parse_children(children)
    local children_tbl = children
    local _children = {}
    for index, child in ipairs(children_tbl) do
        if child == nil or child == false then
            break
        end
        local _child = child
        if child.class_name and child.class_name == "View" then
            _child = child.fn(child.children, child.props_tbl)
        end
        local rendered_child

        if _child.class_name == "Node" then
            _child.parent = self.node
            rendered_child = _child:render()
        elseif type(_child) == "table" then
            rendered_child = self:gap(self:parse_children(_child))
        elseif type(_child) == "function" then
            rendered_child = _child(self.node.props_tbl)
        else
            rendered_child = _child
        end

        table.insert(_children, rendered_child)
    end

    return _children
end

function InlineRenderer:render()
    local children = self.node.children
    if type(children) == "function" then
        children = children(self.node.props_tbl)
    end

    if self.node.class_name and self.node.class_name == "View" then
        print("view")
    end

    local render = children
    if type(self.node.children) == "table" then
        -- inner
        children = self:parse_children(self.node.children)
        render = self:gap(children)
    end

    -- outer
    render = self:pad(render)
    render = self:fit(render)
    render = self:border(render)
    render = self:corner(render)
    render = self.stylizer:stylize(render)
    return render
end

return InlineRenderer
