-- recommended by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set `mapleader` lazy so mappings are correct
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.winborder = "rounded"

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.showcmd = true
vim.opt.laststatus = 3
vim.opt.autowrite = true
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.autoread = true

vim.opt.formatoptions = "jcroqlnt" -- tcqj

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.scrolloff = 8

vim.opt.swapfile = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"

vim.opt.completeopt = "menu,menuone,noselect"

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.grepprg = "rg --vimgrep --multiline-dotall"

vim.opt.undofile = false

vim.opt.mouse = ""

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

vim.opt.shortmess:append({ W = true, I = true, c = true })
vim.opt.splitkeep = "screen"
vim.opt.shortmess:append({ C = true })

-- set yank to automatically use the system clipboard
vim.opt.clipboard = "unnamedplus"
