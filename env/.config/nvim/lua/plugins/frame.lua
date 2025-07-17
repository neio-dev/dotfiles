vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "lua/nvim-frame/*.lua",
  callback = function()
    require("nvim-frame").setup()
    print("[nvim-frame] Frame redrawn")
  end
})

return {
    dir = "~/.config/nvim/lua/nvim-frame",
    name = "frame",
    config = function()
        local frame = require("nvim-frame")
        frame.setup()
   end,
}
