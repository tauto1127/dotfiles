local double_press = require("ctrlDoublePress")

local open_wezterm = function()
  local appName = "WezTerm"
  local app = hs.application.get(appName)

  if app == nil or app:isHidden() then
    hs.application.launchOrFocus(appName)
  else
    if app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  end
end

local open_ticktick = function()
  local appName = "TickTick"
  local app = hs.application.get(appName)

  if app == nil or app:isHidden() then
    hs.application.launchOrFocus(appName)
  else
    if app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  end
end

double_press.timeFrame = 0.3
double_press.action = open_wezterm

-- ticktick
hs.hotkey.bind({ "ctrl", "cmd" }, "t", function()
  open_ticktick()
end)
