#include <portalLib>
#include <WM_COPYDATA>
SetBatchLines,-1
#NoEnv
#NoTrayIcon
#SingleInstance,Off
DetectHiddenWindows.on

args:=[]
Loop %0%
{
	param := %A_Index%
	args.push(param)
}
if !(args.maxindex()>0)
	ExitApp

sid:=args[1]
,chartNo:=args[2]
,YesterdayDate:=args[3]
SetTimer,exit,-120000


PacsCTHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid)).getNodeByNames("置頂","報告","影核醫報告").arr

for k,v in PacsCTHx {
	RegExMatch(v.innerText,"is)^([\d\/]{10})\_(.+)", match)
	,match1:=RegExReplace(match1, "\D", "")
	
	
	if (match1=YesterdayDate && instr(match2, "CT")
		&& match2~="i)chest|thora|lung"){
		Send_WM_COPYDATA(WinExist("ahk_exe RAID2Syngovia.exe"),0, chartNo)
		goto exit
	}
}
Send_WM_COPYDATA(WinExist("ahk_exe RAID2Syngovia.exe"),0, "")
goto exit
return 

exit:

ExitApp
return