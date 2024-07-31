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

local function cycleSizes(sizes, direction)
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentFrame = win:frame()
  local screenFrame = win:screen():frame()

  -- Calculate current relative size
  local currentXr = (currentFrame.x - screenFrame.x) / screenFrame.w
  local currentWr = currentFrame.w / screenFrame.w

  local log = hs.logger.new('CycleSizes', 'info')
  log.i("Current xr:", currentXr, "Current wr:", currentWr)

  -- Find the current size index in the cycle
  local currentIndex
  for i, size in ipairs(sizes) do
      if math.abs(currentXr - size[1]) < 0.01 and math.abs(currentWr - size[2]) < 0.01 then
          currentIndex = i
          break
      end
  end

  -- If current size not found in list, use the first or last size based on direction
  if not currentIndex then
      currentIndex = direction > 0 and 0 or #sizes + 1
  end

  -- Calculate the next index based on direction
  local nextIndex = ((currentIndex - 1 + direction) % #sizes) + 1
  local nextSize = sizes[nextIndex]

  -- Apply the new size
  resizeWindow(nextSize[1], nextSize[2])
end


local function moveToNextScreen()
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end

local modifiers = {"cmd", "ctrl"}

local sizes = {
  {0, 0.25},
  {0, 0.33},
  {0, 0.50},
  {0, 0.67},
  {0, 0.75},
  {0, 1},
  {0.25, 0.75},
  {0.33, 0.66},
  {0.50, 0.50},
  {0.67, 0.33},
  {0.75, 0.25},
}

hs.hotkey.bind(modifiers, "up", function() resizeWindow(0, 1) end)
hs.hotkey.bind(modifiers, "down", function() moveToNextScreen() end)
hs.hotkey.bind(modifiers, "left", function() cycleSizes(sizes, -1) end)
hs.hotkey.bind(modifiers, "right", function() cycleSizes(sizes, 1) end)
