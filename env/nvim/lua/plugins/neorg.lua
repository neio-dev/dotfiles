return {
    "nvim-neorg/neorg",
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {},
                ["core.esupports.indent"] = {},
                ["core.keybinds"] = {
                    config = {
                        default_keybinds = false,
                    }
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                    }
                },
            }            
        }
        vim.keymap.set("n", "<leader> a", "<Plug>(neorg.pivot.list.toggle)", {})
    end,
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
}
