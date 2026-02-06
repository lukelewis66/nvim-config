-- Line nums
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Appearance
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8

-- Behavior
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 50

-- Clipboard (use system clipboard)
vim.opt.clipboard = "unnamedplus"  -- Use + register (system clipboard) for yank/delete/put

-- Disable netrw (we use mini.files and telescope)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

