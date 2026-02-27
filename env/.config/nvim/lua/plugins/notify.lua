return {
    -- 'j-hui/fidget.nvim',
    -- config = function()
    --     local notify = require('fidget')
    --     notify.setup({
    --         notification = {
    --             override_vim_notify = false,
    --             window = {
    --                 border = "double",
    --                 align = "top",
    --             },
    --         },
    --     })
    -- end,
    "rcarriga/nvim-notify",
    enabled = true,
    lazy = false,
    config = function()
        local notify = require("notify")
        notify.setup({
            background_colour = "#000000"
        })
        vim.notify = require("notify")
    end,
    opts = {
        render = "compact",
        background_colour = "#000000"
    }
}
