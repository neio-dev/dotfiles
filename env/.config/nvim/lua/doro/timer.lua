local utils = require "doro.utils"

---@enum states
local STATES = {
    paused = 1,
    started = 2,
    stopped = 3,
}

---@class Timer
local Timer = {}
function Timer:new(o)
    o = o or {}
    self.__index = self
    local instance = setmetatable({
    }, self)
    instance.onEnd = nil
    instance.elapsed = 0
    instance.target = nil
    instance.instance = nil
    instance.state = STATES.stopped

    return instance
end

function Timer:start(countdown, onEnd)
    self.target = countdown or self.target
    self.onEnd = onEnd or self.onEnd
    self.instance = utils.set_interval(1000, function()
        if self.elapsed + 1 > self.target then
            self:stop()
            if self.onEnd then
                self.onEnd()
            end
            return
        end
        self.elapsed = self.elapsed + 1
    end)
    self.state = STATES.started
end

function Timer:pause()
    self.instance:stop()
    self.state = STATES.paused
end

function Timer:stop()
    if self.instance then
        self.elapsed = 0
        utils.clear_interval(self.instance)
        self.instance = nil
    end
end

return Timer
