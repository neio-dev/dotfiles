return {
    'rcarriga/nvim-notify',
    config = function()
        local notify = require('notify')
        notify.setup({
            background_colour = "#000000",
            render = "compact",
            timeout = 2500,
        })
        vim.notify = notify
    end,
}
