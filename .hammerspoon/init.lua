local function resizeWindow(xr, wr)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local currentFrame = win:screen():frame()

  f.x = currentFrame.x + currentFrame.w * xr
  f.y = currentFrame.y
  f.w = currentFrame.w * wr
  f.h = currentFrame.h
  win:setFrame(f, 0)
end

local function moveToNextScreen()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end

local modifiers = {"cmd", "ctrl"}

hs.hotkey.bind(modifiers, "up", function() resizeWindow(0, 1) end)
hs.hotkey.bind(modifiers, "down", function() moveToNextScreen() end)
hs.hotkey.bind(modifiers, "left", function() resizeWindow(0, 0.5) end)
hs.hotkey.bind(modifiers, "right", function() resizeWindow(0.5, 0.5) end)
