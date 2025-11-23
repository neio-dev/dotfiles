local Timer = require("doro.timer")
---
---@class Pomo
---@field timer Timer
---@field times table
---@field flow table
---@field current integer
local Pomo = {}

Pomo.W = "work"
Pomo.S = "short"
Pomo.L = "long"

function Pomo:new()
    self.__index = self
    ---@class Pomo
    local instance = setmetatable({}, self)
    instance.times = {
        [self.W] = 25 * 60,
        [self.L] = 10 * 60,
        [self.S] = 5 * 60,
    }
    instance.flow = { self.W, self.S, self.W, self.S, self.W, self.S, self.W, self.L }
    instance.current = nil
    instance.timer = Timer:new()
    return instance
end

function Pomo:start()
    self:next()
end

function Pomo:stop()
    self.timer:stop()
    self.current = nil
    self:notify("Pomo stopped")
end

function Pomo:skip()
    self.timer:stop()
    self:next()
end

function Pomo:get_notification_message()
    if self:get_current_type() == self.L then
        return "⏹️ Starting long break"
    end

    if self:get_current_type() == self.S then
        return "⌛ Starting short break"
    end

    return "💻 Starting work period"
end

function Pomo:next()
    local next = self.current and (self.current + 1) or 1

    if next > #self.flow then
        next = 1
    end

    self.timer:start(
        self.times[self.flow[next]],
        function()
            self:next()
        end
    )

    self.current = next
    self:flash_colors()
    self:notify(self:get_notification_message())
end

function Pomo:notify(text)
    self.notification = require("notify")(
        text,
        self:get_current_type() == self.W and "info" or "error",
        {
            title = "DORO",
            replace = self.notification,
            on_close = function() self.notification = nil end,
        }
    )
end

function Pomo:flash_colors()
    vim.schedule(function()
        local original = self.original_hl or vim.api.nvim_get_hl(0, { name = "Normal" })
        self.original_hl = original
        vim.api.nvim_set_hl(0, "Normal", original)
        local insert_hl = vim.api.nvim_get_hl(0, { name = "Info" })
        local flash = insert_hl
        if self:get_current_type() == self.L then
            flash = vim.api.nvim_get_hl(0, { name = "Error" })
        elseif self:get_current_type() == self.S then
            flash = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })
        end

        vim.api.nvim_set_hl(0, "Normal", flash)

        vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "Normal", original)
            vim.defer_fn(function()
                vim.api.nvim_set_hl(0, "Normal", flash)
                vim.defer_fn(function()
                    vim.api.nvim_set_hl(0, "Normal", original)
                end, 300)
            end, 300)
        end, 300)
    end)
end

function Pomo:get_current_type()
    return self.current and self.flow[self.current]
end

return Pomo
