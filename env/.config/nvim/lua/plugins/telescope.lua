return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    lazy = false,
    priority = 800,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'BurntSushi/ripgrep',
        "nvim-telescope/telescope-ui-select.nvim"
    },
    config = function()
        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                get_selection_window = function()
                    require("edgy").goto_main()
                    return 0
                end,
                file_ignore_patterns = {
                    "%:Zone%.Identifier$",
                    "node_modules",
                    "vendor/*",
                }
            },
            extensions = {
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
            },
            pickers = {
                colorscheme = { enable_preview = true }
            }
        })

        require("telescope").load_extension("ui-select")
    end,
}
