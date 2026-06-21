for name, _ in pairs(package.loaded) do
    if name:match("^esper") then
        package.loaded[name] = nil
    end
end

local esper = require "esper"
local utils = require "esper.utils"
local DevTool = {}
local show_details = false
-- _G.EsperDom = nil
local ns = vim.api.nvim_create_namespace("esper_dev_tool")
DevTool.show = function()
    print("...DevTool...")
    if not _G.EsperDom then return end

    ---@alias node Component
    for index, node in ipairs(_G.EsperDom) do
        print("<" .. node.id .. "> " .. node.name)
        print(string.rep("=", 15))
        print("hash:" .. node._hash)

        if #node.children then
            for index, value in ipairs(node.children) do
                if type(value) == "string" then
                    print("    <div> " .. index .. ": " .. value)
                elseif utils.instanceof(value, "Component") then
                    local fchild = value.children[1]
                    print("    > <div>" .. (type(fchild) == "string" and fchild or "Component"))
                end
                if index ~= #node.children and index ~= 1 then

                end
            end
        else
            print("No children")
        end

        if show_details then
            print(string.rep("=", 15))
            if not utils.is_object_empty(node._layout) then
                print("Layout:")
                for key, value in pairs(node._layout) do
                    print(key .. ": " .. tostring(value))
                end
            else
                print("No layout")
            end

            print(string.rep("=", 15))
            if not utils.is_object_empty(node._style) then
                print("Style:")
                for key, value in pairs(node._style) do
                    if type(value) == "string" then
                        print(key .. ": " .. tostring(value))
                    end
                end
            else
                print("No style")
            end

            print(string.rep("=", 15))
            if not utils.is_object_empty(node._props) then
                print("Props:")
                for key, value in pairs(node._props) do
                    if type(value) == "string" then
                        print(key .. ": " .. tostring(value))
                    end
                end
            else
                print("No props")
            end
            print(string.rep("=", 15))
            print("\n")
        end
    end
end

local function tab(level)
    return string.rep(" ", 4 * (level or 1))
end


local function concat(tbl, sep)
    local str = ""

    for index, value in ipairs(tbl) do
        if type(value) == "table" then
            str = str .. concat(value._children, sep)
        else
            str = str .. value
        end
        if #tbl > 1 and index ~= #tbl then
            str = str .. sep
        end
    end

    return str
end

local Builder = esper.CoreComponent
DevTool.open = function()
    local width = 50
    local center = function(str, length)
        local spaces = ((length or width) / 2) - (#str / 2)
        return string.rep(" ", spaces) .. str .. string.rep(" ", spaces)
    end
    local buf = esper.Buffer {
            "┌" .. string.rep("─", width - 2) .. "┐",
            "│" .. center("DevTool", width - 2) .. "│",
            "└" .. string.rep("─", width - 2) .. "┘",
            Builder { "is work or no???" }
                :style { color = "cyan", bg = "black" }
                :layout { padding = 1 },
            Builder { "arwwwwwsisoke" }
                :layout { padding = 1 }
                :style { color = "red", bg = "pink" },
            center "Tree:",
            center "what??",
            center "CA MARCHE PAS LA",
            "┌" .. string.rep("─", width - 2) .. "┐",
            "│" .. center("DevTool", width - 2) .. "│",
            "└" .. string.rep("─", width - 2) .. "┘",
        }
        :style { color = "black", bg = "orange", bold = true }
        :layout { padding = 1 }

    local buf = esper.Buffer {
            "┌" .. string.rep("─", width - 2) .. "┐",
            "│" .. center("Replace in Files", width - 2) .. "│",
            "└" .. string.rep("─", width - 2) .. "┘",
            Builder { center "Search" }
                :style { bg = "grey", border = "red" }
                :layout { border = 1 },
            Builder { center "Replace" }
                :layout {},
            Builder { "In Project", "Module", "Directory", "Scope" }
                :style { bg = "red" }
                :layout { border = 1, gap = 4, row = true },
            Builder {
                Builder { "$search = $subPath", "ClassLoader.php 502" }:layout { row = true, gap = 15 },
                Builder { "* @param mixed $element", "ReadableContent.php 59" }:layout { row = true, gap = 7 },
                Builder { "* @param mixed $element", "ReadableContent.php 79" }:layout { row = true, gap = 7 },
            }:style { bg = "darkyellow", color = "purple" },
            Builder {
                Builder { "SwitchFinderController.php" },
                Builder { "api/src/Controller" },
            }
                :style { bg = "grey", border = "red" }
                :layout { border = 1, row = true },
            center "Tree:",
            center "what??",
            center "CA MARCHE PAS LA",
        }
        :style { color = "white", bg = "black", bold = true }
        :layout { padding = 0, border = 2, border_style = "normal", floating = true }

    buf:render()
end

DevTool.pen = function()
    local buf = esper.Buffer { "Test" }
    buf:render()
    local b = Builder { "Esper :", Builder { "New UI framework" }:style { color = "white" } }
    vim.o.winbar = b
        :layout { gap = 2, corner = "caret", padding = 1 }
        :style { color = "magenta", bg = "black" }
        :render()
    local d = Builder { "D Component", Builder { "Sidebar" }
        :style { bg = "yellow" }, "Yo", "xoxvsso" }
    d:render()
    local r = Builder { Builder { "R Component" }, "footer" }
    r:render()

    if not _G.EsperDom then return end
    local win = _G.esper_test_win
    local buf = vim.api.nvim_win_get_buf(win)
    local width = (vim.api.nvim_win_get_width(win))

    local center = function(str, length)
        local spaces = ((length or width) / 2) - (#str / 2)
        return string.rep(" ", spaces) .. str .. string.rep(" ", spaces)
    end

    local lines = {
        "┌" .. string.rep("─", width - 2) .. "┐",
        "│" .. center("DevTool", width - 2) .. "│",
        "└" .. string.rep("─", width - 2) .. "┘",
        center "Tree:",
        "1-hash: " .. b._hash .. " / " .. concat(b._children, ", "),
        "2-hash: " .. d._hash .. " / " .. concat(d._children, ", "),
        "3-hash: " .. r._hash .. " / " .. concat(r._children, ", "),
    }

    local function parse_nodes(nodes, tab_level, is_tbl)
        local level = tab_level or 0
        local _pairs = is_tbl and ipairs or pairs
        local sep = is_tbl and "." or "─"
        for key, node in _pairs(nodes) do
            table.insert(lines, string.rep(sep, width))
            if type(node) == "string" then
                table.insert(lines, tab(level) .. "󰘍 " .. node)
            else
                table.insert(lines, tab(level) .. "󰘍 <div> hash " .. (node and node.id or "") .. ":")
            end
            table.insert(lines, tab(level) .. "cache:" .. tostring(node.hit_cache))
            table.insert(lines, tab(level) .. "is_alive:" .. tostring(node._alive))
            table.insert(lines, tab(level) .. "render:" .. tostring(node._rendered))
            if node then
                if node._children then
                    for index, child in ipairs(node._children) do
                        if type(child) == "string" then
                            table.insert(lines, tab(level + 1) .. "󰘍 + \"" .. child .. "\"")
                        else
                            parse_nodes({ child }, level + 2, true)
                        end

                        -- table.insert(lines, string.rep(sep, width))
                    end
                end

                if node._layout then
                    table.insert(lines, tab(level + 1) .. "- Layout :")
                    for key, value in pairs(node._layout) do
                        table.insert(lines,
                            tab(level + 2) .. "- + " .. key .. ": " .. tostring(value) .. " <" .. type(value) .. ">")
                    end
                end

                if node._style then
                    table.insert(lines, tab(level + 1) .. "- Style :")
                    for key, value in pairs(node._style) do
                        table.insert(lines,
                            tab(level + 2) .. "- + " .. key .. ": " .. tostring(value) .. " <" .. type(value) .. ">")
                    end
                end

                if node._props then
                    table.insert(lines, tab(level + 1) .. "- Props :")
                    for key, value in pairs(node._props) do
                        table.insert(lines,
                            tab(level + 2) .. "- + " .. key .. ": " .. tostring(value) .. " <" .. type(value) .. ">")
                    end
                end
            end

            table.insert(lines, string.rep(sep, width))
        end
    end

    parse_nodes(_G.EsperDom)

    vim.api.nvim_buf_set_lines(buf, 0, 0, true, lines)
    vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_row = 3, end_col = width, hl_group = "Search" })
    vim.api.nvim_buf_set_extmark(buf, ns, 3, 0, {
        end_row = 3, end_col = #lines[4], hl_eol = true, hl_group = "Cursor",
    })
    vim.api.nvim_buf_set_extmark(buf, ns, 4, 0, { end_row = 7, end_col = #lines[8], hl_eol = true, hl_group = "Visual", })
    vim.api.nvim_buf_set_extmark(buf, ns, 8, 0, { end_row = 8, end_col = #lines[9], hl_eol = true, hl_group = "Search", })
end

--[[
if _G.esper_test_win and vim.api.nvim_win_is_valid(_G.esper_test_win) then
    pcall(vim.api.nvim_win_close, _G.esper_test_win, true)
    _G.esper_test_win = nil
end

local buf = vim.api.nvim_create_buf(false, true)
_G.esper_test_win = vim.api.nvim_open_win(buf, false, { split = "right", style = 'minimal' })
--]]

DevTool.open()

return DevTool
