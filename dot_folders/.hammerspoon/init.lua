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

local open_obsidian = function()
  local appName = "Obsidian"
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

local open_omnifocus = function()
  local appname = "OmniFocus"
  local app = hs.application.get(appname)

  if app == nil or app:isHidden() then
    hs.application.launchOrFocus(appname)
  else
    if app:isFrontmost() then
      app:hide()
    else
      app:activate()
    end
  end
end

double_press.timeFrame = 0.3
double_press.action = open_obsidian

-- ticktick
hs.hotkey.bind({ "ctrl", "cmd" }, "t", function()
  open_ticktick()
end)

-- wezterm
hs.hotkey.bind({ "alt" }, "space", function()
  open_wezterm()
end)

-- omnifocus
hs.hotkey.bind({ "ctrl", "cmd" }, "o", function()
  open_omnifocus()
end)
