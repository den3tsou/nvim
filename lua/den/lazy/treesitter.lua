return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    version = false,
    dependencies = {
        'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
        local treesitter = require('nvim-treesitter')
        local treesitter_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/"

        local parsers = {
            "lua",
            "vim",
            'vimdoc',
            "javascript",
            "typescript",
            "go",
            "diff",
            "git_rebase",
            'bash',
            'c',
            'diff',
            'html',
            'luadoc',
            'markdown',
            'markdown_inline',
        }

        treesitter.install(parsers)

        dofile(treesitter_dir .. "plugin/filetypes.lua")
        local file_types = vim.iter(parsers)
            :map(function(parser)
                return vim.treesitter.language.get_filetypes(parser)
            end)
            :flatten()
            :totable()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = file_types,
            callback = function(args)
                -- Highlights
                vim.treesitter.start()

                -- Folds
                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo[0][0].foldmethod = "expr"

                -- Indentation
                vim.bo[args.buf].indentexpr = "v:lua.require\"nvim-treesitter\".indentexpr()"
            end,
        })
    end,
}
