local lspconfig = require("lspconfig")
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        function(server)
            require('lspconfig')[server].setup({
                capabilities = lsp_capabilities,
            })
        end,
        ["ts_ls"] = function() end, -- handled by `typescript_tools.lua`
    },
    ensure_installed = {
        "gopls",
        "ts_ls",
        "rust_analyzer",
        "eslint",
        "clangd",
        "lua_ls",
        "terraformls",
    }
})

local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer',  keyword_length = 3 },
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
            luasnip.lsp_expend(args.body)
        end,
    },
    -- preselect = 'item',
    -- completion = {
    --     completeopt = 'menu,menuone,noinsert'
    -- },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ['<C-o>'] = cmp.mapping.confirm({ select = false }),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = 'insert' })
            else
                cmp.complete()
            end
        end),
    },
    formatting = {
        expandable_indicator = true,
        -- changing the order of fields so the icon is the first
        fields = { 'menu', 'abbr', 'kind' },

        -- here is where the change happens
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                buffer = 'Ω',
                path = '🖫',
                nvim_lua = 'Π',
                luasnip = 'S',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

lspconfig.gopls.setup({
    settings = {
        gopls = {
            ["ui.inlayhint.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true
            },
        },
    },
})

require("typescript-tools").setup {
    settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = "all",
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = function(ft)
            return {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
            }
        end,
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = "en",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
        }
    },
}
-- handle by typescript_tools for now
-- lspconfig.ts_ls.setup({
--     settings = {
--         javascript = {
--             inlayHints = {
--                 includeInlayEnumMemberValueHints = true,
--                 includeInlayFunctionLikeReturnTypeHints = true,
--                 includeInlayFunctionParameterTypeHints = true,
--                 includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
--                 includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--                 includeInlayPropertyDeclarationTypeHints = true,
--                 includeInlayVariableTypeHints = false,
--             },
--         },
--
--         typescript = {
--             inlayHints = {
--                 includeInlayEnumMemberValueHints = true,
--                 includeInlayFunctionLikeReturnTypeHints = true,
--                 includeInlayFunctionParameterTypeHints = true,
--                 includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
--                 includeInlayParameterNameHintsWhenArgumentMatchesName = true,
--                 includeInlayPropertyDeclarationTypeHints = true,
--                 includeInlayVariableTypeHints = false,
--             },
--         },
--     },
-- })

lspconfig.rust_analyzer.setup({
    settings = {
        ['rust-analyzer'] = {
            inlayHints = {
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true
                }
            },
        },
    },
})

-- vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
-- vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
-- vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr }
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
        if client ~= nil and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(false, { bufnr })
            set("n", "si", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
            end, opts)
        end

        set('n', 'H', function() vim.lsp.buf.hover() end, opts)
        set('n', '<C-]>', function() vim.lsp.buf.definition() end, opts)
        set('n', '<C-[>', function() vim.lsp.buf.type_definition() end, opts)
        set('n', '<C-\\>', function() vim.lsp.buf.declaration() end, opts)
        -- The following is only for typescript
        set('n', '<leader>s', ':TSToolsGoToSourceDefinition<CR>', opts)
        set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
        set('n', 'gr', function() require('telescope.builtin').lsp_references() end, opts)
        -- replace by the above command
        -- set('n', 'gr', function() vim.lsp.buf.references() end, opts)
        set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
        set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
        set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
        -- this is for call hierarchy
        set('n', 'ghi', function() vim.lsp.buf.incoming_calls() end, opts)
        set('n', 'gho', function() vim.lsp.buf.outgoing_calls() end, opts)
        set('n', 'gdd', function() vim.diagnostic.open_float() end, opts)
        set('n', 'gdp', function() vim.diagnostic.goto_prev() end, opts)
        set('n', 'gdn', function() vim.diagnostic.goto_next() end, opts)

        require("lsp_signature").on_attach({
            bind = true,
            handler_opts = {
                border = "rounded"
            }
        }, bufnr)
    end
})
