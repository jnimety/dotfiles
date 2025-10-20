return {
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    ---@class tokyonight.Config
    ---@field on_colors fun(colors: ColorScheme)
    ---@field on_highlights fun(highlights: tokyonight.Highlights, colors: ColorScheme)
    opts = {
      style = "night",

      styles = {
        sidebars = "transparent",
        floats = "tranparent",
      },
      transparent = true,

      ---@param highlights tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        highlights.CursorLine.bg = colors.bg
        highlights.CursorLineNr.bg = colors.bg
        highlights.LineNr.fg = colors.yellow
        highlights.LineNrAbove.fg = colors.fg_dark
        highlights.LineNrBelow.fg = colors.fg_dark
      end,
    },
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
