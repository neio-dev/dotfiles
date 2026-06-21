local theme = "lume"

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('highlight_on_yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank {
            higroup = 'IncSearch',
            timeout = 150,
            on_macro = true
        }
    end
})


--pcall(vim.cmd, "colorscheme github_dark_default")
--pcall(vim.cmd, "colorscheme neo64")
-- pcall(vim.cmd, "colorscheme catppuccin-intellijdark")
-- vim.cmd "colorscheme catppuccin-latte"
-- vim.o.background = "dark"
vim.cmd("colorscheme " .. theme)
-- Noirbuddy
--local Group = require("colorbuddy").Group
--local colors = require("colorbuddy").colors
--local styles = require("colorbuddy").styles


--Group.new("lualine_a_normal", colors.primary or colors.secondary, colors.noir_9)
--Group.new("HarborLualineActiveGroup", colors.noir_9, colors.secondary, styles.bold)
