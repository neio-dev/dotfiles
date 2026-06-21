local utils = require "esperv2.utils"
---@class InlineStylizer
---@field node Node
local InlineStylizer = {}
InlineStylizer.__index = InlineStylizer

---comment
---@param node Node
---@return InlineStylizer
function InlineStylizer:new(node)
    local instance = setmetatable({
        node = node,
    }, self)

    return instance
end

function InlineStylizer:compute_style(style_tbl)
    self._style = style_tbl

    if self.node.parent then
        self.node.parent.renderer.stylizer:stylize("test")
    end

    self.computed_style = (self.node.parent
        and self.node.parent.renderer.stylizer.computed_style) or self.computed_style or {}

    local style_to_hl = {
        color = "fg",
    }

    local validate = {
        color = "string",
        bg = "string",
        bold = "boolean",
        underline = "boolean",
        italic = "boolean"
    }

    for key, value in pairs(style_tbl) do
        if type(value) == validate[key] then
            if style_to_hl[key] then
                self.computed_style[style_to_hl[key]] = value
            else
                self.computed_style[key] = value
            end
        end
    end

    if self:get_hl_name() then
        vim.api.nvim_set_hl(0, self:get_hl_name(), self.computed_style)
    end

    self._style = style_tbl

    return self
end

---@return string | nil
function InlineStylizer:get_hl_name()
    if utils.is_object_empty(self.computed_style) then return nil end
    self.hl_name = self.hl_name or "Esper" .. utils.fnv1a(utils.serialize_style(self.computed_style))
    return self.hl_name
end

function InlineStylizer:get_parent_hl_name(str)
    local parent_hl
    if self.node.parent then
        self.node.parent.renderer.stylizer:stylize(str)
        parent_hl = self.node.parent.renderer.stylizer:get_hl_name()

        if (not parent_hl) and self.node.parent.parent then
            local next_parent = self.node.parent.parent

            while next_parent and (next_parent.parent or parent_hl == self.node.parent.hl_name) do
                parent_hl = next_parent.renderer.stylizer:get_hl_name()
                next_parent = next_parent.parent
            end
        end
    end

    return parent_hl
end

function InlineStylizer:stylize(str)
    self:compute_style(self.node.style_tbl)
    local returned_conc = str
    local base_hl = self:get_parent_hl_name(str) or self:get_hl_name()

    if self.computed_style and #self.computed_style and self:get_hl_name() then
        returned_conc = utils.T(base_hl or self:get_hl_name()) { returned_conc, self:get_hl_name() }
    else
        returned_conc = returned_conc
    end

    return returned_conc
end

return InlineStylizer
