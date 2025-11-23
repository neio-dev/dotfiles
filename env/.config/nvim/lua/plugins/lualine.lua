return {
   'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local harbor = require("harbor")
        local doro = require("doro")

        require('lualine').setup({
            theme = 'shine',
            tabline = {
                lualine_a = {
                    harbor.extensions.lualine,
                },
                lualine_c = {
                    doro.extensions.lualine,
                },
            },
        })
    end,
}
