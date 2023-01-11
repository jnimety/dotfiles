vim.keymap.set('n', '<c-n>', '<cmd>NvimTreeFindFileToggle<cr>')

return {
  'nvim-tree/nvim-tree.lua',
  cmd = "NvimTreeFindFileToggle",
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    view = {
      adaptive_size = true
    }
  },
}
