vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
-- vim.g.nvim_tree_respect_buf_cwd = 1
require("config.lazy")
require("neio")
vim.cmd([[
  highlight! link jsDocParam Keyword
  highlight! link jsDocTags Keyword
  highlight! link jsDocComment Comment
]])
vim.api.nvim_set_hl(0, "@comment.documentation", { link = "Comment" })
vim.api.nvim_set_hl(0, "@lsp.type.parameter.jsdoc", { link = "Keyword" })
vim.api.nvim_set_hl(0, "@comment.documentation.tag", { link = "Keyword" })

vim.api.nvim_create_user_command("AddMissingImports", function()
    vim.lsp.buf.code_action({
        context = { only = { "source.addMissingImports" }, diagnostics = {} }
    })
end, { desc = "Add missing imports via LSP" })

function _G.ReloadModule(name)
    package.loaded[name] = nil
    return require(name)
end

