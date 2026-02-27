vim.g.mapleader = " "
vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<leader><tab>", [[<C-^>]])
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>w', "<cmd>w<cr><esc>")
vim.keymap.set('n', '<leader>m', function() vim.cmd("source %") end)
vim.keymap.set("n", "<leader><leader>a", "<Plug>PlenaryBustedFile", {})
-- color scheme reload

vim.keymap.set('n', '<leader>j', function()
    print("reloaded neo64")
    package.loaded["neo64"] = nil
    require("neo64").setup()
end)

-- Fzf remap
local fzf = require("fzf-lua")
vim.keymap.set('n', '<leader>f', function()
    return fzf.files({
        cmd = "fd . --type f --hidden --exclude node_modules --exclude vendor --exclude .git"
    })
end)

vim.keymap.set({ "n", "t" }, "<C-r>",
    function()
        local result = vim.treesitter.get_captures_at_cursor(0)
        print(vim.inspect(result))
    end,
    { noremap = true, silent = false }
)

-- Telescope remap
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>s', "<cmd>Outline<CR>")
vim.keymap.set('n', '<leader>S', builtin.lsp_workspace_symbols)

-- zen mode
local zen = require("zen-mode")
vim.keymap.set('n', '<leader>z', zen.toggle)

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
-- vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
-- Multiline remap
