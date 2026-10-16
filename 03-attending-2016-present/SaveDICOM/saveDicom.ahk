#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#include <risimpax>
DefaultDir:="C:\temp"
;~ ,thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))

;~ ,RISImpaxRegister([ {app: "Impax", type: "State", hwnd: thisHwnd, msg: {msg: 0x8001}, func: "ImpaxStateChange", initStart: 1}])
;~ impaxState:=impaxOpened()
;~ ToolTip % "Loaded!"
;~ SetTimer,ToolTip,-1000
return

;~ impaxStateChange(){
	;~ global 
	;~ ImpaxState:=ImpaxOpened()
;~ }

ToolTip:
ToolTip
return

#IfWinExist,ahk_exe impax-client-main.exe
^d::
impaxState:=ImpaxOpened()
,date:=getImpaxExamDate(impaxState[2,1])[1]
,chartNo:=getImpaxChartNo(impaxState[2,1])
,RegExMatch(date, "(\d+)\/(\d+)\/(\d+)", m)

send {F2}
Sleep 200
clipboard:= chartNo "_" m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3
send ^v
return

^+s::
^s::
MouseGetPos,mx,my,Win
winget,pName,ProcessName,ahk_id %win%
if (pName!="impax-client-main.exe")
	return

winactivate,ahk_id %win%
send {RButton}
winwait,DisplayMenuForm ahk_exe impax-client-main.exe,,3
if ErrorLevel
	return
Menu:=WinExist("DisplayMenuForm ahk_exe impax-client-main.exe")
winactivate,ahk_id %menu%
Loop {
	MouseGetPos,,,win
	if (win=Menu)
		break
	if A_Index > 20
		return
	Sleep 100
}
WinGetPos,x,y,,,ahk_id %menu%
Loop,% DefaultDir "\*.dcm"
	FileDelete,% A_LoopFileLongPath	


if InStr(A_ThisHotkey, "+")
	Mouseclick,l,% x+167,% y+480,1,0
	;~ MouseMove,% x+167,% y+470,1
else
	Mouseclick,l,% x+217,% y+480,1,0
	;~ MouseMove,% x+167,% y+480,1
;~ return
Mouseclick,l,% x-10,% y-10,1,1


;~ FileCreateDir,% targetDir:=A_ScriptDir "\" chartNo "_" RegExReplace(SubStr(date, 1,10), "\D","") 
FileCreateDir,% tmpDir:=A_ScriptDir "\" a_now




waitNoFile:=0
Loop {
	if FileExist(DefaultDir "\*.dcm"){
		filemove,% DefaultDir "\*.dcm",% tmpDir,1
		waitNoFile:=0
	}else {
		waitNoFile++
		t:=A_TickCount
		Count := 0
		Loop,files,%tmpDir%\*,FDR
			if !InStr(FileExist(A_LoopFileLongPath), "D")
				Count++
		if(A_TickCount-t<500)
			Sleep % 500- (A_TickCount-t)
	}
	if waitNoFile>3
		break
}
;~ run % "explorer """ A_ScriptDir """"
impaxState:=ImpaxOpened()
,date:=getImpaxExamDate(impaxState[2,1])[1]
,chartNo:=getImpaxChartNo(impaxState[2,1])

,RegExMatch(date, "(\d+)\/(\d+)\/(\d+)", m)

targetDir:=A_ScriptDir "\" chartNo "_" m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3

if(date="" || chartNo=""){
	targetDir:=tmpDir "_Done"
}else{
	
	while FileExist(targetDir)
		targetDir:=targetDir "_"
	FileMoveDir,% tmpDir,% targetDir,R
}
;~ Run,% "explorer.exe /e`, /select`," targetDir
;~ clipboard:=listcontrols(Menu)
;~ exportStrip:=getNetControl2(Menu, "", "exportStrip")[1]
;~ WinGetPos,x,y,w,h,% "ahk_id " exportStrip
;~ MouseMove,% x+10,% y+10,0
;~ Sleep 100
;~ exports:=acc_children(acc_objectfromwindow(exportStrip))
;~ ,exports:=acc_children(exports[1])
;~ ,loc:=acc_location(exports[2])
;~ mouseclick,left,% loc.x+10,% loc.y+10,1,0

ToolTip % "Done!`nTotal " Count " files!"
SetTimer,ToolTip,-5000
return
#IfWinExist


;~ esc::ExitApp





