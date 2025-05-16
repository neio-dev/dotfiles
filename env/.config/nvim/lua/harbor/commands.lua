local Commands = {}
local harbor

local commands = {
    {
        "HrbDock",
        function()
            local to_print = ""
            for i, v in ipairs(harbor.dock:get()) do
                local val = v.value ~= nil and v.value or "empty"
                to_print = to_print .. val .. ", "
            end
            print("Dock", "[", to_print, "]")
        end,
        { desc = "Get dock list" }
    },
    {
        "HrbAdd",
        function()
            harbor.dock:set()
            local to_print = ""
            for i, v in ipairs(harbor.dock:get()) do
                local val = v.value ~= nil and v.value or "empty"
                to_print = to_print .. val .. ", "
            end
            print("Dock", "[", to_print, "]")
        end,
        { desc = "Add current buffer to dock" }
    },
    {
        "HrbRemove",
        function(opt)
            harbor.dock:remove(opt.args and tonumber(opt.args) or nil)
            local to_print = ""
            for i, v in ipairs(harbor.dock:get()) do
                local val = v.value ~= nil and v.value or "empty"
                to_print = to_print .. val .. ", "
            end
            print("Dock", "[", to_print, "]")
        end,
        { desc = "Remove current buffer to dock", nargs = 1 }
    },{
        "HrbShow",
        function(opt)
            harbor.dock:show(opt.args)
        end,
        { desc = "Show docked ship", nargs = 1 }
    },
}

local function create_command(command)
    local name, callback, opts = unpack(command)
    vim.api.nvim_create_user_command(name, callback, opts)
end


function Commands:init()
    harbor = require("harbor")
    for index, value in ipairs(commands) do
        create_command(value)
    end
end

return Commands
