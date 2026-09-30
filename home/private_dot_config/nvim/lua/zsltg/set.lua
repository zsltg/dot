-- Line numbers
vim.opt.nu = true

-- Displayed tab space
vim.opt.tabstop = 4
-- Inserted tab space
vim.opt.softtabstop = 4
-- Auto-indent space
vim.opt.shiftwidth = 4
-- Replace tab with spaces
vim.opt.expandtab = true

-- Context sensitive extra indentation
vim.opt.smartindent = true

-- Make invisible characters visible
vim.opt.list = true
vim.opt.listchars = {
    tab = "  ",
    trail = "·",
    extends = ">",
    precedes = "<",
    nbsp = "␣",
}

-- Wrap long lines
--vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
--vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.o.ignorecase = true
vim.o.smartcase = true

