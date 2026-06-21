local text_renderer = require("esper.text_renderer")
local utils = require("esper.utils")
local cache = {}

local BuilderMaker = {}
BuilderMaker.__index = BuilderMaker
BuilderMaker.class_name = "Component"
local function resetG()
    _G.EsperDom = {}
    _G.EsperRenderCache = {}
end

resetG()

function BuilderMaker:new(children, renderer)
    local instance = setmetatable({
        _children = children,
        hit_cache = false,
        is_alive = false,
        computed_style = {},
    }, self)

    -- print(vim.inspect(debug.getinfo(3, "Sl")))
    instance["_hash"] = instance:hash_instance()
    instance.id = utils.fnv1a(utils.serialize_object(debug.getinfo(3, "Sl")) .. instance["_hash"])
    instance.renderer = renderer or text_renderer:new()
    _G.EsperDom = _G.EsperDom or {}
    _G.EsperDom[instance.id] = instance

    if self._children then
        for index, child in ipairs(self._children) do
            if utils.instanceof(child, "Component") then
                child.parent = self
            end
        end
    end

    return instance
end

local function hash_style()
    return ""
end

function BuilderMaker:style(style_tbl)
    self._style = style_tbl

    local style_hash = hash_style(style_tbl)
    if cache[style_hash] then
        self._style_hash = style_hash
    end

    self.computed_style = self.computed_style or {}

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

    vim.api.nvim_set_hl(0, self:get_hl_name(), self.computed_style)

    self._style = style_tbl

    return self
end

local function hash_layout(layout_tbl)
    return ""
end

function BuilderMaker:class(class)
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
---@return BuilderMaker
function BuilderMaker:layout(layout_tbl)
    local layout_hash = hash_layout(layout_tbl)

    if cache[layout_hash] then
        self._layout_hash = layout_hash
    else
        self._layout = layout_tbl
    end

    self.computed_layout = layout_tbl

    return self
end

function BuilderMaker:hash_instance()
    local hashed_instance = ""

    if self._children then
        for index, child in ipairs(self._children) do
            local hashed_child

            if utils.instanceof(child, "Component") then
                hashed_child = child:hash_instance()
            else
                hashed_child = utils.fnv1a(tostring(child))
            end

            hashed_instance = hashed_instance .. (hashed_child)
        end
    end

    return utils.fnv1a(hashed_instance)
end

function BuilderMaker:render(forced_renderer)
    _G.EsperRenderCache = _G.EsperRenderCache or {}

    if self._children then
        for index, child in ipairs(self._children) do
            if utils.instanceof(child, "Component") then
                child:render(forced_renderer or self.renderer)
                child.parent = self
            end
        end
    end

    self._alive = true

    if _G.EsperRenderCache[self.id] then
        self.hit_cache = true
        self._rendered = _G.EsperRenderCache[self.id]
        return self._rendered
    end

    local renderer = forced_renderer or self.renderer
    local render = renderer:render(self)
    self._rendered = render
    -- _G.EsperRenderCache[self.id] = render
    return render
end

function BuilderMaker:get_hl_name()
    if utils.is_object_empty(self.computed_style) then return nil end
    return "Esper" .. utils.fnv1a(utils.serialize_style(self.computed_style))
end

return BuilderMaker
