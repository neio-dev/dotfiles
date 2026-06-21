-- vim.opt.guicursor = "i:blinkon100"
vim.api.nvim_set_hl(0, "LualineBufferHighlight", {
    underline = true,
    bold = true,
    -- leave `fg` and `bg` unset so they inherit from parent
})
vim.lsp.set_log_level("debug")
--[[
vim.api.nvim_create_autocmd("ColorSchemePre", {
    callback = function()
        vim.cmd("highlight clear")
        if vim.fn.exists("syntax_on") then
            vim.cmd("syntax reset")
        end
    end
})
--]]
-- vim.opt.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.splitkeep = "screen"
vim.opt.tabstop = 4
vim.opt.scrolloff = 8
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.o.showtabline = 2
vim.keymap.set("n", "<leader> a", "<Plug>(neorg.pivot.list.toggle)", {})

vim.filetype.add({
    extension = {
        mdx = "mdx"
    }
})

local horiz = "─"
local fillchars = {
    vert      = " ",
    horiz     = " ",

    vertleft  = " ",
    vertright = " ",
    verthoriz = " ",

    horizup   = " ",
    horizdown = " ",

    foldopen  = "",
    foldclose = "",
    foldsep   = "|",

    diff      = "╱",

    eob       = " ",
}

vim.opt.fillchars:append(fillchars)

function _G.ReloadConfig()
    for name, _ in pairs(package.loaded) do
        if name:match("^user") or name:match("^plugins") then -- or your config folder prefix
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.MYVIMRC)
    vim.notify("Config reloaded!", vim.log.levels.INFO)
end
