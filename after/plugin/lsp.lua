-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'gopls',
  'rust_analyzer',
  'tsserver',
  'eslint',
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.set_preferences({
    set_lsp_keymaps = false,
})

local cmp = require('cmp')

-- this is used when default is not wanted
-- lsp.setup_nvim_cmp({
--   mapping = cmp.mapping.preset.insert({
--     ['<C-o>'] = cmp.mapping.complete(),
--   })
-- })
--
lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
    ['<C-o>'] = cmp.mapping.confirm(),
    ['<CR>'] = vim.NIL,
  })
})


lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr}
    local set = vim.keymap.set

    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

    set('n', 'H', '<CMD>lua vim.lsp.buf.hover()<CR>', opts)
    set('n', '<C-]>', '<CMD>lua vim.lsp.buf.definition()<CR>', opts)
    set('n', '<C-[>', '<CMD>lua vim.lsp.buf.declaration()<CR>', opts)
    set('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>', opts)
    set('n', 'gt', '<CMD>lua vim.lsp.buf.type_definition()<CR>', opts)
    set('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>', opts)
    set('n', '<C-k>', '<CMD>lua vim.lsp.buf.signature_help()<CR>', opts)
    set('n', '<leader>rn', '<CMD>lua vim.lsp.buf.rename()<CR>', opts)
    set('n', '<leader>ca', '<CMD>lua vim.lsp.buf.code_action()<CR>', opts)
    -- set('n', '<leader>f', '<CMD>lua vim.lsp.buf.format({async = true})<CR>', opts)
    -- this is for call hierarchy
    set('n', 'ghi', '<CMD>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    set('n', 'gho', '<CMD>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    set('n', 'gd', '<CMD>lua vim.diagnostic.open_float()<CR>', opts)
    set('n', 'gdp', '<CMD>lua vim.diagnostic.goto_prev()<CR>', opts)
    set('n', 'gdn', '<CMD>lua vim.diagnostic.goto_next()<CR>', opts)
end)


lsp.setup()
