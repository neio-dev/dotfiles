local Dock = require("harbor.dock")
local Bay = require("harbor.bay")
local Commands = require("harbor.commands")
local Extensions = require("harbor.extensions")
local Ship = require("harbor.ship")
local SessionManager = require("harbor.sessions")
local Lighthouse = require("harbor.lighthouse")
local buffer = require("harbor.buffer")
require("harbor.types")

---@class Harbor
local Harbor = {}
Harbor.__index = Harbor
function Harbor:new()
    ---@class Harbor
    local instance = setmetatable({
        extensions = Extensions,
        active_ship = nil,
    }, self)

    instance.bay = Bay:new(instance)
    instance.dock = Dock:new(instance)
    instance.sessions = SessionManager:new(instance)
    instance.lighthouse = Lighthouse:new(instance)
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
    vim.keymap.set("n", "<C-t>", function() self.lighthouse:input() end)
    vim.keymap.set("n", "<leader>r", function() self:get_current_list():remove() end)
    vim.keymap.set("n", "<C-n>", function() self.dock:show(1) end)
    vim.keymap.set("n", "<C-e>", function() self.dock:show(2) end)
    vim.keymap.set("n", "<C-i>", function() self.dock:show(3) end)
    vim.keymap.set("n", "<C-o>", function() self.dock:show(4) end)
    vim.keymap.set("n", "<C-1>", function() self:get_current_list():show(1) end)
    vim.keymap.set("n", "<C-2>", function() self:get_current_list():show(2) end)
    vim.keymap.set("n", "<C-3>", function() self:get_current_list():show(3) end)
    vim.keymap.set("n", "<C-4>", function() self:get_current_list():show(4) end)
end

function Harbor:set_autocommands()
    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            local curr_buf = buffer:get_current()
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

---@return Dock|Bay|nil
function Harbor:get_current_list()
    if self.active_ship == nil then return end
    return self[self.active_ship.current_list]
end

function Harbor:setup(partial_config)
    self:set_autocommands()
    Commands:init(self)
    self.sessions:load()
end

return Harbor
