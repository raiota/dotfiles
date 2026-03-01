local wezterm = require("wezterm")

local module = {}

function module.apply_to_config(config)
	-- window
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
	config.text_background_opacity = 1.0
	config.macos_window_background_blur = 10
	config.win32_system_backdrop = "Acrylic"

	-- font
	config.font = wezterm.font({
		family = "UDEV Gothic NF",
		weight = "Medium",
	})
	config.font_size = 12

	-- tab
	config.use_fancy_tab_bar = true
	config.tab_bar_at_bottom = false
	config.hide_tab_bar_if_only_one_tab = false
	config.tab_and_split_indices_are_zero_based = false
	config.show_tab_index_in_tab_bar = true
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 24
	wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
		local background = "#6e738d"
		local foreground = "#cad3f5"
		local edge_background = "none"

		if tab.is_active then
			background = "#ed8796"
			foreground = "#363a4f"
		end

		local edge_foreground = background

		local title = "  "
			.. tab.tab_index
			.. ": "
			.. wezterm.truncate_right(tab.active_pane.title, max_width - 1)
			.. "  "

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

	-- theme
	config.color_scheme = "Catppuccin Macchiato"
	config.colors = {
		tab_bar = {
			background = "none",
		},
	}
end

return module
