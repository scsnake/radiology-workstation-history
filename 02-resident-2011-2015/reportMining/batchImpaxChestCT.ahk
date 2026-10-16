#NoEnv
#SingleInstance,Off
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
;~ coordmode,mouse,screen
;~ #NoTrayIcon
#persistent
#include <RisImpax>
#include <ImpaxContextServer>
#include <portallib>
#include <JXON>
onexit,onexit


;~ MsgBox
args:=[]
;~ Loop %0%
	;~ args.push(%a_index%)
	;~ args.push("5______")
fileread,lst,input.csv

Loop,Parse,lst,`n,`r
{
	if (RegExMatch(A_LoopField, "\b(\d\d?)\W(\d\d?)\W(\d\d\d\d)\b", studyDate) && RegExMatch(A_LoopField, "\b\w{7}\b", chartNo)
		&& (opdate:=Format("{}{:02}{:02}",studydate3,studydate1,studydate2)))
		args.push([chartNo, opdate])
		;~ if args.haskey(chartNo)
			;~ args[chartNo].push(studyDate)
		;~ else
			;~ args[chartNo]:=[studyDate]
	else if RegExMatch(A_LoopField, "i)[TY]\w{10}", AccNo)
		args[AccNo]:=1
}
	


impaxState:=ImpaxOpened()
if (impaxState[1]!=2){
	MsgBox % "Login IMPAX first!"
	ExitApp
}

if !(hwnd:=ImpaxContextServer_Init()){
	MsgBox % "Run ImpaxContextServer.exe first!"
	ExitApp
}


;~ SplitPath,A_ScriptFullPath,,,,fileNameNoExt

;~ MsgBox % ExploreObj(args)
;~ MsgBox % fileNameNoExt
sid:=askForPortalIdPw()
for m,n in args {
	chartNo:=n[1]
	,opdate:=n[2]

	;~ if (studyDates=1){
		;~ Loop {
			;~ if WinExist("ahk_exe ImpaxContextServer.exe") && WinExist("ahk_exe impax-client-main.exe")
				;~ break
			;~ else
				;~ Sleep 500
		;~ }
		;~ ImpaxContextServer_Add(AccNo:=chartNo, hwnd)
		;~ Sleep 500
		;~ continue
		
	;~ }


	while StrLen(chartNo)<7
		chartNo:="0" chartNo
	
	
	ToolTip % "Searching for " chartNo " ..."
	for k,v in PacsHx:=getPacsHxByPortal(sid, chartNo) {
		;~ clipboard:=exploreobj(PacsHx)
		examDate:=RegExReplace(v.ExamDate, "\D", "")
		;~ if k=74
			;~ b:=1
		if (examDate<=opdate && ((v.ExamName~="i)^(CT)" && v.ExamName~="i)thora|lung|chest") || v.ExamName~="i)^Requesting")){
			Loop {
				if WinExist("ahk_exe ImpaxContextServer.exe") && WinExist("ahk_exe impax-client-main.exe")
					break
				else
					Sleep 500
			}
			FileAppend,% chartNo "," v.AccNo "`r`n",results.csv,utf-8
			ImpaxContextServer_Add(v.AccNo, hwnd)
			Sleep 500
		}
	}
	
		
	
	
}
MsgBox,,,% "Finished!",3
ExitApp
return 

OnExit:
ExitApp