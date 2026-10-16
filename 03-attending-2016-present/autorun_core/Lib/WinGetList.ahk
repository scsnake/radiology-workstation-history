#include <WinVisible>
WinGetList(WinTitle="",WinText="",ExcludeTitle="",ExcludeText="", WinVisible=true){
	if WinTitle is Integer
		WinTitle:="ahk_id " WinTitle
	winget,list,list,% WinTitle,% WinText,% ExcludeTitle,% ExcludeText
	ret:=[]
	loop % list 
		if (WinVisible(hwnd:=list%a_index%)==WinVisible || WinVisible=="off")
			ret.push(list%a_index%)
	return ret
}