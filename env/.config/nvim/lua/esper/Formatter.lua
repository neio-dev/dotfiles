local utils = require "esper.utils"
local Formatter = {}
Formatter.__index = Formatter


---@enum BorderStyles
local BORDER_STYLES = {
    normal = "normal",
    staggered = "staggered",
    double = "double",
    dash = "dash",
    dot = "dot",
    bracket = "bracket",
}

local BORDERS = {
    [BORDER_STYLES.normal] = "|",
    [BORDER_STYLES.staggered] = "/",
    [BORDER_STYLES.double] = "║",
    [BORDER_STYLES.dash] = "╎",
    [BORDER_STYLES.dot] = "┊",
    [BORDER_STYLES.bracket] = { "[", "]" },
}

---@enum CornerStyles
local CORNERS_STYLES = {
    rounded = "rounded",
    triangle = "triangle",
    angleup = "angleup",
    angledown = "angledown",
    caret = "caret",
    caretright = "caretright",
    caretleft = "caretleft",
    caretline = "caretline",
    fullblock = "fullblock",
    darkshade = "darkshade",
    mediumshade = "mediumshade",
    lightshade = "lightshade",
}

local CORNERS = {
    [CORNERS_STYLES.angledown] = { "", "" },
    [CORNERS_STYLES.rounded] = { "", "" },
    [CORNERS_STYLES.angleup] = { "", "" },
    [CORNERS_STYLES.caret] = { "", "" },
    [CORNERS_STYLES.caretright] = "",
    [CORNERS_STYLES.caretleft] = "",
    [CORNERS_STYLES.caretline] = { "", "" },
    [CORNERS_STYLES.fullblock] = "█",
    [CORNERS_STYLES.darkshade] = "▓",
    [CORNERS_STYLES.mediumshade] = "▒",
    [CORNERS_STYLES.lightshade] = "░",
}

function Formatter:new(node)
    local instance = setmetatable({
        node = node,
    }, self)

    return instance
end

function Formatter:corner(str)
    if not utils.has_property(self.node.computed_layout, "corner", "corner_left", "corner_right") then
        return str
    end

    local computed_style = {}

    local nearest_parent_with_bg
    if self.node.parent then
        local last_parent = self.node.parent
        while last_parent and not nearest_parent_with_bg do
            if utils.has_property(last_parent.computed_style, "bg") then
                nearest_parent_with_bg = last_parent
            end
            last_parent = last_parent.parent
        end
    end

    if nearest_parent_with_bg then
        computed_style.bg = nearest_parent_with_bg.computed_style.bg
    end

    if utils.has_property(self.node.computed_style, "bg") then
        computed_style.fg = self.node.computed_style.bg
    end

    local hl_name = "Esper" .. utils.fnv1a(utils.serialize_style(computed_style))
    vim.api.nvim_set_hl(0, hl_name, computed_style)
    local l_corner
    local r_corner
    local l_style = CORNERS[self.node.computed_layout.corner_left or self.node.computed_layout.corner]
    local r_style = CORNERS[self.node.computed_layout.corner_right or self.node.computed_layout.corner]

    if type(l_style) == "table" then
        l_corner = l_style and l_style[1] or ""
    else
        l_corner = l_style or ""
    end

    if type(r_style) == "table" then
        r_corner = r_style and r_style[2] or ""
    else
        r_corner = r_style or ""
    end
    local nearest_parent_with_style
    if self.node.parent then
        local last_parent = self.node.parent
        while last_parent and not nearest_parent_with_style do
            if not utils.is_object_empty(last_parent.computed_style) then
                nearest_parent_with_style = last_parent
            end
            last_parent = last_parent.parent
        end
    end

    if self.node.computed_layout.corner == "angleup" then
    end

    local T = utils.T(self.node:get_hl_name() or (nearest_parent_with_style and nearest_parent_with_style:get_hl_name()) or
        "")

    return (l_corner and T { l_corner, hl_name } or "") .. str .. (r_corner and T { r_corner, hl_name } or "")
end

function Formatter:border(str)
    if not utils.has_property(self.node.computed_layout, "border", "border_left", "border_right") then
        return str
    end

    local left_bor
    local right_bor

    local bor_left_style = BORDERS
        [self.node.computed_layout.border_left or self.node.computed_layout.border_style or "normal"]
    local bor_right_style = BORDERS
        [self.node.computed_layout.border_right or self.node.computed_layout.border_style or "normal"]

    if type(bor_left_style) == "table" then
        left_bor = bor_left_style[1]
    else
        left_bor = bor_left_style
    end

    if type(bor_right_style) == "table" then
        right_bor = bor_right_style[2]
    else
        right_bor = bor_right_style
    end

    left_bor = string.rep(left_bor, self.node.computed_layout.border)
    right_bor = string.rep(right_bor, self.node.computed_layout.border)
    return left_bor .. str .. right_bor
end

function Formatter:margin(str)
    if not utils.has_property(self.node.computed_layout, "margin") then
        return str
    end

    local margin = string.rep(" ", self.node.computed_layout.margin)
    return margin .. str .. margin
end

function Formatter:pad(value)
    if not utils.has_property(self.node.computed_layout, "padding") then
        return value
    end

    local str_pad = string.rep(" ", self.node.computed_layout.padding)

    if type(value) == "string" then
        return str_pad .. value .. str_pad
    end

    if type(value) == "table" then
        local formatted_lines = {}
        local max_line_length = 0

        for _, line in ipairs(value) do
            local padded_line = str_pad .. line .. str_pad
            table.insert(formatted_lines, padded_line)

            if vim.fn.strcharlen(padded_line) > max_line_length then
                max_line_length = vim.fn.strcharlen(padded_line)
            end
        end

        local ceiled_padding = math.ceil(self.node.computed_layout.padding / 2)

        for _ = 1, ceiled_padding, 1 do
            table.insert(formatted_lines, 1, string.rep(" ", max_line_length))
        end

        for _ = 1, ceiled_padding, 1 do
            table.insert(formatted_lines, string.rep(" ", max_line_length))
        end

        return formatted_lines
    end
end

return Formatter
