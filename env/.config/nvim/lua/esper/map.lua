local utils = require("esper.utils")
if _G.grid_win and vim.api.nvim_win_is_valid(_G.grid_win) then
    pcall(vim.api.nvim_win_close, _G.grid_win, true)
    _G.grid_win = nil
end

local len = vim.fn.strchars
local function bytesub(str, i, j)
    return vim.fn.strcharpart(str, i, j or len(str))
end

local buf = vim.api.nvim_create_buf(false, true)
_G.grid_win = vim.api.nvim_open_win(buf, false, { split = "right", style = 'minimal' })

local width = (vim.api.nvim_win_get_width(_G.grid_win))

local lines = {}

for i = 1, 20, 1 do
    table.insert(lines, string.rep("-", width))
end

local function parse_percentage_str(str)
    local _percent = tonumber(str:sub(1, -2)) / 100
    return _percent
end

local function block(child_lines, node)
    local maxsize = 0
    local _lines = { table.unpack(child_lines) }

    for _, value in ipairs(_lines) do
        if len(value) > maxsize then maxsize = len(value); end
    end

    local _width = node:get_layout_width()

    local _direction = node._layout.direction or "column"
    maxsize = (_width or 0) > maxsize and _width or maxsize
    if _direction == "column" and len(value) < maxsize then
        for index, value in ipairs(child_lines) do
            if node._layout.align == "center" then
                -- fix empty line
                local _value_len = (len(value) == 0) and 1 or len(value)
                local _mod = (len(value) > 0 and len(value) % 2 == 0) and 0 or 1
                local l_rep = string.rep(" ", math.floor((maxsize - _value_len) / 2) + _mod)
                local r_rep = string.rep(" ", math.floor((maxsize - _value_len) / 2))
                _lines[index] = l_rep .. (value == "" and " " or value) .. r_rep
            elseif node._layout.align == "right" then
                _lines[index] = string.rep(" ", maxsize - len(value)) .. value
            else
                _lines[index] = value .. string.rep(" ", maxsize - len(value))
            end

            if node._layout.gap then
                for i = 1, node._layout.gap, 1 do
                    table.insert(_lines, index + (node._layout.gap * (i - 1)), string.rep(" ", maxsize))
                end
            end
        end
    elseif _direction == "row" then
        local inline = ""

        for index, value in ipairs(child_lines) do
            if index > 1 then
                inline = inline .. string.rep(" ", (node._layout.gap or 0) + 1)
            end
            inline = inline .. value
        end

        if node._layout.align == "center" then
            local _value_len = (len(inline) == 0) and 1 or len(inline)
            local _mod = (len(inline) > 0 and len(inline) % 2 == 0) and 0 or 1
            local l_rep = string.rep(" ", math.floor((maxsize - _value_len) / 2) + _mod)
            local r_rep = string.rep(" ", math.floor((maxsize - _value_len) / 2))
            _lines = { l_rep .. inline .. r_rep }
        elseif node._layout.align == "right" then
            _lines = { string.rep(" ", maxsize - len(inline)) .. inline }
        else
            _lines = { inline .. string.rep(" ", maxsize - len(inline)) }
        end
    end

    for _ = 1, (node._layout.height or #_lines) - #_lines, 1 do
        table.insert(_lines, string.rep(" ", maxsize))
    end

    return _lines
end

local function padding(child_lines, pad)
    if not pad then return child_lines end
    local _lines = { table.unpack(child_lines) }
    local _pad_str = string.rep(" ", pad or 0)

    for index, value in ipairs(_lines) do
        _lines[index] = _pad_str .. value .. _pad_str
    end

    for i = 1, pad and math.ceil(pad / 2) or 0, 1 do
        table.insert(_lines, 1, string.rep(" ", len(_lines[1])))
        table.insert(_lines, #_lines + 1, string.rep(" ", len(_lines[1])))
    end

    return _lines
end

local borders_style = {
    normal = { "┌", "┐", "└", "┘", "─", "│" },
    plus = { "╬", "╬", "╬", "╬", "─", "│" },
    rounded = { "╭", "╮", "╰", "╯", "─", "│" },
    angular = { "/", "\\", "\\", "/", "─", "│" },
    double = { "╔", "╗", "╚", "╝", "═", "║" },
}

local function border(child_lines, node)
    local type = node._layout.border
    if not type then return child_lines end
    local _lines = { table.unpack(child_lines) }
    local tl, tr, bl, br, h, v = table.unpack(borders_style[type or "normal"])

    for index, value in ipairs(_lines) do
        _lines[index] = v .. (node._layout.width and value:sub(0, -2) or value) .. v
    end

    local _mod = node._layout.width and -1 or 0
    table.insert(_lines, 1, tl .. string.rep(h, len(child_lines[1]) + _mod) .. tr)
    table.insert(_lines, #_lines + 1, bl .. string.rep(h, len(child_lines[1]) + _mod) .. br)

    return _lines
end

local Component = {}
Component.__index = Component
Component.class_name = "Component"

function Component:new(children)
    local instance = setmetatable({
        _children = children,
        _layout = {},
    }, Component)

    instance:compute_width()
    return instance
end

function Component:render(x, y)
    local _lines = { table.unpack(self._children) }
    for index, child in ipairs(self._children) do
        if utils.instanceof(child, Component.class_name) then
            table.remove(_lines, index)
            local child_lines = child:render(0, 0)
            for line_index, _line in ipairs(child_lines) do
                table.insert(_lines, _line)
            end
        end
    end

    print(vim.inspect(_lines))
    local modifiers = {
        { block,   self },
        { padding, self._layout.padding },
        { border,  self },
    }

    for _, mod in ipairs(modifiers) do
        _lines = mod[1](_lines, table.unpack(mod, 2))
    end

    self.x = x
    self.y = y + 1
    self.height = #_lines
    self.width = len(_lines[1])

    if (self.y + self.height) > #lines then
        for i = 1, (self.y + self.height) - #lines, 1 do
            table.insert(lines, string.rep("-", width))
        end
    end


    local top_border = _lines[1]
    local bottom_border = _lines[#_lines]
    local prev_line = lines[self.y - 1]
    local tl = bytesub(top_border, 0, 1)
    if prev_line then
        if bytesub(prev_line, self.x, 1) == "│" then
            print("yoye", vim.inspect(_lines[1]))
            _lines[1] = "├" .. bytesub(_lines[1], 1)
        end
        if bytesub(prev_line, self.x + self.width - 1, 1) == "│" then
            print("yoye", vim.inspect(_lines[1]))
            _lines[1] = bytesub(_lines[1], 0, len(_lines[1]) - 1) .. "┤"
        end
    end
    local tr = bytesub(top_border, len(top_border) - 1, 1)
    local bl = bytesub(bottom_border, 0, 1)
    local br = bytesub(bottom_border, len(top_border) - 1, 1)

    for index, value in ipairs(_lines) do
        local _y = self.y + index - 1
        lines[_y] = bytesub(lines[_y], 0, self.x) ..
            value .. bytesub(lines[_y], self.x + len(value), len(lines[_y]))
    end
    return _lines
end

function Component:compute_width()
    local _width = 0

    -- padding
    _width = _width + ((self._layout.padding or 0) * 2)

    if self._layout.direction == "row" then
        _width = _width + ((self._layout.gap or 0) * (#self._children - 1))
    end

    if not self._layout.width then
        local max_child = 0
        for _, _child in ipairs(self._children) do
            if self._layout.direction == "row" then
                _width = _width + len(_child)
            elseif max_child < len(_child) then
                max_child = len(_child)
            end
        end
        _width = _width + max_child
    else
        _width = self:get_layout_width()
    end

    self.width = _width
    return _width
end

function Component:get_layout_width()
    local _width = self._layout.width
    if type(_width) == "string" and (string.sub(_width, -1) == "%") then
        print(width * parse_percentage_str(_width))
        _width = math.floor(width * parse_percentage_str(_width)) - 1
    end

    return _width
end

function Component:layout(layout_tbl)
    self._layout = layout_tbl
    self:compute_width()
    return self
end

local header = Component:new {
    "[Devtool]",
}:layout { width = "100%", align = "center", border = "normal" }

local feat = Component:new {
    "[Elements]",
    "[Performance]",
    "[Memory]",
}:layout { width = "100%", align = "center", border = "normal", direction = "row" }

local lox = Component:new {
    "Affichage des composants [K]",
    "Changer une propriete [E]",
    "Cibler le parent [P]",
    "Dupliquer le composant [D]",
    "Supprimer le composant [X]",
}:layout { align = "left", border = "plus", gap = 0 }

local div = Component:new {
        "<div>",
        string.rep(" ", 4) .. "<div>",
        string.rep(" ", 4) .. "<div>",
        string.rep(" ", 4) .. "<div>",
        "<div>",
        "<div>",
    }
    :layout { padding = 2, width = "100%", height = 10, border = "normal" }

local side = Component:new {
        "Styles",
        "Computed",
        "Layout",
    }
    :layout { padding = 2, width = "20%", height = 20, border = "normal", direction = "row" }


local modal = Component:new {
        "- Close ? -",
        "============",
        "[V]  Yes",
        "[V] No",
    }
    :layout { padding = 2, align = "center", width = 30, border = "double" }

local footer = Component:new {
    "Footer",
}
    :layout {  padding = 4, width = "94%", border = "double" }


local dom = {}

local function renderer(node)
    local x = 0
    local y = 0
    local previous_node = dom[#dom]

    if previous_node then
        node.previous = previous_node
        x = previous_node.x + previous_node.width
        y = previous_node.y - 1
        if (x + (node.width)) > width then
            local surp_height = previous_node.previous and previous_node.previous.height or 0
            local max_height = surp_height > previous_node.height and surp_height or previous_node.height
            x = 0
            y = previous_node.y + (max_height) - 1
        end
    end

    node:render(x, y)
    table.insert(dom, node)
end

renderer(header)
renderer(feat)
renderer(div)
renderer(side)
renderer(footer)

vim.api.nvim_buf_set_lines(buf, 0, 0, true, lines)
