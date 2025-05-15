local function use_scheme(plugin)
    return function()
            vim.cmd.colorscheme(plugin)
            require(plugin).setup({
                lazy = false,
                priority = 1000,
            })
        end
end

return {
    { "folke/tokyonight.nvim" },
    { "eldritch-theme/eldritch.nvim", config=use_scheme('eldritch') },
}
