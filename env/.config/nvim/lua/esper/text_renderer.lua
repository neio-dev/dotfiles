local utils = require "esper.utils"
local Formatter = require "esper.Formatter"
local TextRenderer = {}
TextRenderer.__index = TextRenderer

function TextRenderer:new()
    local instance = setmetatable({
        name = "text_renderer",
    }, self)

    instance.node = {}

    return instance
end

function TextRenderer:parse_node_children(tbl, conc)
    if not tbl then return end
    for _, child in ipairs(tbl) do
        if child then
            local rendered_child = child

            if utils.instanceof(child, "Component") then
                rendered_child = child:render()
            elseif type(child) == "table" then
                print(child)
                rendered_child = self:parse_node_children(child, conc)
            end

            table.insert(conc, rendered_child)
        end
    end
end

---@param node Component
---@return string
function TextRenderer:render(node)
    self.node = node
    self.dom = self.dom or {}
    local conc = {}
    local separator = (node.computed_layout and node.computed_layout.vertical) and "\n" or ""

    self:parse_node_children(node._children, conc)

    local returned_conc = table.concat(
        conc,
        string.rep(
            node.computed_layout and node.computed_layout.separator or " ",
            node.computed_layout and node.computed_layout.gap or 0)
    )
    local conc_formatter = Formatter:new(node)
    returned_conc = conc_formatter:corner(conc_formatter:border(conc_formatter:pad(returned_conc)))
    self.dom[node.id] = node

    local ret_conc
    local base_hl
    if node.parent then
        base_hl = node.parent:get_hl_name()
        if (not base_hl) and node.parent.parent then
            local next_parent = node.parent.parent

            while next_parent and (next_parent.parent or base_hl == node.parent:get_hl_name()) do
                base_hl = next_parent:get_hl_name()
                next_parent = next_parent.parent
            end
        end
    end
    base_hl = base_hl or node:get_hl_name()
    if node.computed_style and #node.computed_style and node:get_hl_name() then
        returned_conc = utils.T(base_hl or node:get_hl_name()) { returned_conc, node:get_hl_name() }
    else
        returned_conc = returned_conc
    end

    if node.click then
        returned_conc = string.format(
            "%%%d@v:lua.EsperClickHandler@%s%%T",
            node.id,
            returned_conc
        )
    end

    ret_conc = conc_formatter:margin(returned_conc)
    return ret_conc
end

return TextRenderer
