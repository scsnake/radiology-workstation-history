#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#persistent
onexit,onexit

SetTimer,checkOpenInIE,2000
return

checkOpenInIE:
if !hwnd:=WinExist("Opening in IE ... ahk_class MozillaWindowClass")
	return
WinGetTitle,title,ahk_id %hwnd%
RegExMatch(title, "Opening in IE \.\.\. (.+)$", match)
if !InStr(url:=match1, "SESSION="){
	SetTimer,checkOpenInIE,500
}else{
	WinActivate,ahk_id %hwnd%
	WinWaitActive,ahk_id %hwnd%,,1
	send ^w
	run % "iexplore.exe """ url """"
	SetTimer,checkOpenInIE,2000
}
return

;~ esc::
;~ OnExit:
;~ ExitApp