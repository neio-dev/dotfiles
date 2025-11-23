return {
    dir = "~/.config/nvim/lua/doro",
    name = "doro",
    config = function()
        local doro = require("doro")
        doro:setup()
    end,
}
