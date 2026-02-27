local common_opts = {
    transparent = false,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
    }
}

return {
    {
        "folke/tokyonight.nvim",
        opts = common_opts,
    },
    { "eldritch-theme/eldritch.nvim" },
    {
        "projekt0n/github-nvim-theme",
        config = function()
            require("github-theme").setup({
                options = common_opts
            })
        end,
    },
    { "yorik1984/newpaper.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { 'aliqyan-21/darkvoid.nvim' },
    {
        'wnkz/monoglow.nvim',
        opts = common_opts,
    },
    { 'owickstrom/vim-colors-paramount' },
    {
        'datsfilipe/vesper.nvim',
        opts = common_opts,
    },
    {
        -- test du theme
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('kanso').setup {
                theme = 'pearl'
            }
        end,
    },
    --   {
    --       "jesseleite/nvim-noirbuddy",
    --       dependencies = { "tjdevries/colorbuddy.nvim" },
    --       lazy = false,
    --       priority = 1000,
    --       opts = {
    --           colors = {
    --               primary = "#A3BE8C",
    --           },
    --           styles = {
    --               italic = true,
    --               bold = true,
    --               underline = true,
    --               undercurl = true,
    --           }
    --       },
    --   },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup {
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                terminalColors = true,
            }
        end
    },
}
