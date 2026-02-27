return {
    "ibhagwan/fzf-lua",
    config = function()
        local fzf = require("fzf-lua")
        local cfg = fzf.config

        require("fzf-lua").setup({
            fzf_colors = true,
            files = {
                fd_opts = [[--type f --hidden --exclude vendor]],
            },
            lines = {
                winopts = { treesitter = true },
            },
            colors = {
                fg     = "Normal",
                bg     = "Normal",
                fg_sel = "PmenuSel", -- selected line foreground
                bg_sel = "Visual",   -- selected line background
                fg_win = "Normal",
                bg_win = "Normal",
                -- optional: floating border
                border = "FloatBorder",
            },
            hl = {
                -- unselected lines
                normal    = "Normal",
                -- selected line
                selected  = "Visual",
                -- scrollbar/preview
                scrollbar = "CursorLine",
                preview   = "Normal",
            },
        })
    end,
}
