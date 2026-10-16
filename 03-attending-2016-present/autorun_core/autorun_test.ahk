#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#include <acc>
#include <.netgetcontrol>
#include <risimpax>
#include <portallib>
#include <hotstring>
#include <SystemCursor>
#include <hash>
#include <WinVisible>
;~ #include <ahkmini>
;~ #include <ahkthread>
;~ #include <createscript>
#include <getDllPath>
#include <JoinScript>
#include <RegJump>
#include <UIAutomationServer>
#Include <ComDispatch>
#Include <ComDispTable>
#Include <ComVar>
#Include <SetTimerF>
#Include <RelToAbs>
#Include <GetActiveBrowserURL>
;~ #include <JSON>
ComObjError(false)
gosub RisImpaxRoutine
return

esc::ExitApp

RisImpaxRoutine:
risOld:=impaxOld:=0
risState:=CriticalObject(), ImpaxState:=CriticalObject(), RisChanged:=false
;~ return ;pauseThread
RisImpaxRoutineTh:=ahkmini("
(
;~ threadIds:=CriticalObject(" (&ThreadIds) "), threadIds[""RisImpaxRoutine""]:=DllCall(""GetCurrentThreadId""), clipboard.=""RisImpaxRoutine "" DllCall(""GetCurrentThreadId"") ""``n""
#include <RisImpax>
#persistent
#notrayicon
Alias(risOld, " getvar(risOld) ")
,Alias(impaxOld, " getvar(impaxOld) ")
,Alias(RisChanged, " getvar(RisChanged) ")
,risState:=CriticalObject(" (&risState) ")
,ImpaxState:=CriticalObject(" (&ImpaxState) ")
,alive:=1
loop {
	risOld:=risState[2],impaxOld:=impaxState[2,1]
	risState:=risOpened()
	impaxState:=impaxOpened()
	if (!risOld || risOld!=risState[2])
		RisChanged:=true
	risOld:=risState[2]
	sleep 500
}
return
)")
threads["RisImpaxRoutine"]:=RisImpaxRoutineTh
;~ SetTimer,RisImpaxRoutine,-500
while !RisImpaxRoutineTh.ahkReady()
	Sleep 200
;~ SetTimer,RisChanged,500
return

