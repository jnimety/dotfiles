return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
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
    "marko-cerovac/material.nvim",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      contrast = {
        terminal = false, -- Enable contrast for the built-in terminal
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
      },

      styles = { -- Give comments style such as bold, italic, underline etc.
        comments = { --[[ italic = true ]]
        },
        strings = { --[[ bold = true ]]
        },
        keywords = { --[[ underline = true ]]
        },
        functions = { --[[ bold = true, undercurl = true ]]
        },
        variables = {},
        operators = {},
        types = {},
      },

      plugins = { -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        "dap",
        -- "dashboard",
        "gitsigns",
        -- "hop",
        -- "indent-blankline",
        -- "lspsaga",
        -- "mini",
        -- "neogit",
        -- "nvim-cmp",
        -- "nvim-navic",
        "nvim-tree",
        "nvim-web-devicons",
        -- "sneak",
        "telescope",
        -- "trouble",
        "which-key",
      },

      disable = {
        colored_cursor = false, -- Disable the colored cursor
        borders = false, -- Disable borders between verticaly split windows
        background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        term_colors = false, -- Prevent the theme from setting terminal colors
        eob_lines = false, -- Hide the end-of-buffer lines
      },

      high_visibility = {
        lighter = false, -- Enable higher contrast text for lighter style
        darker = false, -- Enable higher contrast text for darker style
      },

      lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

      async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

      custom_colors = nil, -- If you want to everride the default colors, set this to a function

      custom_highlights = {}, -- Overwrite highlights with your own
    },
    config = function(_, opts)
      require("material").setup(opts)

      vim.g.material_style = "deep ocean"
      vim.cmd.colorscheme("material")
    end,
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
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
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      dark_variant = "main", -- 'main' | 'moon'
      dim_nc_background = true,
    },
    config = function(_, opts)
      local scheme = require("rose-pine")
      scheme.setup(opts)

      vim.cmd([[ highlight Identifier guifg=#eb6f92 ]])
    end,
  },

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
        -- sidebars = "transparent",
        floats = "tranparent",
      },
      transparent = false,

      ---@param highlights tokyonight.Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors)
        highlights.LineNr = {
          fg = colors.yellow,
        }
        highlights.CursorLineNr = {
          fg = colors.yellow,
          bg = "#0a0a0a",
        }
        highlights.CursorLine = {
          bg = "#0a0a0a",
        }
        highlights.WinSeparator = {
          fg = colors.yellow,
          bg = colors.black,
        }
      end,
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
