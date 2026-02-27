return {
    "neovim-idea/catppuccin-reloaded-nvim",
    dependencies = { "catppuccin/nvim" },
    priority = 1000,
    config = function()
        require("catppuccin-reloaded").setup({
            catppuccin = {}
        })
    end,
}
