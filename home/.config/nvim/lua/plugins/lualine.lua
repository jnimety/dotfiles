return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    {
      icons_enabled = true,
      theme = 'auto',
    },
    sections = {
      lualine_a = {
        {
          'filename',
          path = 1,
        }
      }
    }
  }
}
