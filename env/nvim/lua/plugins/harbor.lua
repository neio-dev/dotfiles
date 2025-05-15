return {
    dir = "~/.config/nvim/lua/harbor",
    name = "harbor",
    config = function()
        local harbor = require("harbor")
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

        harbor.setup({})

        vim.keymap.set("n", "<leader>ha", function() harbor.dock:add() end)
        vim.keymap.set("n", "<leader>hn", function() harbor.dock:show(1) end)
        vim.keymap.set("n", "<leader>he", function() harbor.dock:show(2) end)
        vim.keymap.set("n", "<leader>hi", function() harbor.dock:show(3) end)
        vim.keymap.set("n", "<leader>ho", function() harbor.dock:show(4) end)
        -- vim.keymap.set("n", "<leader>hh", function() harpoon:list("__harpoon_temp"):show(1) end)
        -- vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harbor.dock) end)
    end,
}
