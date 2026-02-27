vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
        vim.keymap.set("n", "bR", require("ufo").openAllFolds)
        vim.keymap.set("n", "bM", require("ufo").closeAllFolds)

        require("ufo").setup({})
    end,
}
