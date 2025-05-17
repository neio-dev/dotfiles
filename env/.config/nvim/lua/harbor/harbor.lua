local Dock = require("harbor.dock")
local Bay = require("harbor.bay")
local Commands = require("harbor.commands")
local Extensions = require("harbor.extensions")
local Ship = require("harbor.ship")
local SessionManager = require("harbor.sessions")
local buffer = require("harbor.buffer")
require("harbor.types")

---@class Harbor
local Harbor = {}
Harbor.__index = Harbor
function Harbor:new()
    ---@class Harbor
    local instance = setmetatable({
        bay = Bay:new(),
        extensions = Extensions
    }, self)

    instance.dock = Dock:new(instance)
    instance.sessions = SessionManager:new(instance)
    return instance
end

function Harbor:set_default_keybinds()
    vim.keymap.set("n", "<leader>ha", function() self.dock:set() end)
    vim.keymap.set("n", "<leader>hh", function() self.bay:cycle() end)
    vim.keymap.set("n", "<leader>hn", function() self.dock:show(1) end)
    vim.keymap.set("n", "<leader>he", function() self.dock:show(2) end)
    vim.keymap.set("n", "<leader>hi", function() self.dock:show(3) end)
    vim.keymap.set("n", "<leader>ho", function() self.dock:show(4) end)
    vim.keymap.set("n", "<leader>h1", function() self.dock:show(1) end)
    vim.keymap.set("n", "<leader>h2", function() self.dock:show(2) end)
    vim.keymap.set("n", "<leader>h3", function() self.dock:show(3) end)
    vim.keymap.set("n", "<leader>h4", function() self.dock:show(4) end)
end

function Harbor:set_autocommands()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local curr_buf = buffer:get_current()
            print("debug init nvim", curr_buf.name, curr_buf.type)
            if curr_buf.name == "" or curr_buf.type ~= "" then
                return
            end

            local main_list = self.dock
            local temp_list = self.bay
            local is_present = main_list:get_ship_index(curr_buf.name) or temp_list:get_ship_index(curr_buf.name)
            if is_present ~= nil then
                return
            end

            temp_list:set(Ship:new(curr_buf.name))
        end
    })
end

function Harbor:setup(partial_config)
    self:set_autocommands()
    Commands:init()
end

return Harbor
