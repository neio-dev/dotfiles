local M = {}

local function reload(module_name)
    package.loaded[module_name] = nil

    return require(module_name)
end

local function get_highlights()
    local colors = reload("neo64.colors")
    local base_hl = {
        Normal = { fg = colors.white, bg = colors.bg },
        Folded = { fg = colors.fg, bg = colors.mg },
        NormalNC = { fg = colors.fg, bg = colors.bg },
        NormalFloat = { fg = colors.fg, bg = colors.bg },
        EndOfBuffer = { fg = colors.fg, bg = colors.bg },

        Visual = { fg = colors.bg, bg = colors.white },
        Terminal = { fg = colors.green, bg = colors.red },

        Comment = { fg = colors.red, italic = true },
        Keyword = { fg = colors.purple, bold = true },
        String = { fg = colors.lightgreen },
        Number = { fg = colors.fg },
        Variable = { fg = colors.white },
        LineNr = { fg = colors.bg, bg = colors.fg },
        FoldColumn = { fg = colors.bg, bg = colors.dg },
        SignColumn = { fg = colors.bg, bg = colors.fg },
        CursorLine = { bg = colors.mg },
        CursorLineSign = { bg = colors.mg },
        CurSearch = { fg = colors.red },
        Search = { fg = colors.red },
        PmenuSbar = { fg = colors.red },
        PmenuSel = { fg = colors.red },
        MsgArea = { fg = colors.white, bg = colors.dg },
    }
    local fzf = reload("neo64.plugins.fzf-lua")
    local treesitter = reload("neo64.plugins.treesitter")
    local md = reload("neo64.plugins.render-markdown")

    return {
        base_hl,
        fzf(),
        treesitter(),
        md(),
    }
end

function M.setup()
    -- reset previous hi before setup
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")
    vim.o.background = "dark"

    local highlights_sections = get_highlights()

    for index, highlights in pairs(highlights_sections) do
        for group, opts in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, opts)
        end
    end

    require("neo64.plugins.lualine")()
    vim.cmd.colorscheme("neo64")
end

M.colors = colors

return M
