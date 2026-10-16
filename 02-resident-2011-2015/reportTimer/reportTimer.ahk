#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,ignore
SetBatchLines,-1
;~ DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
sendmode,input
onexit,onexit
#include <risimpax>

sendState:=["暫存","存檔","發送"]
settimer,timer,10000
settimer,sample,1000
time:=0,sample:=0
return


timer:
if (A_TimeIdlePhysical<7500) && (sample>2)
	time+=10,sample:=0
else
	tooltip % "Not counted"
return

sample:
mousegetpos,,,win
winget,processName,processName,ahk_id %win%
if (processName="impax-client-main.exe") {
	sample+=1
	return
}else if (processName="Menu.exe") {
	focused:=getFocused()
	found:=0
	for k,v in getControls(risopened()[2]) {
		if (v.text="報告撰打作業")
			found:=1
		if (v.hwnd=focused) {
			if (found) {
				sample+=1
				return
			}else{
				break
			}
		}Postoperative changes. No definite recurrence.
	}
}
tooltip % "Not sampled"
return

#ifwinactive,ahk_exe Menu.exe
~F3::
~F1::
~F2::
sendType:=sendState[substr(a_thishotkey,0,1)]
examChanged:
tooltip,% sendType ": " time " s"

time:=sample:=0,sendType:=""
return
#ifwinactive


onexit:
~esc::
exitapp
return


getFocused(){
	static GuiThreadInfoSize = 48
	VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
	DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
	return FocusedHWND := NumGet(GuiThreadInfo, 12)
}
