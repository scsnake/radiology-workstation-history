getDllPath(mini=1){
	mini:=mini?"Mini":""
	if fileexist(path:=a_scriptdir "\AutoHotkey" mini ".dll")
		return path
	else if fileexist(path:=a_scriptdir "\..\AutoHotkey" mini ".dll")
		return path
	else if fileexist(path:=a_programfiles "\AutoHotkey\AutoHotkey" mini ".dll")
		return path
	else if fileexist(path:=a_mydocuments "\AutoHotkey" mini ".dll")
		return path
	else if fileexist(path:=a_mydocuments "\AutoHotkey\AutoHotkey" mini ".dll")
		return path
	else if fileexist(path:=substr(a_scriptdir,1,1) ":\scripts\AutoHotkey\AutoHotkey" mini ".dll")
		return path
	
}
