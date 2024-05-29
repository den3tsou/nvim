local lspconfig = require("lspconfig")
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local default_setup = function(server)
  require('lspconfig')[server].setup({
    capabilities = lsp_capabilities,
  })
end

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        default_setup,
    },
    ensure_installed = {
        "gopls",
        "tsserver",
        "rust_analyzer",
        "eslint",
        "clangd",
        "lua_ls",
    }
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer', keyword_length = 3 },
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
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
        -- changing the order of fields so the icon is the first
        fields = { 'menu', 'abbr', 'kind' },

        -- here is where the change happens
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                buffer = 'Ω',
                path = '🖫',
                nvim_lua = 'Π',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

require("neodev").setup({})

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

lspconfig.tsserver.setup({
    settings = {
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
            },
        },

        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
            },
        },
    },
})

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
    callback = function (args)
        local bufnr = args.buf
        local opts = {buffer = bufnr}
        local set = vim.keymap.set
        local client = vim.lsp.get_client_by_id(args.data.client)

        -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
        if client ~= nil and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr })
            set("n", "si", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
            end, opts)
        end

        set('n', 'H', function() vim.lsp.buf.hover() end, opts)
        set('n', '<C-]>', function() vim.lsp.buf.definition() end, opts)
        set('n', '<C-[>', function() vim.lsp.buf.type_definition() end, opts)
        set('n', '<C-\\>', function() vim.lsp.buf.declaration() end, opts)
        set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
        set('n', 'gr', function() vim.lsp.buf.references() end, opts)
        set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
        set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
        set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
        set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
        set('n', '<leader>n', ':bnext<CR>', opts)
        set('n', '<leader>m', ':bprevious<CR>', opts)
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

-- lsp.on_attach(function(client, bufnr)
--     local opts = { buffer = bufnr }
--     local set = vim.keymap.set
--
--     -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
--     if client.server_capabilities.inlayHintProvider then
--         vim.lsp.inlay_hint.enable(true, { bufnr })
--         set("n", "si", function()
--             vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })
--         end, opts)
--     end
--
--     set('n', 'H', function() vim.lsp.buf.hover() end, opts)
--     set('n', '<C-]>', function() vim.lsp.buf.definition() end, opts)
--     set('n', '<C-[>', function() vim.lsp.buf.type_definition() end, opts)
--     set('n', '<C-\\>', function() vim.lsp.buf.declaration() end, opts)
--     set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
--     set('n', 'gr', function() vim.lsp.buf.references() end, opts)
--     set('n', '<C-k>', function() vim.lsp.buf.signature_help() end, opts)
--     set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
--     set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
--     set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
--     set('n', '<leader>n', ':bnext<CR>', opts)
--     set('n', '<leader>m', ':bprevious<CR>', opts)
--     -- this is for call hierarchy
--     set('n', 'ghi', function() vim.lsp.buf.incoming_calls() end, opts)
--     set('n', 'gho', function() vim.lsp.buf.outgoing_calls() end, opts)
--     set('n', 'gdd', function() vim.diagnostic.open_float() end, opts)
--     set('n', 'gdp', function() vim.diagnostic.goto_prev() end, opts)
--     set('n', 'gdn', function() vim.diagnostic.goto_next() end, opts)
--
--     require("lsp_signature").on_attach({
--         bind = true,
--         handler_opts = {
--             border = "rounded"
--         }
--     }, bufnr)
-- end)

-- lsp.setup()
