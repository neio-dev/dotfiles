return {
    "y2w8/neolij.nvim",
    opts = {},
    keys = {
        { "<leader><leader>n", ":NeolijLeftTab<CR>",  mode = { "n", "t" }, desc = "Move left",  silent = true },
        { "<leader><leader>e", ":NeolijUp<CR>",       mode = { "n", "t" }, desc = "Move up",    silent = true },
        { "<leader><leader>i", ":NeolijDown<CR>",     mode = { "n", "t" }, desc = "Move down",  silent = true },
        { "<leader><leader>o", ":NeolijRightTab<CR>", mode = { "n", "t" }, desc = "Move right", silent = true },
    },
}
