return {
    "heavenshell/vim-jsdoc",
    ft = { "javascript", "typescript" },
    build = "make install",
    config = function()
        vim.g.jsdoc_enable_es6 = 1
        vim.g.jsdoc_input_description = 1
    end,
}
