return {
    'folke/tokyonight.nvim',
    opts = {
        style = "night",
    },
    config = function()
        vim.opt.termguicolors = true
        vim.cmd.colorscheme('tokyonight')
    end
}
