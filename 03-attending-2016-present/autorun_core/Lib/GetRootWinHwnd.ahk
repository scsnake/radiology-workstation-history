GetRootWinHwnd(controlHwnd){
	return DllCall("user32\GetAncestor", "Ptr",controlHwnd, "UInt",2, "Ptr") ;GA_ROOT := 2
}