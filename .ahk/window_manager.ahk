#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; List of window sizes (relative to screen width)
sizes := [[0, 0.25], [0, 0.33], [0, 0.50], [0, 0.67], [0, 0.75], [0, 1], [0.25, 0.75], [0.33, 0.66], [0.50, 0.50], [0.67, 0.33], [0.75, 0.25]]

getMonitorFromWindow(win := 'A') {
    WinGetPos &wx, &wy, &ww, &wh, win
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

getScreenInfo(mon) {
    left := top := right := bottom := 0
    MonitorGetWorkArea(mon, &left, &top, &right, &bottom)
    return { x: left, y: top, w: right - left, h: bottom }
}

getWindowInfo(win := 'A') {
    wx := wy := ww := wh := 0
    WinGetPos(&wx, &wy, &ww, &wh, win)
    return { x: wx, y: wy, w: ww, h: wh }
}

findClosestIndex(wx, ww, sx, sw) {
    minDiff := 1e9
    idx := 1
    winCenterXr := (wx + ww / 2 - sx) / sw
    winWr := ww / sw
    for i, size in sizes {
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
    left := top := right := bottom := 0
    MonitorGetWorkArea(mon, &left, &top, &right, &bottom)
    nx := left + x
    ny := top + y
    WinMove(Floor(nx), Ceil(ny), Floor(w), Ceil(h), win)
}

cycleSizes(direction) {
    winID := WinGetID('A')
    minmax := WinGetMinMax(winID)
    if (minmax == 1) {
        WinRestore(winID)
    }
    mon := getMonitorFromWindow(winID)
    s := getScreenInfo(mon)
    w := getWindowInfo()
    idx := findClosestIndex(w.x, w.w, s.x, s.w)
    winCenterXr := (w.x + w.w / 2 - s.x) / s.w
    winWr := w.w / s.w
    size := sizes[idx]
    targetCenterXr := size[1] + (size[2] / 2)
    targetWr := size[2]
    diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
    if diff > 0.01 {
        nextIdx := idx
    } else {
        if direction > 0 {
            nextIdx := Mod(idx, sizes.Length) + 1
        } else {
            nextIdx := Mod(idx - 2 + sizes.Length, sizes.Length) + 1
        }
    }
    newsize := sizes[nextIdx]
    x := s.x + newsize[1] * s.w
    y := s.y
    w := newsize[2] * s.w
    h := s.h
    moveWindowRelativeToMonitor(x - s.x, y - s.y, w, h)
}

moveToNextScreen() {
    winID := WinGetID('A')
    minmax := WinGetMinMax('A')
    if (minmax == 1) {
        WinRestore(winID) ; restore size so that it's kept across screens
    }

    count := MonitorGetCount()
    WinGetPos(&wx, &wy, &ww, &wh, winID)
    curMon := getMonitorFromWindow(winID)
    nextMon := curMon + 1
    if nextMon > count {
        nextMon := 1
    }
    w := getWindowInfo(winID)
    cs := getScreenInfo(curMon)
    ns := getScreenInfo(nextMon)
    rw := ns.w / cs.w
    rh := ns.h / cs.h
    nx := (w.x - cs.x) * rw
    ny := (w.y - cs.y) * rh
    nw := w.w * rw
    nh := w.h * rh 
    moveWindowRelativeToMonitor(nx, ny, nw, nh, winID, nextMon)
    if (minmax == 1){
        WinMaximize('A')
    }
}



^!Left:: cycleSizes(-1)
^!Right:: cycleSizes(1)
^!Up:: WinMaximize('A')
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
