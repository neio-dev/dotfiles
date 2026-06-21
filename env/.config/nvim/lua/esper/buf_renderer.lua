local utils = require "esper.utils"
local Formatter = require "esper.Formatter"
local TextRenderer = require "esper.text_renderer"

local text_renderer = TextRenderer:new()

local BufRenderer = {}
BufRenderer.__index = BufRenderer
local ns = vim.api.nvim_create_namespace("esper_dev_tool")
function BufRenderer:new()
    local instance = setmetatable({
        win = nil,
        buf = nil,
        name = "buf_renderer",
        children_style = {},
    }, self)

    instance.node = {}

    return instance
end

function BufRenderer:parse_node_children(tbl, lines)
    if self.node.computed_layout and self.node.computed_layout.row then
        -- lines = text_renderer:parse_node_children(tbl, lines)
    end

    for _, child in ipairs(tbl) do
        if child then
            ---@class Component
            local rendered_child = child
            if utils.instanceof(child, "Component") then
                if child.computed_layout and child.computed_layout.row then
                    child.renderer = text_renderer
                else
                    child.renderer = self
                end
                rendered_child = child:render(child.renderer)
                if child.computed_layout and child.computed_layout.row then
                    print("text", vim.inspect(rendered_child))
                else
                    print("notext", vim.inspect(rendered_child))
                end
            elseif type(child) == "table" then
                rendered_child = self:parse_node_children(child, lines)
            end

            local start = #lines
            local max_length = 0
            if type(rendered_child) == "table" then
                if #rendered_child > max_length then
                    max_length = #rendered_child
                end

                for _, child_line in ipairs(rendered_child) do
                    table.insert(lines, child_line)
                end
            else
                table.insert(lines, rendered_child)
            end

            if utils.instanceof(child, "Component") and child:get_hl_name() then
                local padding = self.node.computed_layout.padding or 0
                table.insert(self.children_style, {
                    y = math.ceil(start + ((padding) / 2)),
                    x = math.ceil(padding),
                    endY = math.ceil(#rendered_child + start + (padding / 2)),
                    hl_name = child:get_hl_name(),
                    length = (#child._children),
                    max_length = rendered_child[1] ~= nil and #rendered_child[1],
                })
                -- print(vim.inspect(self.children_style))
            end
        end
    end
end

function BufRenderer:open()
    if _G.esper_test_win and vim.api.nvim_win_is_valid(_G.esper_test_win) then
        pcall(vim.api.nvim_win_close, _G.esper_test_win, true)
        _G.esper_test_win = nil
    end

    self.buf = vim.api.nvim_create_buf(false, true)
    local floating = self.node and self.node.computed_layout and self.node.computed_layout.floating
    -- _G.esper_test_win = vim.api.nvim_open_win(self.buf, false, { split = "right" })
    _G.esper_test_win = vim.api.nvim_open_win(
        self.buf,
        true,
        {
            relative = 'win',
            row = 20,
            col = 30,
            width = 60,
            height = 150,
            border = "single",
            style = "minimal",
        }
    )

    self.win = _G.esper_test_win
    return self.win
end

---@param node Component
---@return string
function BufRenderer:render(node)
    self.node = node
    self.dom = self.dom or {}
    local lines = {}
    local separator = (node.computed_layout and node.computed_layout.vertical) and "\n" or ""

    self:parse_node_children(node._children, lines)

    local conc_formatter = Formatter:new(node)
    self.dom[node.id] = node

    lines = conc_formatter:pad(lines)
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

    if node.click then
        -- TODO handle clicks
    end

    lines = conc_formatter:margin(lines)
    local win = self:open()
    vim.api.nvim_buf_set_lines(self.buf, 0, 0, true, lines)
    if node.computed_style and #node.computed_style and node:get_hl_name() then
        self:stylize(lines)
        -- returned_conc = utils.T(base_hl or node:get_hl_name()) { returned_conc, node:get_hl_name() }
    else
    end

    return lines
end

function BufRenderer:stylize(lines)
    local width = (vim.api.nvim_win_get_width(self.win))
    vim.api.nvim_buf_set_extmark(self.buf, ns, 0, 0,
        { end_row = #lines, end_col = 0, hl_group = self.node:get_hl_name() })

    for index, value in ipairs(self.children_style) do
        print('length', value.length)
        print('length2', value.endY - value.y)
        for i = 0, value.endY - value.y - 1, 1 do
            print('y', value.y + i)
            vim.api.nvim_buf_set_extmark(self.buf, ns, value.y + i, value.x,
                { end_row = value.y + i, end_col = value.x + value.max_length, hl_group = value.hl_name })
        end
    end
end

return BufRenderer
