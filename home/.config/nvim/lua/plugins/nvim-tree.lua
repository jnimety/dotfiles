return {
  'nvim-tree/nvim-tree.lua',
  cmd = "NvimTreeFindFileToggle",
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<c-n>', "<cmd>NvimTreeFindFileToggle<cr>", desc = 'nvim-tree Toggle' },
  },
  opts = {
    view = {
      adaptive_size = true
    }
  },
}
