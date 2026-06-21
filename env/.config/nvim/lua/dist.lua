-- Bundled by luabundle {"version":"1.7.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
for name, _ in pairs(package.loaded) do
    if name:match("^esperv2") then
        package.loaded[name] = nil
    end
end

local Node = require("esperv2.node")

local function Box(children)
    return Node:new(children)
end

local function Title(children)
    return Box(children)
        :style { color = "yellow", bg = "blue" }
        :layout {
            padding = 1,
            border_style = "t"
        }
end

local function WinBar()
    return Box {
            { "Esper,", "IS", "great" },
            Title { "Your new framework !" },
            Title { "You can use components" },
            Box { "(with custom DSL)" }
                :style { color = "purple", bg = "violet" }
                :layout {
                    border = 1
                },
        }:style {
            color = "black",
            bg = "lavender"
        }:layout {
            width = "fill",
            gap = 1,
            padding = 2,
            border = 3
        }
end

vim.o.winbar = (WinBar():render())

end)
__bundle_register("esperv2.node", function(require, _LOADED, __bundle_register, __bundle_modules)
local inline_renderer = require("esperv2.inline_renderer")
local utils           = require("esperv2.utils")
---@class Node
---@field style function
---@field layout function
---@field render function
---@field renderer InlineRenderer
---@field children {}
---@field style_tbl Style
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

function Node:render()
    return self.renderer:render()
end

return Node

end)
__bundle_register("esperv2.utils", function(require, _LOADED, __bundle_register, __bundle_modules)
local M = {}

M.instanceof = function(object, class)
    if not object then return false end

    local mt = getmetatable(object)
    while mt do
        if mt.class_name == class then
            return true
        end

        mt = getmetatable(mt)
    end

    return false
end

M.is_object_empty = function(obj)
    for _, _ in pairs(obj) do
        return false
    end

    return true
end

M.has_property = function(obj, ...)
    if not obj then return false end

    for index, value in ipairs({ ... }) do
        if obj[value] then
            return true
        end
    end

    return false
end

M.T = function(get_base)
    return function(...)
        local base = get_base
        local output = {}

        for _, part in ipairs({ ... }) do
            output[#output + 1] = "%#" .. (part[2] or base) .. "#" .. part[1] .. "%#" .. base .. "#"
        end

        return table.concat(output, "")
    end
end

---@param str string
---@return integer
M.fnv1a = function(str)
    local hash = 2166136261
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        hash = (hash * 16777619) % 4294967296
    end
    return hash
end

M.serialize_style = function(style)
    local serialized = table.concat({ style.fg or "", style.bg or "", tostring(style.bold or ""), tostring(style.italic or
        ""), tostring(style.underline or "") })

    return serialized
end

M.object_get_keys = function(obj)
    local keys = {}

    for key, _ in pairs(obj) do
        table.insert(keys, key)
    end

    return keys
end

M.serialize_object = function(obj)
    local s = "{"

    local keys = M.object_get_keys(obj)
    -- sorting to prevent serialization differences because of arbitrary table order in lua
    table.sort(keys)

    for _, key in ipairs(keys) do
        if #s > 1 then s = s .. "," end
        s = s .. key .. ":" .. obj[key]
    end

    return s .. "}"
end

return M

end)
__bundle_register("esperv2.inline_renderer", function(require, _LOADED, __bundle_register, __bundle_modules)
local inline_stylizer = require("esperv2.inline_stylizer")

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
    local gap = self.node.layout_tbl.gap
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
    local _children = {}

    for index, child in ipairs(children) do
        local rendered_child

        if child.class_name == "Node" then
            child.parent = self.node
            rendered_child = child:render()
        elseif type(child) == "table" then
            print(vim.inspect(child))
            rendered_child = self:gap(self:parse_children(child))
        else
            rendered_child = child
        end

        table.insert(_children, rendered_child)
    end

    return _children
end

function InlineRenderer:render()
    local children = self:parse_children(self.node.children)

    -- inner
    local render = self:gap(children)
    -- outer
    render = self:pad(render)
    render = self:fit(render)
    render = self:border(render)
    render = self:corner(render)
    render = self.stylizer:stylize(render)
    return render
end

return InlineRenderer

end)
__bundle_register("esperv2.inline_stylizer", function(require, _LOADED, __bundle_register, __bundle_modules)
local utils = require("esperv2.utils")
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

end)
return __bundle_require("__root")