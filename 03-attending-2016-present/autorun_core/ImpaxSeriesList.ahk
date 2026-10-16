#persistent
#notrayicon
#SingleInstance,Force
DetectHiddenWindows,on
#include <WM_COPYDATA>
#include <JXON>

OnMessage(0x4a, "ON_WM_COPYDATA")

setbatchlines,-1

RISImpaxRegister([ {app: "Impax", type: "State", hwnd: thisHwnd, msg: {msg: 0x8001}, func: "ImpaxStateChange", initStart: 1}])

gui,main: +hwndguihwnd
WinSetTitle,% "ahk_id " guihwnd,,% "ImpaxSeriesList_main"
SetTimer,exit,3000


#include <RisImpax>
monitorInfo:=monitorInfo()

;~ Hotkey,IfWinActive,ahk_exe impax-client-main.exe
;~ Hotkey,tab,tab

return


#IfWinActive,ahk_exe impax-client-main.exe
toggleSeriesList:
MouseGetPos,,,mouseOnWin
if inArray(mouseOnWin, seriesListStored)
	SetTimer,toggleSeriesList,-500
else{
	toggleSeriesList(ImpaxState,"off","all",monitorInfo)
	PostMessage,0x2022,,,,RazerNaga_main ahk_class AutoHotkeyGUI
}
return

tab::
showSeriesList:
if (ImpaxState[1]!=2 && ImpaxState[2,4]!=1)
	return
seriesListStored:=toggleSeriesList(ImpaxState, "toggle", "all", monitorInfo)
gosub adjustSeriesListWin
SetTimer,toggleSeriesList,-3000
winactivate,% "ahk_id " ImpaxState[2,1]
return 

return
#IfWinActive



adjustSeriesListWin:
seriesListHwnd:=[]
if IsObject(seriesListStored){
	Loop % (seriesListStored.maxindex())/2
		seriesListHwnd.push(seriesListStored[A_Index*2])
}else{
	for k,v in seriesList:=getSeriesList()
		seriesListHwnd.push(v[1])
}

seriesListMaxHeight:=0
for k,v in seriesListHwnd {
	if !WinExist("ahk_id " seriesListWin:=v)
		continue
	;~ if winvisible(seriesListWin:=v.1) {
		WinGetPos,seriesListx,seriesListy,seriesListw,seriesListh,ahk_id %seriesListWin%
		winset,AlwaysOnTop,on,ahk_id %seriesListWin%
		seriesListAt:=whichMonitor(seriesListx+seriesListw/2,seriesListy+seriesListh/2,monitorInfo).1
		if(seriesListh>seriesListMaxHeight)
			seriesListMaxHeight:=seriesListh
		;~ if(seriesListh<30){
			;~ WinMove,ahk_id %seriesListWin%,,,,,270
		;~ }
		MouseGetPos,mx,my
		mouseAt:=whichMonitor(mx,my, monitorInfo).1
		;~ MsgBox % seriesListWin
		if(seriesListAt=mouseAt || seriesList.maxindex()=1){
			Loop 10 {
				;~ WinMove,ahk_id %seriesListWin%,,% seriesListx,% targetY:=((my-seriesListh)>seriesListy?(my-seriesListh):seriesListy)+Floor(seriesListh/2)
				WinMove,ahk_id %seriesListWin%,,% monitors[mouseAt].l,% targetY:=my-130,% monitors[mouseAt].w,% 500
				WinGetPos,,y,,,ahk_id %seriesListWin%
				if (y=targetY)
					break
				;~ ToolTip % y "," my "," targetY "," seriesListh "," seriesListy
				Sleep -1
			}
			MouseGetPos,mx2,
			MouseMove,mx2,my
			;~ ToolTip % seriesListWin ;16161c
		}
	;~ }else{
		;~ SetTimer,adjustSeriesListWinBack,off
	;~ }
}
;~ ToolTip % seriesListMaxHeight
for k,v in seriesListHwnd {
	WinMove,% "ahk_id " v,,,,,% seriesListMaxHeight<100?400:seriesListMaxHeight
}

return


adjustSeriesListWinBack:
	WinMove,ahk_id %seriesListWin%,,% seriesListx,% seriesListy
return



exit:
if !WinExist("scsnake_autorun_main ahk_class AutoHotkeyGUI")
	ExitApp
return



On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
	global newX,newY,frame
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 19) ; CMD_CURRENTPOSITION
	{
		try
			j:=JXON_load(str)
		catch
			return
		
		if(j.haskey("command")){
			try 
			SetTimer,% j.command,-1
		}

	}
}




inArray(ele, arr){
	for k,v in arr
		if(ele=v)
			return true
	return false
}



impaxStateChange(){
	global 
	ImpaxState:=ImpaxOpened()
}