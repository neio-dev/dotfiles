return {
    'nvim-tree/nvim-tree.lua',
    opts = {
        auto_close = true,
        actions = {
            open_file = { quit_on_open = true },
        },
        update_focused_file = { enable = true, update_cwd = true },
        git = {
            enable = true,
            ignore = false,
            timeout = 500,
        },
        view = {
            relativenumber = true,
            --            float = { enable = true },
            number = true,
            side = "right",
        },
        renderer = {
            highlight_git = true,
            icons = {
                show = { git = true }
            }
        },
    },
    config = function(_, opts)
        local previous_on_attach = opts.on_attach or function() end
        --        opts.on_attach =  function(bufnr)
        --            previous_on_attach(bufnr)
        --            local api = require('nvim-tree.api')
        --
        --            vim.keymap.set('n', '<Esc>', api.tree.close, { buffer = bufnr})
        --            vim.keymap.set('n', 'q', api.tree.close, { buffer = bufnr})
        --       end
        local function custom_on_attach(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.del("n", "e", { buffer = bufnr })
        end
        opts.on_attach = custom_on_attach
        require('nvim-tree').setup(opts)
    end,
}
