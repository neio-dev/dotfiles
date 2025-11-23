local utils = {}

local function get_hours(seconds)
    return math.floor(seconds / 3600)
end

local function get_minutes(seconds)
    return math.floor(seconds / 60) - get_hours(seconds) * 60
end

local function get_seconds(seconds)
    return seconds - get_hours(seconds) * 3600 - get_minutes(seconds) * 60
end

local function print_numbers(nbr)
    return nbr < 10 and "0"..nbr or nbr
end

utils.print_time = function (seconds)
    local hh = print_numbers(get_hours(seconds))
    local mm = print_numbers(get_minutes(seconds))
    local ss = print_numbers(get_seconds(seconds))
    return hh..":"..mm..":"..ss
end


utils.set_interval = function (interval, callback)
    local timer = vim.uv.new_timer()
    timer:start(interval, interval, function()
        callback()
    end)
    return timer
end

utils.clear_interval = function (timer)
    timer:stop()
    timer:close()
end

utils.set_timeout = function (timeout, callback)
    local timer = uv.new_timer()
    timer:start(timeout, 0, function()
        timer:stop()
        timer:close()
        callback()
    end)
    return timer
end

return utils
