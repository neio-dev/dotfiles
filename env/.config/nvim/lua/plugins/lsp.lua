local function lsp_add(ls, config)
    if config then vim.lsp.config(ls, config) end

    vim.lsp.enable(ls)
end

local function enable_lsps()
    lsp_add("docker-language-server", {
        cmd = { 'docker-language-server', 'start', '--stdio' },
        filetypes = { 'dockerfile', 'yaml.docker-compose' },
        get_language_id = function(_, ftype)
            if ftype == 'yaml.docker-compose' or ftype:lower():find('ya?ml') then
                return 'dockercompose'
            else
                return ftype
            end
        end,
        root_markers = {
            'Dockerfile',
            'docker-compose.yaml',
            'docker-compose.yml',
            'compose.yaml',
            'compose.yml',
            'docker-bake.json',
            'docker-bake.hcl',
            'docker-bake.override.json',
            'docker-bake.override.hcl',
        },
        filetypes = { "dockerfile", "yaml", "yaml.docker-compose" }
    })
    lsp_add("lua_ls", {
        settings = {
            Lua = {
                semantic = { enable = true },
                hint = { enable = true },
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
                workspace = {
                    library = {
                        vim.api.nvim_get_runtime_file("", true),
                        vim.fn.expand "${3rd}/love2d/library",
                        vim.fn.expand "${3rd}/busted/library",
                        "/usr/local/share/lua/5.4/busted",
                        "/usr/local/lib/luarocks/rocks-5.4/busted/2.3.0-1/lua",
                    },
                    checkThirdParty = true,
                    semanticTokens = { enable = true },
                },
                runtime = {
                    version = "LuaJIT", -- or "Lua 5.4" / "Lua 5.5"
                    path = {
                        "?.lua",
                        "?/init.lua"
                    }
                },
                workspace = {
                    library = {
                        "/usr/local/share/lua/5.4", -- path where LuaRocks installs Lua files
                        "/usr/local/lib/lua/5.4",    -- compiled rocks (.so/.dll)
                        "/usr/local/share/lua/5.4/busted",
                        "/usr/local/lib/luarocks/rocks-5.4/busted/2.3.0-1/lua",
                        vim.fn.expand "${3rd}/busted/library",
                    }
                },
                diagnostics = {
                    globals = {
                        "vim",
                        "love",
                        "describe",
                        "it",
                        "before_each",
                        "after_each",
                        "assert",
                        "setup",
                    }
                }
            }
        }
    })

    lsp_add("mdx_analyzer")
    lsp_add("pyright")
    local customizations = {
        { rule = 'style/*',   severity = 'off', fixable = true },
        { rule = 'format/*',  severity = 'off', fixable = true },
        { rule = '*-indent',  severity = 'off', fixable = true },
        { rule = '*-spacing', severity = 'off', fixable = true },
        { rule = '*-spaces',  severity = 'off', fixable = true },
        { rule = '*-order',   severity = 'off', fixable = true },
        { rule = '*-dangle',  severity = 'off', fixable = true },
        { rule = '*-newline', severity = 'off', fixable = true },
        { rule = '*quotes',   severity = 'off', fixable = true },
        { rule = '*semi',     severity = 'off', fixable = true },
    }
    lsp_add("eslint", {
        filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "html",
            "markdown",
            "json",
            "jsonc",
            "yaml",
            "toml",
            "xml",
            "gql",
            "graphql",
            "astro",
            "svelte",
            "css",
            "less",
            "scss",
            "pcss",
            "postcss"
        },
        settings = {
            -- Silent the stylistic rules in your IDE, but still auto fix them
            rulesCustomizations = customizations,
        },
    })
    lsp_add("qmk-lsp", {
        cmd = { "qmk-lsp" },
        filetypes = { "c" },
    })
    lsp_add("html")
    lsp_add("jsonls")
    lsp_add("cssls")
    lsp_add("phpactor")
    lsp_add("intelephense", {
        settings = {
            intelephense = {
                stubs = {
                    "apache",
                    "bcmath",
                    "bz2",
                    "calendar",
                    "com_dotnet",
                    "Core",
                    "ctype",
                    "curl",
                    "date",
                    "dba",
                    "dom",
                    "enchant",
                    "exif",
                    "FFI",
                    "fileinfo",
                    "filter",
                    "fpm",
                    "ftp",
                    "gd",
                    "gettext",
                    "gmp",
                    "hash",
                    "iconv",
                    "imap",
                    "intl",
                    "json",
                    "ldap",
                    "libxml",
                    "mbstring",
                    "meta",
                    "mysqli",
                    "oci8",
                    "odbc",
                    "openssl",
                    "pcntl",
                    "pcre",
                    "PDO",
                    "pdo_ibm",
                    "pdo_mysql",
                    "pdo_pgsql",
                    "pdo_sqlite",
                    "pgsql",
                    "Phar",
                    "posix",
                    "pspell",
                    "readline",
                    "Reflection",
                    "session",
                    "shmop",
                    "SimpleXML",
                    "snmp",
                    "soap",
                    "sockets",
                    "sodium",
                    "SPL",
                    "sqlite3",
                    "standard",
                    "superglobals",
                    "sysvmsg",
                    "sysvsem",
                    "sysvshm",
                    "tidy",
                    "tokenizer",
                    "xml",
                    "xmlreader",
                    "xmlrpc",
                    "xmlwriter",
                    "xsl",
                    "Zend OPcache",
                    "zip",
                    "zlib",
                    "wordpress"
                }
            }
        }

    })
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
        local luasnip = require('luasnip')

        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            },
            snippet = {
                expand = function(args)
                    -- You need Neovim v0.10 to use vim.snippet
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-e>"] = cmp.mapping.select_next_item(),
                ["<C-i>"] = cmp.mapping.select_prev_item(),
                ["<Up>"] = cmp.config.disable,
                ["<Down>"] = cmp.config.disable,
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
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
        local types = require("cmp.types")

        local function deprioritize_snippet(entry1, entry2)
            if entry1:get_kind() == types.lsp.CompletionItemKind.Snippet then
                return false
            end
            if entry2:get_kind() == types.lsp.CompletionItemKind.Snippet then
                return true
            end
        end

        table.insert(cmp.get_config().sorting.comparators, 1, deprioritize_snippet)
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "LspEslintFixAll",
        })
    end,
},
    {
        'hrsh7th/cmp-nvim-lsp',
    },
    {
        'hrsh7th/nvim-cmp',
    },
}
