#singleinstance,ignore
SetBatchLines,-1
CoordMode,mouse,screen

interval:=20
toggle:=1
mouseHooks:=[]
return


~lctrl::
if(a_thishotkey=a_priorhotkey && a_TimeSincePriorHotkey<500){
	if (toggle:=!toggle){
		Tooltip % "啟動！"
	}else{
		tooltip % "暫停！"
	}
}
return


~lbutton::
if !toggle
	return
mousegetpos,ox,oy
yy:=oy
mouseHooks.push(hHookMouse:=SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast")))

return

~lbutton up::

for k,v in mouseHooks
		UnhookWindowsHookEx(v)
return

~^!q::
;~ esc::
onexit:
for k,v in mouseHooks
		UnhookWindowsHookEx(v)
ExitApp
return


MouseHook(nCode, wParam, lParam){
	static lx,ly
	global hHookMouse,ox,oy,yy,interval
	Critical
	if (wParam=0x202){
		UnhookWindowsHookEx(hHookMouse)
		return CallNextHookEx(nCode, wParam, lParam)
	}
	If nCode || !(wParam = 0x200)
		return CallNextHookEx(nCode, wParam, lParam)
	;~ VarSetCapacity(lpPoint,8)
	;~ ,DllCall("GetCursorPos", "Uint", &lpPoint)
	;~ ,lx := NumGet(lParam+0, 0, "Int")
	ly := NumGet(lParam+0, 4, "Int")
	
	;~ ,DllCall("SetCursorPos", "Int", lx, "Int", ly)
	;~ NumPut(lx, lParam+0, 0, "Int")
	;~ NumPut(ly, lParam+0, 4, "Int")
	
	if (abs(delta:=ly-yy)>interval){
		count:=floor(abs(delta)/interval)
		,yy+=interval*count*(delta>0?1:-1)
		;~ msgbox % yy
		send % (delta>0?"{pgdn":"{pgup") " " count "}"
		;~ tooltip % ox "," oy ";" lx "," ly ";" yy ";" sent
	}
	
	
	return CallNextHookEx(nCode, wParam, lParam)
}