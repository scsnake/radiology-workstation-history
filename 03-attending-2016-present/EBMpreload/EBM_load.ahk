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
#NoTrayIcon
onexit,onexit
;~ #NoTrayIcon
;~ #include <RisImpax>
;~ #include <PortalLib>
#include <EBMViewer>
;~ #include <DoublyLinkedList>
#include <Crypt>
#include <WM_COPYDATA>
#include <JXON>
#Persistent

SetTimer,exit,3000

pw:="$uq?23bPef5c3?9^s9Ajva7m9TMCvW2_"
,args:=ParseArg()
,OnMessage(0x4a, "ON_WM_COPYDATA")
try
	jx:=JXON_load(Crypt.Encrypt.StrDecrypt(args[1],pw,7,6))
catch, e
{
	MsgBox % e
	ExitApp
}

GroupAdd,EBM,ahk_exe WEBVIE~1.exe
GroupAdd,EBM,ahk_exe WebViewerComSrvEC.exe
pwbs:=[]
return

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
	global cAccNo, cChartNo, nextAccNo, nextChartNo, forceLoad, examDate
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 0x199) ; CMD_CURRENTPOSITION
	{
		try
			jx:=JXON_load(str)
		catch
			return
		
		if(jx.haskey("load")){
			nextAccNo:=jx.nextAccNo
			,nextChartNo:=jx.nextChartNo
			,forceLoad:=jx.forceLoad
			while StrLen(nextChartNo)<7
				nextChartNo:="0" nextChartNo
			settimer,load,-1
		}else if (jx.haskey("previousOpened")){
			cAccNo:=jx.cAccNo
			,cChartNo:=jx.cChartNo
			,examDate:=jx.examDate
			settimer,previousOpenedCheck,-1
		}else if (jx.haskey("pacsOpened")){
			cAccNo:=jx.cAccNo
			,cChartNo:=jx.cChartNo
			,examDate:=jx.examDate
			settimer,pacsOpenedCheck,-1
		}
		else if (jx.haskey("nowOpen")){
			nextAccNo:=jx.cAccNo
			,nextChartNo:=jx.cChartNo
			;~ ,examDate:=jx.examDate
			,forceLoad:=forceLoad
			settimer,load,-1
		}
		
		
	}
}

previousOpenedCheck(){
	global examDate, cChartNo, ebmv
	WinGetTitle,t,%cChartNo% ahk_group EBM
	if !InStr(t, SubStr(examDate,1,10)) 
		MsgBox % "Exam date of " cChartNo " not match!"
	ebmv:=new EBMViewer(cChartNo)
}
pacsOpenedCheck(){
	global examDate, cChartNo, ebmv
	winwait,%cChartNo% ahk_group,,15
	if (ErrorLevel){
		MsgBox % "EBM Viewer of " cChartNo " not opened!"
		return
	}
	WinGetTitle,t,%cChartNo% ahk_group EBM
	if !InStr(t, SubStr(examDate,1,10)) 
		MsgBox % "Exam date of " cChartNo " not match!"
	ebmv:=new EBMViewer(cChartNo)
}

load:
if(nextChartNo==cChartNo)
	return
if(forceLoad){
	WinClose,% cChartNo " ahk_group EBM"
	openNextEBM(nextAccNo, nextChartNo)
}else{
	if (ebmv && ebmv.Exists() && !ebmv.isHidden() && ebmv.isLoading()){
		settimer,load,-1000
	}else
		openNextEBM(nextAccNo, nextChartNo)
}
return

openNextEBM(nextAccNo, nextChartNo, tried=0, presearch=false){
	global HCHPwb, YLHPwb, cAccNo, cChartNo, hch_id, hch_pw, refreshing, ylh_id, ylh_pw,HCHPwbTimeout,YLHPwbTimeout, garbage, hch_info_ok, ylh_info_ok, HiddenMode, CHUTPwb, CHUTPwbTimeout, __nextChartNo, EBMInstances, EBMChartNoQueue
	if WinExist(nextChartNo " ahk_group EBM")
		return
	
	if (!presearch){
		ToolTip % "Opening: " nextChartNo " (" nextAccNo ")"
		KeyWait,LCtrl,T2 D
		if (!ErrorLevel){
			ToolTip 
			settimerF("openNextEBM", -15000, [nextAccNo, nextChartNo, tried, presearch])
			return 
		}
			
	}
		
	
	;~ winget,EBM_count,list,ahk_group EBM 
	;~ EBM_win:="`n"
	;~ Loop % EBM_count
		;~ EBM_win.=EBM_count%a_index% "`n"
	
	priorActiveSimpleRis:=WinActive("simple RIS ahk_class AutoHotkeyGUI")
	
	if (nextChartNo~="i)^H") {
		if !WinExist("ahk_id " HCHPwb.hwnd) 
			HCHPwb:=EBMWebPacsLogin_IE(hch_id, hch_pw, "HC")
			,HCHPwb.Visible:=!!HiddenMode
		thisPwb:=HCHPwb
		LButtonState:=GetKeyState("LButton")
	}else if (nextChartNo~="i)^C") {
		if !WinExist("ahk_id " CHUTPwb.hwnd) 
			CHUTPwb:=EBMWebPacsLogin_IE(hch_id, hch_pw, "CHUT")
			,CHUTPwb.Visible:=!!HiddenMode
		thisPwb:=CHUTPwb
	}else if SubStr(nextChartNo,1,1)="Y" && ylh_info_ok  {
		if !WinExist("ahk_id " YLHPwb.hwnd)
			YLHPwb:=EBMWebPacsLogin_IE(ylh_id, ylh_pw, "YL")
			,YLHPwb.Visible:=!!HiddenMode
		thisPwb:=CHUTPwb	
	}else{
		return
	}
	
	LButtonState:=GetKeyState("LButton")
		;~ settimer,reclickButton,1000
	
	,priorActiveSimpleRis:=WinActive("simple RIS ahk_class AutoHotkeyGUI")
	
	if (EBMWebPacsQuery_IE(nextAccNo, thisPwb, nextChartNo, !presearch, !presearch)=-1){
		ToolTip % "Search " nextChartNo " error!"
		thisPwb.Visible:=true
		return
	}
		
	
	if presearch 
		return
	
	winwait,%nextChartNo% ahk_group EBM,,10
	if (ErrorLevel){
		MsgBox % "EBM Viewer of " nextChartNo " not opened!"
		return
	}
	
	if LButtonState
		send {Lbutton Down}
	
	if priorActiveSimpleRis
		WinActivate,ahk_id %priorActiveSimpleRis%
	return
}

exit:
if !WinExist("EBM preload ahk_class AutoHotkeyGUI")
	ExitApp
return


OnExit:
HCHPwb.quit()
CHUTPwb.quit()
YLHPwb.quit()
ExitApp