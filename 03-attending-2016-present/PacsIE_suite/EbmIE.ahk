/*
	scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
;~ #notrayicon
onexit,onexit
#include <EbmWebPacs>
#include <RisImpax>
#include <SetTimerF>
#include <WindowShellEvent>

thisHwnd:= WinExist("Ahk_PID " pid:=DllCall("GetCurrentProcessId"))
,onmessage(0______,"nextStudy")
,onmessage(0______,"priorStudy")
,onmessage(0______,"exit")
,OnMessage(0______,"activateMain")
,OnMessage(0______,"sendReport")


gosub readIni
gosub setHotKey
if !instr(fileexist(reportDir),"D")
	reportDir:=a_mydocuments "\feedRIS"
reportList:=[]
openedEBM:=[]
,openedEBM.Count:=0

settimer,checkActiveWin,500

;~ goto test

gosub checkRisOpened


thisHwnd:=WinExist("ahk_pid " thisPid := DllCall("GetCurrentProcessId"))
,RisState:=RisOpened()
,RisListHwnd:=getRisList(RisState[2])
,RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
,reportListCount:=parseDataGrid(RisListRowsAcc, reportList, 1, 1)
,monitors:=monitorInfo()
,monitorCount:=monitors.maxindex()

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
RisSearchResultCount:=(RisSearchResultCount(RisState[2])+1)
,RisListRowsCount:=RisListRowsAcc.maxindex()
,parseDataGrid(RisListRowsAcc,reportList,1,0,"","","reportListProgress")
,AccNoHwnd:=getRisAccNoHwnd(RisState[2])

if(currentAccNo:=controlgettext(AccNoHwnd)){
	thisStudyInd:=1,foundPos:=0
	loop % reportListCount-1 {
		++thisStudyInd
		;~ test:=acc_children(RisListRows[thisStudyInd])[statusCol].accValue
		if !foundPos && (rowAcc:=acc_children(RisListRowsAcc[thisStudyInd]))[AccNoCol].accValue!=currentAccNo
			continue
		foundPos:=1
		if (rowAcc[statusCol].accValue="已發報告")
			continue
		thisAccNo:=acc_children(RisListRowsAcc[thisStudyInd])[AccNoCol].accValue
		if thisAccNo!="" && !fileexist(reportDir "\" thisAccNo "*.txt")
			break
	}
}else{
	thisStudyInd:=1
	loop % reportListCount-1 {
		++thisStudyInd
		;~ test:=acc_children(RisListRows[thisStudyInd])[statusCol].accValue
		if (acc_children(RisListRowsAcc[thisStudyInd])[statusCol].accValue="已發報告")
			continue
		thisAccNo:=acc_children(RisListRowsAcc[thisStudyInd])[AccNoCol].accValue
		if thisAccNo!="" && !fileexist(reportDir "\" thisAccNo "*.txt")
			break
	}
}

if (thisAccNo=""){
	showErrorAndExit("No available report on the list.`nThis application will exit.")
}

settimer,openOthers,-1
main:
gosub initWebPacs


globalInd:=1


gosub init

;~ SetTimerF("parseDataGrid", -1, [RisListRowsAcc, reportList, 1, 0, 0, 11], -1)
return

;~ esc::ExitApp
;~ n::
;~ nextStudy()
;~ return
;~ p::
;~ priorStudy()
;~ return

test:
thisHwnd:=WinExist("ahk_pid " thisPid := DllCall("GetCurrentProcessId"))
,monitors:=monitorInfo()
,monitorCount:=monitors.maxindex()
,reportList:=[[""], [thisAccNo:="T__________"], ["T__________"], ["T__________"], ["T__________"], ["T__________"], ["T__________"]] 
,thisStudyInd:=2
,AccNoCol:=1
,reportListCount:=reportList.maxindex()
,test:=true
goto main
return

openOthers:
if !winexist("ahk_exe feedRIS.exe")
	run % a_scriptdir "\feedRIS.exe"
return

init:
gui,EbmIELogGUI: +hwndlogGuiHwnd

webPacs.queryIE(reportList[thisStudyInd, AccNoCol], 1, true)
Sleep 2000
Loop % totalIE-1 {
	ind:=A_Index+1
	, webPacs.queryIE(reportList[thisStudyInd+ind-1, AccNoCol], ind, true)
	;~ Loop
		;~ Sleep 100
	;~ until A_TickCount-openedEBMLastRenew<500
}
hwnd:=0
Loop
	Sleep 100
until WinExist("ahk_id " hwnd:=openedEBM[thisAccNo, "hwnd"]) || A_Index>100

if(hwnd){
	showStudy(hwnd)
	logGui(thisAccNo " " openedEBM[thisAccNo, "chartNo"] " " openedEBM[thisAccNo, "examName"])
}else{
	Msgbox % "Can't find the opened EBM viewer for study: " thisAccNo
	return
}
return

logGui(title){
	global logGuiHwnd
	WinSetTitle,ahk_id %logGuiHwnd%,,% "EbmIE Log GUI: " title 
}

showStudy(hwnd, activate=true){
	global monitors, monitorCount
	WinShow,ahk_id %hwnd%
	monitor:=monitors[monitorCount>1?2:1]
	WinMove,ahk_id %hwnd%,,% monitor.l, % monitor.t, % monitor.w, % monitor.h
	if(activate)
		WinActivate,ahk_id %hwnd%
}

nextStudy(){
	global globalInd, thisStudyInd, reportList, openedEBM, webPacs, reportListCount, RisState, thisAccNo, AccNoCol
	thisStudyInd++, globalInd++
	
	tmpAccNo:=thisAccNo
	if(thisStudyInd>reportListCount){
		Msgbox,8192,, % "This is the LAST study!"
		WinShow,% "ahk_id " RisState[2]
		return 
	}

	;~ grantBypassWinActiveHook()
	Loop
		Sleep 100
	until (thisStudyAcc:=reportList[thisStudyInd, AccNoCol]) || ((i:=a_index)>50)
	
	
	if(i>50){
		MsgBox % "Can't get AccNo at index: " thisStudyInd
		return
	}
	
	thisAccNo:=thisStudyAcc
	
	hwnd:=0
	Loop 2 {
		Loop
			Sleep 100
		until WinExist("ahk_id " hwnd:=openedEBM[thisStudyAcc, "hwnd"]) || A_Index>100

		if(hwnd){
			break
		}else{
			webPacs.queryIE(thisStudyAcc, nextInd(globalInd-1), true)
		}
	}
	if(hwnd){
		showStudy(hwnd)
		logGui(thisStudyAcc " " openedEBM[thisStudyAcc, "chartNo"] " " openedEBM[thisStudyAcc, "examName"])
	}else{
		Msgbox % "Can't find the opened EBM viewer for study: " thisStudyAcc
	}
	
	WinHide,% "ahk_id " openedEBM[tmpAccNo, "hwnd"]
	
	if(thisStudyInd>2){
		SetTimerF("preload", -1000, [thisStudyInd+2, priorInd(globalInd-1)])
	}
}

priorStudy(){
	global globalInd, thisStudyInd, reportList, openedEBM, webPacs, reportListCount, RisState, thisAccNo, AccNoCol
	thisStudyInd--, globalInd--
	
	if(thisStudyInd<2){
		Msgbox,8192,, % "This is the FIRST study!"
		WinShow,% "ahk_id " RisState[2]
		return 
	}
	
	tmpAccNo:=thisAccNo
	;~ grantBypassWinActiveHook()
	thisStudyAcc:=reportList[thisStudyInd, AccNoCol]
	thisAccNo:=thisStudyAcc

	hwnd:=0
	Loop 2 {
		Loop
			Sleep 100
		until WinExist("ahk_id " hwnd:=openedEBM[thisStudyAcc, "hwnd"]) || A_Index>100

		if(hwnd){
			break
		}else{
			webPacs.queryIE(thisStudyAcc, nextInd(globalInd-1), true)
		}
	}
	if(hwnd){
		showStudy(hwnd)
		logGui(thisStudyAcc " " openedEBM[thisStudyAcc, "chartNo"] " " openedEBM[thisStudyAcc, "examName"])
	}else{
		Msgbox % "Can't find the opened EBM viewer for study: " thisStudyAcc
	}
	
	WinHide,% "ahk_id " openedEBM[tmpAccNo, "hwnd"]
	
}

preload(studyInd, whichEBM){
	global webPacs, reportList, AccNoCol, reportListCount, thisStudyInd
	if(studyInd>reportListCount)
		return
	
	if(thisStudyInd+1<=reportListCount)
		showStudy(openedEBM[reportList[thisStudyInd+1, AccNoCol], "hwnd"], false)
	
	webPacs.queryIE(reportList[studyInd, AccNoCol], whichEBM, true)
}

checkActiveWin:
winget,activeWinHwnd,id,A
shellMessage(4, activeWinHwnd)
return

shellMessage(wParam, lParam){
	Critical
	global bypassWinActiveHook
	if (wParam = 4 && !bypassWinActiveHook){ ; window activated
		WinGetTitle,t,ahk_id %lParam%
		WinGetClass,c,ahk_id %lParam%
		if (c="TViewerForm"){
			SetTimerF("renewOpenedEBM", -1, [lParam, t])
		}
	}
}

renewOpenedEBM(activeHwnd, activeTitle){
	global openedEBM, thisAccNo, openedEBMLastRenew, reportList, thisStudyInd, AccNoCol, examNameCol, chartNoCol
	static staticArr:=["chartNo", "name", "age", "gender", "examDate"]
	
	if !InStr(activeTitle, thisAccNo)
		settimer,activateSimpleRis,-1
	
	if WinExist("ahk_id " hwnd:=openedEBM[thisAccNo, "hwnd"]) && hwnd=activeHwnd
		return
	
	toBeRemoved:=[]
	for k,v in openedEBM
		if !WinExist("k") || !WinExist("ahk_id " v.hwnd) 
			toBeRemoved.push(k)
	
	for k,v in toBeRemoved
		openedEBM.Delete(v)
		, openedEBM.Count:=openedEBM.Count-1
	
	winget,list,list,ahk_class TViewerForm
	Loop % list {
		hwnd:=list%a_index%
		WinGetTitle,t,ahk_id %hwnd%
		if RegExMatch(t, "病歷號: (\w{6}\d) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d+\/\d+\/\d+) 存取編號: ([TY]\w{9}\d)", match){
			if(match6!=thisAccNo)
				WinHide,ahk_id %hwnd%
			if(!openedEBM.haskey(match6) && hwnd!=openedEBM[match6].hwnd){
				openedEBM[match6, "hwnd"]:=hwnd
				
				Loop 8 
					if (match6=reportList[thisStudyInd-4+A_Index, AccNoCol]){
						thisExamName:=reportList[thisStudyInd-4+A_Index, examNameCol]
						, thisChartNo:=reportList[thisStudyInd-4+A_Index, chartNoCol]
						break
					}
				openedEBM[match6, "examName"]:=Trim(thisExamName)
				,openedEBM[match6, "chartNo"]:=Trim(thisChartNo)
				
				
				for k,v in staticArr
					openedEBM[match6, v]:=match%k%
				openedEBM.Count:=openedEBM.Count+1
				,openedEBMLastRenew:=A_TickCount
				;~ TrayTip,,% "hide: " t
			}
		}
	}
}

grantBypassWinActiveHook(duration=1000){
	global bypassWinActiveHook
	bypassWinActiveHook:=true
	,SetTimerF("noBypassWinActiveHook", (-1)*duration)
}
noBypassWinActiveHook(){
	global bypassWinActiveHook
	bypassWinActiveHook:=false
}

nextInd(ind){
	global totalIE
	return Mod(ind, totalIE)+1
}
priorInd(ind){
	global totalIE
	return Mod(ind-2+totalIE, totalIE)+1
}

readIni:
root:=substr(a_scriptdir,1,1)
,ini:=a_scriptdir "\PacsIE.ini"
iniread,reportDir,% ini,Settings,暫存資料夾
iniread,loginId,% ini,Settings,portal帳號
iniread,loginPw,% ini,Settings,portal密碼
return

initWebPacs:
totalIE:=4
,webPacs:=new EbmWebPacs("hc", loginId, loginPw)
,webPacs.createIE(totalIE-1)
Loop % totalIE-1
	webPacs.loginIE(loginId, loginPw, A_Index+1)
;~ WindowShellEvent("shellMessage")
return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){
	global RisSearchResultCount
	tooltip % "Get list from RIS: " k-1 " / " RisSearchResultCount-1 " ..."
}

checkRisOpened:
if (risopened()[1]!=2){
	showErrorAndExit("Open RIS first.`nThis application will exit.")
}
return

showErrorAndExit(msg, exitapp=1, return=0){
	MsgBox, 4144, ,% msg
	if exitapp
		exitapp
	else
		return % return
}

setHotKey:

iniread,showChartNo,% ini,Settings,showChartNo,1
iniread,showAccNo,% ini,Settings,showAccNo,1
iniread,addNormalHeartSize,% ini,Settings,addNormalHeartSize,0


iniread,noAdditionalHotkey,% ini,Settings,noAdditionalHotkey,0
if(noAdditionalHotkey)
	return 

iniread,sendReportKey,% ini,Settings,發送,F3
iniread,activateSimpleRisKey,% ini,Settings,activateSimpleRisKey,CapsLock
try {
	hotkey,ifwinactive,simple RIS ahk_class AutoHotkeyGUI
	hotkey,% sendReportKey,sendReport
	;~ hotkey,ifwinactive,ahk_group MyGUI
	;~ hotkey,% sendReportKey,sendReport
	hotkey,ifwinactive
	
	hotkey,% activateSimpleRisKey " UP",activateSimpleRis
	if(activateSimpleRis="CapsLock"){
		settimer,setcapslockstate,500
		hotkey,% "#" activateSimpleRisKey,toggleCapslockState
	}
}catch e{
	tooltip % e.Message
}
;~ if !winexist("ahk_exe PacsIEMain.exe") {
	;~ hotkey,~!#q,guiclose
;~ }
return

setcapslockstate:
SetCapslockstate,% capslockstate?"on":"off"
return

toggleCapslockState:
capslockstate:=!capslockstate
gosub setcapslockstate
return

sendReport(){
	gosub sendReport
}

sendReport:
if (!editHwnd || !controlexist(editHwnd))
	controlget,editHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
if !controlexist(editHwnd)
	return
if (text:=trim(controlgettext(editHwnd)))=""
	return
Text:=RegExReplace(Text, "i)\/(placement|metal)", ".$1")
if RegExMatch(Text, "i)\.?\w+\/?placement", match) && !InStr(match, "replacement"){
	MsgBox, 4404, Typo in report, Continue?
	IfMsgBox,No
		return
}
examDate:=RegExReplace(reportList[thisStudyInd, examDateCol], "\D" ,"")
,now:=A_Now
now-=examDate, Days
;~ msgbox % examDate "," now
if(now>90 && !InStr(Text, "this study is reassigned to current radiologist on "))
	text.="this study is reassigned to current radiologist on " A_YYYY "/" a_mm "/" a_dd ". "
checkReport(text)
;~ controlsettext,,% "",ahk_id %editHwnd%
;~ Edit_SetText(editHwnd, "")
postmessage,0x2024,,,,simple RIS ahk_class AutoHotkeyGUI
nextStudy()
postmessage,0x1011,,,,ahk_exe feedRIS.exe
return

checkReport(text){
	global reportDir,editHwnd,monitors,monitorCount,reportList,openedEBM
	
	;~ text:=RegExReplace(text,"\.+",".")
	text:=RegExReplace(text,"\ {2,}(?!(-+ |\d+\W ))"," ")
	,text:=RegExReplace(text,"(?<=[\,\.\;\(])\ {2,}"," ")
	;~ ,text:=RegExReplace(text," {2}"," ")
	,text:=RegExReplace(text,"\.{2,}",".")
	,text:=RegExReplace(text,",{2,}",",")
	,text:=RegExReplace(text,"\.\,",",")
	,text:=RegExReplace(text,"\,\.",".")
	,text:=RegExReplace(text,"\.\/",". ")
	,text:=RegExReplace(text,"\ ([,.;])","$1")
	,text:=RegExReplace(text,"i)([a-z])\. ([a-z])","$1.$2")
	,text:=RegExReplace(text,"([,;])(\w)","$1 $2")
	,text:=RegExReplace(text,".\ {2,}(\r?\n)",". $1")
	,text:=RegExReplace(text,"(^(\r?\n)+)|((\r?\n)+$)","")
	,text:=RegExReplace(text,"at at","at ")
	;~ ,Text:=RegExReplace(Text, "i)\/(placement)", ".$1")
	;~ text:=RegExReplace(text,"(\.)  +(\w)",". $2")
	,newText:=""
	,incomplete:=0
	loop,parse,text,`.
		if regexmatch(a_loopfield,"\w"){
			;~ if strlen(line:=trim(a_loopfield))<5
				;~ incomplete:=1
			newText.=stringupper(substr(trim(a_loopfield),1,1)) substr(trim(a_loopfield),2) ". "
		}else{
			newText.=trim(a_loopfield) ". "
		}
	newText:=substr(newText,1,-2)
	,newText:=RegExReplace(newText,"(\d). (\d)","$1.$2")
	,newText:=RegExReplace(newText,"\. \)",".)")
	,newText:=RegExReplace(newText,"(?<!\n) {2,}"," ")
	,newText:=RegExReplace(newText,"[\.\ ]+$",".")
	
	,monitor:=monitors[(monitorCount>=2)?2:1]
	,thisGetTitle:=WinGetAtCoords(monitor.l+monitor.w/2, monitor.the + monitor.h/4)
	,RegExMatch(thisGetTitle, "病歷號: (\w{6}\d) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d+\/\d+\/\d+) 存取編號: ([TY]\w{9}\d)", match)
	,thisStudyAcc:=match6,thisChartNo:=match1
	,Exam:=openedEBM[thisStudyAcc, "ExamName"]
	
	,selStart:=0
	loop,parse,nexText,`.
		if strlen(line:=trim(a_loopfield))<5 && regexmatch(line,"^[a-z]+\d*?$") {
			incomplete:=1
			break
		}else{
		selStart+=strlen(a_loopfield)+1
	}
	
	if (incomplete){
		settimer,moveMsgBox,20
		msgbox,4144,,% "Check the report for AHK error!"
		;~ controlsettext,,% newText,ahk_id %editHwnd%
		Edit_SetText(editHwnd, newText)
		,Edit_setsel(editHwnd,seltStart,selStart+strlen(line))
		,Edit_ScrollCaret(editHwnd)
		return -1
	}
	
	
	if (thisStudyAcc="" || thisChartNo=""){
		settimer,moveMsgBox,20
		msgbox,,,% "Accession No or chart No error !!!`nRestart in 5 seconds...",5
		run % "EbmIE.exe" (a_iscompiled?"":" EbmIE.ahk")
		exitapp
	}
	
	filedelete,% filePath:=reportDir "\" thisStudyAcc " " thisChartNo ".txt"
	fileappend,% addTitle(newText,Exam,thisAccNo,thisChartNo) "`r`n-=-=-=-=-`r`n",% filePath,utf-8
	tooltip % "Saved !"
	settimer,tooltip,-1000
}	

addTitle(newText,exam="",accNo="",chartNo=""){
	global showAccNo, showChartNo, addNormalHeartSize
	
	risState:=RisOpened()
	
	if instr(newText,"EXAMINATION:")
		return newText
	if instr(newText,"shows")
		newText:=RegExReplace(newText,"is)^.+shows\s*","")
		,newText:=stringupper(substr(newText,1,1)) substr(newText,2)
	
	if (addNormalHeartSize && RegExMatch(exam,"is)Chest : (PA|AP) View") && !regexmatch(newText,"i)normal heart size|cardiomegaly|borderline heart size|heart border|opacified (left|right) hemithorax"))
		heartSize:="Normal heart size. "
	else 
		heartSize:=""
	
	exam:=RegExReplace(exam," ?: ?"," - ")
	return  (showChartNo?(chartNo=""?"":"Chart No: " chartNo "`r`n"):"") (showAccNo?(accNo=""?"":"Accession No: " accNo "`r`n"):"") "EXAMINATION: " exam (match1=""?"":" (" match1 ")") ".`r`nFINDINGS:`r`n" heartSize RegExReplace(newText,"(^(\r?\n)+)|((\r?\n)+$)","")
}
stringupper(t){
	StringUpper,t,t
	return t
}

tooltip:
ToolTip
return

moveMsgBox:
if msgboxHwnd:=winexist("ahk_class #32770 ahk_exe EbmIE.exe") {
	winmove,ahk_id %msgBoxHwnd%,,% monitors.2.l+(monitors.2.w)/2,% (monitors.2.h)/2
	winset,AlwaysOnTop,on,ahk_id %msgBoxHwnd%
	;~ winset,AlwaysOnTop,off,ahk_id %msgBoxHwnd%
	settimer,moveMsgBox,off
}
return


activateSimpleRis:
showStudy(reportList[thisAccNo, "hwnd"], true)
simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
winactivate,ahk_id %simpleRis%
ControlFocus,Scintilla1,ahk_id %simpleRIS%
return

#ifwinactive,ahk_exe simpleRIS.exe
F12::
critical
nextStudy()
return
F11::
critical
priorStudy()
return
#IfWinActive

OnExit:
for k,v in openedEBM
	WinShow,% "ahk_id " v.hwnd
ExitApp
return
