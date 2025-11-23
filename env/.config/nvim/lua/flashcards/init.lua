local nui = require("flashcards.nui")

local M = {}

function M:new()
    self.__index = self

    local instance = setmetatable({}, self)
    return instance
end

function M:setup()
    vim.api.nvim_create_user_command("T", function()
        nui:create("Test")
    end, {})
end

return M
