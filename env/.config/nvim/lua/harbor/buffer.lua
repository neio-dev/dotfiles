local buffer = {}

function buffer:get_current()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local type = vim.uv.fs_stat(name) ~= nil and vim.uv.fs_stat(name).type or nil
    local number = vim.fn.bufnr(buf)
    local row,col = unpack(vim.api.nvim_win_get_cursor(0))

    return {
        name = name,
        type = type,
        buf = buf,
        number = number,
        cursor = { row=row, col=col }
    }
end

return buffer
