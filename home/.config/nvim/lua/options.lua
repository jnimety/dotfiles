-- recommended by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set `mapleader` lazy so mappings are correct
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.o.background = "dark"

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true -- Highlight the text line of the cursor
vim.opt.autoread = true

vim.opt.formatoptions = "jcroqlnt" -- tcqj

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.scrolloff = 8

-- Directories for swap files
vim.opt.backupdir = vim.fs.normalize("~/.vim/backup")
vim.opt.directory = vim.fs.normalize("~/.vim/backup")

-- Disable swap files
vim.cmd [[ set noswapfile ]]

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.opt.completeopt = "menu,menuone,noselect"

-- search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.grepprg = "rg --vimgrep --multiline-dotall"

vim.o.undofile = false

vim.opt.mouse = ""

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

vim.opt.shortmess:append { W = true, I = true, c = true }
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append { C = true }
end
