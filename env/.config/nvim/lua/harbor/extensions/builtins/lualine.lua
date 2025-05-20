local Extension = require("harbor.extensions.extension")
local buffer = require("harbor.buffer")

local harbor_lualine = Extension:new("lualine")
harbor_lualine.__index = harbor_lualine

local function get_active_highlight(invert)
    invert = invert == nil and false or invert
    local hl_name = "HarborLualineActiveGroup"
    local mode = vim.fn.mode()
    local mode_map = {
        n = "normal",
        i = "insert",
        v = "visual",
        V = "visual",
        [""] = "visual", -- Visual block
        c = "command",
        R = "replace",
        t = "terminal",
    }

    local hl_group = "lualine_a_" .. (mode_map[mode] or "normal")
    local bg = vim.api.nvim_get_hl(0, { name = hl_group }).bg
    local fg = vim.api.nvim_get_hl(0, { name = hl_group }).fg
    vim.api.nvim_set_hl(0, hl_name, {
        fg = invert and bg or fg,
        bg = invert and fg or bg,
        bold = true,
        standout = true,
        underdotted = true,
        special = "",
    })

    return { hl_name, hl_group }
end

local function get_git_status(ship)
    local git_status = vim.fn.system("git status --porcelain " .. ship.value)
    local prefix = ""
    if (#git_status > 0 and (#git_status < (#ship:format_name() + 7))) then
        local split = string.match(git_status, "%S+")

        prefix = split and ("(" .. split .. ") ") or ""
    end

    return prefix
end

local function get_diagnostic(name)
    local prefix = ""
    local buf = name and buffer:get(name) or nil
    if buf == nil then return "" end
    local bufnr = buf.number
    print("DEBUG BUF", buf, bufnr, buf.name)
    if bufnr ~= -1 then
        local diagnostics = vim.diagnostic.get(bufnr)
        local severity = 0

        for _, diag in ipairs(diagnostics) do
            severity = tonumber(diag.severity) > severity and tonumber(diag.severity) or severity
        end

        if severity ~= nil then
            if severity == vim.diagnostic.severity.ERROR then prefix = " " end
            if severity == vim.diagnostic.severity.WARN then prefix = " " end
            if severity == vim.diagnostic.severity.INFO then prefix = " " end
            if severity == vim.diagnostic.severity.HINT then prefix = " " end
        end
    end
    return prefix
end

local function pretty_name(ship, is_active, opt)
    opt = opt or {}
    local hl = get_active_highlight(opt.invert)
    local name = get_diagnostic(ship.value) .. (ship.value and ship:format_name() or "x")
    -- name = get_git_status(ship) .. name

    if is_active then
        name = "%#" .. hl[opt.invert and 2 or 1] .. "#[  " .. name .. "]%#" .. hl[opt.invert and 1 or 2] .. "#"
    end

    return name
end

local function get_fleet(name, fleet, opt)
    local line = name .. " "
    opt = opt or {}
    local curr_buf = buffer:get_current()
    local invert = opt.invert == nil and false or opt.invert

    for index, ship in ipairs(fleet) do
        local is_active = ship.value and curr_buf.name == ship.value
        line = line .. " "

        if opt.show_index then
            line = line .. index .. " "
        end

        line = line .. pretty_name(ship, is_active, opt) .. (index ~= #fleet and " | " or "")
    end
    return "%#" ..
        get_active_highlight()[invert and 1 or 2] ..
        "#" .. line .. "%#" .. get_active_highlight(false)[invert and 1 or 2] .. "#"
end

function harbor_lualine:setup()
    local ext = function()
        local harbor = require("harbor")
        local bay_fleet = get_fleet(": ", harbor.bay:get(), { invert = true })
        local dock_fleet = get_fleet(": ", harbor.dock:get(), { show_index = true, invert = false })
        return bay_fleet .. " ||| " .. dock_fleet
    end

    return ext
end

return harbor_lualine
