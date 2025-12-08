return {
    "neovim/nvim-lspconfig",
    depdendencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lua',
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },

    config = function()
        local lspconfig = vim.lsp.config
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                "gopls",
                "vtsls",
                "eslint",
                "lua_ls",
                "terraformls",
            },
            handlers = {
                function(server)
                    lspconfig(server, {
                        capabilities = lsp_capabilities,
                    })
                end,
            },
        })

        local cmp = require('cmp')
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'buffer',  keyword_length = 3 },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
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

        lspconfig("lua_ls", {
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace"
                    }
                }
            }
        })

        lspconfig("vtsls", {
            settings = {
                typescript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                },
                javascript = {
                    inlayHints = {
                        parameterNames = { enabled = "all" },
                        parameterTypes = { enabled = true },
                        variableTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        enumMemberValues = { enabled = true },
                    },
                },
            },
        })

        lspconfig("gopls", {
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
                set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
                set('n', 'gr', function() require('telescope.builtin').lsp_references() end, opts)
                set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
                set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
                set({ 'n', 'v' }, '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
                set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
                -- this is for call hierarchy
                set('n', 'ghi', function() vim.lsp.buf.incoming_calls() end, opts)
                set('n', 'gho', function() vim.lsp.buf.outgoing_calls() end, opts)
                set('n', 'gdd', function() vim.diagnostic.open_float() end, opts)
                set('n', 'gdp', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
                set('n', 'gdn', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
                set('n', 'gdl', function() require('telescope.builtin').diagnostics() end, opts)

                require("lsp_signature").on_attach({
                    bind = true,
                    handler_opts = {
                        border = "rounded"
                    }
                }, bufnr)
            end
        })
    end
}
