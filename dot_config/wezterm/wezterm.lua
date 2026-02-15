local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.max_fps = 120

-- appearance
-- -- window
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 16,
	right = 16,
	top = 16,
	bottom = 16,
}
config.window_frame = {
	font = wezterm.font("UDEV Gothic NF", { weight = "Bold" }),
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_opacity = 0.9
config.text_background_opacity = 0.5
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"

-- -- font
config.font = wezterm.font({
	family = "UDEV Gothic NF",
	weight = "Medium",
})
config.font_size = 12

-- -- tab
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 24
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#6e738d"
	local foreground = "#cad3f5"
	local edge_background = "none"

	if tab.is_active then
		background = "#ed8796"
		foreground = "#363a4f"
	end

	local edge_foreground = background

	local title = "  " .. tab.tab_index .. ": " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "  "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = wezterm.nerdfonts.ple_ice_waveform_mirrored },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = wezterm.nerdfonts.ple_ice_waveform },
	}
end)

-- -- theme
config.color_scheme = "Catppuccin Macchiato"
config.colors = {
	tab_bar = {
		background = "none",
	},
}

--wezterm.on("gui-startup", function()
--	local _, main_pane, window = wezterm.mux.spawn_window({})
--
--	local right_pane = main_pane:split({ direction = "Right", size = 86 })
--	right_pane:split({ direction = "Bottom" })
--
--	main_pane:activate()
--end)
return config
