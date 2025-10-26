local wezterm = require("wezterm")

-- local mux = wezterm.mux
-- not needed if your window tiling manager does it for you
-- wezterm.on("gui-startup", function(cmd)
--   local _, _, window = mux.spawn_window(cmd or {})
--   window:gui_window():maximize()
-- end)

return {
  audible_bell = "Disabled",
  color_scheme = "tokyonight_night",
  enable_wayland = false,
  warn_about_missing_glyphs = false,
  font = wezterm.font_with_fallback({
    { family = "Iosevka Term", stretch = "Expanded" },
    "Symbols Nerd Font Mono",
  }),
  font_rules = {
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font("Iosevka Term", { weight = "Medium", stretch = "Expanded", style = "Oblique" }),
    },
    {
      intensity = "Bold",
      font = wezterm.font("Iosevka Term", { weight = "Medium", stretch = "Expanded" }),
    },
    {
      italic = true,
      font = wezterm.font("Iosevka Term", { weight = "Regular", stretch = "Expanded", style = "Oblique" }),
    },
  },
  font_size = 24.0,
  harfbuzz_features = { "calt=0" },
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 0.83,
  selection_word_boundary = " \t\n{}[]()\"'`,;:", -- default: " \t\n{}[]()\"'`"
  window_decorations = "NONE",
  skip_close_confirmation_for_processes_named = {
    "bash",
    "sh",
    "zsh",
    "fish",
    "tmux",
    "nu",
    "cmd.exe",
    "pwsh.exe",
    "powershell.exe",
    "top",
  },
  window_frame = {
    font_size = 24.0,
  },
  window_padding = {
    left = "1cell",
    right = "1cell",
    top = "0.5cell",
    bottom = "0.5cell",
  },
}
