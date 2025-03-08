-- Pull in the wezterm API
local wezterm = require 'wezterm'
local io = require("io")
local os = require("os")
local config = wezterm.config_builder()
-- This will hold the configuration.
local function get_user_home()
    if package.config:sub(1, 1) == '\\' then
        -- Windows
        return os.getenv("USERPROFILE")
    else
        -- Unix-based (Linux/macOS)
        return os.getenv("HOME")
    end
end
local function pick_random_background(folder)
    local handle
    if package.config:sub(1, 1) == '\\' then
        -- Windows
        handle = io.popen('dir "' .. folder .. '" /b')
    else
        -- Unix-based (Linux/macOS)
        handle = io.popen('ls "' .. folder .. '"')
    end

    if handle ~= nil then
        local files = handle:read("*a")
        handle:close()

        local images = {}
        for file in string.gmatch(files, "[^\r\n]+") do
            table.insert(images, file)
        end

        if #images > 0 then
            if package.config:sub(1, 1) == '\\' then
                -- Windows
                return folder .. "\\" .. images[math.random(#images)]
            else
                -- Unix-based (Linux/macOS)
                return folder .. "/" .. images[math.random(#images)]
            end
        else
            return nil
        end
    end
end
local user_home = get_user_home()
local brightness = 0.03
local background_folder = user_home .. '/.config/bg'
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Tokyo Night'
config.window_padding = {
    left = '0',
    right = '0',
    top = '0',
    bottom = '0',
}
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font 'ComicShannsMono Nerd Font'
config.font_size = 18
config.front_end = "OpenGL"
config.prefer_egl = true
config.max_fps = 144
-- default background
local bg_image = user_home .. "/.config/bg/d.jpg"
config.window_background_image = bg_image
-- end image setting
-- config.window_background_opacity = 0.9
config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = brightness,

    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 1.0,

    -- You can adjust the saturation also.
    saturation = 1.0,
}
-- keys
config.keys = {
    {
        key = "b",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window)
            bg_image = pick_random_background(background_folder)
            if bg_image then
                window:set_config_overrides({
                    window_background_image = bg_image,
                })
                wezterm.log_info("New bg:" .. bg_image)
            else
                wezterm.log_error("Could not find bg image")
            end
        end),
    },
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
                window_background_image = bg_image
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
                window_background_image = bg_image
            })
        end),
    },
}
-- and finally, return the configuration to wezterm
return config
