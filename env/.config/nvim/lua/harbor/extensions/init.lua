local lualine_extension = require("harbor.extensions.builtins.lualine")
local telescope_extension = require("harbor.extensions.builtins.telescope")
local Extensions = {
    lualine=lualine_extension:setup(),
    telescope=telescope_extension:setup(),
}

return Extensions
