local Commands = require "doro.commands"
local Extensions = require "doro.extensions"
local Pomo = require "doro.pomo"

---@class Doro
local Doro = {}

function Doro:new()
    local o = {
        current_state = "paused",
    }

    self.__index = self
    ---@class Doro
    local instance = setmetatable(o, self)
    instance.pomo = Pomo:new()
    instance.extensions = Extensions:get(instance)

    return instance
end

function Doro:setup()
    Commands:init()

    vim.keymap.set("n", "<leader>dd", function() self.pomo:start() end)
    vim.keymap.set("n", "<leader>dp", function() self.pomo.timer:pause() end)
    vim.keymap.set("n", "<leader>ds", function() self.pomo:skip() end)
    vim.keymap.set("n", "<leader>dS", function() self.pomo:stop() end)
    vim.keymap.set("n", "<leader>dc", function() self.pomo.timer:start() end)
end

local the_doro = Doro:new()
return the_doro
