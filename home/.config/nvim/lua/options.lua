vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.scrolloff = 8

-- Directories for swap files
vim.opt.backupdir = vim.fs.normalize("~/.vim/backup")
vim.opt.directory = vim.fs.normalize("~/.vim/backup")

-- Disable swap files
-- vim.cmd [[ set noswapfile ]]

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undofile = false

vim.opt.mouse = ""
