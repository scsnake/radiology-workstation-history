#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
SendMode,Input
OnExit,OnExit
#include <RisImpax>
#include <SetWindowsHookEx>
#include <SetTimerF>

noduleDataCsvFolder:=A_ScriptDir "\"

thisChartNo:="5______"
gosub importNoduleData


return

importNoduleData:
/*
noduleData[ chartNo "_pbb", nodule_id, col=1 to 5]
*/
noduleData:=[]
Loop, % noduleDataCsvFolder "\*.csv"
{
	SplitPath,A_LoopFileLongPath,,,,fileName
	csvData:=[]
	Loop,read,% A_LoopFileLongPath
	{
		if(Trim(A_LoopReadLine)="")
			continue
		lineData:=[]
		Loop,Parse,A_LoopReadLine,csv
			lineData.push(Trim(A_LoopField))
		csvData.push(lineData)
	}

	noduleData["" fileName]:=csvData
}
dicomInfos:=[]
dicomInfos["" thisChartNo "_pbb"]:= {origin: {x: -150.5, y: -11.2______, z: -10.3______}, spacing: {x: 0.599609375,y: 0.599609375,z: 1.0}, dimension: {x:512, y:512}}
gosub noduleCoordConvert
return

noduleCoordConvert:
; will convert by python in the future
noduleCoord:=[]
for chartNo, data in noduleData {
	d:=[], dicomInfo:=dicomInfos[chartNo]
	for i, coord in data
		d.push(pacsPos:=coordToPacsPos(dicomInfo.origin
			, coord:={x: coord.4,y: coord.3,z: coord.2}
			, dicomInfo.spacing))
	noduleCoord["" chartNo]:=d
}
;~ MsgBox % exploreobj(d)
gosub noduleCoordCollect
return

noduleCoordCollect:
nodulePos:=[]
for chartNo, data in noduleCoord {
	d:=[]
	for i, coord in data
		if IsObject(d[coord.z])
			d[coord.z].push({x: coord.x, y: coord.y})
		else
			d[coord.z]:=[{x: coord.x, y: coord.y}]
	nodulePos["" chartNo]:=d
}
return

ShowKeyList:

return

mouseWinInfo:
MouseGetPos,mx,my,mWin,mCon,2
framePos:=[]
WinGetPos,fX,fY,fW,fH,ahk_id %mCon%
framePos.x:=fX, framePos.y:=fY, framePos.w:=fW, framePos.h:=fH
return


~LButton::
gosub mouseWinInfo
winget,ProcessName,ProcessName,ahk_id %mWin%
if(ProcessName!="impax-client-main.exe")
	return
thisChartNo:=getImpaxChartNo(mWin)
, allImNo:=getImpaxAllImNo(mWin)
gosub hookMouse
return

~LButton up::
gosub unhookMouse
return

#IfWinActive,ahk_exe impax-client-main.exe



;~ ~PGUP::
;~ ~PGDN::
~WheelDown::
~WheelUp::
gosub mouseWinInfo
thisChartNo:=getImpaxChartNo(mWin)
, allImNo:=getImpaxAllImNo(mWin)
, SEIM:=getSEIM(mWin)
, showTag(SEIM.2)
return
#IfWinActive

tagOnImpax:

return

showTag(imgNo){
	global  framePos, allImNo, thisChartNo, dicomInfos, nodulePos
	;~ static prvImgNo
	if !(pacsPos:=nodulePos[thisChartNo "_pbb", imgNo]){
		ToolTip % imgNo
		;~ prvImgNo:=imgNo
		return
	}
	;~ if(prvImgNo=imgNo)
		;~ return
	;~ prvImgNo:=imgNo
	WinClose,ahk_group tag
	targets:=[], anyTag:=false
	for i, pos in pacsPos
		target:=coordToPacs(framePos, {pacsNo: pos}, dicomInfos[thisChartNo "_pbb"])
		,targets.push(target)
		,anyTag:=true
	if(anyTag)
		tagGUI(targets)
}

tagGUI(targets){
	th:=ahkthread("
	(%
	Alias(targets, " getvar(targets) ")
	for i, target in targets {
		gui,%i%: Default
		gui,+lastfound +ToolWindow -Border -Caption +AlwaysOnTop
		gui,Color,EEEEEE
		winset,TransColor,EEEEEE
		gui,Font,s50
		gui,Add,Text,cFFFFFF,↖
		gui,show,% ""x"" target.x+10 "" y"" target.y+10 "" noactivate""
	
	}
	ready:=1
	Sleep 3000
	ExitApp
	)")
	while !th.ahkgetvar("ready")
		Sleep -1
}

__MouseMove(nCode, wParam, lParam){
	global  framePos, allImNo, thisChartNo, dicomInfos, nodulePos
	static prvImgNo
	
	If nCode<0
		return CallNextHookEx(nCode, wParam, lParam)
	x:=NumGet(lParam+0, 0, "int")
	,y:=NumGet(lParam+0, 4, "int")
	,imgNo:=impaxMousePosToImNo(y, framePos.y, framePos.h, allImNo)
	
	if(imgNo!=prvImgNo)
		SetTimerFn("showTag", -1, [imgNo])
	
	prvImgNo:=imgNo
	
	Return CallNextHookEx(nCode, wParam, lParam)
}

hookMouse:
hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("__MouseMove", "Fast"))
return

unhookMouse:
UnhookWindowsHookEx(hHookMouse)
return

esc::
OnExit:
gosub unhookMouse
ExitApp