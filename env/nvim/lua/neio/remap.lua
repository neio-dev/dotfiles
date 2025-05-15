vim.g.mapleader = " "
vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader><tab>", [[<C-^>]] )
vim.keymap.set('t','<Esc>', [[<C-\><C-n>]])

-- Telescope remap
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files)
vim.keymap.set('n', '<C-p>', builtin.git_files)
vim.keymap.set('n', '<leader>ps', builtin.live_grep)

-- Harpoon remap
-- local mark = require("harpoon.mark")
-- local ui = require("harpoon.ui")

--vim.keymap.set('n', '<leader>a', mark.add_file)
--vim.keymap.set('n', '<C-k>', ui.toggle_quick_menu)
--vim.keymap.set('n', '<C-n>', function() ui.nav_file(1) end)
--vim.keymap.set('n', '<C-e>', function() ui.nav_file(2) end)
--vim.keymap.set('n', '<C-i>', function() ui.nav_file(3) end)
--vim.keymap.set('n', '<C-o>', function() ui.nav_file(4) end)

-- Undotree remap
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
-- Multiline remap

