WinGetRoot(hwnd){
	static GA_ROOT:=2
	return DllCall("GetAncestor", "Ptr", hwnd, "UINT", GA_ROOT)
}