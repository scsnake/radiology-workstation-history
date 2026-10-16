#include <EBMViewer>
SetBatchLines,-1
CoordMode,mouse,Screen
SetTitleMatchMode,2
DetectHiddenWindows,On
SendMode Input
#SingleInstance,force
#Persistent
#InputLevel, 0
#InstallKeybdHook
#InstallMouseHook
process,Priority,,h
OnExit,OnExit

ebm:=new EBMViewer
gosub assignHotkey

return

assignHotkey:
defaultHotkey:=ImportHotkeyIni("EBMhelperHotkey_default.ini")
,userHotkey:=ImportHotkeyIni("EBMhelperHotkey.ini")
,HotkeyToTag:=[]
Hotkey,IfWinActive,ahk_class TViewerForm 
for k,v in userHotkey {
	i:=A_Index
	for x,y in v {
		if (y!=""){
			try
				Hotkey,% InStr(y,"$")=1?y:"$" y,EBMhotkey
			HotkeyToTag["" y]:=[i, A_Index, k, x]
		}
	}
}
Hotkey,IfWinActive
return

EBMHotkey:
thisHotkey:=RegExReplace(A_ThisHotkey, "^\$", "")
,tag:=HotkeyToTag["" thisHotkey]
if((originalHotkey:=defaultHotkey[tag[3], tag[4]])!=""){ ;replaced hotkey
	StringLower,originalHotkey,originalHotkey
	send % originalHotkey
}else if !InStr(tag[3], "工具列"){
	ebm.SelectTool(tag[1] "." tag[2])
}else if (tag[3]="工具列1"){
	ebm.SelectTool2(tag[2])
}else if (tag[3]="工具列2"){
	ebm.PopupMenuWin(tag[2])
}
return

;~ esc::
OnExit:
ExitApp

