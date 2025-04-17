vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
-- vim.g.nvim_tree_respect_buf_cwd = 1
require("config.lazy")
require("neio")
require("nvim-tree").setup({
    view = { float = { enable = true, quit_on_focus_loss = true } },
    update_focused_file = { enable = true, update_cwd = true },
})
