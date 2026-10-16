﻿﻿SetDefaultMouseSpeed, 0
setTitleMatchMode 2
SetControlDelay, 20
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

!x::
  WinWait, NotifyOtherDoctor.aspx
  WinActivate, NotifyOtherDoctor.aspx
  WinWaitActive, NotifyOtherDoctor.aspx
  SendInput, {Ctrl Down}{End}{Ctrl Up}
  ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, images/VS.png
  MouseClick, left, %FoundX%, %FoundY%
  WinWait, The page at ihisaw.hospital-n.local says:, 
  IfWinNotActive, The page at ihisaw.hospital-n.local says:, , WinActivate, The page at ihisaw.hospital-n.local says:, 
  WinWaitActive, The page at ihisaw.hospital-n.local says:, 
  WinClose
  WinWait, NotifyOtherDoctor.aspx
  WinActivate, NotifyOtherDoctor.aspx
  WinWaitActive, NotifyOtherDoctor.aspx
  WinClose

;  Sleep 1000
;  SendInput, {Alt Down}{F4}{Alt Up}
;  Sleep 100
;  SendInput, {Alt Down}{F4}{Alt Up}
return

