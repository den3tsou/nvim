return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>p', function() builtin.find_files({ hidden = true }) end, {})
        -- vim.keymap.set('n', '<leader>g', builtin.git_files, {})
        vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
        vim.keymap.set('n', 'gb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fc', builtin.commands, {})
        vim.keymap.set('n', '<leader>ff', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>fr', builtin.registers, {})
        vim.keymap.set('n', '<leader>fg', builtin.git_commits, {})
        vim.keymap.set('n', '<leader>fgb', builtin.git_bcommits, {})

        local h_pct = 0.90
        local w_pct = 0.80
        local w_limit = 75
        local standard_setup = {
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            preview = { hide_on_startup = true },
            layout_strategy = 'vertical',
            layout_config = {
                vertical = {
                    mirror = true,
                    prompt_position = 'top',
                    width = function(_, cols, _)
                        return math.min(math.floor(w_pct * cols), w_limit)
                    end,
                    height = function(_, _, rows)
                        return math.floor(rows * h_pct)
                    end,
                    preview_cutoff = 10,
                    preview_height = 0.4,
                },
            },
        }
        local fullscreen_setup = {
            borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            preview = { hide_on_startup = false },
            layout_strategy = 'flex',
            layout_config = {
                flex = { flip_columns = 100 },
                horizontal = {
                    mirror = false,
                    prompt_position = 'top',
                    width = function(_, cols, _)
                        return math.floor(cols * w_pct)
                    end,
                    height = function(_, _, rows)
                        return math.floor(rows * h_pct)
                    end,
                    preview_cutoff = 10,
                    preview_width = 0.5,
                },
                vertical = {
                    mirror = true,
                    prompt_position = 'top',
                    width = function(_, cols, _)
                        return math.floor(cols * w_pct)
                    end,
                    height = function(_, _, rows)
                        return math.floor(rows * h_pct)
                    end,
                    preview_cutoff = 10,
                    preview_height = 0.5,
                },
            },
        }


        local actions = require "telescope.actions"
        require("telescope").setup {
            defaults = vim.tbl_extend('error', fullscreen_setup, {
                sorting_strategy = 'ascending',
                path_display = { "filename_first" },
                -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L133
                mappings = {
                    n = {
                        ['o'] = require('telescope.actions.layout').toggle_preview,
                        ['<C-c>'] = require('telescope.actions').close,
                    },
                    i = {
                        ['<C-o>'] = require('telescope.actions.layout').toggle_preview,
                    },
                },
            }),
            pickers = {
                find_files = {
                    hidden = true
                },
                grep_string = {
                    additional_args = { "--hidden" }
                },
                live_grep = {
                    mappings = {
                        i = { ["<c-f>"] = actions.to_fuzzy_refine },
                    },
                    additional_args = { "--hidden" }
                },
                buffers = {
                    mappings = {
                        i = {
                            ["<c-x>"] = actions.delete_buffer + actions.move_to_top,
                        }
                    }
                }
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }

                    -- pseudo code / specification for writing custom displays, like the one
                    -- for "codeactions"
                    -- specific_opts = {
                    --   [kind] = {
                    --     make_indexed = function(items) -> indexed_items, width,
                    --     make_displayer = function(widths) -> displayer
                    --     make_display = function(displayer) -> function(e)
                    --     make_ordinal = function(e) -> string
                    --   },
                    --   -- for example to disable the custom builtin "codeactions" display
                    --      do the following
                    --   codeactions = false,
                    -- }
                },
                fzf = {
                    fuzzy = true,           -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                }
            },
        }

        require("telescope").load_extension("ui-select")
    end
}
