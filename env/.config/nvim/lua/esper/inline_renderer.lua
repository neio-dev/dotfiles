local InlineRenderer = {}
InlineRenderer.__index = InlineRenderer

function InlineRenderer:new()
    local instance = setmetatable({
        win = nil,
        buf = nil,
        name = "inline_renderer",
        children_style = {},
    }, self)

    instance.node = {}

    return instance
end

function InlineRenderer:parse_children()
end

function InlineRenderer:render(node)
    local render = ""

    for _, child in ipairs(node) do
        render = render .. child
    end

    return render
end

local ren = InlineRenderer:new()
ren:render { "Test", "No" }
return InlineRenderer
