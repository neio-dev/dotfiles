vim.opt.guicursor = "i:blinkon100"
vim.api.nvim_set_hl(0, "LualineBufferHighlight", {
  underline = true,
  bold = true,
  -- leave `fg` and `bg` unset so they inherit from parent
})
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

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

local function normalize_path(buf_name, root)
    local Path = require("plenary.path")
    return Path:new(buf_name):make_relative(root)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        require("harpoon"):sync()
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local name = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_buf_get_option(buf, "buftype")

        if name == "" or buftype ~= "" then
            return
        end
        local harpoon = require("harpoon")
        local main_list = harpoon:list()
        local temp_list = harpoon:list("__harpoon_temp")
        local buf_path = normalize_path(
            vim.api.nvim_buf_get_name(buf),
            vim.loop.cwd())
        print(harpoon:list():get_by_value(buf_path))
        local harpoon_item = harpoon:list():get_by_value(buf_path)
        if harpoon_item ~= nil then
            return
        end
        temp_list:replace_at(1, { value = buf_path, context = { 1, 0 } })
        harpoon:sync()
    end,
})

function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match("^user") or name:match("^plugins") then -- or your config folder prefix
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end
