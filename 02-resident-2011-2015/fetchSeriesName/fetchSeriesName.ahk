#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1
#SingleInstance,force
DetectHiddenWindows,on
#include <risimpax>
#persistent
onexit,onexit
logFile:="log.txt"
RisState:=RisOpened()

settimer,routine,1000



return

routine:
checkRIS(RisState)
if(!controlexist(RisAccNoHwnd)){
	RisAccNoHwnd:=getRisAccNoHwnd(RisState[2])
}
thisAccNo:=controlgettext(RisAccNoHwnd)
if(priorAccNo!=thisAccNo){
	;~ if(!controlexist(RisReports[1,1])){
		;~ RisReports:=getRisReports(RIsState[2])
	;~ }
	if(!controlexist(examItemHwnd)){
		examItemHwnd:=getRisExamItems(RisState[2])
	}
	text:=controlgettext(RisReports[1,1])
	settimer,AccChanged,-5000
}
priorAccNo:=thisAccNo
return


AccChanged:
for k,v in (impaxControls:=getcontrols(impaxopened()[2,1])){
	if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
		controlclick,,% "ahk_id " v.hwnd
        break
	}
}

ExamItems:=parseRisExamItems(examItemHwnd)
impaxSeries:=getSeriesName()
str:=thisAccNo ": "
for k,v in ExamItems[2] {
	if instr(v,"without/with")
		str.="±"
	else if instr(v,"without")
		str.="-"
	else if instr(v,"with")
		str.="+"
	regexmatch(v,"is)-(.+)$",match)
	if (match1="Head and Neck(Skull Base to Clavicle)")
		match1:="Neck"
	str.=trim(match1) ", "
}
str:=substr(str,1,-2) ": "

for k,v in impaxSeries {
	str.=v.1 " " v.2 ", "
}
str:=substr(str,1,-2)
str:=RegExReplace(str," +"," ")
fileappend,% str "`n",% logFile,utf-8
return


;~ ~esc::
onexit:
exitapp
return