return {
    "mg979/vim-visual-multi",
    lazy=false,
    init = function()
        vim.g.VM_default_mappings = 0
        vim.g.VM_mouse_mappings = 0
  vim.g.VM_maps = {
    ['Find Under'] = 'du',
    ['Find Subword Under'] = '<leader>ih',
    ['Add Cursor Down'] = '<leader>in',
    ['Add Cursor Up'] = '<leader>ie',
    ['Next'] = 'h',
    ['Prev'] = 'H',
  }
    end,
}
