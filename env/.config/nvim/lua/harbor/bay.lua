local Fleet = require("harbor.fleet")

---@class Bay
---@field split_id? number
local Bay = setmetatable({}, { __index = Fleet })
Bay.__index = Bay

---@param harbor Harbor
---@return Bay
function Bay:new(harbor)
    ---@class Bay
    local instance = Fleet.new(self, harbor, "Bay", 3, RESOLVE.prepend)
    instance.split_id = nil
    return instance
end

function Bay:set(ship, index)
    -- vim.cmd("vsplit")
    self:show_split()
    Fleet.set(self, ship, index)
end

function Bay:show_split()
    local saved_split_id = self.split_id
    print('current save id', saved_split_id)
    local current_win_id = vim.api.nvim_get_current_win()
    if saved_split_id == nil or vim.api.nvim_win_is_valid(saved_split_id) == false then
        vim.cmd("topleft vsplit")
        self.split_id = vim.api.nvim_get_current_win()
        print('new save id', current_win_id)
    elseif current_win_id ~= saved_split_id then
        vim.api.nvim_set_current_win(saved_split_id)
    end
end

function Bay:close_split()
    if self.split_id ~= nil and vim.api.nvim_win_is_valid(self.split_id) then
        vim.api.nvim_win_close(self.split_id, false)
    end
end

function Bay:show(index)
    -- vim.cmd("vsplit")
    self:show_split()
    Fleet.show(self, index)
end

return Bay
