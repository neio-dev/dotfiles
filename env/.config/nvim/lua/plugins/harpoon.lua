return {
	'theprimeagen/harpoon',
    branch = "harpoon2",
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup {
            
        }
        local harpoon_extensions = require("harpoon.extensions")
        harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
        harpoon:extend(harpoon_extensions.builtins.navigate_with_number())
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
        vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    end,
}
