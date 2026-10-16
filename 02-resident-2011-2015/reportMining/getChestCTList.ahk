FileEncoding,utf-8

#NoEnv
#SingleInstance,Off
SetBatchLines,-1
;~ DetectHiddenWindows, On
;~ SetTitleMatchMode,2
;~ coordmode,mouse,screen
#NoTrayIcon
#persistent
#include <portalLib>
#include <JXON>
onexit,onexit



csv_file:="all_cases.csv"
,out_file:="all_cases_chest_ct.csv"

,args:=ParseArg()

if args.length()
	goto Parse
else
	goto main

return

main:
sid:=askForPortalIdPw()
Loop,read,% csv_file
{
	if !RegExMatch(Trim(A_LoopReadLine), "^(\w{7})\,(\d{8})$",  match)
		continue
	
	chartNo:=match1, studyDate:=match2
	
	run % Commands("getChestCTList.exe", chartNo, studyDate, sid)
	Sleep 500
}
ExitApp
return

parse:
chartNo:=args[1]
,studyDate:=args[2]
,sid:=args[3]

for k,v in getPacsHxByPortal(sid, chartNo) {
	examName:=v.ExamName
	if InStr(examName, "CT") && !InStr(examName,"guide") && !InStr(examName,"RFA") && (examName~="i)chest|lung|thora") {
		FileAppend,% chartNo "," studyDate "," v.ExamDate  "," v.AccNo "," examName "`r`n",% out_file,utf-8
	}
}
ExitApp
return

OnExit:
ExitApp