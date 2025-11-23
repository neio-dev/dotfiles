local lualine_extension = require("doro.extensions.builtins.lualine")

local Extensions = {
}

function Extensions:get(doro)
    return {
        lualine = lualine_extension:setup(doro),
    }
end

return Extensions
