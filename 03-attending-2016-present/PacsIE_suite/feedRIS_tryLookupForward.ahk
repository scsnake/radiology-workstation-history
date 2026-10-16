SetTitleMatchMode,2
SetBatchLines,-1
SetControlDelay,-1
ComObjError(false)
DetectHiddenWindows,on
DetectHiddenText,on
#persistent
#include <risimpax>
#include <winvisible>
#include <jxon>
#SingleInstance,force



;~ if %0% {
	;~ param:=[]
	;~ loop %0%
		;~ param.push(%a_index%)
	;~ for k,v in param {
		;~ if(v="-waitJson"){
			;~ waitJson:=1
		;~ }
	;~ }
;~ }

onexit,onexit
RisId:=loginId
RisPw:=loginPw


Menu, Tray, Click, 2
Menu, tray, add, Delete All,deleteAll
Menu, tray, add, Delete reports,deleteReports
Menu, Tray, Add, Feed Folder, openFeedFolder
Menu, Tray, Default, Feed Folder 
gosub risState
settimer,risState,1000
interval:=3000
pause:=0
dir:=a_mydocuments "\feedRIS"
if !InStr(FileExist(dir), "D")
	filecreatedir,% dir
if !InStr(FileExist(dir "\saved"), "D")
	filecreatedir,% dir "\saved"

gosub env
settimer,sendReport,-1
settimer,riserror,500

;~ SetTimer,loadReportList,-1
return

loadReportList:
if !reportListLoaded && FileExist(dir "\reportList.json"){
	while (count:=a_index)<(waitJson?200:3) {
		try{
			fileread,jxon,% dir "\reportList.json"
			reportList:=jxon_load(jxon)
		}catch{
			sleep 500
			continue
		}
		break
	}
	if(count>=(waitJson?200:3))
		reportListLoaded:=0
	else
		reportListLoaded:=1
}
	
if (!reportListLoaded){
	reportList:=[]
	parseDataGrid(RisListRowsAcc,reportList,1,0,"","")
	reportListLoaded:=1
}

if (!reportListLoaded)
	return

for k,v in reportList[1] {
	if (v="照會單號") {
		AccNoCol:=k
	}
	if (v="病歷號") {
		chartNoCol:=k
	}
	if (v="檢查名稱") {
		examNameCol:=k
	}
	if (v="狀態") {
		statusCol:=k
	}
	if (v="檢查日") {
		examDateCol:=k
	}
	
}
return


risState:
RisState:=RisOpened()
;~ if(oldRisState[2]=RisState[2])
	;~ return
oldRisState:=RisState.clone()
RisReports:=getRisReports(RisState[2])
RisAccNoHwnd:=getRisAccNoHwnd(RisState[2])
ChartNoHwnd:=getRisChartNoHwnd(RisState[2])
sendButtonHwnd:=getNetAcc(RisState[2],"cmdRunVerifySend","WindowsForms10.BUTTON.app",0,0)
nextButtonHwnd:=getNetAcc(RisState[2],"cmdRunNext","WindowsForms10.BUTTON.app",0,0)
;~ priorButtonHwnd:=getNetAcc(RisState[2],"cmdRunFoword","WindowsForms10.BUTTON.app",0,0)
;~ RisListHwnd:=getRisList(RisState[2])
;~ RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
return

riserror:
ifwinexist,kReport ahk_exe Menu.exe,報告內容已修改, 是否確定存檔
	controlclick,Button2
ifwinexist,ahk_exe Menu.exe,Unhandled exception
{
	controlclick,&Quit
	process,close,Menu.exe
	pause:=1
	MsgBox, 4144, ,% "RIS當掉！請重開！",10
	ExitApp
}else{
	pause:=0
}
return


deleteAll:
MsgBox, 4404, , % "Delete all?"
ifmsgbox,yes
{
	filedelete,% dir "\*"
	loop,% dir "\*",1,0
		fileremovedir,% a_loopfilefullpath,1
	FileCreateDir,% dir "\saved"
	msgbox,,,% "Deleted!",2
}
return

deleteReports:
filedelete,% dir "\*.txt"
if(!errorlevel)
	msgbox,,,% "Deleted!",2
return

openFeedFolder:
run % dir
return

traytip:
TrayTip
return


sendReport:
loop {
	
	if (pause)
		settimer,sendReport,-1000
	
	countFile:=0
	loop,%dir%\*.txt
		;~ if regexmatch(a_loopfilename,"([TY]\w{9}\d) \w{6}\d",match) && (!reportListLoaded || reportInList(match1)) {
		if regexmatch(a_loopfilename,"([TY]\w{9}\d) \w{6}\d",match) {
			if (++countFile>10)
				break
		}


	if(!countFile){
		settimer,sendReport,-10000
		;~ exitapp
		return
	}
	
	traytip,,% countFile>10?">10":countFile,1
	settimer,traytip,-1000
	
	thisAccNo:=controlgettext(RisAccNoHwnd)
	while (priorAccNo && priorAccNo=thisAccNo) {
		sleep % floor(interval/2)
		if(a_index>10)
			break
	}
	priorAccNo:=thisAccNo
	if(!winexist("ahk_id " RisState[2])){
		Msgbox,,, % "Please reopen RIS!",10
		settimer,env,-30000
		;~ settimer,saveToFile,-1
		return
	}
	if (!controlexist(RisReports[1,1])){
		Msgbox % "Please reopen 報告撰打作業!"
		settimer,env2,-30000
		;~ settimer,saveToFile,-1
		return
	}
	
	thisChartNo:=controlgettext(chartNoHwnd)
	errorSend:=0
	if (fileexist(thisFile:=dir "\" thisAccNo " " thisChartNo ".txt")){
		fileread,contents,% thisFile
		RegExMatch(contents,"s)(.*)\r?\n-=-=-=-=-\r?\n(.*)",match)
		if !(match1="" && match2=""){
			controlsettext,,% match1,% "ahk_id " RisReports[1,1]
			controlsettext,,% match2,% "ahk_id " RisReports[1,2]
			if(controlgettext(RisReports[1,1])=match1 && controlgettext(RisReports[1,2])=match2){
				acc_objectfromwindow(sendButtonHwnd).accDoDefaultAction()
				filemove,% thisFile,% dir "\saved\" thisAccNo " " thisChartNo ".txt" ,1
				FileRemoveDir,% dir "\" thisAccNo " " thisChartNo,1
			}else
				errorSend:=0
		}else{
			;~ if(!reportListLoaded || (prvSteps:=anyPrevious(thisAccNo))<1)
				acc_objectfromwindow(nextButtonHwnd).accDoDefaultAction()
			;~ else {
				;~ Loop % prvSteps {
					;~ acc_objectfromwindow(priorButtonHwnd).accDoDefaultAction()
					;~ Sleep 1000
				;~ }
			;~ }
			
		}
		
		
		
	}else{
		;~ if(!reportListLoaded || (prvSteps:=anyPrevious(thisAccNo))<1)
			acc_objectfromwindow(nextButtonHwnd).accDoDefaultAction()
		;~ else{
			;~ Loop % prvSteps {
				;~ acc_objectfromwindow(priorButtonHwnd).accDoDefaultAction()
				;~ Sleep 1000
			;~ }
		;~ }
	}
	
	;~ if (countFile=1)
		;~ sleep 5000
	;~ else if (countFile<5)
		;~ sleep 3000
	;~ else 
		sleep 1000
	;~ sleep % interval
}

return

; 1: run forward, 0: run next, -1: no report to send
anyPrevious(thisAccNo){
	global 
	local k,v,prv:=1,found:=0
	
	for k,v in reportList {
		if(found)
			++found
		if (v[AccNoCol]=thisAccNo){
			prv:=0
			if(found)
				return found
		}
		if FileExist(dir "\" v[AccNoCol] " " v[chartNoCol] ".txt") && v[statusCol]!="已發報告" {
			found:=1
			if(prv=0)
				return 0
		}
		
	}
	return -1
}

reportInList(AccNo){
	global
	local k,v
	for k,v in reportList
		if (v[AccNoCol]=AccNo && v[statusCol]!="已發報告")
			return 1
		
	return 0
}

env:

loop {
	if ((RisState:=RisOpened())[1]!=2){
		MsgBox, 49, , % "Open RIS first!"
		ifmsgbox,OK
			sleep 10000
		else
			exitapp
	}else
		break
}
winhide,% "ahk_id " risState[2]
env2:
loop {
	if !controlexist((RisReports:=getRisReports(RisState[2]))[1,1]) {
		MsgBox, 49, , % "Open 報告撰打作業 first!"
		ifmsgbox,OK
		{
			winshow,% "ahk_id " RisState[2]
			WinActivate,% "ahk_id " RisState[2]
			sleep 10000
		}else
			exitapp
	}else
		break
}


return

;~ esc::
;~ ExitApp
;~ return
!#p::

checkRis(RisState)
if WinVisible(RisState[2]){
	goReportTab(2)
	winhide,% "ahk_id " RisState[2]
}else {
	winshow,% "ahk_id " RisState[2]
	goReportTab(3)
	WinActivate,% "ahk_id " RisState[2]
}

return

!#d::
RisState:=RisOpened()
WinGet, Style, Style, % "ahk_id " RisState[2]
if (Style & 0x8000000)
	winset,enable,,% "ahk_id " RisState[2]
else
	winset,disable,,% "ahk_id " RisState[2]
return


goReportTab(ind=2){
	tabs:=getNetControl2(RisOpened()[2],"","B_ACTIVE","","WindowsForms10.BUTTON")
	if tabs[ind]
		acc_objectfromwindow(tabs[ind]).accDoDefaultAction()
}
return

onexit:
winshow,% "ahk_id " RisState[2]
winset,enable,,% "ahk_id " RisState[2]
winactivate,% "ahk_id " RisState[2]
;~ winshow,ahk_exe Menu.exe
ExitApp