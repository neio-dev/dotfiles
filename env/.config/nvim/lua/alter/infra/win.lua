local enum = require "alter.enum"

---@class Win
local M = {}

local function create_win(title, opts)
    local current_win = vim.schedule(function()
        return vim.api.nvim_get_current_win()
    end)


    -- scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    local ns = vim.api.nvim_create_namespace(enum.NAMESPACE)

    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
        virt_lines = { { { title, "Comment" } } },
        virt_lines_above = true,
    })


    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {  "" })

    local win = vim.api.nvim_open_win(buf, true, opts)
    return { win = win, buf = buf }
end

---@return Win
function M:new(title, opts)
    self.__index = self
    local instance = setmetatable({}, self)
    instance.nvim_win = create_win(title, opts)

    return instance
end

---Show Diff
function M:show()
end

---Hide Diff
function M:hide()
end

return M
