local function lsp_add(ls, config)
    if config then vim.lsp.config(ls, config) end

    vim.lsp.enable(ls)
end

local function enable_lsps()
    lsp_add("lua_ls", {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                workspace = {
                    library = {
                        vim.api.nvim_get_runtime_file("", true),
                    },
                    checkThirdParty = false,
                },
                diagnostics = {
                    globals = { "vim" }
                }
            }
        }
    })

    lsp_add("mdx_analyzer")
    lsp_add("pyright")
    lsp_add("html")
    lsp_add("jsonls")
    lsp_add("cssls")
    lsp_add("ts_ls", {
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    })
    lsp_add("glsl_analyzer")
    lsp_add("emmet_ls", {
        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "svelte", "pug", "typescriptreact", "vue" },
        init_options = {
            css = {
                snippets = {
                    lf = "left: 100%;",
                    tf = "top: 100%;",
                    bf = "bottom: 100%;",
                    rf = "right: 100%;",
                    wf = "width: 100%;",
                    mwf = "min-width: 100%;",
                    Mwf = "max-width: 100%;",
                    hf = "height: 100%;",
                    mhf = "min-height: 100%;",
                    Mhf = "max-height: 100%;",
                },
            },
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ["bem.enabled"] = true,
                },
            },
        }
    })
end

return { {
    'neovim/nvim-lspconfig',
    config = function()
        vim.opt.signcolumn = 'yes'
        local lspconfig = require('lspconfig')
        local lspconfig_defaults = lspconfig.util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', '<leader>L', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', '<leader>ld', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', '<leader>lx', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                vim.keymap.set('n', '<leader>lD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', '<leader>lo', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', '<leader>lR', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<leader>e', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end,
        })
        enable_lsps()
        local cmp = require('cmp')

        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
            },
            snippet = {
                expand = function(args)
                    -- You need Neovim v0.10 to use vim.snippet
                    vim.snippet.expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-e>"] = cmp.mapping.select_next_item(),
                ["<C-i>"] = cmp.mapping.select_prev_item(),
                ["<Up>"] = cmp.config.disable,
                ["<Down>"] = cmp.config.disable,
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<CR>"] = cmp.config.disable,
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Esc>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

            }),
        })
    end
},
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        'hrsh7th/nvim-cmp',
    },
}
