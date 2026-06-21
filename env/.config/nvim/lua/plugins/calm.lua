return {
    dir = "~/.config/nvim/lua/calm",
    name = "calm",
    config = function()
        local calm = require("calm")
        calm:setup()
    end,
}
