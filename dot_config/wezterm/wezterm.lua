local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local appearance = require 'appearance'
local keybinds = require 'keybinds'

config.max_fps = 120
config.scrollback_lines = 10000

appearance.apply_to_config(config)
keybinds.apply_to_config(config)

return config
