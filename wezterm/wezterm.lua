-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- This will hold the configuration.
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.window_padding = {
	left = "0",
	right = "0",
	top = "0",
	bottom = "0",
}
config.colors = require("cyberdream")
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("ComicShannsMono Nerd Font", { weight = "Regular" })
config.font_size = 14
config.front_end = "OpenGL"
config.prefer_egl = true
config.max_fps = 144
config.window_background_opacity = 0.9 -- Set window opacity to 95% for better readability

-- and finally, return the configuration to wezterm
return config
