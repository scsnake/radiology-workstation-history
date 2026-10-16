#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;~ SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;~ SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
#NoTrayIcon
;~ coordMode,mouse,screen
;~ coordMode,pixel,screen
;~ coordMode,tooltip,screen
;~ SetTitleMatchMode,2
;~ setformat,float,0.2
;~ SetControlDelay,-1


if fileexist(shortcut:=A_Desktop "\Impax 6.lnk")
	exitapp

if fileexist(impax:=A_ProgramFiles "\Agfa\Impax client\Appstart.exe")
	FileCreateShortcut,% impax,% shortcut
else if fileexist(impax:="D:\Program files\Agfa\Impax client\Appstart.exe")
	FileCreateShortcut,% impax,% shortcut
else
	msgbox % "Not install Impax 6 yet ?"

exitapp