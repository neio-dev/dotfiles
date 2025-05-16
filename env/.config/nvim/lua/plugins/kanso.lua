return {
    -- test du theme
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require('kanso').setup {
            theme = 'pearl'
        }
    end,
}
