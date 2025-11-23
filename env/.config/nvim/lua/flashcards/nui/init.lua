local progress = require "flashcards.nui.progress"
local api = vim.api
local M = {}

local function str_sub(str, i, j)
    local length = vim.str_utfindex(str)
    if i < 0 then i = i + length + 1 end
    if (j and j < 0) then j = j + length + 1 end
    local u = (i > 0) and i or 1
    local v = (j and j <= length) and j or length
    if (u > v) then return "" end
    local s = vim.str_byteindex(str, u - 1)
    local e = vim.str_byteindex(str, v)
    return str:sub(s + 1, e)
end

local function merge_tables(_table, second)
    for _, v in ipairs(second) do
        table.insert(_table, v)
    end
end


function M:new()
    self.__index = self
    local instance = setmetatable({}, self)
    return instance
end

local buf = -1
local win = -1

local function open_buffer()
    buf = api.nvim_create_buf(false, true)
    api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    api.nvim_set_option_value("modifiable", true, { buf = buf })
end

local function hl(str, count, skip)
    if not skip then
        count = count - vim.fn.strchars(str)
    end

    count = count / 2
    return string.rep(" ", count) .. str .. string.rep(" ", count)
end

local subjects = {
    { subject = "Vietnamese - Clothing",  nbr = 22, progress = 19 },
    { subject = "Vietnamese - Colors",    nbr = 12, progress = 39 },
    { subject = "Vietnamese - Greetings", nbr = 82, progress = 79 },
    { subject = "Vietnamese - Test",      nbr = 2,  progress = 100 },
}

local function get_remaining_width(width, curr)
    local total = width
    for _, value in ipairs(curr) do
        total = total - vim.fn.strchars(value)
    end

    return total
end

local function map_default(base, dict)
    local temp = {}
    local length = vim.fn.strchars(base)
    for i = 1, length, 1 do
        local sym = dict.default or "─"
        if i == 1 then
            sym = dict.start or "│"
        elseif i == length then
            sym = dict.last or "│"
        elseif str_sub(base, i, i) == "│" then
            sym = dict.inter or "│"
        end

        temp[i] = sym
    end

    return table.concat(temp, "")
end

local function get_table_head(opts, _table)
    local head = {}
    local full_columns = {}
    local columns = opts.columns
    local title_row = { "│" }

    for index, col in ipairs(columns) do
        local title = { "", col.label or col.property, "" }

        if col.size ~= "fit" then
            table.insert(full_columns, index)
        end

        -- TODO If odd, add one more space
        table.insert(title_row, table.concat(title,
            col.size == "fit" and "  " or ""
        ))

        if index ~= #columns then
            table.insert(title_row, "│")
        end
    end

    table.insert(title_row, "│")

    local remainingWidth = get_remaining_width(opts.width, title_row)
    for _, value in ipairs(full_columns) do
        local eachWidth = remainingWidth / #full_columns
        title_row[value * 2] = title_row[value * 2] .. string.rep(" ", eachWidth)
    end

    for index, col in ipairs(opts.columns) do
        local col_index = index * 2
        opts.columns[index].width = vim.fn.strchars(title_row[col_index])
    end

    local str_title_row = table.concat(title_row, "")

    local top = map_default(str_title_row, {
        start = "┌",
        last = "┐",
        inter = "┬",
    })

    local bottom = map_default(str_title_row, {
        start = "├",
        last = "┤",
        inter = "┼",
    })

    local finish = map_default(str_title_row, {
        start = "└",
        last = "┘",
        inter = "┴",
    })

    local divider = map_default(str_title_row, {
        default = "-",
    })

    local empty = map_default(str_title_row, {
        default = " ",
    })

    table.insert(head, top)
    table.insert(head, str_title_row)
    table.insert(head, bottom)
    -- start adding --
    for index, tableRow in ipairs(_table) do
        local value_row = { "│" }
        for colIndex, col in ipairs(opts.columns) do
            local foundColumn = nil

            for colName, colValue in pairs(tableRow) do
                if colName == col.property then
                    foundColumn = colValue
                end
            end
            local used_value = col.format and col.format(foundColumn, col.width) or foundColumn
            table.insert(value_row, used_value .. string.rep(" ", col.width - vim.fn.strchars(used_value)))
            table.insert(value_row, "│")
        end
        table.insert(head, table.concat(value_row, ""))
        if index ~= #tableRow then
            table.insert(head, divider)
        end
    end
    table.insert(head, empty)
    -- stop adding --
    table.insert(head, finish)
    print(vim.inspect(opts.columns))
    return head
end

local function prettyTable(_table, opts)
    local lines = {}

    merge_tables(lines, get_table_head(opts, _table))

    return lines
end

function M:create(label)
    local gwidth = api.nvim_list_uis()[1].width
    local gheight = api.nvim_list_uis()[1].height
    local lines = {
        '',
        hl('┌───────┐', 61),
        hl('│ TRIKY │', 61),
        hl('└───────┘', 61),
        '',
    }

    local table_opts = {
        width = 61,
        columns = {
            {
                property = "subject",
                label = "Subject",
            },
            {
                property = "nbr",
                label = "#",
                size = "fit"
            },
            {
                property = "progress",
                label = "Progress",
                size = "fit",
                format = function(value, width)
                    return progress.print(value, { width = width })
                end,
            },
        }
    }

    merge_tables(lines, prettyTable(subjects, table_opts))
    merge_tables(lines, {
        hl("", 61),
        hl("(b) select - (x) delete", 61),
        hl("", 61),
    })

    local height = #lines
    local width = vim.fn.strchars(lines[8])
    local win_opts = {
        relative = "editor",
        style = "minimal",
        border = "single",
        height = height,
        width = width,
        row = (gheight - height) * 0.5,
        col = (gwidth - width) * 0.5,
    }

    open_buffer()

    win = api.nvim_open_win(buf, true, win_opts)
    api.nvim_set_option_value("cursorline", false, { win = win })
    api.nvim_set_option_value("winhl", "Normal:Question", { win = win })

    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    api.nvim_set_option_value("modifiable", false, { buf = buf })
end

local instance = M:new()

return instance
