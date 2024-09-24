local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.default_prog = { wezterm.home_dir .. "/.nix-profile/bin/zsh" }
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 12.0
config.pane_focus_follows_mouse = true
config.window_decorations = "RESIZE"
config.initial_rows = 75
config.initial_cols = 245
config.window_background_opacity = 0.97
config.macos_window_background_blur = 25
config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.bold_brightens_ansi_colors = "BrightAndBold"
config.default_cursor_style = "SteadyBlock"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.inactive_pane_hsb = {
	brightness = 0.7,
}

-- use CTRL+^ in vim
config.use_dead_keys = false

-- color scheme
config.colors = {
	tab_bar = {
		background = "#0d0e10",
		active_tab = {
			bg_color = "#0d0e10",
			fg_color = "#b39ec1",
		},
		inactive_tab = {
			bg_color = "#0d0e10",
			fg_color = "#c7c7c7",
		},
	},

	foreground = "#c7c7c7",
	background = "#0d0e10",

	selection_fg = "#d9dde7",
	selection_bg = "#4d5568",

	ansi = {
		"#1f1f1f",
		"#9f4845",
		"#8fada2",
		"#ebc17f",
		"#85bef9",
		"#a2779c",
		"#6d9c9f",
		"#d0d0d0",
	},
	brights = {
		"#555555",
		"#bf625f",
		"#94a862",
		"#f9dfb2",
		"#afd4fb",
		"#c279b8",
		"#83b3aa",
		"#e1e1e1",
	},
}

return config
