local text_renderer  = require "esper.text_renderer"
local utils          = require "esper.utils"

local id             = 1

_G.EsperClickHandler = function(component_id)
    _G.EsperDom[component_id].listeners.click[1]()
end

---@class Component
local Component      = {}
Component.__index    = Component
Component.class_name = "Component"

---@param name any
---@param children any
---@return Component
function Component:new(name, children)
    local instance = setmetatable({
        _style = {},
        _layout = {},
        _props = {},
        computed_style = {},
        computed_layout = {},
        listeners = {},
    }, Component)

    instance.children = children

    for index, child in ipairs(children) do
        if utils.instanceof(child, "Component") then
            child.parent = (instance)
        end
    end

    instance.name = name
    instance.id = id
    id = id + 1

    return instance
end

---@class StyleObject
---@field color string
---@field bg string
---@field underline boolean
---@field bold boolean
---@field italic boolean

---@param obj table
---@return boolean
local function is_object_empty(obj)
    for key, value in pairs(obj) do
        return false
    end

    return true
end

---@return string?
function Component:get_hl_name()
    if is_object_empty(self.computed_style) then return nil end
    return "Esper" .. utils.fnv1a(utils.serialize_style(self.computed_style))
end

---comment
---@param style_tbl StyleObject
---@return Component
function Component:style()
    -- style_tbl = vim.tbl_extend("force", self.parent and self.parent._style or {}, style_tbl)
    if type(style_tbl) == "function" then
        style_tbl = style_tbl(self._style)
    end

    self._style = self.style_tbl or {}
    self.computed_style = self.computed_style or {}

    local style_to_hl = {
        color = "fg",
    }

    local validate = {
        color = "string",
        bg = "string",
        bold = "boolean",
        underline = "boolean",
        italic = "boolean",
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
    vim.api.nvim_set_hl(0, self:get_hl_name(), self.computed_style)
    self._style = style_tbl

    return self
end

function Component:on(type, callback)
    local listeners = self.listeners[type] or {}
    table.insert(listeners, callback)

    self.listeners[type] = listeners
    return self
end

---@class Layout
---@field padding number
---@field border number
---@field border_style BorderStyles
---@field border_right BorderStyles
---@field border_left BorderStyles
---@field corner CornerStyles
---@field corner_left CornerStyles
---@field corner_right CornerStyles
---@field gap number

---@param layout_tbl Layout
---@return Component
function Component:layout(layout_tbl)
    local computed_layout = {}

    self._layout = layout_tbl
    self.computed_layout = layout_tbl

    return self
end

function Component:props(props_tbl)
    self._props = props_tbl

    return self
end

function Component:on_mount()
    for index, value in ipairs(self.listeners.click or {}) do
        local click_function = "EsperClickHandler"
        self.click = click_function
    end
end

local renderer = text_renderer:new()
function Component:render()
    -- print(vim.inspect(self))
    self:on_mount()
    _G.EsperDom = _G.EsperDom or {}
    _G.EsperDom[self.id] = self
    return text_renderer:render(self)
end

function Component:attach_parent(parent)
    if not utils.instanceof(parent, "Component") then
        return
    end

    self.parent = parent
end

return Component
