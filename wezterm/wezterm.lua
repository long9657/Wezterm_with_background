-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local brightness = 0.1
-- This will hold the configuration.
-- This is where you actually apply your config choices
local function get_user_home()
	-- Check if the OS is Windows or Unix-based
	local home_dir = os.getenv("HOME") or os.getenv("USERPROFILE") or os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH")
	return home_dir
end
local user_home = get_user_home()
local bg_image = user_home .. "/.config/bg/f.jpg"

-- For example, changing the color scheme:
config.window_padding = {
	left = "0",
	right = "0",
	top = "0",
	bottom = "0",
}
-- config.colors = require("cyberdream")
config.color_scheme = "Tokyo Night"
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("ComicShannsMono Nerd Font", { weight = "Regular" })
config.font_size = 14
config.front_end = "OpenGL"
config.prefer_egl = true
config.max_fps = 144
-- config.window_background_opacity = 0.95 -- Set window opacity to 95% for better readability
config.window_background_image = bg_image
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.5,
}
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = brightness,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	hue = 1.0,

	-- You can adjust the saturation also.
	saturation = 0.8,
}
config.keys = {
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window)
			brightness = math.min(brightness + 0.01, 1.0)
			window:set_config_overrides({
				window_background_image_hsb = {
					brightness = brightness,
					hue = 1.0,
					saturation = 0.8,
				},
				window_background_image = bg_image,
			})
		end),
	},
	{
		key = "<",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window)
			brightness = math.max(brightness - 0.01, 0.01)
			window:set_config_overrides({
				window_background_image_hsb = {
					brightness = brightness,
					hue = 1.0,
					saturation = 0.8,
				},
				window_background_image = bg_image,
			})
		end),
	},
}
-- and finally, return the configuration to wezterm
return config
