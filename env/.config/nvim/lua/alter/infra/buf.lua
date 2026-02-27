---@class Buf
local M = {}

---@return Buf
function M:new()
    self.__index = self
    local instance = setmetatable({}, self)

    return instance
end

---Show Diff
function M:show()
end

---Hide Diff
function M:hide()
end

function M:get_current()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)

    return self:get(name)
end

---@param name string
function M:get(name)
    local buf = vim.fn.bufnr(name)
    local type = vim.uv.fs_stat(name) ~= nil and vim.uv.fs_stat(name).type or nil
    local number = vim.fn.bufnr(buf)
    local row, col = table.unpack(vim.api.nvim_win_get_cursor(0))

    return {
        name = name,
        type = type,
        buf = buf,
        number = number,
        cursor = vim.api.nvim_win_get_cursor(0)
    }
end

return M
