return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    ---@class tokyonight.Config
    ---@field on_colors fun(colors: ColorScheme)
    ---@field on_highlights fun(highlights: tokyonight.Highlights, colors: ColorScheme)
    opts = {
      dim_inactive = false,
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "tranparent",
      },
      transparent = true,

      on_colors = function(colors)
        colors.fg_gutter = colors.fg_dark
      end,

      ---@param highlights tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        highlights.CursorLine = { bg = colors.bg }
        highlights.CursorLineNr = { fg = colors.yellow, bg = colors.bg }
        highlights.LineNr = { fg = colors.yellow }
        highlights.LspReferenceRead = { bg = colors.bg_highlight }
        highlights.LspReferenceText = { bg = colors.bg_highlight }
        highlights.LspReferenceWrite = { bg = colors.bg_highlight }
        highlights.WinSeparator = { fg = colors.yellow }
      end,

      cache = true,

      ---@type table<string, boolean|{enabled:boolean}>
      plugins = {
        -- enable all plugins when not using lazy.nvim
        -- set to false to manually enable/disable plugins
        all = package.loaded.lazy == nil,
        -- uses your plugin manager to automatically enable needed plugins
        -- currently only lazy.nvim is supported
        auto = true,
        -- add any plugins here that you want to enable
        -- for all possible plugins, see:
        --   * https://github.com/folke/tokyonight.nvim/tree/main/lua/tokyonight/groups
        -- telescope = true,
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)

      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
