local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return {
  audible_bell = "Disabled",
  color_scheme = 'tokyonight-night',
  font = wezterm.font_with_fallback {
    { family = "Iosevka Term", stretch = "Expanded" },
    -- 'Source Code Pro',
    'Symbols Nerd Font Mono',
  },
  font_rules = {
    {
      intensity = 'Bold',
      font = wezterm.font('Iosevka Term', { weight = "Medium", stretch = "Expanded" }),
      -- font = wezterm.font('Source Code Pro', { weight = "Medium" }),
    },
  },
  font_size = 16.0,
  harfbuzz_features = { 'calt=0' },
  hide_tab_bar_if_only_one_tab = true,
  -- window_background_opacity = 0.95,
  selection_word_boundary = " \t\n{}[]()\"'`,;:", -- default: " \t\n{}[]()\"'`"
  window_decorations = "RESIZE",
  window_frame = {
    font_size = 16.0,
  },
  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  },
}
