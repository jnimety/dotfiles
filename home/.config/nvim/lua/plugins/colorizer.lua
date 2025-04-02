local filetypes = { "css", "scss" }

return {
  "NvChad/nvim-colorizer.lua",
  ft = filetypes,
  opts = {
    filetypes = filetypes,
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      css = false,
      rgb_fn = true,
      hsl_fn = true,
      mode = "virtualtext",
      names = false,
      sass = {
        enable = true,
        parsers = {
          RGB = true,
          RRGGBB = true,
          css = false,
          rgb_fn = true,
          hsl_fn = true,
          mode = "virtualtext",
          names = false,
        },
      },
      virtualtext = "",
    },
  },
}
