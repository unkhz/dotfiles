#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; List of window sizes (relative to screen width)
largeScreenWindowSizes := [[0, 0.25], [0, 0.333], [0, 0.50], [0, 0.667], [0, 0.75], [0, 1], [0.25, 0.75], [0.333, 0.667], [0.50, 0.50], [0.667, 0.333], [0.75, 0.25]]
smallScreenWindowSizes := [[0, 0.333], [0, 0.50], [0, 0.667], [0, 1], [0.333, 0.667], [0.50, 0.50], [0.667, 0.333]]

getMonitorFromWindow(win := 'A') {
    WinGetPos(&wx, &wy, &ww, &wh, win)
    count := MonitorGetCount()
    Loop count {
        MonitorGetWorkArea(A_Index, &left, &top, &right, &bottom)
        cx := wx + (ww / 2)
        cy := wy + (wh / 2)
        if (cx >= left && cx < right && cy > top && cy < bottom) {
            return A_Index
        }
    }
    return 1 ; fallback to primary monitor
}

getScreenInfo(mon := getMonitorFromWindow()) {
    left := top := right := bottom := 0
    MonitorGetWorkArea(mon, &left, &top, &right, &bottom)
    return { x: left, y: top, w: right - left, h: bottom }
}

getWindowInfo(win := 'A') {
    wx := wy := ww := wh := 0
    WinGetPos(&wx, &wy, &ww, &wh, win)
    return { x: wx, y: wy, w: ww, h: wh }
}

getWindowSizes() {
    screen := getScreenInfo()
    if (screen.w > 2048) {
        return largeScreenWindowSizes
    } else {
        return smallScreenWindowSizes
    }
}

findClosestIndex(wx, ww, sx, sw) {
    minDiff := 1e9
    idx := 1
    winCenterXr := (wx + ww / 2 - sx) / sw
    winWr := ww / sw
    windowSizes := getWindowSizes()
    for i, size in windowSizes {
        targetXr := size[1]
        targetWr := size[2]
        targetCenterXr := targetXr + (targetWr / 2)
        diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
        if diff < minDiff {
            minDiff := diff
            idx := i
        }
    }
    return idx
}

moveWindowRelativeToMonitor(x, y, w, h, win := 'A', mon := getMonitorFromWindow('A')) {
    screen := getScreenInfo(mon)
    WinMove(screen.x + x, screen.y + y, w, h, win)
}

cycleSizes(direction) {
    winID := WinGetID('A')
    minMax := WinGetMinMax(winID)
    if (minMax == 1) {
        WinRestore(winID)
    }
    mon := getMonitorFromWindow(winID)
    screen := getScreenInfo(mon)
    win := getWindowInfo()
    idx := findClosestIndex(win.x, win.w, screen.x, screen.w)
    winCenterXr := (win.x + win.w / 2 - screen.x) / screen.w
    winWr := win.w / screen.w
    windowSizes := getWindowSizes()
    size := windowSizes[idx]
    targetCenterXr := size[1] + (size[2] / 2)
    targetWr := size[2]
    diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
    if diff > 0.01 {
        nextIdx := idx
    } else {
        if direction > 0 {
            nextIdx := Mod(idx, windowSizes.Length) + 1
        } else {
            nextIdx := Mod(idx - 2 + windowSizes.Length, windowSizes.Length) + 1
        }
    }
    nextSize := windowSizes[nextIdx]
    moveWindowRelativeToMonitor(nextSize[1] * screen.w, 0, nextSize[2] * screen.w, screen.h)
}

moveToNextScreen() {
    winID := WinGetID('A')
    minMax := WinGetMinMax('A')
    if (minMax == 1) {
        WinRestore(winID) ; restore size so that it's kept across screens
    }

    monCount := MonitorGetCount()
    WinGetPos(&wx, &wy, &ww, &wh, winID)
    curMon := getMonitorFromWindow(winID)
    nextMon := curMon + 1
    if nextMon > monCount {
        nextMon := 1
    }
    
    win := getWindowInfo(winID)
    currentScreen := getScreenInfo(curMon)
    nextScreen := getScreenInfo(nextMon)
    ratio := { w: nextScreen.w / currentScreen.w, h: nextScreen.h / currentScreen.h }
    moveWindowRelativeToMonitor(
        (win.x - currentScreen.x) * ratio.w,
        (win.y - currentScreen.y) * ratio.h,
        win.w * ratio.w, win.h * ratio.h,
        winID,
        nextMon
    )

    if (minMax == 1) {
        WinMaximize('A')
    }
}

toggleMinMax() {
    minMax := WinGetMinMax('A')
    if (minMax == 1) {
        WinRestore('A')
    } else {
        WinMaximize('A')
    }
}


^!Left:: cycleSizes(-1)
^!Right:: cycleSizes(1)
^!Up:: toggleMinMax()
^!Down:: moveToNextScreen()


;Cycle App Windows
cycleWindows() {
    activeWin := WinGetID("A")
    activePID := WinGetPID("A")
    winList := []
    activeWinIndex := 1
    for win in WinGetList() {
        pid := WinGetPID(win)
        if pid == activePID {
            winList.Push(win)
            if activeWin == win {
                activeWinIndex := winList.Length
            }
        }
    }

    if winList.Length > 1 {
        nextIndex := 1
        if activeWinIndex < winList.Length {
            nextIndex := activeWinIndex + 1
        }
        WinActivate(winList[nextIndex])
    }
}

!`:: cycleWindows()
