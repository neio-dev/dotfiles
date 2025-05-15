return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local harpoon = require("harpoon")
        local harpoon_tabs = {}
        local function get_name(name)
            local is_found = false
            for i, v in ipairs(harpoon_tabs) do
                if name == v then
                    is_found = true
                    break
                end
            end

            return is_found and name or name:match("([^/]+)$")
        end
        local function get_harpoon_indicator(harpoon_entry, index, active)
            local is_active = active or false
            local prefix = is_active and ("%#LualineBufferHighlight#[" .. index .. "]") or index
            return prefix .. ": " .. get_name(harpoon_entry.value) .. (is_active and "%*" or "")
        end
        local function get_temp()
            local local_list = harpoon:list("__harpoon_temp")
            local first_temp_item = local_list.items[1]
            local buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(buf) or "temp"
            local is_active = get_name(buf_name) == get_name(first_temp_item.value)
            local temp_prefix = is_active and "%#LualineBufferHighlight#[temp]" or "temp"
            return temp_prefix .. ": " .. get_name(first_temp_item and first_temp_item.value or "temp") .. (is_active and "%*" or "")
        end
        require('lualine').setup({
            theme = 'dracula',
            tabline = {
                lualine_a = {
                    get_temp,
                    {
                        "harpoon2",
                        indicators = {
                            function(entry) return get_harpoon_indicator(entry, "n") end,
                            function(entry) return get_harpoon_indicator(entry, "e") end,
                            function(entry) return get_harpoon_indicator(entry, "i") end,
                            function(entry) return get_harpoon_indicator(entry, "o") end,
                        },
                        active_indicators = {
                            function(entry) return get_harpoon_indicator(entry, "n", true) end,
                            function(entry) return get_harpoon_indicator(entry, "e", true) end,
                            function(entry) return get_harpoon_indicator(entry, "i", true) end,
                            function(entry) return get_harpoon_indicator(entry, "o", true) end,
                        },
                        _separator = " | ",
                    }
                },
            },
        })
    end,
}
