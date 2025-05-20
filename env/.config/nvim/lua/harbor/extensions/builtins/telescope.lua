local Extension = require("harbor.extensions.extension")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

local harbor_telescope = Extension:new("telescope")
harbor_telescope.__index = harbor_telescope

local function filter_empty(fleet)
    local populated_fleet = {}

    for index, value in ipairs(fleet) do
        if value ~= EMPTY then
            table.insert(populated_fleet, value)
        end
    end
end

local generate_new_finder = function()
    local harbor = require("harbor")
    return finders.new_table({
        results = filter_empty(harbor.dock:get()),
        ---@param entry Ship
        entry_maker = function(entry)
            local line = entry.value
                .. ":"
                .. entry.position.row
                .. ":"
                .. entry.position.col
            local displayer = entry_display.create({
                separator = " - ",
                items = {
                    { width = 2 },
                    { width = 50 },
                    { remaining = true },
                },
            })
            local make_display = function()
                return displayer({
                    tostring(index),
                    line,
                })
            end
            return {
                value = entry,
                ordinal = line,
                display = make_display,
                lnum = entry.position.row,
                col = entry.position.col,
                filename = entry.value,
            }
        end,
    })
end

function harbor_telescope:setup()
    ---@param harbor Harbor
    local ext = function()
        local harbor = require("harbor")
        return function(opts)
            opts = opts or {}

            pickers
                .new(opts, {
                    promps_title = "Harbor (Dock)",
                    finder = generate_new_finder(),
                    sorter = conf.generic_sorter(opts),
                    previewer = conf.grep_previewer(opts),
                })
        end
    end

    return ext
end

return harbor_telescope
