local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', function() builtin.find_files({ hidden = true }) end, {})
-- vim.keymap.set('n', '<leader>g', builtin.git_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', 'gb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fr', builtin.registers, {})
vim.keymap.set('n', '<leader>fg', builtin.git_commits, {})
vim.keymap.set('n', '<leader>fgb', builtin.git_bcommits, {})

local actions = require "telescope.actions"
require("telescope").setup {
    pickers = {
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
        }
    },
}

require("telescope").load_extension("ui-select")
