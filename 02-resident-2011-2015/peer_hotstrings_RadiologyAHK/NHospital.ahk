﻿﻿; for N Hospital routine
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon

#Include include\common.ahk
;#Include include\YLH-login.ahk
;#Include include\Impax6.ahk
#Include include\Impax5.ahk
#Include include\cheatsheet.ahk

!Pause::Run awake.ahk
