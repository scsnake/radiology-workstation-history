#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,ignore
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1
DetectHiddenWindows,on
DetectHiddenText,on
onexit,onexit
#NoTrayIcon


#include <Acc>
#include <.NetGetControl>
#include <risimpax>

OnMessage(0x10305, "toggleState")
,thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
,RISImpaxRegister([{app: "Impax", type: "State", hwnd: thisHwnd, msg: {msg: 0x8000}, func: "ImpaxStateChange", initStart: 1}])
,monitors:=monitorInfo()
if !(mon:=monitors.2)
	mon:=monitors.1
;~ gosub RisImpaxRoutine
;~ settimer,RisImpaxRoutine,200
ImpaxStateChange()
sleep 200
hide:=0
,initStyle:=[]
,saveInitStyle()
gosub hideImpax
return

ImpaxStateChange(){
	global ImpaxState:=ImpaxOpened()
}


toggleState(wParam, lParam, msg, hwnd){
	global hide
	if(lParam!=""){
		if(hide=!lParam){
			gosub hideImpax
		}
	}else{
		gosub hideImpax
	}
}

#IfWinActive,ahk_exe impax-client-main.exe
~!^tab::
~!#tab::
~`::
~F1::
toggleState("", false, "", "")
SetTimerFn("toggleState", -20000, ["", true, "", ""])
return
#IfWinActive

^esc::
hideImpax:
;~ mousegetpos,,,mouseWin
;~ wingetclass,mouseClass,% "ahk_id " mouseWin
;~ if(priorMouseWin=mouseWin)
	;~ return
;~ priorMouseWin:=mouseWin
;~ if(mouseWin=RisState[2]){
if(hide:=!hide){
	if(ImpaxState[2,2]!=hidden1 || ImpaxState[2,3]!=hidden2){
		resetInit()
		,saveInitStyle()
	}
	
	hidden1:=ImpaxState[2,2]
	,hidden2:=ImpaxState[2,3]
	
	WinSet, ExStyle, +0x80,  ahk_id %hidden1% ; 0x80 is WS_EX_TOOLWINDOW
	WinSet, ExStyle, +0x80,  ahk_id %hidden2% ; 0x80 is WS_EX_TOOLWINDOW
	;~ WinSet, ExStyle, +0x80,  ahk_id %hidden3% ; 0x80 is WS_EX_TOOLWINDOW
;~ }else if(mouseClass="WindowsForms10.Window.8.app.0.2bf8098"){
	;~ if(ImpaxState[2,4]=1){
		;~ winminimize,% "ahk_id " ImpaxState[2,2]
		;~ winminimize,% "ahk_id " ImpaxState[2,3]
	;~ }
	;~ winshow,% "ahk_id " ImpaxState[2,2]
	;~ winshow,% "ahk_id " ImpaxState[2,3]
	;~ impaxArr:=[]
	;~ winget,list,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	;~ loop % list
		;~ if(list%a_index%!=ImpaxState[2,1])
			;~ impaxArr.push(list%a_index%)
	;~ if(ImpaxState[2,4]=1)
		;~ for k,v in impaxArr
			;~ winminimize,% "ahk_id " v
	;~ for k,v in impaxArr
		;~ winshow,% "ahk_id " v

}else{
	;~ winshow,% "ahk_id " hidden1
	resetInit()
}

return

saveInitStyle(){
	global
	Loop 3 {
		winget,Style,Style,% "ahk_id " ImpaxState[2,A_Index]
		winget,ExStyle,ExStyle,% "ahk_id " ImpaxState[2,A_Index]
		initStyle[A_Index]:=[Style, ExStyle]
	}
}

resetInit(){
	global
	;~ winshow,% "ahk_id " hidden1
	;~ winshow,% "ahk_id " hidden2
	Loop 3 {
		winset,Style,% initStyle[A_Index,1],% "ahk_id " ImpaxState[2,A_Index]
		winset,ExStyle,% initStyle[A_Index, 2],% "ahk_id " ImpaxState[2,A_Index]
		
	}
	;~ WinMove,% "ahk_id " ImpaxState[2,2],,,,% mon.w,% mon.h
	;~ WinMove,% "ahk_id " ImpaxState[2,3],,,,% mon.w,% mon.h
}

;~ ~F1::
;~ if !winactive("ahk_id " impaxstate[2,1])
	;~ return
;~ if hide
	;~ gosub ^esc
;~ return

~!^q::
onexit:
;~ winshow,% "ahk_id " hidden1
hide:=1
gosub hideImpax
exitapp
return