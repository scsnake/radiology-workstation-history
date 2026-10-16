#include <RisImpax>
;~ DetectHiddenWindows,On
;~ DetectHiddenText,on
SetBatchLines,-1

RisState:=RisOpened()
,RisHwnd:=RisState[2]
,RisReports:=getRisReports(RisHwnd)



Loop % 318-55 {
	t:=ControlGetText(RisReports[1,1])
	if !(t~="i)placement of [\(\) \w\,]+\.") || InStr(t, "placement of cardiac conduction device."){
		risNextStudy(RisHwnd)
		Sleep 2000
		continue
	}
		
	
	t:=RegExReplace(t, "i)placement of [\(\) \w\,]+\.", "Line(s) and/or tube(s) in position.")
	ControlSetText,,% t,% "ahk_id " RisReports[1,1]
	risSendReport(RisHwnd)
	,risNextStudy(RisHwnd)
	Sleep 2000
}




esc::ExitApp