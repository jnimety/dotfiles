return {
  {
    'ellisonleao/gruvbox.nvim',
    lazy = true,
    opts = {
      undercurl = false,
      underline = true,
      bold = true,
      italic = true,
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "hard", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = true,
      transparent_mode = false,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "light",
        percentage = 0.85,
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        -- For more plugins integrations: https://github.com/catppuccin/nvim#integrations
        cmp = true,
        fidget = true,
        gitsigns = true,
        telescope = true,
        treesitter = true,
        nvimtree = true,
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    }
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      dark_variant = 'main', -- 'main' | 'moon'
      dim_nc_background = true,
    },
    config = function(_, opts)
      local scheme = require "rose-pine"
      scheme.setup(opts)

      vim.cmd [[ highlight Identifier guifg=#eb6f92 ]]
    end
  },

  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.opt.termguicolors = true
      vim.o.background = "dark"

      vim.cmd.colorscheme "tokyonight-night"
    end,
  },
}
