-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
local lspconfig = require("lspconfig")

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
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

lsp.set_preferences({
    set_lsp_keymaps = false,
})

local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
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
        -- changing the order of fields so the icon is the first
        fields = { 'menu', 'abbr', 'kind' },

        -- here is where the change happens
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
                nvim_lua = 'Π',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
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

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr }
    local set = vim.keymap.set

    -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, {bufnr})
        set("n", "si",  function ()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), {bufnr})
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
    set('n', '<leader>f', function() vim.lsp.buf.format({async = true}) end, opts)
    set('n', '<leader>n', ':bnext<CR>', opts)
    set('n', '<leader>m', ':bprevious<CR>', opts)
    -- this is for call hierarchy
    set('n', 'ghi', function() vim.lsp.buf.incoming_calls() end, opts)
    set('n', 'gho', function() vim.lsp.buf.outgoing_calls() end, opts)
    set('n', 'gdd', function() vim.diagnostic.open_float() end, opts)
    set('n', 'gdp', function() vim.diagnostic.goto_prev() end, opts)
    set('n', 'gdn', function() vim.diagnostic.goto_next() end, opts)
end)


lsp.setup()
