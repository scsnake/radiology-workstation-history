CloseOtherYCHAHK(){
	DetectHiddenWindows,on

	;~ gui,ych_ahk_group:new,+ToolWindow,YCH_AHK_GROUP
	;~ MsgBox % WinGetTitle(____ychgrouphwnd)
	;~ MsgBox % WinExist("YCH_AHK_GROUP ahk_class AutoHotkeyGUI")
	;~ winget,list,list,YCH_AHK_GROUP ahk_class AutoHotkeyGUI
	;~ MsgBox % list
	
	for k,v in ["YCH_AHK_main","YCH_MAMMO_AHK_main","YCH_XR_main","YCH_BMD_main"]
	{
		if !(h:=WinExist(v " ahk_class AutoHotkeyGUI"))
			continue
		if ((pid:=WinGet("PID", h))!=thisPid){
			winget,l,list,ahk_pid %pid%
			Loop % l 
				PostMessage,0x10101,,,,% "ahk_id " l%a_index%
			taskkill(pid)
		}
	}

}