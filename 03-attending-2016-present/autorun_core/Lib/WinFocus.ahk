WinFocus(win, control="", WinWaitActive=1){
	WinShow,% "ahk_id " win
	winget,MinMax,MinMax,% "ahk_id " win
	if (MinMax=-1)
		WinRestore,% "ahk_id " win
	winactivate,% "ahk_id " win
	WinWaitActive,% "ahk_id " win,,% WinWaitActive
	if control
		ControlFocus,,% "ahk_id " control
}