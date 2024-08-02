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

local log = hs.logger.new('CycleSizes', 'debug')

local function cycleSizes(sizes, direction)
  local win = hs.window.focusedWindow()
  if not win then return end

  local currentFrame = win:frame()
  local screenFrame = win:screen():frame()

  -- Calculate current relative size and center point
  local windowCenterXr = (currentFrame.x + currentFrame.w / 2 - screenFrame.x) / screenFrame.w
  local windowWr = currentFrame.w / screenFrame.w

  log.i("Current xr:", windowCenterXr, "Current wr:", windowWr)

  -- Find the closest size index in the cycle
  local closestIndex
  local smallestDiff = math.huge
  for i, size in ipairs(sizes) do
      local targetXr = size[1]
      local targetWr = size[2]
      local targetCenterXr = targetXr + (targetWr / 2)

      -- The calculation of diff as the sum of the center position difference
      -- and the width difference is a simplification that serves as a
      -- reasonable approximation for overall similarity
      local diff = math.abs(windowCenterXr - targetCenterXr) + math.abs(windowWr - targetWr)

      if diff < smallestDiff then
          smallestDiff = diff
          closestIndex = i
      end
  end

  -- Determine the next index
  local nextIndex
  if smallestDiff > 0.01 then
      -- Align to the closest size if the window is not exactly there (+/- 1%)
      nextIndex = closestIndex
  else
      if direction == 1 then
        nextIndex = closestIndex % #sizes + 1
      else
        nextIndex = (closestIndex - 2 + #sizes) % #sizes + 1
      end
  end

  -- Apply the new size
  local newSize = sizes[nextIndex]
  win:move({x = screenFrame.x + newSize[1] * screenFrame.w,
            y = screenFrame.y,
            w = newSize[2] * screenFrame.w,
            h = screenFrame.h})
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
