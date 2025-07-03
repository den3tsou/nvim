vim.opt.number = true
vim.opt.relativenumber = true

-- highlight while search, this may degrade the performance
vim.opt.hlsearch = true

vim.opt.incsearch = true
vim.opt.cursorline = true
vim.opt.ignorecase = true

-- show the match for things like parenthesis, braces, brackets, quotes
vim.opt.showmatch = true

vim.opt.scrolloff = 8

-- write the buffer when going to other buffer
vim.opt.autowrite = true

-- indentation set up
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false

-- spell check for british english
vim.opt.spell = true
vim.opt.spelllang = "en_gb"

vim.api.nvim_create_autocmd('FileType', {
    pattern = { "*" },
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "typescriptreact" then
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
            vim.bo.softtabstop = 2
        elseif ft == "typescript" then
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
            vim.bo.softtabstop = 2
        end
    end
})

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.g.mapleader = " "

-- move the line up and down while in virtual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set('n', '<leader>n', ':bnext<CR>')
vim.keymap.set('n', '<leader>m', ':bprevious<CR>')

vim.keymap.set("n", "q:", ":q")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("i", "jk", "<ESC>")

-- use for big screen. To crentre the right pane to the middle
vim.keymap.set("n", "<leader>cc", ":vertical resize +60<CR>l")

-- For full path
-- vim.keymap.set("n", "cp", "let @\" = expand(\"%:p\")");
vim.keymap.set("n", "cp", ":let @* = expand(\"%\")<CR>");

-- this will make sure that the cursor will not reach the bottom line
vim.opt.scrolloff = 8

-- vim.opt.colorcolumn = "80"
vim.diagnostic.config({
    -- virtual_lines = true,
    virtual_text = true,

})
