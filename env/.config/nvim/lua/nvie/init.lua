local buf = vim.api.nvim_create_buf(false, true)
local win = vim.api.nvim_open_win(buf, false, {
    style = "minimal",
    relative = "editor",
    width = 40,
    height = 20,
    border = "single",
    bufpos = {40, 40},
    focusable = true,
})
