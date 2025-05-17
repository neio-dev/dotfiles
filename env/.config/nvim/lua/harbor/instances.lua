local Dock = require("harbor.dock")
local Bay = require("harbor.bay")
local SessionManager = require("harbor.sessions")

return {
    dock=Dock:new(),
    bay=Bay:new(),
    sessions=SessionManager:new(),
}
