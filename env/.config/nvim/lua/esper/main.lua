for name, _ in pairs(package.loaded) do
    if name:match("^esper") then
        package.loaded[name] = nil
    end
end

local WinBar     = require "esper.components.WinBar"
local TabLine    = require "esper.components.TabLine"
local StatusLine = require "esper.components.StatusLine"

function render(component)
    return component:render()
end

require("lualine").hide()
vim.o.statusline = render(StatusLine())
vim.o.tabline = render(TabLine())
vim.o.winbar = render(WinBar())

-- testing purpose
--if not _G.esper_test_win or not vim.api.nvim_win_is_valid(_G.esper_test_win) then
--    local buf = vim.api.nvim_create_buf(false, true)
--    _G.esper_test_win = vim.api.nvim_open_win(buf, false, { split = "right" })
--else
--    local buf = vim.api.nvim_win_get_buf(_G.esper_test_win)
--end
