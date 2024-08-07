-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.keys = {
	{
		key = "¥",
		mods = "ALT",
		action = wezterm.action.SendKey({ key = "\\" }),
	},
}

config.hide_tab_bar_if_only_one_tab = true
-- This is where you actually apply your config choices

config.color_scheme = "tokyonight"
-- For example, changing the color scheme:
--config.color_scheme = "Belafonte Day" config.color_scheme = "Belge (terminal.sexy)"
--config.color_scheme = "AdventureTime"
--config.color_scheme = "Bespin (light) (terminal.sexy)"
--config.color_scheme = "Birds Of Paradise (Gogh)"
-- and finally, return the configuration to wezterm
return config
