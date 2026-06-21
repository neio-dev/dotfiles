local commands = require "calm.commands"
---@class Calm
local Calm = {}

function Calm:new()
    local o = {
    }

    self.__index = self
    ---@class Calm
    local instance = setmetatable(o, self)
    return instance
end

function Calm:test()
    print("calm")
end

function find(pattern, callback)
    vim.system({ "rg", "--vimgrep", pattern, "." }, {
        text = true,
    }, function(obj)
        local qf = {}

        for _, line in ipairs(vim.split(obj.stdout, "\n")) do
            local file, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")
            if file then
                table.insert(qf, {
                    filename = file,
                    lnum = tonumber(lnum),
                    col = tonumber(col),
                    text = text,
                })
            end
        end

        vim.schedule(function()
            vim.fn.setqflist(qf, "r")
            vim.cmd("copen")
            vim.schedule(function()
                callback()
            end)
        end)
    end)
end

function Calm:find_all_and_replace()
    local search = vim.fn.input("Find: ")
    if search == nil or search == "" then
        return
    end
    local replace = vim.fn.input("Replace: ")
    if replace == nil or replace == "" then
        return
    end

    find(search, function()
        local good = vim.fn.input("Good: ")
        print("is good ? " .. good)
        vim.cmd("cdo %s/" .. search .. "/" .. replace .. "/ge | update")
    end)
end

function Calm:setup()
    commands:init()
    vim.keymap.set("n", "<leader>cc", function() self:find_all_and_replace() end)
end

return Calm:new()
