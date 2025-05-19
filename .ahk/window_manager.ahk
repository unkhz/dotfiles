#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; List of window sizes (relative to screen width)
sizes := [ [0, 0.25], [0, 0.33], [0, 0.50], [0, 0.67], [0, 0.75], [0, 1], [0.25, 0.75], [0.33, 0.66], [0.50, 0.50], [0.67, 0.33], [0.75, 0.25] ]
currentIndex := 1

; Helper: Get active window and screen info
getScreenInfo(ByRef wx, ByRef wy, ByRef ww, ByRef wh, ByRef sx, ByRef sy, ByRef sw, ByRef sh) {
    WinGetPos, wx, wy, ww, wh, A
    SysGet, Monitor, MonitorWorkArea, % (WinGetMonitor(A))
    sx := MonitorLeft
    sy := MonitorTop
    sw := MonitorRight - MonitorLeft
    sh := MonitorBottom - MonitorTop
}

; Helper: Find closest size index
findClosestIndex(wx, ww, sx, sw) {
    global sizes
    minDiff := 1e9
    idx := 1
    winCenterXr := (wx + ww/2 - sx) / sw
    winWr := ww / sw
    Loop % sizes.Length() {
        s := sizes[A_Index]
        targetXr := s[1]
        targetWr := s[2]
        targetCenterXr := targetXr + (targetWr/2)
        diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
        if (diff < minDiff) {
            minDiff := diff
            idx := A_Index
        }
    }
    return idx
}

; Cycle window sizes
cycleSizes(direction) {
    global sizes, currentIndex
    getScreenInfo(wx, wy, ww, wh, sx, sy, sw, sh)
    idx := findClosestIndex(wx, ww, sx, sw)
    ; If not close, snap to closest
    winCenterXr := (wx + ww/2 - sx) / sw
    winWr := ww / sw
    s := sizes[idx]
    targetCenterXr := s[1] + (s[2]/2)
    targetWr := s[2]
    diff := Abs(winCenterXr - targetCenterXr) + Abs(winWr - targetWr)
    if (diff > 0.01) {
        nextIdx := idx
    } else {
        if (direction > 0) {
            nextIdx := Mod(idx, sizes.Length()) + 1
        } else {
            nextIdx := Mod(idx - 2 + sizes.Length(), sizes.Length()) + 1
        }
    }
    s := sizes[nextIdx]
    x := sx + s[1]*sw
    y := sy
    w := s[2]*sw
    h := sh
    WinMove, A, , x, y, w, h
}

; Move window to next monitor
moveToNextScreen() {
    WinGet, winID, ID, A
    SysGet, count, MonitorCount
    WinGetPos, wx, wy, ww, wh, ahk_id %winID%
    SysGet, curMon, Monitor, % (WinGetMonitor("ahk_id " winID))
    nextMon := curMon + 1
    if (nextMon > count) {
        nextMon := 1
    }
    SysGet, Monitor, MonitorWorkArea, %nextMon%
    x := MonitorLeft
    y := MonitorTop
    WinMove, ahk_id %winID%, , x, y, ww, wh
}

; Hotkeys: Ctrl+Win+Arrow
^#Left::cycleSizes(-1)
^#Right::cycleSizes(1)
^#Up::WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
^#Down::moveToNextScreen()
