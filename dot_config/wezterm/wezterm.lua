local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- font
config.font = wezterm.font({
	family = "UDEV Gothic NF",
	weight = "Medium",
})
config.font_size = 12

-- appearance
config.tab_bar_at_bottom = true
-- -- override catppuccin macchiato
local custom = wezterm.color.get_builtin_schemes()["Catppuccin Macchiato"]
custom.tab_bar.background = "#b7bdf8"
custom.tab_bar.active_tab.bg_color = "#8bd5ca"
config.color_schemes = { ["Myppuccin"] = custom }
config.color_scheme = "Myppuccin"

config.window_background_opacity = 0.9
config.text_background_opacity = 0.5

config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.hide_tab_bar_if_only_one_tab = false

config.max_fps = 120

wezterm.on("gui-startup", function()
	local _, main_pane, window = wezterm.mux.spawn_window({})

	local right_pane = main_pane:split({ direction = "Right", size = 86 })
	right_pane:split({ direction = "Bottom" })

	main_pane:activate()
end)

return config
