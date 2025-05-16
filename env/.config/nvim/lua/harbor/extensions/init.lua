local lualine_extension = require("harbor.extensions.builtins.lualine")
local Extensions = {
    lualine=lualine_extension:setup(),
}

return Extensions
