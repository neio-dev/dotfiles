local Commands = {}

function Commands:get_defaults(doro)
    return {
        {
            "DoroStart",
            function(opts)
                doro:start_pomo()
            end,
            { nargs = "?" },
        },
        {
            "DoroContinue",
            function(opts)
                doro.timer:start()
            end,
            { nargs = "?" },
        },

        {
            "DoroPause",
            function()
                doro.timer:pause()
            end,
            {},
        },
        {
            "DoroStop",
            function()
                doro:stop_pomo()
            end,
            {},
        }
    }
end

local function create_command(command)
    local name, callback, opts = unpack(command)
    vim.api.nvim_create_user_command(name, callback, opts)
end

function Commands:init()
    local doro = require("doro")
    for index, value in ipairs(self:get_defaults(doro)) do
        create_command(value)
    end
end

return Commands
