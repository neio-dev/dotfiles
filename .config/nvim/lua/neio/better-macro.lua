local snippets = {
    t = "s-- This is a test",
    s = "s-- This is a variable $ test"
}
local function normal(cmdStr) vim.cmd.normal { cmdStr, bang = true } end
local reg
local isRecording = false

local function grabAndDeleteMacro()
    local macro = vim.fn.getreg(reg)
    vim.fn.setreg(reg, "")
    return macro
end

local function playMacro()
    local macroBackup = vim.fn.getreg("0")
    print(snippets[reg])
    vim.fn.setreg("0", snippets[reg])
    vim.defer_fn(function()
        normal("@0")
        vim.fn.setreg("0", macroBackup)
    end, 50)
end


_G.BmStartRecording = function()
    if not isRecording then
        vim.api.nvim_echo({ { "q", "Normal" } }, false, {})
        reg = vim.fn.nr2char(vim.fn.getchar())
        isRecording = true;

        normal("q" .. reg)
        vim.notify("Registering new snippet in registery:" .. reg)
        return
    end
    normal("q")
    vim.notify("Snippet registered into registery " .. reg .. "!")
    isRecording = false

    snippets[reg] = grabAndDeleteMacro()
end
_G.BmPlayMacro = function()
    reg = vim.fn.nr2char(vim.fn.getchar())
    if snippets[reg] == nil then
        print("No stored snippet in registery " .. reg)
        print(snippets)
        reg = nil
        return
    end
    playMacro()
end

-- This is a tes-- This is a testtttttttt require"cmp.utils.feedkeys".run(149)
vim.api.nvim_set_keymap('n', '<leader>q', ':lua BmStartRecording()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>y', ':lua BmPlayMacro()<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>S', 'local', opts)


-- this is a comment test
-- this is a comment test-- this is a comment test
