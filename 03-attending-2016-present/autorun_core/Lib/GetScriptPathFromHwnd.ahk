GetScriptPathFromHwnd(hwnd) {
    WinGetTitle, win, ahk_id %hwnd%
    Return RegExMatch(win, ".*(?= - AutoHotkey v[0-9\.]+)", ret) ? ret : win
}