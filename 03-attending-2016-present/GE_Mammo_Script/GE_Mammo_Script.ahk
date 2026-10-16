#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#include <SetWindowsHookEx>

OnExit,OnExit
return


#IfWinActive,ahk_exe MammoWorkstation.exe
~Ctrl::
;~ ToolTip % "Hook"
;~ MouseGetPos,ox
if !GetKeyState("Lbutton" ,"P") || hHookMouse
	return
 hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("__MouseMove", "Fast"))
 SetTimer,unhookRoutine,1000
return

unhookRoutine:
if GetKeyState("Lbutton" ,"P")
	return
~LButton Up::
~Ctrl up::
unhook:
;~ ToolTip % "UnHook"
if (hHookMouse)
	UnhookWindowsHookEx(hHookMouse), hHookMouse:=0
SetTimer,unhookRoutine,Off
return


#IfWinActive

__MouseMove(nCode, wParam, lParam){
	Critical
	global ox
	
	If nCode || !(wParam = 0x200)
		return CallNextHookEx(nCode, wParam, lParam)
	
	VarSetCapacity(lpPoint,8)
	,DllCall("GetCursorPos", "Uint", &lpPoint)
	,lx := NumGet(lpPoint, 0, "Int")
	,ly := NumGet(lpPoint, 4, "Int")
	,mx := NumGet(lParam+0, 0, "Int")
	,my := NumGet(lParam+0, 4, "Int")
	,mx := lx
	,my := ly + (mx-lx) + (my-ly)
	,DllCall("SetCursorPos", "Int", mx, "Int", my)
	,NumPut(mx, lParam+0, 0, "Int")
	,NumPut(my, lParam+0, 4, "Int")
	;~ ,SystemCursor("Off")  ; not work on impax
	return 1
}

OnExit:
gosub unhook
ExitApp
return



;~ esc::ExitApp