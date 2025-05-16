return {
    dir = "~/.config/nvim/lua/harbor",
    name = "harbor",
    config = function()
        local harbor = require("harbor")
        local Ship = require("harbor.ship")
        print("Dock", #harbor.dock:get())
        print("Bay", #harbor.bay:get())

        local to_print = ""
        for i,v in ipairs(harbor.dock:get()) do
            local val = v.value ~= nil and v.value or "empty"
            to_print = to_print .. val  .. ", "
        end
        print("Dock", "[", to_print, "]")

        local to_print_2 = ""
        for i,v in ipairs(harbor.bay:get()) do
            local val = v.value ~= nil and v.value or "empty"
            to_print_2 = to_print_2 .. val  .. ", "
        end
        print("Bay", "[", to_print_2, "]")
        harbor:setup()
        harbor.dock:set(Ship:new("/home/dev/.config/nvim/lua/harbor/init.lua"))
        harbor.dock:set(Ship:new("/home/dev/.config/nvim/lua/harbor/fleet.lua"))
        harbor.dock:set(Ship:new("/home/dev/.config/nvim/lua/harbor/commands.lua"))
        harbor:set_default_keybinds()
        print("formatted name", harbor.dock:get()[1]:format_name())
        -- vim.keymap.set("n", "<leader>hh", function() harpoon:list("__harpoon_temp"):show(1) end)
        -- vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harbor.dock) end)
    end,
}
