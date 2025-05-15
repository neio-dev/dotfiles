return {
    'theprimeagen/harpoon',
    branch = "harpoon2",
    -- commit = "bfd649328a7effe4b7c311d39e97059d31144632",
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup({
            config = {
                get_root_dir = vim.fn.getcwd(),
            },
        })
        local harpoon_extensions = require("harpoon.extensions")
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
        harpoon:extend(harpoon_extensions.builtins.navigate_with_number())
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-x>n", function()
            table.remove(harpoon:list().items, 1)
        end)
        vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-x>e", function()
            table.remove(harpoon:list().items, 2)
        end)
        vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-x>i", function()
            table.remove(harpoon:list().items, 3)
        end)
        vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<C-x>o", function()
            table.remove(harpoon:list().items, 4)
        end)
        vim.keymap.set("n", "<C-h>", function() harpoon:list("__harpoon_temp"):select(1) end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        harpoon:sync()
    end,
}
