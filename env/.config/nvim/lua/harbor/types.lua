---@class Harbor
---@field dock Dock
---@field bay Bay
---@field extensions {[string]: Extension}

---@class CursorPosition
---@field col number
---@field row number

---@class Ship
---@field value string
---@field position CursorPosition 

---@class Fleet
---@field name string
---@field ships {[string]: Ship}
---@field resolve? RESOLVE.replace|RESOLVE.prepend
---@field harbor Harbor

---@class Config
---@field bay Fleet

---@class SavedData
---@field dock Ship[]
---@field bay Ship[]

---@class SessionManager
---@field path string
---@field dir string
---@field harbor Harbor

return {}
