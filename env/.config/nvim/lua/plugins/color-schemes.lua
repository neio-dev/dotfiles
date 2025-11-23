return {
    { "folke/tokyonight.nvim" },
    { "eldritch-theme/eldritch.nvim" },
    { "projekt0n/github-nvim-theme" },
    { "yorik1984/newpaper.nvim" },
    { "nyoom-engineering/oxocarbon.nvim" },
    { 'aliqyan-21/darkvoid.nvim' },
    { 'wnkz/monoglow.nvim' },
    {
        "jesseleite/nvim-noirbuddy",
        dependencies = { "tjdevries/colorbuddy.nvim" },
        lazy = false,
        priority = 1000,
        opts = {
            colors = {
                primary = "#A3BE8C",
            },
            styles = {
                italic = true,
                bold = true,
                underline = true,
                undercurl = true,
            }
        },
    },
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
