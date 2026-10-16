#MaxMem 4095
SetTitleMatchMode,2
SetBatchLines,-1
SetControlDelay,-1
ComObjError(false)
DetectHiddenWindows,on
DetectHiddenText,on
#persistent
#include <risimpax>
#include <winvisible>
#include <WM_COPYDATA>
#SingleInstance,Off
#include <CryptFileRead>
#include jpegDirName.ahk

if CryptFilePW()
	ExitApp

try
	Menu,tray,icon,% A_ScriptDir "\F.ico"

onexit,onexit
if (GetKeyState("Rbutton")){
	MsgBox, 4, ,% "Temp Save Mode?",5
	IfMsgBox,Yes
		saveMode:=true
	else 
		saveMode:=false
}
RisImpaxInfo:=RisImpaxLoadPw("000000")

OnMessage(0x1011, "reportSaved")
,OnMessage(0x1012, "quit")
,OnMessage(0x4a, "On_WM_COPYDATA")


,validReports:=[]
gui,+ToolWindow -Caption -Border +hwndtraytipguihwnd
gui,Font,s10,Verdana
gui,Add,Text,vcount,% "0000000"


Menu, Tray, Click, 2
Menu, tray, add, Delete All,deleteAll
Menu, tray, add, Delete reports,deleteReports
Menu, tray, add, Reload,Reload
Menu, Tray, Add, Feed Folder, openFeedFolder
;~ Menu, Tray, Default, Feed Folder 
gosub,RisState
settimer,risState,1000
interval:=3000
pause:=0
reportdir:=a_mydocuments "\feedRIS"
if !InStr(FileExist(reportdir), "D")
	filecreatedir,% reportdir
if !InStr(FileExist(reportdir "\saved"), "D")
	filecreatedir,% reportdir "\saved"

gosub env
getValidReports()
settimer,riserror,500


return

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	global ReportList, ReportListSet
	;~ static lastTick
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	;~ msgbox % lpData
	try
		json:=jxon_load(lpData)
	catch 
		return
	;~ clipboard:=lpData "`n`n`n"
	;~ ToolTip % exploreObj(json)
	if (json.ReportList){
		ReportList:=reportList:=new DataGridTable(json.ReportList)
		,ReportListSet:=true
	}
}
	

TrayTipShow(count){
	global
	
	if Mod(StrLen(dots),3)=0
		dots:="."
	else 
		dots.="."
		
	count:=count>20?">20":count
	while StrLen(count)<5
		count:=" " count
	guicontrol,,count,% count dots
	gui,Show,% "noactivate w80 h30 x" A_ScreenWidth-80 " y" A_ScreenHeight-120
	winset,AlwaysOnTop,on,ahk_id %traytipguihwnd%
	SetTimer,traytipguihide,-3000
}

traytipguihide:
gui,Hide
return


reportSaved(){
	global sending
	if(!sending)
		SetTimer,getValidReports,-1
}

Reload:
Reload
return

risState:
if !WinExist("ahk_id " RisState[2])
	RisState:=RisOpened()
if(oldRisState[2]=RisState[2]) && sendButtonHwnd && nextButtonHwnd
	return
oldRisState:=RisState.clone()
,RisReports:=getRisReports(RisState[2])
,RisAccNoHwnd:=getRisAccNoHwnd(RisState[2])
,ChartNoHwnd:=getRisChartNoHwnd(RisState[2])
,sendButtonHwnd:=saveMode?getNetControl2(RisState[2],"暫存","cmdRunSave","暫存","WindowsForms10.BUTTON.app","","","",0)[1]:getNetControl2(RisState[2],"存檔發送","cmdRunVerifySend","存檔發送","WindowsForms10.BUTTON.app","","","",0)[1]
,nextButtonHwnd:=getNetControl2(RisState[2],"下筆","cmdRunNext","下筆","WindowsForms10.BUTTON.app","","","",0)[1]
return

riserror:
IfWinExist,kReport ahk_class #32770,because it is being used by another process.
	WinClose,kReport ahk_class #32770,because it is being used by another process.
ifwinexist,kReport ahk_exe Menu.exe,% "已無任何待判讀"
{
	controlclick,Button1
	winshow,% "ahk_id " RisState[2]
	winset,enable,,% "ahk_id " RisState[2]
	winactivate,% "ahk_id " RisState[2]

}
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
	filedelete,% reportdir "\*"
	loop,% reportdir "\*",1,0
		fileremovedir,% a_loopfilefullpath,1
	FileCreateDir,% reportdir "\saved"
	msgbox,,,% "Deleted!",2
}
return

deleteReports:
filedelete,% reportdir "\*.txt"
if(!errorlevel)
	msgbox,,,% "Deleted!",2
return

openFeedFolder:
run % reportdir
return

traytip:
TrayTip
return

getValidReports(gotoSend=true){
	global validReports, validReportsInfo,____, reportListAccNos,validFile,reportdir
	validReports:=[]
	,validReportsInfo:=[]
	loop,%reportdir%\*.txt
			if (regexmatch(a_loopfilename,"([TY]\w{9}\d) \w{6}\d", match) || regexmatch(__CryptStr(SubStr(A_LoopFileName,1,-4),____,0),"([TY]\w{9}\d) \w{6}\d", match)) {
				FileGetAttrib,attr,% A_LoopFileLongPath
				FileGetSize,fs,% A_LoopFileLongPath
				if !InStr(attr, "H") && (fs>6) {
					validReports[A_LoopFileName]:=match1
					,validReportsInfo[match1]:=A_LoopFileName
				}
			}
			
	validFile:=0
	for k,v in reportListAccNos
		if validReportsInfo.haskey(k)
			validFile++
	
	if gotosend
		SetTimer,sendReport,-1
}


sendReport:
sending:=1
	gosub RisState
	if (pause)
		settimer,sendReport,-1000
	
	countFile:=validReports.SetCapacity(0)


	if (ReportListSet && !validFile) || (!ReportListSet && !countFile){
		;~ settimer,sendReport,-5000
		;~ exitapp
		gosub collectRisAccNos
		SetTimer,getValidReports, -5000
		goto sendReportEnd
	}
	
	;~ if(ReportListSet)
		;~ traytip,,% validFile>20?">20":validFile,1
	;~ else
		;~ traytip,,% countFile>20?">20":countFile,1
	;~ traytip,,% countFile,1
	
	;~ settimer,traytip,-1000
	
	thisAccNo:=controlgettext(RisAccNoHwnd)
	while (priorAccNo && priorAccNo=thisAccNo) {
		sleep % floor(interval/2)
		if(a_index>10)
			break
	}
	
	
	priorAccNo:=thisAccNo
	if(!winexist("ahk_id " RisState[2]) && !winexist("ahk_id " (RisState:=RisOpened())[2])){
		Msgbox,,, % "Please reopen RIS!",10
		settimer,env,-30000
		;~ settimer,saveToFile,-1
		goto sendReportEnd
	}
	if (!controlexist(RisReports[1,1]) && !controlexist((RisReports:=getRisReports(RisState[2]))[1,1])){
		Msgbox % "Please reopen 報告撰打作業!"
		settimer,env2,-30000
		;~ settimer,saveToFile,-1
		goto sendReportEnd
	}
	
	thisChartNo:=controlgettext(chartNoHwnd)
	,errorSend:=0
	if (FileExistValid(thisFile:=reportdir "\" thisAccNo " "  thisChartNo ".txt") || FileExistValid(thisFile:=reportdir "\" __CryptStr(thisAccNo " "  thisChartNo,____) ".txt")){
		FileGetSize,fs,% thisFile
		if (fs>6){
			
		
		
		fileread,contents,% thisFile
		if !InStr(contents, "Chart")
			contents:=__CryptStr(contents,____, 0)
		
		
		if InStr(contents, "(N/A)")
			FileSetAttrib,+H,% thisFile
		
		else if !InStr(contents, "(N/A)") && RegExMatch(contents,"s)(.*)\r?\n-=-=-=-=-\r?\n(.*)",match) && !(match1="" && match2=""){
			
			;~ if RegExMatch(match1, "is)(.*)zv\s*$", m){
				;~ match1:=m1
				;~ controlsettext,,% "(Due to work overload of the radiologists, this report is completed in limited reading time, which may cause suboptimal detection rate for the lesions. Suggest double-reading by the clinician and correlate with clinical information.)",% "ahk_id " RisReports[1,3]
			;~ }
			if InStr(ParseRisExamItems(getRisExamItems(RisState[2]))[1,1], "spine") && (match1~="i)(^|\r?\n)fracture\.")
				match1:=RegExReplace(match1, "i)(^|\r?\n)fracture\.", "$1Compression fracture.")
			if (match2="")
				match2:="."
			controlsettext,,% match1,% "ahk_id " RisReports[1,1]
			controlsettext,,% match2,% "ahk_id " RisReports[1,2]
			if(controlgettext(RisReports[1,1])=match1 && controlgettext(RisReports[1,2])=match2){
				if (InStr(reportHint:=getReportHint(RisState[2]),"請於impression輸入中文診斷") && Trim(ControlGetText(RisReports[1,2]))="" )
					ControlSetText,,% "Please see the findings.",% "ahk_id " RisReports[1,2]
				
				
				acc_objectfromwindow(sendButtonHwnd).accDoDefaultAction()
				,TrayTipShow(countFile)
				filemove,% thisFile,% reportdir "\saved\" (cryptedFilename:=__CryptStr(thisAccNo " " thisChartNo,____)) ".txt" ,1
				FileRemoveDir,% reportdir "\" cryptedFilename,1
				FileRemoveDir,% reportdir "\" thisAccNo " " thisChartNo,1
				SplitPath,thisFile,fileNameFull
				validFile--, countFile--
				, validReports.delete(filenameFull)
				,validReportsInfo.delete(thisAccNo)
			}else
				errorSend:=0
		}else{
			acc_objectfromwindow(nextButtonHwnd).accDoDefaultAction()
		}
		
		}else{
			acc_objectfromwindow(nextButtonHwnd).accDoDefaultAction()
		}
		
	}else{
		acc_objectfromwindow(nextButtonHwnd).accDoDefaultAction()
	}
	
	;~ if (countFile=1)
		;~ sleep 5000
	;~ else if (countFile<5)
		;~ sleep 3000
	;~ else 
		SetTimer,sendReport,-1000
	;~ sleep % interval
sendReportEnd:
sending:=0
return

env:

loop {
	if ((RisState:=RisOpened())[1]!=2){
		for k,v in RisOpened(1)[2]
			WinShow,ahk_id %v%
		
		if ((RisState:=RisOpened())[1]=2)
			break
		
		MsgBox, 49, , % "Open RIS first!"
		ifmsgbox,OK
			sleep 10000
		else
			exitapp
	}else
		break
}
gosub collectRisAccNos
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
	}else{
		;~ SetTimer,sendReport,-1
		break
	
	}
}


return

collectRisAccNos:
ReportList:=ParseDataGrid2(RisListHwnd:=getRisList(RisState[2]))

,statusCol:=reportList.getColNo("status")
,ChartNoCol:=reportList.getColNo("ChartNo")
,AccNoCol:=reportList.getColNo("AccNo")
,ExamDateCol:=reportList.getColNo("ExamDate")
,ExamNameCol:=reportList.getColNo("ExamName")
,reportvsCol:=reportList.getColNo("ReportVS")
,reportListAccNos:=[]
for k,row in reportList.data {
	if (row[statusCol]!="已發報告")
		reportListAccNos[row[AccNoCol]]:=row[ChartNoCol]
}
return

^!a::
Pause
return

;~ esc::
;~ ExitApp
;~ return
!#p::
;~ RisState:=RisOpened()
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
;~ RisState:=RisOpened()
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

Quit:
ExitApp
return

onexit:
while WinExist("kReport", "報告清單無資料")
	WinClose,kReport,報告清單無資料
winshow,% "ahk_id " RisState[2]
winset,enable,,% "ahk_id " RisState[2]
winactivate,% "ahk_id " RisState[2]
;~ winshow,ahk_exe Menu.exe
ExitApp