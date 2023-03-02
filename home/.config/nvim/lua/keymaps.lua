-- double percentage sign in command mode is expanded
-- to directory of current file - http://vimcasts.org/e/14
vim.keymap.set("c", "%%", "<C-R>=expand('%:h').'/'<cr>")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- move blocks of text in visual mode
vim.keymap.set('x', "<C-j>", [[ ":m '>+" .. (v:count1) .. "\<CR>gv=gv" ]], { expr = true })
vim.keymap.set('x', "<C-k>", [[ ":m '<-" .. (v:count1 + 1) .. "\<CR>gv=gv" ]], { expr = true })

-- Change 1.8 hash syntax on the current line to 1.9.
-- NB: this isn't perfect, but it's pretty good.
-- List of valid symbol chars: https://gist.github.com/misfo/1072693
vim.keymap.set('n', ",9", [[ <cmd>.s/:\([_a-z0-9]\{1,}\) *=>/\1:/g<cr><cmd>nohlsearch<cr> ]])
