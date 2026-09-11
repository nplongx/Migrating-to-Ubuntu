local wezterm = require 'wezterm'
local config = {}

config.bypass_mouse_reporting_modifiers = 'SHIFT'

config.mouse_bindings = {
  -- Change triple-click to select a semantic zone instead of a full line
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
  },
  -- Open hyperlink with Ctrl+Left click
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
