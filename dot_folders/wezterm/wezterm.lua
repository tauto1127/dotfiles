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
-- ウィンドウを閉じてもアプリを終了しない
config.quit_when_all_windows_are_closed = false

-- ウィンドウタイトルのカスタマイズ
config.window_decorations = "TITLE | RESIZE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32

-- ウィンドウタイトルのフォーマット設定
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  return pane.title
end)

-- and finally, return the configuration to wezterm
return config
