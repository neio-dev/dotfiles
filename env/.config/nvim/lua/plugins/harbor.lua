return {
    -- "neio-dev/harbor",
    dir = "~/.config/nvim/lua/harbor",
    lazy = false,
    priority = 2555,
    config = function()
        local harbor = require("harbor")
        harbor:setup({
            extensions = { "lualine", "telescope" },
            show_history = false,
            bay = {
                length = 3,
            }
        })

        harbor.emitter:on("FLEET_ADD", function(data) print(data.fleet.name, data.ship, " was added") end)

        harbor:set_default_keybinds()
    end,
}
