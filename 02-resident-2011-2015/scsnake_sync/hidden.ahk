#persistent
#NoTrayIcon
#persistent
#SingleInstance,force
SetTitleMatchMode,2
DetectHiddenWindows,on
;~ #include <socket>
#include <TrayIconInfo>
;~ #include <jxon>
;~ #include <httprequest>
#include <winvisible>
;~ #include <checkUpdate>
SplitPath,% A_ScriptFullPath,,,,nameNoExt
hiddenArr:=[]
onexit,onexit
hiddenProcArr:=["CCProxy.exe", "TeamViewer.exe", "tv_w32.exe", "Proxifier.exe", "FileZilla Server Interface.exe", "hfs (http file server).exe", "hfs.exe", "AnyDesk.exe"]
gosub hideTrayIconAndProcess
settimer,hideTrayIconAndProcess,10000

settimer,checkHidden,1000
hiddenWin:={"TeamViewer ahk_class #32770":0,"ahk_class BuddyWindow ahk_exe TeamViewer.exe":0,"ahk_class Proxifier32Cls ahk_exe Proxifier.exe":0,"ahk_class TmainFrm ahk_exe hfs (http file server).exe}":0,"AnyDesk ahk_exe AnyDesk.exe":0}
gosub EnsureOpen
SetTimer,ensureOpen,60000
return

EnsureOpen:
Loop % A_ScriptDir "\*.exe"
{
	if (A_LoopFileName=nameNoExt ".exe")
		continue
	;~ process,Exist,% A_LoopFileName
	;~ if ErrorLevel
		;~ continue
	if WinExist("ahk_exe " A_LoopFileName)
		continue
	run % A_LoopFileLongPath
}
return

hideTrayIconAndProcess:
DetectHiddenWindows,off
winminimize,ahk_class FileZilla Server Main Window
DetectHiddenWindows,on
hideIcon:=true
toggleTrayIconAndProcess:
TrayIconInfo:=TrayIcon_GetInfo()
for k,v in TrayIconInfo {
	if !(process:=v.Process)
		continue
	if HasVal(hiddenProcArr, process)
		TrayIcon_Hide(v.IDcmd, v.Tray, hideIcon)
}
;~ for k,v in hiddenProcArr
	;~ if hideIcon
		;~ hideProcess(v)
	;~ else 
		;~ showProcess(v)
return

~^#+!q::
ExitApp

~^#+!s::
hideIcon:=!hideIcon
gosub toggleTrayIconAndProcess
if (!hideIcon) {
	for hiddenTitle,count in hiddenWin {
		winget,list,list,% hiddenTitle
		Loop % list
			if !winvisible(winexist("ahk_id " list%a_index%))
				winshow,% "ahk_id " list%a_index%
	}
		
}else{
	for hiddenTitle,count in hiddenWin {
		winget,list,list,% hiddenTitle
		
		Loop % list
			if winvisible(winexist("ahk_id " list%a_index%)){
				hiddenWin[hiddenTitle]:=0
				WinHide,% "ahk_id " list%a_index%
			}
				
	}
		
}
return

checkHidden:
if !hideIcon
	return
for hiddenTitle,count in hiddenWin {
	if(winvisible(winexist(hiddenTitle)))
		hiddenWin[hiddenTitle]:=count+1
	if (count>60) {
		hiddenWin[hiddenTitle]:=0
		winhide,% hiddenTitle
	}
}	
return

OnExit:
hideIcon:=false
gosub toggleTrayIconAndProcess
for hiddenTitle,count in hiddenWin {
	winget,list,list,% hiddenTitle
	Loop % list
		if !winvisible(winexist("ahk_id " list%a_index%))
			winshow,% "ahk_id " list%a_index%
}
ExitApp


