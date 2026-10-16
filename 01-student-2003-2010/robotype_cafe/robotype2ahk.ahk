SetTitleMatchMode,2

win:="RoboType ahk_exe RoboType.exe"

str:="",prior:=""
controlsend,syslistview321,{home},% win
loop {
	ControlGet, t, List, Selected, SysListView321, % win 
	RegExMatch(t,"(\w+)",match)
	if (prior=match1)
		break
	prior:=match1
	str.="::/" match1 "::"
	controlgettext,t,Edit1,% win
	if instr(t,"`n")
		str.="`r`n(`r`n" t "`r`n)`r`n"
	else
		str.=trim(t) "`r`n"
	controlsend,syslistview321,{down},% win
	
}

fileappend,% str,jw.ahk,utf-8