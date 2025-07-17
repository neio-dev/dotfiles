local M = {}
local state = { windows = {}, buffers = {} }
local ns = vim.api.nvim_create_namespace("nvim-frame")

local border = {
  tl = "╭", tr = "╮",
  bl = "╰", br = "╯",
  h = "─", v = "│"
}

local function make_buf(lines)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines or {})
  local ns = vim.api.nvim_create_namespace("highlight_ns")
vim.api.nvim_buf_add_highlight(0, ns, "Error", 3, 6, 11)
  table.insert(state.buffers, buf)
  return buf
end

local function make_win(buf, opts)
  local win = vim.api.nvim_open_win(buf, false, vim.tbl_extend("force", {
    relative = "editor",
    style = "minimal",
    focusable = false,
    noautocmd = true,
    zindex = 50
  }, opts))
  table.insert(state.windows, win)
  return win
end

function M.clear()
  for _, win in ipairs(state.windows) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end
  for _, buf in ipairs(state.buffers) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  state = { windows = {}, buffers = {} }
end

local function split(s, i)
    return string.sub(s, 1, i), string.sub(s, i + 1, #s)
end

function M.setup()
  M.clear()

  local cols = vim.o.columns
  local lines = vim.o.lines

  local menu = {
    {label="File", bind="F"},
    {label="Edit", bind="E"},
    {label="Search", bind="S"},
    {label="Settings", bind="g"},
  }

  local menu_size = 0

  for index, value in ipairs(menu) do
     menu_size = menu_size + #value.label
  end

  local menu_string = ""
  for idx, item in ipairs(menu) do
      if idx ~= 0 then
          menu_string = menu_string .. " "
      end

      local err = "%#Error#"
      local bk = "%#Normal#"
      local function hl(str)
          return err .. str .. bk
      end
    
      local label = item.label
      local bind_in_label = string.find(label, item.bind)
    
      if bind_in_label ~= nil then
          local lab_start, lab_end = split(label, bind_in_label)
          if bind_in_label == 1 then
              label = hl(lab_start) .. lab_end
         else
             label = lab_start:sub(1, -2) .. hl(item.bind) .. lab_end
          end
      else
          label = label .. " " .. hl(item.bind)
      end

      menu_string = menu_string .. label
  end
  
    local left_modules = menu_string
    local right_modules = " " .. vim.fn.strftime("%H:%M") .. " "
    local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")


    local center_modules = fname:upper()
    local modules_size = #left_modules:gsub("%%#.-#","") + #center_modules + #right_modules
-- make_win(make_buf({ border.tl .. string.rep(border.h, 4) .. left_modules .. string.rep(border.h, (cols - modules_size - 10)/2) .. center_modules .. string.rep(border.h, (cols - modules_size - 10) / 2) .. right_modules .. string.rep(border.h, 4) .. border.tr }), {
--   row = 0,
--   col = 0,
--   width = cols,
--   height = 1,
-- })

-- -- Bottom border
-- make_win(make_buf({ border.bl .. string.rep(border.h, cols - 2) .. border.br }), {
--   row = lines - 1,
--   col = 0,
--   width = cols,
--   height = 1
-- })
  vim.o.tabline = border.tl .. string.rep(border.h, 4) .. left_modules .. string.rep(border.h, (cols - modules_size - 10)/2) .. center_modules .. string.rep(border.h, (cols - modules_size - 10) / 2) .. right_modules .. string.rep(border.h, 4) .. border.tr
    vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
  callback = function()
    fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
  vim.o.tabline = border.tl .. string.rep(border.h, 4) .. left_modules .. string.rep(border.h, (cols - modules_size - 10)/2) .. center_modules .. string.rep(border.h, (cols - modules_size - 10) / 2) .. right_modules .. string.rep(border.h, 4) .. border.tr
  end,
})  -- Left + right border
  local vertical = {}
  for _ = 1, lines - 3 do
    table.insert(vertical, border.v)
  end

  make_win(make_buf(vertical), { row = 2, col = 0, width = 1, height = #vertical })
  make_win(make_buf(vertical), { row = 2, col = cols - 1, width = 1, height = #vertical })
end

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("NvimFrameResize", { clear = true }),
  callback = function()
    require("nvim-frame").setup()
  end
})

return M

