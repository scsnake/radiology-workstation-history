isDebug(){
	static t:="__AHK__OutputDebug"
	OutputDebug,% t
	winwait,% "Stream viewer ahk_class AutoHotkeyGUI",,0.3
	if h:=WinExist("Stream viewer ahk_class AutoHotkeyGUI") {
		ControlGetText,Text,Edit1,% "ahk_id " h 
		if InStr(Text, t){
			WinClose,% "ahk_id " h
			return true
		}
	}
		
}