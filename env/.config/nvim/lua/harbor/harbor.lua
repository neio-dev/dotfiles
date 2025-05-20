local Dock = require("harbor.dock")
local Bay = require("harbor.bay")
local Commands = require("harbor.commands")
local Extensions = require("harbor.extensions")
local Ship = require("harbor.ship")
local SessionManager = require("harbor.sessions")
local buffer = require("harbor.buffer")
require("harbor.types")

---@class Harbrr
local Harbor = {}
Harbor.__index = Harbor
function Harbor:new()
    ---@class Harbor
    local instance = setmetatable({
        extensions = Extensions
    }, self)

    instance.bay = Bay:new(instance)
    instance.dock = Dock:new(instance)
    instance.sessions = SessionManager:new(instance)
    return instance
end

function Harbor:set_default_keybinds()
--    vim.keymap.set("n", "<leader>ha", function() self.dock:set() end)
--    vim.keymap.set("n", "<leader>hh", function() self.bay:cycle() end)
--    vim.keymap.set("n", "<leader>hr", function() self.dock:remove() end)
--    vim.keymap.set("n", "<leader>hn", function() self.dock:show(1) end)
--    vim.keymap.set("n", "<leader>he", function() self.dock:show(2) end)
--    vim.keymap.set("n", "<leader>hi", function() self.dock:show(3) end)
--    vim.keymap.set("n", "<leader>ho", function() self.dock:show(4) end)
--    vim.keymap.set("n", "<leader>h1", function() self.dock:show(1) end)
--    vim.keymap.set("n", "<leader>h2", function() self.dock:show(2) end)
--    vim.keymap.set("n", "<leader>h3", function() self.dock:show(3) end)
--    vim.keymap.set("n", "<leader>h4", function() self.dock:show(4) end)
    vim.keymap.set("n", "<leader>a", function() self.dock:set() end)
    vim.keymap.set("n", "<leader>hd", function() vim.cmd("HrbDev") end)
    vim.keymap.set("n", "<C-h>", function() self.bay:cycle() end)
    vim.keymap.set("n", "<leader>r", function() self.dock:remove() end)
    vim.keymap.set("n", "<leader>br", function() self.bay:remove() end)
    vim.keymap.set("n", "<C-n>", function() self.dock:show(1) end)
    vim.keymap.set("n", "<C-e>", function() self.dock:show(2) end)
    vim.keymap.set("n", "<C-i>", function() self.dock:show(3) end)
    vim.keymap.set("n", "<C-o>", function() self.dock:show(4) end)
    vim.keymap.set("n", "<C-1>", function() self.dock:show(1) end)
    vim.keymap.set("n", "<C-2>", function() self.dock:show(2) end)
    vim.keymap.set("n", "<C-3>", function() self.dock:show(3) end)
    vim.keymap.set("n", "<C-4>", function() self.dock:show(4) end)
end

function Harbor:set_autocommands()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local curr_buf = buffer:get_current()
            print("DEBUG CURR BUFF", curr_buf.type, curr_buf.name)
            if curr_buf.type ~= "file" then
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
    Commands:init(self)
    self.sessions:load()
end

return Harbor
