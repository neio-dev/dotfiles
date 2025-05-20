---@class Ship
local Ship = {}

Ship.__index = Ship

---@param name string
---@param cursor_position? CursorPosition 
---@param current_list? PossibleList 
function Ship:new(name, cursor_position, current_list)
    local ship = setmetatable({
        value = name,
        position = cursor_position or { col = 0, row = 1},
        current_list = current_list
    }, self)
    return ship
end

function Ship:format_name()
   return self.value:match("([^/]+)$")
end

function Ship:update_cursor()
    local row, col = unpack(vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win()))

    self.position.row = row
    self.position.col = col
end

return Ship
