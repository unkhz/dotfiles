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

local modifiers = {"cmd", "ctrl"}

hs.hotkey.bind(modifiers, "up", function() resizeWindow(0, 1) end)
hs.hotkey.bind(modifiers, "left", function() resizeWindow(0, 0.5) end)
hs.hotkey.bind(modifiers, "right", function() resizeWindow(0.5, 0.5) end)
