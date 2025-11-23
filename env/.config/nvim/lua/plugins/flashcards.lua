return {
    dir = "~/.config/nvim/lua/flashcards",
    name = "flashcards",
    config = function()
        local flashcards = require("flashcards")
        flashcards:setup()
    end,
}
