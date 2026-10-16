﻿﻿﻿; EnvSet
EnvGet, session, SESSIONNAME
EnvGet, domain, USERDOMAIN
;IfInString, session, RDP
;  EnvSet, I, RDP
;else IfInString, domain, HW
; EnvSet, I, YLH
;else IfInString, domain, YL
; EnvSet, I, YLH
;else
EnvSet, I, NH

EnvSet, HIS, 1
EnvSet, Approval, -1
EnvSet, Idtype, 1

EnvGet, HIS, HIS
EnvGet, I, I
EnvGet, Approval, Approval
EnvGet, Idtype, Idtype

; control
SendMode Input
#Hotstring EndChars -()[]{}:;'"\,.?!`n `t
SetDefaultMouseSpeed, 0
setTitleMatchMode 2
SetControlDelay, 20

; break in the pars interarticularis

;#w::Run D:\Program Files\Mozilla Firefox\Firefox.exe
;#p::Run D:\Program Files\pietty0327.exe



^!r::
;  WinActivate, 172.22.111
;  SendPlay, ^!r
  reload
return

^!q::ExitApp
#q::
  Run, net use /delete * /y
return

!Esc::
  WinMinimize, A
  SoundSet, +1, , mute
return

^!e::
  FileSelectFile, SelectedFile, 3, %A_WorkDIR%, Open a file, Text Documents (*.txt; *.doc; *.ahk)
  if SelectedFile =
    MsgBox, The user didn't select anything.
  else
    Run, NotePad %SelectedFile%
  WinWaitClose, Notepad
  Sleep 500
  Reload
return

^m::SoundSet, +1, , mute
;^Pause::hotkey toggle
^!Down::SoundSet -10
^!Up::SoundSet +10

;SetTimer, CheckShutdown, 60000
SetTimer, CheckShutdown, 1000
return

CheckShutdown:
   if A_TimeIdle > 1 ; 900
   ;DllCall("powrprof.dll\SetSuspendState","Int",0)
   ;ExitApp
return

!`::MouseClick, left

^!BackSpace::
  InputBox, T, Min,,,100,120
  if (T < 1)
    Sleep, 300000
  else
    Sleep, 60000 * T
  Shutdown, 6
return

^!+BS::
  Shutdown, 6
return


#1::SendInput 018490
#2::SendInput 094810
#3::SendInput cyyang
#4::SendInput quanto
#0::SendInput physician@hospital.example.com
#a::SendInput 018490{Tab}094810{Tab 2}{Up 7}{Down 3}{Tab}{Enter}
#z::SendInput 018490{Tab}094810{Tab 2}{Up 7}{Down 4}{Tab}{Enter}
