return {
    'nvim-lualine/lualine.nvim',
    enabled = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    priority = 1000,
    config = function()
        local harbor = require("harbor")
        local doro = require("doro")

        require('lualine').setup({
            options = {
                globalstatus = true,
                -- component_separators = { left = '', right = '' },
                -- section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                theme = "auto",
                icons_enabled = true,
                padding = 1,
            },
            tabline = {
                lualine_a = {
                    harbor.extensions.lualine,
                },
                lualine_c = {
                    doro.extensions.lualine,
                },
            },
            sections = {
                lualine_a = {
                    doro.extensions.lualine,
                    "mode",
                },
                lualine_c = {
                    { "filename", path = 2 }
                },
            }
        })
    end,
}
