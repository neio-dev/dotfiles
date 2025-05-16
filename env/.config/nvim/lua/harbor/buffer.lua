local buffer = {}

function buffer:get_current()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local buftype = vim.bo[buf].buftype
    local number = vim.fn.bufnr(buf)

    return {
        name = name,
        type = buftype,
        buf = buf,
        number = number,
    }
end

return buffer
