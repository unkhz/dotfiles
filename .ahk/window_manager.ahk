#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

; List of window sizes (relative to screen width)
sizes := [[0, 0.25], [0, 0.33], [0, 0.50], [0, 0.67], [0, 0.75], [0, 1], [0.25, 0.75], [0.33, 0.66], [0.50, 0.50], [0.67, 0.33], [0.75, 0.25]]

getMonitorFromWindow(win := 'A') {
    WinGetPos &wx, &wy, &ww, &wh, win
    count := MonitorGetCount()
    Loop count {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        if (wx >= left && wx < right && wy >= top && wy < bottom) {
            return A_Index
        }
    }
    return 1 ; fallback to primary monitor
}

getScreenInfo() {
    wx := wy := ww := wh := 0
    WinGetPos &wx, &wy, &ww, &wh, 'A'
    mon := getMonitorFromWindow('A')
    left := top := right := bottom := 0
    MonitorGet(mon, &left, &top, &right, &bottom)
    sx := left
    sy := top
    sw := right - left
    sh := bottom - top
    return { wx: wx, wy: wy, ww: ww, wh: wh, sx: sx, sy: sy, sw: sw, sh: sh }
}

findClosestIndex(wx, ww, sx, sw) {
    minDiff := 1e9
    idx := 1
    winCenterXr := (wx + ww / 2 - sx) / sw
    winWr := ww / sw
    for i, s in sizes {
        targetXr := s[1]
        targetWr := s[2]
        targetCenterXr := targetXr + (targetWr / 2)
        diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
        if diff < minDiff {
            minDiff := diff
            idx := i
        }
    }
    return idx
}

cycleSizes(direction) {
    info := getScreenInfo()
    idx := findClosestIndex(info.wx, info.ww, info.sx, info.sw)
    winCenterXr := (info.wx + info.ww / 2 - info.sx) / info.sw
    winWr := info.ww / info.sw
    s := sizes[idx]
    targetCenterXr := s[1] + (s[2] / 2)
    targetWr := s[2]
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
    s := sizes[nextIdx]
    x := info.sx + s[1] * info.sw
    y := info.sy
    w := s[2] * info.sw
    h := info.sh
    WinMove x, y, w, h, 'A'
}

moveToNextScreen() {
    winID := WinGetID('A')
    count := MonitorGetCount()
    WinGetPos &wx, &wy, &ww, &wh, winID
    curMon := getMonitorFromWindow(winID)
    nextMon := curMon + 1
    if nextMon > count {
        nextMon := 1
    }
    left := top := right := bottom := 0
    MonitorGet(nextMon, &left, &top, &right, &bottom)
    WinMove left, top, ww, wh, winID
}

^!Left:: cycleSizes(-1)
^!Right:: cycleSizes(1)
^!Up:: WinMove 0, 0, A_ScreenWidth, A_ScreenHeight, 'A'
^!Down:: moveToNextScreen()