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
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == "filesystem"
                end,
                size = { width = 0.25 },
                pinned = true,
                open = "Neotree position=right filesystem",
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
