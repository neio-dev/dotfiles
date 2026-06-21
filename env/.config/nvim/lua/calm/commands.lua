local Commands = {}

function Commands:get_defaults(calm)
    return {
        {
            "Calm",
            function(opts)
                calm:test()
            end,
            { nargs = "?" },
        },
    }
end

local function create_command(command)
    local name, callback, opts = unpack(command)
    vim.api.nvim_create_user_command(name, callback, opts)
end

function Commands:init()
    local calm = require("calm")
    for index, value in ipairs(self:get_defaults(calm)) do
        create_command(value)
    end
end

return Commands
