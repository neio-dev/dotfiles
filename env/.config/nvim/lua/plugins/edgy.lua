return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.opt.laststatus = 3
        vim.opt.splitkeep = "topline"
    end,
    opts = {
        animate = { enabled = false },
        right = {
            {
                title = "Explorer",
                ft = "NvimTree",
                size = { height = 0.5 },
                pinned = true,
                open = "NvimTreeOpen"
            },
            {
                title = "Symbols",
                ft = "Outline",
                size = { height = 0.5 },
                pinned = true,
            },
        }
    },
}
