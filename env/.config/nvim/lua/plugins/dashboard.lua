  return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup({
            theme = 'hyper',
            shortcut_type = 'letter',
            description = "test"
        })
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function()
        print(#vim.fn.getbufinfo({ buflisted = 1}))
        if #vim.fn.getbufinfo({ buflisted = 1 }) == 1 then
            vim.cmd.Dashboard()
        end
    end,
})


    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'} }
} 
