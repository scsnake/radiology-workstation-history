﻿﻿; control
SendMode Input
#Hotstring EndChars -()[]{}:;'"\,.?!`n `t
SetDefaultMouseSpeed, 0
setTitleMatchMode 2

Loop
{
  Sleep 60000
  hWnd := WinExist("A")
  if (A_TimeIdle > 30000)
  {
    if WinExist("ahk_class com.pohai.client.application.MainFrame")
    {
      WinActivate,
      WinGetPos, X, Y, W, H
      ImageSearch, x, y, 0, 0, W, H, images\RIS_query.gif
      if !ErrorLevel
      {
        CoordMode, Mouse, Screen
        MouseGetPos, xpos, ypos 
        CoordMode, Mouse, Relative
        MouseClick, left,  %x%, %y%, 1
        CoordMode, Mouse, Screen
        MouseMove, xpos, ypos 
        CoordMode, Mouse, Relative
        WinActivate, ahk_id %hWnd%
      }
    }
  }
}
