return {
    'ya2s/nvim-cursorline',
    config = function()
        require("nvim-cursorline")
            .setup({
                cursorline = {
                    enable = true,
                    timeout = 1000,
                    number = false
                }
            })    
    end,
}
