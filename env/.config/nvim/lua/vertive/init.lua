local ns = vim.api.nvim_create_namespace("vertive")

local interval = 5
local max_columns = 15
local fade_steps = 3

local base_color = "#5f87ff"
for i = 1, fade_steps do
    local fade = 100 + (i - 1) * 30
    vim.api.nvim_set_hl(0, "ColumnGuide" .. i, { fg = base_color })
end

local function update_columns()
    local buf = 0
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    local lines = vim.api.nvim_buf_line_count(buf)
    for i = 1, lines do
        local line_content = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)
        print(vim.inspect(line_content))
        if #line_content == 0 or #(line_content[1]) == 0 then
            break
        end
        for c = interval, #line_content[1], interval do
            local dist = math.abs(c - (col + 1))
            local fade_index = math.min(math.floor(dist / interval) + 1, fade_steps)
            local hl_group = "ColumnGuide"..fade_index
            vim.api.nvim_buf_set_extmark(buf, ns, i - 1, c - 1, {
               virt_text = { { "|", hl_group } },
               virt_text_pos = "overlay",
               priority = 10,
            })
        end
    end
end

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    callback = update_columns,
})
