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

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr}
    local bind = vim.keymap.set

    bind('n', 'H', '<CMD>lua vim.lsp.buf.hover()<CR>', opts)
    bind('n', '<C-]>', '<CMD>lua vim.lsp.buf.definition()<CR>', opts)
    bind('n', '<C-[>', '<CMD>lua vim.lsp.buf.declaration()<CR>', opts)
    bind('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>', opts)
    bind('n', 'gt', '<CMD>lua vim.lsp.buf.type_definition()<CR>', opts)
    bind('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>', opts)
    bind('n', '<C-k>', '<CMD>lua vim.lsp.buf.signature_help()<CR>', opts)
    bind('n', '<leader>rn', '<CMD>lua vim.lsp.buf.rename()<CR>', opts)
    bind('n', '<leader>ca', '<CMD>lua vim.lsp.buf.code_action()<CR>', opts)
    bind('n', '<leader>f', '<CMD>lua vim.lsp.buf.format({async = true})<CR>', opts)
    -- this is for call hierarchy
    bind('n', 'ghi', '<CMD>lua vim.lsp.buf.incoming_calls()<CR>', opts)
    bind('n', 'gho', '<CMD>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
    bind('n', 'gd', '<CMD>lua vim.diagnostic.open_float()<CR>', opts)
    bind('n', 'gdp', '<CMD>lua vim.diagnostic.goto_prev()<CR>', opts)
    bind('n', 'gdn', '<CMD>lua vim.diagnostic.goto_next()<CR>', opts)
end)


lsp.setup()
