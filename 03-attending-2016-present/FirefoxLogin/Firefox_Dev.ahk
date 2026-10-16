﻿#include <Explorer_Get>
#include <Zip>
#include <acc>
CoordMode,mouse,Screen
SetTitleMatchMode,2
ComObjError(0)
SendMode,input
SetBatchLines,-1

MsgBox % WinExist("Google")
ExitApp
WinGet, fh, ID, ahk_class MozillaWindowClass
FF := Acc_ObjectFromWindow(fh)
ind:=0
for ch in acc_EnumChildren(FF)
	if (acc_GetRoleText(ch.accRole(0))="工具列") && acc_GetRoleText((tb:=Acc_Children(ch)[1]).accRole(0)="索引標籤清單")
		if (++ind>1)
			break
found:=0
for tab in Acc_EnumChildren(tb) {
	a:=tab.accName(0)
	;~ MsgBox % tab.accName(0)
   ;~ if InStr(tab.accName(0),"Add-ons"){
		;~ tab.accDoDefaultAction(0), found:=1
		;~ break
	;~ }
}



SetTimer,routine,500
return

~!z::
;~ WinActivate,dev ahk_class CabinetWClass
;~ WinWaitActive
hwnd:=WinExist("N_Portal_WebExt ahk_class CabinetWClass") | WinExist("N_Portal_WebExt ahk_class ExploreWClass") 
if(!hwnd){
	MsgBox % "Can't find N_Portal_WebExt folder"
	return
}

p:=Explorer_GetPath(hwnd)

if !FileExist(7z:=A_ScriptDir "\7z.exe"){
	MsgBox % "Can't find 7z.exe in the script folder"
	return
}

t:=0
Loop
	++t
until !FileExist(x:=p "\" t ".xpi")

RunWait,% clipboard:="""" 7z """ a -tzip """ p "\" t ".zip"" """ p "\*.*""",% p ; ,Hide
RunWait,% """" 7z """ d """ p "\" t ".zip"" *.xpi",% p ; ,Hide
RunWait,% """" 7z """ d """ p "\" t ".zip"" *.zip",% p ; ,Hide
RunWait,% """" 7z """ d """ p "\" t ".zip"" README.md",% p ; ,Hide
RunWait,% """" 7z """ d """ p "\" t ".zip"" LICENSE",% p ; ,Hide
Loop,% p "\*",1
{
	if InStr(FileExist(A_LoopFileLongPath),"D") && (A_LoopFileName!="for_dev_only"){
		RunWait,% """" 7z """ a -tzip """ p "\" t ".zip"" """ A_LoopFileLongPath """",% p ; ,Hide
		;~ Sleep 500
	}
}
;~ return
filemove,% p "\" t ".zip", % p "\" t ".xpi",1
SetTimer,openNewExplorer,-1
FileDelete,% p "\" t ".zip"

WinClose,Developer Tools ahk_class MozillaWindowClass

WinGet, fh, ID, ahk_class MozillaWindowClass
if(!fh){
	MsgBox % "FireFox not found!"
	WinClose,ahk_id %hwnd%
	return
}
winactivate,ahk_id %fh%
FF := Acc_ObjectFromWindow(fh)
ind:=0
for ch in acc_EnumChildren(FF)
	if (acc_GetRoleText(ch.accRole(0))="工具列") && acc_GetRoleText((tb:=Acc_Children(ch)[1]).accRole(0)="索引標籤清單")
		if (++ind>1)
			break
	

found:=0
for tab in Acc_EnumChildren(tb) {
	;~ MsgBox % tab.accName(0)
   if InStr(tab.accName(0),"Add-ons"){
		tab.accDoDefaultAction(0), found:=1
		break
	}
}
if(!found){
	send ^t
	Sleep 500
	send !d
	Sleep 500
	send about:addons
	Sleep 500
	send {Enter}
	Sleep 500
}
;~ WinActivate,ahk_id %hwnd%
if FileExist(x)
	WinClose,ahk_id %hwnd%
winwait,N_Portal_WebExt,,3
winactivate,ahk_id %fh%
return

;~ esc::ExitApp

openNewExplorer:
Run %COMSPEC% /c explorer.exe /select`, "%x%",, Hide
return


routine:
If dh:=WinExist("Incoming Connection ahk_class MozillaDialogClass"){
	winactivate,ahk_id %dh%
	ControlClick,x211 y181,ahk_id %dh%
	
}
return