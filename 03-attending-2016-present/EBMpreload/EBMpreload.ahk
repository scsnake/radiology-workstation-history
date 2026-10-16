#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
CoordMode,caret,screen
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
comobjerror(false)
onexit,onexit
;~ #NoTrayIcon
#include <RisImpax>
#include <PortalLib>
#include <EBMViewer>
#include <WindowShellEvent>

;~ WindowShellEvent("ShellProc")

;~ hch_id:="H00000"
;~ YLH_id:="Y00000"
;~ hch_pw:=YLH_pw:="MOCK_PASSWORD"

;~ loadKey:="F6"
;~ nextKey:="F3,F2,F1"

args:=ParseArg()
if RegExMatch(args[1], "i)([\w\d]{7})_(\w{10}\d)", m) {
	arg_chartno:=m1, arg_accNo:=m2, HiddenMode:=true
}

OnMessage(0x2020, "load")
,OnMessage(0x2021, "forceLoad")
,WindowShellEvent("ShellMessage")
,shellHook:=true
if (!HiddenMode)
	RISImpaxRegister([  {app: "Ris", type: "State", hwnd: thisHwnd, msg: {msg: 0x8000}, func: "RisStateChange", initStart: 1}
		, {app: "Ris", type: "AccNo", hwnd: thisHwnd, msg: {msg: 0x1122}, func: "accNoChanged", initStart: 100}])
else
	RisStateChange()
;~ gosub CloseHiddenIEs
GroupAdd,EBM,ahk_exe WEBVIE~1.exe
GroupAdd,EBM,ahk_exe WebViewerComSrvEC.exe

gosub readIni

;~ if (!HiddenMode){
Gui,+hwndguihwnd  +ToolWindow
gui,Font,s12,Verdana
gui,Add,button,gload,Open Study
gui,Add,button,gclose,Close All
gui,Show,NoActivate Center x-500 y-500,EBM Preload
WinGetPos,x,y,w,h,ahk_id %guihwnd%
WinMove,ahk_id %guihwnd%,,% A_ScreenWidth-w,0
gui,+AlwaysOnTop
	
;~ }else{
	;~ settimer,waitPwbClose,1000
;~ }


;~ DllCall( "RegisterShellHookWindow", UPtr,guihwnd) 
;~ MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" ) 
;~ OnMessage( MsgNum, "ShellMessage" ) 

garbage:=[]
gosub sethotkey
settimer,sethotkey,30000
HCHPwbTimeout:=YLHPwbTimeout:=CHUTPwbTimeout:=true
settimer,refreshPwb,600000
settimer,logoutHint,1000

AllEBMV:=[]
settimer,monitorEBMV,500

if(HiddenMode){
	openNextEBM(cAccNo:=arg_accNo, cChartNo:=arg_chartno)
}
;~ debug:=true
return 

monitorEBMV(){
	global AllEBMV
	winget,list,list,ahk_group EBM
	loop % list {
		h:=list%a_index%
		wingettitle,t,ahk_id %h%
		if regexmatch(t,"i)\b[YH\d]\w{5}\d\b",chartNo){
			if(AllEBMV.haskey(chartNo) && AllEBMV[chartNo]!=h && WinExist("ahk_id " AllEBMV[chartNo]))
				winclose,ahk_id %h%
			else
				AllEBMV[chartNo]:=h
		}
	}
	for k,v in AllEBMV
		if !winexist("ahk_id " v)
			AllEBMV.delete(k)
}


ShellMessage( wParam,lParam ) { 
	global shellHook, cChartNo, lastEBMhwnd, activeId, activatePriorTick
	if !shellHook || getkeystate("Shift")
		return
	
  If ( wParam=1 ) {
	winget,activeId,id,A
	WinGetTitle,t,ahk_id %lParam%
	WinGet,pName,ProcessName,ahk_id %lParam%
	if InStr(t, "UniWeb") && (pName~="i)WEBVIE~1.exe|WebViewerComSrvEC.exe") {
		;~ if !InStr(t, cChartNo)
		ShowToolTip("New EBM opened!",1000)
			WinHide,ahk_id %lParam%
		if !winvisible(h:=WinExist(cChartNo " ahk_group EBM"))
			WinShow,ahk_id %h%
		;~ winactivate,%cChartNo% ahk_group EBM
		settimer,checkCurrentEBM,500
		;~ activatePriorTick:=a_tickcount
		;~ settimer,activatePrior,-100
	}
		
  }
} 


checkCurrentEBM(){
	global cChartNo
	if (h:=WinExist(cChartNo " ahk_group EBM")) && !winvisible(h) {
		WinShow,ahk_id %h%
		winactivate,ahk_id %h%
		settimer,checkCurrentEBM,Off
	}
}

activatePrior:
if(a_tickcount-activatePriorTick > 5000)
	return
if winactive(nextChartNo " ahk_group EBM")  {
	winactivate,ahk_id %activeId%
	winhide,nextChartNo " ahk_group EBM"
}	
settimer,,-100
return


waitPwbClose:
return

CloseHiddenIEs:
winget,ielist,list,分院 MainPACS ahk_exe iexplore.exe
Loop % ielist
	if !winvisible(h:=ielist%a_index%) || 1
		WinClose,ahk_id %h%	
winget,ielist,list,分院 UniWeb ahk_exe iexplore.exe
Loop % ielist
	if !winvisible(h:=ielist%a_index%) || 1
		WinClose,ahk_id %h%	
return
Close:
settimer,waitLoadNext,Off
gosub CloseHiddenIEs
WinClose,ahk_group EBM
WinKill,ahk_group EBM
Run, %comspec% /c "taskkill /F /T /IM WEBVIE~1.exe",,Hide
Run, %comspec% /c "taskkill /F /T /IM WebViewerComSrvEC.exe",,Hide
winget,list,list,ahk_group EBM
Loop % list
{
	winget,pid,pid,% "ahk_id " list%a_index%
	Run, %comspec% /c "taskkill /F /T /PID " pid,,Hide
}
return

GuiClose:
gui,-AlwaysOnTop
MsgBox,4,,Exit?
IfMsgBox,Yes
	ExitApp
gui,+AlwaysOnTop
return


readIni:
ini:=A_ScriptDir "\EBMpreload.ini"
;~ IniRead,hch_id,% ini,Settings,hch_id
;~ IniRead,ylh_id,% ini,Settings,ylh_id
;~ IniRead,hch_pw,% ini,Settings,hch_pw
;~ IniRead,ylh_pw,% ini,Settings,ylh_pw
IniRead,loadKey,% ini,Settings,load
IniRead,nextKey,% ini,Settings,next
IniRead,hospitals,% ini,Settings,hospitals,% "H,Y"
vars:={"H": "hch", "Y": "ylh"}
Loop,parse,hospitals,`,
	if StrLen(askforportalidpw(0,true,A_LoopField, false))>2
		var:=vars[A_LoopField]
		,%var%_id:=loginId
		,%var%_pw:=loginPw
		,loginId:=loginPw:MOCK_PASSWORD""
		,%var%_info_ok:=true
return

sethotkey:
Hotkey,IfWinActive,ahk_exe Menu.exe
Hotkey,% loadKey,load,on
;~ Loop,parse,nextKey,`,
	;~ Hotkey,% "~*" A_LoopField,next,on
Hotkey,IfWinActive
return

logoutHint:
IfWinExist,ahk_class TLoginForm ahk_group EBM
{
	WinClose,ahk_class TLoginForm ahk_group EBM
	gosub refreshPwb
	settimer,refreshPwb,600000
}
IfWinExist,COM Server Warning
	ControlClick,Button1,COM Server Warning
return

load(){
	;~ global 
	;~ loading:=false
	load_force:=false
	settimer,waitLoadNext,Off
	gosub load
}

forceLoad(){
	global 
	settimer,waitLoadNext,Off
	stopWinWait:=true
	,loading:=false
	,load_force:=true
	,breakEBMquery:=true
	gosub load
}

reset_loading:
loading:=false
return

load:
ShiftDown:=GetKeyState("Shift")
load1:

if loading
	return

loading:=true
settimer,reset_loading,-120000
;~ AllRis:=risopened(1)
WinGetTitle,t,% "ahk_id " targetRis:=AllRis[2,1]
winactivate,% "ahk_id " targetRis
cChartNo:=getRisChartNo(targetRis)
if (cChartNo~="i)^\D"){
	;~ cChartNo:=getRisChartNo(targetRis)
	cAccNo:=getRisAccNo(targetRis)
	if (pChartNo) && (pChartNo!=cChartNo)
		WinClose, % pChartNo " ahk_group EBM"
	
	pChartNo:=cChartNo
	,previousOpened:=false
	
	,examDate:=getRisExamDate(targetRis)
	if h:=WinExist(cChartNo " ahk_group EBM") {
		WinShow,ahk_id %h%		
		WinActivate,ahk_id %h%
		previousOpened:=true
		,thisEBMViewer:=new EBMViewer(cChartNo)
		WinGetTitle,t,ahk_id %h%
		if !InStr(t, SubStr(examDate,1,10)) 
			MsgBox % "Exam date not match!"
	}else{
		;~ ShowToolTip(cChartNo " not open")
		if (ShiftDown){
			risOpenStudyImpax(targetRis)
			;~ openNextEBM(cAccNo, cChartNo)
			
			if __winwait(cChartNo " ahk_group EBM",5)
				return 
			
			thisEBMViewer:=new EBMViewer(cChartNo)
		}else{
			;~ SetTimerFn("openNextEBM", -1, [cAccNo, cChartNo])
			openNextEBM(cAccNo, cChartNo)
			if __winwait(cChartNo " ahk_group EBM",5)
				return
			
			thisEBMViewer:=new EBMViewer(cChartNo)
			;~ settimer,load1,-30000
			settimer,waitLoadNext,500
			loading:=false
			;~ return
		}
	}
	
	;~ if loginPw=
		;~ askForPortalIdPw()
	
		;~ ,HCHPwb.Visible:=true
	;~ result:=ParseDataGrid2(getRisList(targetRis))
	compareList(result, RisListAcc, RisListHwnd)
	
	,r:=result.getRow("AccNo", cAccNo)
	,nextAccNo:="", nextnextAccNo:=""
	if(r.rowNo){
		Loop % (result.maxIndex()-r.rowNo) {
			nextRow:=r.rowNo+A_Index
			,row:=result.getRow(nextRow)
			if (nextAccNo="" && row.getCell("Status")!="已發報告" && row.getCell("ChartNo")!=cChartNo &&  row.getCell("ChartNo")~="^(H|Y)" && !(row.getCell("ExamName")~="i)^(Request|Offer)")){
				nextAccNo:=row.getCell("AccNo"), nextChartNo:=row.getCell("ChartNo")
				break
				;~ continue
			}
			;~ if (nextAccNo!="" && row.getCell("Status")!="已發報告" && row.getCell("ChartNo")!=cChartNo && row.getCell("ChartNo")!=nextAccNo) {
				;~ nextnextAccNo:=row.getCell("AccNo"), nextnextChartNo:=row.getCell("ChartNo")
				;~ break
			;~ }
		}
	}
	
	if(nextAccNo){
		if !WinExist(nextChartNo " ahk_group EBM")
			settimer,waitLoadNext,500
			;~ SetTimerFn("openNextEBM",previousOpened?-1:-60000, [nextAccNo, nextChartNo])
			;~ if (nextnextAccNo)
				;~ SetTimerFn("presearchEBM", -45000, [nextnextAccNo, nextnextChartNo])
		else {
			WinHide,% nextChartNo " ahk_group EBM"
			;~ winactivate,% nextChartNo " ahk_group EBM"
			WinShow,% cChartNo " ahk_group EBM"
			winactivate,% cChartNo " ahk_group EBM"
		}
			
	}
	
}
loading:=false
return 

next:
if nextAccNo && WinExist(nextChartNo " ahk_group EBM") {
	WinShow,% nextChartNo " ahk_group EBM"
	winactivate,% nextChartNo " ahk_group EBM"
}
settimer,load,-2000
return

;~ presearchEBM(accNo, chartNo){
	;~ return openNextEBM(accNo, chartNo, 0, true)
;~ }

waitLoadNext:
;~ tooltip % a_tickcount "," thisEBMViewer.isHidden() "," thisEBMViewer.isLoading() "`n" nextChartNo
if !load_force
{
	if !thisEBMViewer || !thisEBMViewer.Exists()
		thisEBMViewer:=new EBMViewer(cChartNo)
	if thisEBMViewer.isHidden()
		return
	if thisEBMViewer.isLoading()
		return
}else{
	load_force:=false
}
openNextEBM(nextAccNo, nextChartNo)
settimer,waitLoadNext,Off
return

openNextEBM(nextAccNo, nextChartNo, tried=0, presearch=false){
	global HCHPwb, YLHPwb, cAccNo, cChartNo, hch_id, hch_pw, refreshing, ylh_id, ylh_pw,HCHPwbTimeout,YLHPwbTimeout, garbage, hch_info_ok, ylh_info_ok, HiddenMode, CHUTPwb, CHUTPwbTimeout, breakEBMquery, debug, YLHPwb2, load_force
	if WinExist(nextChartNo " ahk_group EBM")
		return
	
	if (!presearch){
		ToolTip % "Opening: " nextChartNo " (" nextAccNo ")"
		KeyWait,LCtrl,T2 D
		if (!ErrorLevel){
			ToolTip 
			SetTimerFn("openNextEBM", -15000, [nextAccNo, nextChartNo, tried, presearch])
			return 
		}
			
	}
		
	
	;~ winget,EBM_count,list,ahk_group EBM 
	;~ EBM_win:="`n"
	;~ Loop % EBM_count
		;~ EBM_win.=EBM_count%a_index% "`n"
	
	priorActiveSimpleRis:=WinActive("simple RIS ahk_class AutoHotkeyGUI")
	
	if (nextChartNo~="i)^H") && hch_info_ok {
		if !WinExist("ahk_id " HCHPwb.hwnd) || HCHPwbTimeout
			garbage.push(HCHPwb.hwnd)
			,HCHPwb:=EBMWebPacsLogin_IE(hch_id, hch_pw, "HC")
			,HCHPwb.Visible:=!!HiddenMode || debug
			,HCHPwbTimeout:=false
		thisPwb:=HCHPwb

	}else if (nextChartNo~="i)^C") && hch_info_ok {
		if !WinExist("ahk_id " CHUTPwb.hwnd) || CHUTPwbTimeout
			garbage.push(CHUTPwb.hwnd)
			,CHUTPwb:=EBMWebPacsLogin_IE(hch_id, hch_pw, "CHUT")
			,CHUTPwb.Visible:=!!HiddenMode || debug
			,CHUTPwbTimeout:=false
		thisPwb:=CHUTPwb

	}else if SubStr(nextChartNo,1,1)="Y" && ylh_info_ok  {
		if !WinExist("ahk_id " YLHPwb.hwnd) || YLHPwbTimeout
			garbage.push(YLHPwb.hwnd)
			,YLHPwb:=EBMWebPacsLogin_IE(ylh_id, ylh_pw, "YL")
			,YLHPwb.Visible:=!!HiddenMode || debug
			,YLHPwbTimeout:=false,
		if !WinExist("ahk_id " YLHPwb2.hwnd) || YLHPwbTimeout
			garbage.push(YLHPwb2.hwnd)
			,YLHPwb2:=EBMWebPacsLogin_IE(ylh_id, ylh_pw, "YL")
			,YLHPwb2.Visible:=!!HiddenMode || debug
			
		thisPwb:=YLHPwb
		if load_force
			SetTimerFn("EBMWebPacsQuery_IE", -2000, [nextAccNo, YLHPwb2, nextChartNo, !presearch, !presearch, breakEBMquery])
		
	}else{
		ShowToolTip("Chart No not supported!", 2000)
		tooltip
		return
	}
	
	LButtonState:=GetKeyState("LButton")
	,breakEBMquery:=false
	if (ret:=EBMWebPacsQuery_IE(nextAccNo, thisPwb, nextChartNo, !presearch, !presearch, breakEBMquery))<0 {
		tooltip 
		if (ret==-1)
			ShowToolTip("Fail to open study: " nextchartno ", " nextAccNo,2000)
		return
	}
	
	if presearch 
		return
	
	if state
		settimer,reclickButton,-2000
	ToolTip 
	;~ Loop {
		;~ winget,EBM_newcount,list,ahk_group EBM
		;~ MouseGetPos,mx,my
		;~ if EBM_newcount!=EBM_count || (last_index:=A_Index) >50
			;~ break
		;~ lastMx := mx, lastMy:=my
		;~ Sleep 1
	;~ }
	;~ MouseMove,% lastmx,% lastmy,0
	;~ if LButtonState
		;~ send {LButton Down}
	;~ else
		;~ send {LButton Up}
	;~ winwait,% nextChartNo " ahk_group EBM",,5
	if (last_index>50 && tried<3) {
		garbage.push(HCHPwb.hwnd)
		,garbage.push(YLHPwb.hwnd)
		,garbage.push(CHUTPwb.hwnd)
		,HCHPwb:=YLHPwb:=CHUTPwb:=0
		,SetTimerFn("openNextEBM", -500, [nextAccNo, nextChartNo, tried+1])
		return
	}else{
		;~ Loop % EBM_newcount {
			;~ hwnd:=EBM_newcount%a_index%
			;~ if !InStr(EBM_win, "`n" hwnd "`n"){
				;~ WinHide,% "ahk_id " hwnd
			;~ }
		;~ }
	}
	if(cChartNo!=nextChartNo){
		SetTimerFn("hideEBM", 100, [nextChartNo])
		;~ winwait,% nextChartNo " ahk_group EBM"
		;~ WinHide,% nextChartNo " ahk_group EBM"
		
	}
	WinShow,% cChartNo " ahk_group EBM"
	winactivate,% cChartNo " ahk_group EBM"
	WinShow,% cAccNo " ahk_group EBM"
	winactivate,% cAccNo " ahk_group EBM"
	if priorActiveSimpleRis
		WinActivate,ahk_id %priorActiveSimpleRis%
	settimer,gc,-1800000
	return
}

HideEBM(ChartNo){
	if WinExist(chartNo " ahk_group EBM"){
		WinHide,% chartNo " ahk_group EBM"
		return SetTimerFn("hideEBM", 0)
	}
}

reclickButton(){
	send {LButton Down}
}

releaseLButton(){
	if (ret:=GetKeyState("LButton"))
		send {LButton UP}
	return ret
}

gc:
;~ MsgBox % "GC"
for k,v in garbage
	WinClose,ahk_id %v%
garbage:=[]
return

refreshPwb:
;~ ToolTip refresh
HCHPwbTimeout:=YLHPwbTimeout:=CHUTPwbTimeout:=true
;~ refreshing:=true
;~ if HCHPwb
	;~ HCHPwb.quit()
;~ HCHPwb:=EBMWebPacsLogin_IE(hch_id, hch_pw, "HC")
;~ ,HCHPwb.Visible:=false
;~ if YLHPwb
	;~ YLHPwb.quit()
;~ YLHPwb:=EBMWebPacsLogin_IE(YLH_id, YLH_pw, "YL")
;~ ,YLHPwb.Visible:=false
;~ ,refreshing:=false
return


OnExit:
if SubStr(nextChartNo,1,1)="H"
	HCHPwb.Visible:=true
	,YLHPwb.quit()
	,CHUTPwb.quit()
else if SubStr(nextChartNo,1,1)="Y"
	HCHPwb.quit()
	,CHUTPwb.quit()
	,YLHPwb.Visible:=YLHPwb2.Visible:=true
else if SubStr(nextChartNo,1,1)="C"
	HCHPwb.quit()
	,YLHPwb.quit()
	,CHUTPwb.Visible:=true
else
	HCHPwb.Visible:=YLHPwb.Visible:=YLHPwb2.Visible:=CHUTPwb.Visible:=true

gosub gc

WinShow,% nextChartNo " ahk_group EBM"
ExitApp


RisStateChange(){
	global 
	AllRis:=risopened(1)
}


accNoChanged(){
	global AllRis
	;~ cAccNo:=getRisAccNo(targetRis:=AllRis[2,1])
	cChartNo:=getRisChartNo(targetRis:=AllRis[2,1])
	if WinExist(cChartNo " ahk_group EBM")
		settimer,load,-1
	
	settimer,checkCurrentEBM,500
}

Pause::
if(A_PriorHotkey==A_ThisHotkey && A_TimeSincePriorHotkey<400){
	if (nextChartNo){
		WinClose,%nextchartno% ahk_group EBM
	}
}else{
	HCHPwb.visible:=CHUTPwb.visible:=YLHPwb.visible:=YLHPwb2.visible:=pwbVisible:=!pwbVisible
}



return


__WinWait(wintitle,wait_sec,interval=100){
	global stopWinWait
	
	loop % (wait_sec*1000/interval) {
		if (stopWinWait) {
			stopWinWait:=false
			return 2
		}
		sleep % interval
	}until WinExist(wintitle)
	return !WinExist(wintitle)
}