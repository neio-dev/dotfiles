---@class Harbor
---@field dock Dock
---@field bay Bay
---@field lighthouse Lighthouse
---@field extensions {[string]: Extension}
---@field active_ship? Ship

---@class CursorPosition
---@field col number
---@field row number

---@alias PossibleList "dock"|"bay"

---@class Ship
---@field value string
---@field position CursorPosition 
---@field current_list PossibleList 

---@class Fleet
---@field name string
---@field ships {[string]: Ship}
---@field resolve? RESOLVE.replace|RESOLVE.prepend
---@field harbor Harbor

---@class Bay: Fleet

---@class Dock: Fleet

---@class Config
---@field bay Fleet

---@class SavedData
---@field dock Ship[]
---@field bay Ship[]

---@class SessionManager
---@field path string
---@field dir string
---@field harbor Harbor

---@class Lighthouse

return {}
