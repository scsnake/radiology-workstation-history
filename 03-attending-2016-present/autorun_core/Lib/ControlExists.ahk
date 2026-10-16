ControlExists(hwnd){
	ControlGet, OutputVar, Hwnd,,, ahk_id %hwnd%
	return hwnd && outputVar=hwnd
}