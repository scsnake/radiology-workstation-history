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
#notrayicon
onexit,onexit

;~ msgbox %1% , %2%
;~ exitapp

if %0% {
	param:=[]
	loop %0%
		param.push(%a_index%)
	for k,v in param {
		if(v="-offline"){
			offlineMode:=1
		}else if(v="-nogdi"){
			nogdi:=1
		}
	}
}
;~ msgbox % offlineMode
;~ updateLibPath()
if (!offlineMode && !winexist("ahk_exe getAllJpeg.exe")){
	run,% a_scriptdir "\getAllJpeg.exe"
	sleep 2000
}


#include <portallib>
#include <RisImpax>
#include <Acc>
#include <.NetGetControl>
#include <Gdip>
#include <SetTimerF>
#include <EmptyMem>
#include <WinGetAtCoords>
#include <RXMS>
#include <WinVisible>


root:=substr(a_scriptdir,1,1)
ini:=a_scriptdir "\PacsIE.ini"
gosub checkRisOpened

gosub openOthers
gosub setHotKey

if(!noGDI)
	pToken := Gdip_Startup()


iniread,reportDir,% ini,Settings,暫存資料夾
if !instr(fileexist(reportDir),"D")
	reportDir:=a_mydocuments "\feedRIS"

;~ reportDir:=a_mydocuments "\feedRIS"
;~ reportDir:=root ":/scripts/Radiology/feedRIS"

;~ winget,thisHwnd,id,ahk_exe PacsIE.exe
thisHwnd:= WinExist("Ahk_PID " pid:=DllCall("GetCurrentProcessId"))
onmessage(0______,"next")
onmessage(0______,"prior")
onmessage(0______,"exit")
OnMessage(0______,"activateMain")

;~ run,% a_scriptdir "\getAllJpeg.exe"

;~ ahkthread("
;~ (
;~ #notrayicon
;~ return
;~ ~#!q::
;~ process,close,ahk_pid " pid "
;~ exitapp
;~ return
;~ )")


;~ DllCall( "RegisterShellHookWindow", UInt,winexist() )
;~ MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
;~ OnMessage( MsgNum, "ShellMessage" )
;~ settimer,routine,500
;~ ahkmini("
;~ (
;~ #persistent 
;~ #notrayicon
;~ setbatchlines,-1
;~ settimer,routine,500
;~ return
;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ ifwinexist,Internet Explorer Script Error
	;~ winclose
;~ ifwinexist,Internet Explorer 指令碼錯誤
	;~ winclose
;~ return
;~ )")

;~ loginId:=loginId

iniread,loginId,% ini,Settings,portal帳號
iniread,loginPw,% ini,Settings,portal密碼
if !(sid:=login(loginId,loginpw)){
	msgbox % "Portal無法登入：帳號密碼錯誤或是portal暫時無法使用"
	run % ini
	exitapp
}
if (!offlineMode){
	;~ if !PacsWebLogin(loginId,loginPw){
		;~ MsgBox, 4145, ,% "PacsWeb無法使用，使用離線模式？"
		;~ ifmsgbox,OK
			;~ if A_IsCompiled
				;~ run PacsIE.exe -offline
			;~ else
				;~ run PacsIE.exe PacsIE.ahk -offline
		;~ exitapp
	;~ }
}

monitors:=monitorInfo()
if monitors.maxindex()<2 {
	msgbox % "Single monitor not supported!"
	ExitApp
}
monitorInd:=0
monitorCount:=monitors.maxIndex()-1
fixedMonitor:=2
totalGUI:=monitorCount*(monitorCount=1?4:2),guiInd:=1
hx:=CriticalObject(),pHx:=&hx
hx2Yr:=CriticalObject()
threadPool:=[]
reportList:=CriticalObject(),pReportList:=&reportList
title:=[]
downloaded:=[]
settimerF("threadMonitor",3000)
boneKeywords:=["rib","fracture","bone","bony","\bsclero","lytic"]
	,lungKeyWords:=["(lung|pulmonary) (nodule|mass|tumor|lesion|metasta)"]
	,cancerKeywords:=["cancer","malignant","malignancy","lymphoma","leukemia","tumor"]

RisState:=risopened()
AccNoHwnd:=getRisAccNoHwnd(RisState[2])
RisListHwnd:=getRisList(RisState[2])
RisListRowsAcc:=acc_children(acc_objectfromwindow(risListHwnd))
if (fileexist(reportDir "\resumePacsIE")){
	fileread,resumePacsIE,% reportDir "\resumePacsIE"
	RegExMatch(resumePacsIE,"i)[TY]\w{9}\d(?:[\s\r\n]*$)",thisAccNo)
}
if(thisAccNo=""){
	thisAccNo:=controlgettext(AccNoHwnd)
	
	reportListCount:=parseDataGrid(RisListRowsAcc,reportList, 1, 1)
	for k,v in reportList[1] {
		if (v="照會單號") {
			AccNoCol:=k
		}
		if (v="狀態") {
			statusCol:=k
		}
	}
	
	thisStudyInd:=1
	;~ RisListAcc:=acc_objectfromwindow(RisListHwnd)
	;~ RisListRows:=acc_children(RisListAcc)
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
;~ settimer,getReportList,-1
if (thisAccNo=""){
	msgbox % "No report on list!"
	exitapp
}
;~ settimer,closeError,500
globalInd:=1

function1:=createscript("`nloadHistory{}`nmatchText{}")




gosub createGUI
sleep 1000
gosub init

;~ settimer,<setLogGui,1000
;~ ahkmini(createscript("
;~ (
;~ #persistent
;~ #notrayicon
;~ setbatchlines,-1
;~ #include <WinGetAtCoords>
;~ detecthiddenwindows,on
;~ logHwnd:=" logHwnd ",thisHwnd:=" thisHwnd "
;~ reportDir:=""" reportDir """
;~ settimer,<setLogGui,1000
;~ settimer,routine,1000
;~ return
;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ return
;~ <setLogGui:setLogGui>
;~ )"))

;~ winhide,ahk_exe impax-client-main.exe
EmptyMem(pid)
settimerf("EmptyMem",60000,[pid])
;~ DetectHiddenWindows,off
;~ groupadd,impaxGroup,ahk_exe impax-client-main.exe
winminimize,% "ahk_id " impaxopened()[2,1]
;~ DetectHiddenWindows,on
return

activateMain(){
	global 
	gui,%shownGuiInd%: show
}

openOthers:
if !winexist("ahk_exe feedRIS.exe")
	run % a_scriptdir "\feedRIS.exe"
if !winexist("ahk_exe simpleRIS.exe"){
	run % a_scriptdir "\simpleRIS.exe"
	;~ simpleRisOpened:=1
}

return



setHotKey:

iniread,showChartNo,% ini,Settings,showChartNo,1
iniread,showAccNo,% ini,Settings,showAccNo,1
iniread,addNormalHeartSize,% ini,Settings,addNormalHeartSize,0
iniread,sendReportKey,% ini,Settings,發送,F3
iniread,activateSimpleRisKey,% ini,Settings,activateSimpleRisKey,CapsLock
iniread,noAdditionalHotkey,% ini,Settings,noAdditionalHotkey,0
if(noAdditionalHotkey)
	return 

try {
	hotkey,ifwinactive,simple RIS ahk_class AutoHotkeyGUI
	hotkey,% sendReportKey,sendReport
	hotkey,ifwinactive,ahk_group MyGUI
	hotkey,% sendReportKey,sendReport
	hotkey,ifwinactive
	
	hotkey,% activateSimpleRisKey " UP",activateSimpleRis
	if(activateSimpleRis="CapsLock"){
		settimer,setcapslockstate,500
		hotkey,% "#" activateSimpleRisKey,toggleCapslockState
	}
}
if !winexist("ahk_exe PacsIEMain.exe") {
	hotkey,~!#q,guiclose
}
return

setcapslockstate:
SetCapslockstate,% capslockstate?"on":"off"
return

toggleCapslockState:
capslockstate:=!capslockstate
gosub setcapslockstate
return

sendReport:
if (!editHwnd || !controlexist(editHwnd))
	controlget,editHwnd,hwnd,,Edit1,simple RIS ahk_class AutoHotkeyGUI
if !controlexist(editHwnd)
	return
if (text:=trim(controlgettext(editHwnd)))=""
	return
checkReport(text)
controlsettext,,% "",ahk_id %editHwnd%
nextStudy()
return

checkReport(text){
	global reportDir,offlineMode,editHwnd
	
	;~ text:=RegExReplace(text,"\.+",".")
	text:=RegExReplace(text,"\ {2,}(?!(-+ |\d+\W ))"," ")
	text:=RegExReplace(text,"(?<=[\,\.\;\(])\ {2,}"," ")
	;~ text:=RegExReplace(text," {2}"," ")
	text:=RegExReplace(text,"\.{2,}",".")
	text:=RegExReplace(text,",{2,}",",")
	text:=RegExReplace(text,"\.\,",",")
	text:=RegExReplace(text,"\,\.",".")
	text:=RegExReplace(text,"\ ([,.;])","$1")
	text:=RegExReplace(text,"i)([a-z])\. ([a-z])","$1.$2")
	text:=RegExReplace(text,"([,;])(\w)","$1 $2")
	text:=RegExReplace(text,".\ {2,}(\r?\n)",". $1")
	text:=RegExReplace(text,"(^(\r?\n)+)|((\r?\n)+$)","")
	text:=RegExReplace(text,"at at","at ")
	;~ text:=RegExReplace(text,"(\.)  +(\w)",". $2")
	newText:=""
	incomplete:=0
	loop,parse,text,`.
		if regexmatch(a_loopfield,"\w"){
			;~ if strlen(line:=trim(a_loopfield))<5
				;~ incomplete:=1
			newText.=stringupper(substr(trim(a_loopfield),1,1)) substr(trim(a_loopfield),2) ". "
		}else{
			newText.=trim(a_loopfield) ". "
		}
	newText:=substr(newText,1,-2)
	newText:=RegExReplace(newText,"(\d). (\d)","$1.$2")
	newText:=RegExReplace(newText,"\. \)",".)")
	newText:=RegExReplace(newText,"(?<!\n) {2,}"," ")
	newText:=RegExReplace(newText,"[\.\ ]+$",".")


	Exam:=thisAccNo:=thisChartNo:=""
	wingetTitle,title,PacsIE Log GUI ahk_class AutoHotkeyGUI
	regexmatch(title,"is)PacsIE Log GUI \w+: ([^ ]+) ([^ ]+) ([^\n]+)",match)
	Exam:=match3,thisAccNo:=match1,thisChartNo:=match2
	
	selStart:=0
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
		controlsettext,,% newText,ahk_id %editHwnd%
		Edit_setsel(editHwnd,seltStart,selStart+strlen(line))
		Edit_ScrollCaret(editHwnd)
		return -1
	}


	if (thisAccNo="" || thisChartNo=""){
		settimer,moveMsgBox,20
		msgbox,,,% "Accession No or chart No error !!!`nRestart in 5 seconds...",5
		run % "PacsIE.exe" (a_iscompiled?"":" PacsIE.ahk") (offlineMode?" -offline":"")
		exitapp
	}
	
	filedelete,% filePath:=reportDir "\" thisAccNo " " thisChartNo ".txt"
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
	
	if (addNormalHeartSize && RegExMatch(exam,"is)Chest : (PA|AP) View") && !regexmatch(newText,"i)normal heart size|cardiomegaly|borderline heart size|heart border"))
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

checkRisOpened:
Loop {
	if (risopened()[1]=2){
		break
	}else{
		if(a_index=1)
			msgbox,,,% "Open RIS first !",10
		else 
			sleep 2000
	}
}
return

;~ n::
;~ nextStudy()
;~ return
exit(){
	exitapp
}

~lbutton::
OnMessage( 0x200, "WM_MOUSEMOVE" ) 
return

~lbutton up::
OnMessage( 0x200, "" ) 
return

next(wParam, lParam){
	nextStudy()
}
prior(wParam, lParam){
	priorStudy()
}

#ifwinactive,simple RIS ahk_class AutoHotkeyGUI
F12::
critical
nextStudy()
return
F11::
critical
priorStudy()
return
#ifwinactive

#ifwinactive,ahk_group MyGUI
F12::
critical
nextStudy()
return
F11::
critical
priorStudy()
return

wheeldown::
wheelup::
mousegetpos,mx,my
wheelGui:=(mx>monitors.2.r)?2:1
,wheelUp:=(a_thishotkey="wheelup")
,thisPic:=loadedPic[shownGuiInd,wheelGui]
,regexmatch(thisPic,"(\w+ \w+)\\(\w+ \w+ )(\d+)(\.jpeg)",match)
;~ ,picArr:=[]
;~ loop, % reportDir "\" match1 "*.jpeg"
	;~ picArr.push(A_LoopFileLongPath)
if((picCount:=loadedPicCount[substr(match2,1,-1)])<2)
	return
if(wheelUp){
	if !fileexist(reportdir "\" nextPic:=(match1 "\" match2 (match3-1) match4))
		nextPic:=match1 "\" match2 (picCount) match4
}else{
	if !fileexist(reportdir "\" nextPic:=(match1 "\" match2 (match3+1) match4))
		nextPic:=match1 "\" match2 "1" match4
}

showImage(shownGuiInd,wheelGui,monitors[wheelGui+1],substr(match1,1,11),substr(match1,13,7),substr(match2,1,11),ind:=substr(nextPic,41,-5))
;~ loadedPic[guiInd,wheelGui]:=nextPic
showPicInfo(wheelGui,substr(match2,1,-1),ind)
return

#ifwinactive



createGUI:
WB:=[],GuiHwnd:=[],WBp:=[],loadedPic:=[],loadedPicCount:=CriticalObject(),guiHwnd2:=[]
loop % totalGUI {
	gui,color,black
	;~ Gui,%a_index%: +LastFound +ToolWindow  +hwndHwnd -border
	;~ if (pToken){
		;~ Gui,%a_index%: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd
		;~ if (monitorCount>1){
			;~ Gui,2%a_index%: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd2
			;~ guiHwnd2.push(hwnd2)
			;~ groupadd,MyGUI,ahk_id %hwnd2%
		;~ }
	;~ }else {
		Gui,%a_index%: -Caption +LastFound +ToolWindow -border +hwndHwnd
	;~ if (!pToken) {
		Gui,%a_index%: Add, Picture, % (noGdi?"":"altsubmit") " BackgroundBlack x0 y0 0xE hwndWBhwnd" a_index " vWB" a_index " w" (monitors.2.w) " h-1", 
		if monitorCount>1
			Gui,%a_index%: Add, Picture, % (noGdi?"":"altsubmit") " BackgroundBlack x" monitors.2.w+1 " y0 0xE hwndWBphwnd" a_index " vWBp" a_index " w" (monitors.3.w) " h-1" ,
		
	;~ }
		WB.push(WBhwnd%a_index%)
		WBp.push(WBphwnd%a_index%)
	;~ }
	;~ WB%a_index%.Navigate("about:blank")
	;~ WBp%a_index%.document.body.style.backgroundColor := "black"
	GuiHwnd.push(hwnd)
	
	groupadd,MyGUI,ahk_id %hwnd%
}




;~ bitmap2gui(WB[1],reportdir "\T__________ 8______\T__________ 8______ 1.jpeg",monitors.2.w)
;~ gui,1:show,% "w" (monitors.2.w)*2 " h" monitors.2.h " x" monitors.2.l " y0"
;~ bitmap2gui(WB[1],reportdir "\T__________ 6______\T__________ 6______ 1.jpeg",monitors.2.w)
;~ exitapp




gui,log: +hwndLogHwnd +toolwindow

gui,info1: font,s24 cSilver,Verdana
gui,info1: color,black
gui,info1: +ToolWindow  +hwndinfo1Hwnd -border  +lastFound +alwaysontop
WinSet, TransColor, black
gui,info1:add,text,vinfotext1,9999/9999
groupadd,MyGUI,ahk_id %info1hwnd%
if (monitorCount>1) {
	gui,info2: font,s24 cSilver,Verdana
	gui,info2: color,black
	gui,info2: +ToolWindow  +hwndinfo2Hwnd -border  +lastfound +alwaysontop
	winset,transcolor,black
	gui,info2: add,text,vinfotext2,9999/9999
	groupadd,MyGUI,ahk_id %info2hwnd%
}


gui,reportInfo: font,s14 cWhite,Verdana
gui,reportInfo: color,black
gui,reportInfo: +ToolWindow  +hwndreportInfoHwnd -border  +lastFound +alwaysontop
WinSet, TransColor, black
gui,reportInfo:add,text,vreportInfoText,% "T__________`n01234567`nStudy: 9999/9999`nTotal time: 99999999`nMean time: 9______"
;~ gui,reportInfo:show,% "x" (monitors.2.r)-250 " y" (monitors.2.b)-150
groupadd,MyGUI,ahk_id %reportInfoHwnd%

;~ sleep 1000
;~ gui,add,text,,test
;~ gui,log:show

;~ WB.Navigate(PacsWebUrl("T__________","",loginId,loginPw))
;~ sleep 5000
;~ gui,show,% "x" monitors.3.l " y" monitors.3.t " w" (monitors.3.w) " h" (monitors.3.h)
return


getReportList:
parseDataGrid(RisListRowsAcc,reportList, 1, totalGUI,0, [AccNoCol, thisAccNo])
return
offLineModeReportList:
parseDataGrid(RisListRowsAcc,reportList,1)
;~ msgbox % reportList.maxindex()
oldReportList:=reportList.clone()
reportList:=[]
for k,v in oldReportList {
	;~ test:=fileexist(reportDir "\" v[AccNoCol] " " v[ChartNoCol] "\" v[AccNoCol] " " v[ChartNoCol] " 1.jpeg")
	if (k=1) || fileexist(reportDir "\" v[AccNoCol] " " v[ChartNoCol] "\" v[AccNoCol] " " v[ChartNoCol] " 1.jpeg")
		reportList.push(v.clone())
}
reportListCount:=reportList.maxindex()
;~ msgbox % reportList.maxindex()
return


init:
reportListCount:=parseDataGrid(RisListRowsAcc,reportList, 1, 1)
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
;~ if !(AccNoCol && chartNoCol && examNameCol && statusCol){
	;~ settimer,init,-500
	;~ return
;~ }
if offLineMode 
	gosub offLineModeReportList
else 
	settimer,getReportList,-1

initSearch:

matched:=0
for k,v in reportList {
	if (v[AccNoCol]=thisAccNo){
		matched:=1,thisStudyInd:=k
		break
	}
}


if (!matched){
	settimer,initSearch,-1000
	return
}




gosub showfilter

totalStudyCount:=reportListCount-thisStudyInd+1
studyCount:=1
tick0:=a_tickcount

loadImage(guiInd,thisStudyInd,"",1)
showReportInfo(reportList[thisStudyInd,AccNoCol],reportList[thisStudyInd,ChartNoCol],1)


;~ msgbox
loop % totalGUI-1 
	loadImage(guiInd+a_index,thisStudyInd+a_index)
	
	
;~ }
;~ msgbox
monitorInd:=1
;~ gui,filter:hide
settimer,filterHide,-1000
winactivate,% reportList[thisStudyInd,AccNoCol] " ahk_class AutoHotkeyGUI"
WinActivate,simple RIS ahk_class AutoHotkeyGUI
;~ setLogGui(reportList[thisStudyInd,AccNoCol])
;~ settimer,loadMore,-1000


settimer,show2ndGUI,-1000
if !offlineMode
	settimer,getAllReportList,-5000
;~ settimer,getAllJpeg,-10000
return

getAllJpeg:

ahkmini("
(
#persistent
#notrayicon
setbatchlines,-1
#include <portallib>
reportList:=criticalobject(" (&reportList) ")
loadedPicCount:=criticalobject(" (&loadedPicCount) ")
thisStudyInd:=" thisStudyInd ", totalGUI:=" totalGUI "
reportListCount:=" reportListCount ", AccNoCol:=" AccNoCol "
ChartNoCol:=" chartNoCol ", reportDir:=""" reportDir """
PicWidth:=" monitors[fixedMonitor].w "-6
loginId:=""" loginId """, loginPw:=""" loginPw """
i:=thisStudyInd+totalGUI+a_index-1
settimer,routine,1000
loop {
	AccNo:=reportList[i,AccNoCol],chartNo:=reportList[i,chartNoCol]
	if(i>reportListCount){
		exitapp
	}else if (AccNo!="""" && chartNo!="""") {
		
		if !fileexist(reportDir ""\"" AccNo "" "" chartNo ""\"" AccNo "" "" chartNo "" 1.jpeg"") {
			; tooltip `% ""downloading:"" AccNo "","" chartNo "","" reportDir "" "" loginId loginPw 
			; PacsWebDownloadJpeg(AccNo,chartNo,"""",reportDir,PicWidth,loginId,loginPw)
			output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
			loadedPicCount[AccNo "" "" chartNo]:=output.maxindex()
			for k,v in output {
				PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo "" "" chartNo "" "" k "".jpeg"",reportdir ""\"" AccNo "" "" chartNo,PicWidth,loginId,loginPw)
				sleep 2000
			}
			sleep 5000
		}
		++i
	}else{
		sleep 5000
	}
}
return
routine:
ifwinnotexist,ahk_exe PacsIE.exe
	exitapp
return
)")
return


getAllReportList:

ahkmini("
(
#persistent
#notrayicon
setbatchlines,-1
#include <risimpax>
#include <acc>
reportList:=criticalobject(" (&reportList) ")
RisListHwnd:=" rislisthwnd ", thisStudyInd:=" thisStudyInd ", totalGUI:=" totalGUI "
RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
parseDataGrid(RisListRowsAcc,reportList,1,0,200,thisStudyInd+totalGUI)
settimer,routine,1000
return
routine:
ifwinnotexist,ahk_exe PacsIE.exe
	exitapp
return
)")
return

show2ndGUI:
;~ loadImage(2,thisStudyInd+1)
gui,2: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate",% title[2]
;~ sleep 2000
;~ WB1.Navigate("javascript:var controller;if(controller){controller.itemAction('WindowLevelS0Se0',event );}")
;~ WBp1.Navigate("javascript:var controller;if(controller){controller.itemAction('WindowLevelS0Se0',event );}")
return

showFilter:
;~ gui,filter:default
;~ gui,color,black
;~ gui,+toolwindow -caption +alwaysontop +lastfound +hwndfilterHwnd
;~ gosub filterShow
;~ settimer,filterHide,-1000

;~ winset,transparent,200
;~ gui,show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate"
;~ gosub filterShow

return

filterShow:
return
winset,transparent,200,ahk_id %filterHwnd%
gui,filter:show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate"
;~ ahkthread(createscript("
;~ (
;~ #persistent
;~ #notrayicon
;~ #include <SetTimerF>
;~ transValue:=0,filterHwnd:=" filterHwnd "
;~ settimerF(""filterShowHide"",100)
;~ return
;~ filterShowHide{}
;~ )"))
return
filterHide:
if (!filterHideThread) {
filterHideThread:=ahkmini(createscript("
(
#persistent
#notrayicon
setbatchlines,-1
transValue:=200,filterHwnd:=" filterHwnd "
settimer,<filterHide,-1
settimer,routine,1000
return
routine:
ifwinnotexist,ahk_exe PacsIE.exe
	exitapp
return

<filterHide:filterHide>
)"))
}else{
	filterHideThread.ahkassign.transValue:="200"
	filterHideThread.ahkLabel("<filterHide",1)
}
return
<filterHide:
	transValue+=0
	if show && (transValue:=transValue+50)>200
		return
	else if !show && (transValue:=transValue-50)<0 {
		winhide,ahk_id %filterHwnd%
		;~ winset,transparent,200,ahk_id %filterHwnd%
		return
	}
	winset,transparent,% transValue,ahk_id %filterHwnd%
	settimer,<filterHide,-50
filterHide>:
return

setLogGui(title){
	;~ global
	;~ DetectHiddenWindows,on
	;~ winsettitle,ahk_id %logHwnd%,,% "PacsIE Log GUI " thisHwnd ": " title
	;~ tooltip % title
	;~ msgbox % title
}



<setLogGui:
thisTitle:=WinGetAtCoords(1700,300)
;~ msgbox % thisTitle
if (thisTitle="")
	return
;~ msgbox % logHwnd "," thisHwnd
setLogGui:
winsettitle,ahk_id %logHwnd%,,% "PacsIE Log GUI " thisHwnd ": " thisTitle
regexmatch(thisTitle,"^(\w{11}) (\w{6}\d)",match)
if (match!=""){
	currentLogAccNo:=match1
	if fileexist(path:=reportDir "/" match ".txt") && (simpleRISHwnd:=winexist("simple RIS ahk_class AutoHotkeyGUI")) && priorLogAccNo!=currentLogAccNo {
		fileread,report,% path
		regexmatch(report,"is)FINDINGS:\r?\n(.+)\r?\n-=-=-=-=-",match)
		controlsettext,Edit1,% match1,ahk_id %simpleRISHwnd%
		controlget,editHwnd,hwnd,,Edit1,ahk_id %simpleRISHwnd%
		edit_setsel(editHwnd,len:=strlen(match1),len)
	}else{
		controlsettext,Edit1,% "",ahk_id %simpleRISHwnd%
	}
	priorLogAccNo:=currentLogAccNo
}
setLogGui>:
return

threadMonitor(){
	global
	local k,v,
	for k,v in threadPool {
		if (isobject(v.1) && v.1.ahkgetvar.threadFinish=1){
			;~ func(v.2).call(v.1.ahkgetvar.threadReturn)
			settimerF(v.2,-1,[v.1.ahkgetvar.threadReturn])
			v.1.ahkterminate()
			ahkthread_free(v.1)
			threadPool[k]:=[]
		}
	}
	for k,v in threadPool 
		if (!isobject(v.1))
			threadPool.removeat(k)
	
	;~ settimerF("threadMonitor",-1000)

}
	
bitmap2gui(picHwnd,imgPath,w="",h=""){
	global monitors
	mW:=monitors.2.w
	mH:=monitors.2.h
	if(imgPath=""){
		pBitmap:=Gdip_CreateBitmap(mW, mH)
		G := Gdip_GraphicsFromImage(pBitmap)
		;~ pBrush := Gdip_BrushCreateSolid(0x00000000)
		;~ Gdip_FillRectangle(G, pBrush, 0, 0, mW,  mH)
		Gdip_GraphicsClear(G, 0xFF000000)
		
		hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
		ret:= SetImage(picHwnd, hBitmap)
		
		Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap)
		
		return ret
	}
	
	if ! (pBitmap := Gdip_CreateBitmapFromFile(imgPath))
		return -1
	width := Gdip_GetImageWidth(pBitmap), height := Gdip_GetImageHeight(pBitmap)
	
	
	if (w="" && h="") {
		w := width, h := height
	}else if(h=""){
		h:=(w*height)//width
	}else if(w=""){
		w:=(h*width)//height
	}
	if(h>mH){
		h:=mH
		w:=(h*width)//height
	}else if(w>mW){
		w:=mW
		h:=(w*height)//width
	}
	
	pBitmap2 := Gdip_CreateBitmap(mW, mH)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_GraphicsClear(G2, 0xFF000000)
	
	;~ pBrush := Gdip_BrushCreateSolid(0x00000000)
	;~ Gdip_FillRectangle(G2, pBrush, 0, 0, mW,  mH)
	;~ Gdip_DeleteBrush(pBrush)
	
	Gdip_DrawImage(G2, pBitmap, (mW-w)//2, 0, w, h, 0, 0, Width, Height)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_SetSmoothingMode(G2, 7)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap2)
	ret:= SetImage(picHwnd, hBitmap)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap) 
	Gdip_DeleteGraphics(G2), Gdip_DisposeImage(pBitmap2)
	
	return ret
	
}	

checkLoadedPicCount(accno,chartNo,folderAcc:=""){
	global loadedPicCount,reportDir
	k:=0
	loop,% reportDir "\" (folderAcc?folderAcc:AccNo) " " chartNo "\" AccNo " " ChartNo " *.jpeg"
	{
		if regexmatch(a_loopfilename,"\d+\.jpeg") && (A_LoopFileSizeKB>10)
			++k
	}
	loadedPicCount[AccNo " " chartNo]:=k
	
}

showImage(thisGuiInd,whichMonitor,byref thisMonitor,FolderAccNo,chartNo,AccNo="",ind=1){
	global
	
	if(AccNo="")
		AccNo:=FolderAccNo
	
	if(!pToken){
		picHwnd:=whichMonitor=1?WB[thisGuiInd]:WBp[thisGuiInd]
		
		;~ gui,%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)
		
		guicontrol,-redraw,% picHwnd
		
		loop 3 {
			guicontrol,,% picHwnd,% "*w" thisMonitor.w " *h-1 " reportDir "\" FolderAccNo " " chartNo "\" AccNo " " chartNo " " ind ".jpeg"
			if (!errorlevel ){
				loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " chartNo "\" AccNo " " chartNo " " ind ".jpeg"
				break
			}else
				loadedPic[thisGuiInd,whichMonitor]:=""
		}
		
		guicontrol,+redraw,% picHwnd
	}else{
		bitmap2gui(whichMonitor=1?WB[thisGuiInd]:WBp[thisGuiInd],reportDir "\" FolderAccNo " " chartNo "\" AccNo " " chartNo " " ind ".jpeg",thisMonitor.w)
			loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " chartNo "\" AccNo " " chartNo " " ind ".jpeg"
		;~ else
			;~ loadedPic[thisGuiInd,whichMonitor]:=""
	}
	
	
	
	;~ checkLoadedPicCount(AccNo,chartNo,folderAccNo)
}


showReportInfo(AccNo,chartNo,noUpdate=0){
	global
	if(!noUpdate){
		thisTick:=A_TickCount
		floatFormat:=A_FormatFloat
		setformat,float,0.1
		totalReportTime:=(thisTick-tick0)//6000/10
		meanReportTime:=(thisTick-tick0)/studyCount//100/10
		setformat,float,%floatFormat%
		++studyCount
	}
	guicontrol,reportInfo:,reportInfoText,% AccNo "`n" chartNo (!noUpdate?"`nStudy: " studyCount " / " totalStudyCount "`nTotal time: " totalReportTime "min`nMean time: " meanReportTime "s":"")
	gui,reportInfo:show,% "x" (monitors.2.r)-250 " y" (monitors.2.b)-150
	fileappend,% AccNo "`n",% reportDir "\resumePacsIE",utf-8
}


loadImage(GuiInd,studyInd,ChartNo="",show=0){
	global
	local AccNo,thisGuiInd,thisMonitor,thisStudy,PacsHx,k,v,thisStudyInd,anyPriorImage,th,output,oldAccNo
	thisStudyInd:=studyInd
	;~ msgbox,,,1,1
	if(thisStudyInd>reportListCount){
		;~ msgbox,,,err1,1
		Return
	}
	if !isobject(thisStudy:=reportList[thisStudyInd]){
		parseDataGrid(RisListRowsAcc,reportList, 1, [thisStudyInd])
		thisStudy:=reportList[thisStudyInd]
	}
	if ((AccNo:=thisStudy[AccNoCol])=""){
		;~ msgbox,,,err2,1
		;~ msgbox,,,% reportList[thisStudyInd,AccNoCol],1
		return
	}
	thisGuiInd:=mod(guiInd-1,totalGUI)+1
	;~ WB[0+thisGuiInd].Navigate("about:blank")
	;~ msgbox,,,2,1
	
	if (chartNo=""){
		chartNo:=thisStudy[chartNoCol]
	}
	
	if(show){
		shownGuiInd:=thisGuiInd
		resetPicInfo()
	}
	
	if (trim(title[thisGuiInd]:=(AccNo " " (chartNo) " " thisStudy[examNameCol]))=""){
		;~ msgbox
		return loadImage(guiInd,studyInd,chartNo,show)
	}
	WinSetTitle,% "ahk_id " GuiHwnd[thisGuiInd],,% title[thisGuiInd]
	;~ if trim(title[guiInd])=""
		;~ aaaaa:=1
	
	thisMonitor:=monitors[fixedMonitor]

	if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") && !offlineMode {
		output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
		loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		for k,v in output {
			PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo " " chartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,(thisMonitor).w-6,loginId,loginPw)
			;~ sleep 2000
		}
		;~ PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,(thisMonitor).w-6,loginid,loginpw)
	}else{
		checkLoadedPicCount(accno,chartNo)
	}
	
	
	showImage(thisGuiInd,1,thisMonitor,AccNo,chartNo)
	
	
	if (show){
		;~ ++monitorInd
		;~ msgbox % "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)
		gui,%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h),% title[thisGuiInd]
		showPicInfo(1,AccNo " " chartNo)
		;~ setLogGui(title)
		thisTitle:=title[thisGuiInd]
		gosub setLogGui
		
	}else{
		gui,%thisGuiInd%: hide
		;~ gui,%thisGuiInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h) " noactivate",% title
		
	}
	;~ msgbox,,,3,1
	;~ msgbox % WB%thisGuiInd%.busy
	;~ if(globalInd=1)
		;~ sleep 2000
	;~ WB%thisGuiInd%.Navigate(url:=PacsWebUrl(AccNo,thisStudy[chartNoCol],loginId,loginPw))
	;~ msgbox,,,3.1,1
	;~ msgbox,,,% url,1
	
	;~ msgbox,,,3.2,1
	if(monitorCount>1){
		anyPriorImage:=0
		loop % reportDir "\" AccNo " " chartNo "\* " chartNo " 1.jpeg"
			if regexmatch(a_loopfilename,"(\w+) \w+ 1\.jpeg",match) && (match1!=AccNo) {
				anyPriorImage:=1
				oldAccNo:=match1
				break
			}
		
		if(anyPriorImage){
			showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo)
			checkLoadedPicCount(oldAccNo,chartNo,accNo)
			
		}else if (regexmatch(thisStudy[examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")) && !offlineMode {
			
			for k,v in PacsHx:=PacsWebQuery(chartNo)
				if RegExMatch(v.ExamName,"is)Chest.*(AP|PA)") && (regexreplace(v.ExamDate,"\D","")<regexreplace(thisStudy[examDateCol],"\D","")) {
					;~ WBp[thisGuiInd].Navigate("about:blank")
					;~ WBp[thisGuiInd].Navigate(PacsWebUrl(v.AccessNo,thisStudy[chartNoCol],loginId,loginPw))
					anyPriorImage:=1,oldAccNo:=v.AccessNo
					if !fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " chartNo " 1.jpeg") {
						output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,chartNo,loginId,loginPw))
						loadedPicCount[ oldAccNo " " chartNo ]:=output.maxindex()
						for q,r in output {
							PacsWebDownloadJpeg2(r.url,oldAccNo,chartNo,oldAccNo " " chartNo " " q ".jpeg",reportdir "\" AccNo " " chartNo,(thisMonitor).w-6,loginId,loginPw)
							;~ sleep 2000
						}
						;~ PacsWebDownloadJpeg(oldAccNo,chartNo,"",reportDir,thisMonitor.w-6,loginid,loginpw)
					}else{
						checkLoadedPicCount(oldAccNo,chartNo,accNo)
					}
					
					showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo)
					
					if(show)
						showPicInfo(2,oldAccNo " " chartNo)
					
					break
				}
		}
		if(!anyPriorImage){
			;~ WBp%thisGuiInd%.Navigate("about:blank")
			;~ WBp%thisGuiInd%.document.body.style.backgroundColor := "black"
			if(!pToken){
				guicontrol,-redraw,WBp%thisGuiInd%
				guicontrol,,% WBp%thisGuiInd%,% ""
				;~ if !errorlevel 
					
				guicontrol,+redraw,WBp%thisGuiInd%
			}else{
				bitmap2gui(WBp[thisGuiInd],"")
			}
			loadedPic[thisGuiInd,2]:=""
			loadedPicCount[oldAccNo " " chartNo]:=0
		}
		
		showPicInfo(2,oldAccNo " " chartNo)
	}
	
	
	
		
	;~ downloaded.push(loadedPic[thisGuiInd].clone())
	;~ settimer,deleteReportedPic,-1
	;~ msgbox,,,4,1
	
	;~ while loadHistoryFlag
		;~ sleep 500
		
		
	;~ settimerF("loadHistory",-1,[thisStudyInd, show],0)
	;~ msgbox % thisGuiInd
	th:=ahkmini("
(
#persistent
#notrayicon
#include <portalLib>
threadFinish:=0,threadReturn:=0
hx:=CriticalObject(" (&Hx) "),studyInd:=" thisStudyInd "
hx2Yr:=CriticalObject(" (&hx2Yr) ")
,examNameCol:=" examNameCol ",sid:=""" sid """,loginId:=""" loginId """,loginPw:=""" loginPw """
,chartNoCol:=" chartNoCol "
Alias(boneKeyWords," getvar(boneKeyWords) ")
Alias(lungKeyWords," getvar(lungKeyWords) ")
reportList:=CriticalObject(" (&reportList) ")
if loadHistory(studyInd)
	threadFinish:=1,threadReturn:=studyInd
settimer,routine,1000
return
routine:
ifwinnotexist,ahk_exe PacsIE.exe
	exitapp
return

)" function1 )

	if(show){
		threadPool.push([th,"showHx"])
	}
	
	
	
	;~ loadHistory(thisStudyInd)
	;~ if(show)
		;~ showHx(thisStudyInd)
	;~ msgbox,,,5,1
	return 1
}

deleteReportedPic:
++downloadedCount
if !fileexist(downloaded[downloadedCount-totalGui,1]){
	filedelete,% downloaded[downloadedCount-totalGUI,2]
	downloaded.removeAt(downloadedCount-totalGUI)
}
return

showPicInfo(which,AccChartNo,ind=1){
	global
	local count:=loadedPicCount[AccChartNo],title,activeHwnd
	wingettitle,title,A
	winget,activeHwnd,id,A
	if !(count>1){
		gui,info%which%:hide
		return
	}
	guicontrol,info%which%:,infotext%which%,% ind "/" count
	gui,info%which%:show,% "x" (monitors[which+1].l+5) " y5"
	if(title="simple RIS")
		winactivate,ahk_id %activeHwnd%
}


loadHistory(studyInd,show=0){
	global 
	local RisReport2Yr,priorExamItem,keyword,k,v,thisStudyInd,thisHx,thisChartNo
	thisStudyInd:=studyInd
	if !isobject(reportList[thisStudyInd])
		return
	
	if !regexmatch(reportList[thisStudyInd,examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")
		return
	
	thisChartNo:=reportList[thisStudyInd,chartNoCol]
	keyword:="",loadHistoryFlag:=1
	
	if !isobject(RisReport2Yr:=hx2Yr[thisChartNo]){
		RisReport2Yr:=parseRisReport2Yr(RisReport2Yr(checksid(sid)?sid:sid:=login(loginid,loginpw),reportList[thisStudyInd,chartNoCol]))
		hx2Yr[]:=RisReport2Yr.clone()
	}
	
	for k,v in RisReport2Yr {
		if regexmatch(priorExamItem:=v.1.1,"is)Chest.*(AP|PA)") && (++CXRind<11) {
			tmp:=matchText(v.2,boneKeyWords)
			keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CXR: " tmp)
		}else if regexmatch(priorExamItem,"is)CT.*Chest|low dose") && (++CTind<2) {
			tmp:=matchText(v.3,lungKeyWords)
			keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CT: "  tmp)
		}
	}
	
	;~ msgbox % thisStudyInd
	hx[thisStudyInd]:=keyword
	
	;~ if(show)
		;~ showHx(thisStudyInd)
	
	loadHistoryFlag:=0
	return true
}


showHx(studyInd){
	global
	local keyword,hxMonitor,thisStudyInd
	thisStudyInd:=studyInd
	gui,hx:default
	gui,destroy
	if ((keyword:=hx[thisStudyInd])="")
		return
	gui,color,black
	gui,+alwaysontop +hwndhxHwnd +toolwindow -Caption
	gui,font,s14 csilver,Verdana
	gui,add,text,,% keyword:=filterDuplicate(keyword)
	;~ hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	gui,show,% "x" hxMonitor.l+20 " y" hxMonitor.b " autosize noactivate",PacsIE Hx
	wingetpos,x,y,w,h,ahk_id %hxHwnd%
	winmove,ahk_id %hxHwnd%,,% hxMonitor.l+20,% hxMonitor.b-h,w,h
	;~ gui,show,% "x" hxMonitor.l+50 " y" hxMonitor.b-200 " autosize noactivate",PacsIE Hx
	;~ settimer,killGui,% -1000+(-1)*strlen(keyword)*50
	WinActivate,simple RIS ahk_class AutoHotkeyGUI
}

matchText(byref str,byref arrOfKeyWords){
	ret:=""
	for k,v in arrOfKeyWords {
		ret.=(s:=RXMS(str,"is)[^\.;\r\n]*" v "[^\.;\r\n]*([\.;\r\n]|$)","r"))=""?"":s "`n"
	}
	return ret
}

filterDuplicate(str,del="`n"){
	arr:=[]
	loop,parse,str,%del%
		if (trim(a_loopfield)!="" && regexmatch(a_loopfield,"(\d{8}[^:]+: )?([^\r\n]+)",match)  && !instr(match2,"no"))
			arr["" match2].=RegExReplace(match1,":","")
	str:=""
	for k,v in arr
		str.=substr(v,1,-1) ": " k "`n"
	
	return substr(str,1,-1)
}

killGUI:
gui,hx:destroy
return

resetPicInfo(){
	global
	gui,info1:hide
	gui,info2:hide
}

nextStudy(wParam=0, lParam=0, msg=0, hwnd=0){
	global 
	critical
	local nextGuiInd,thisMonitor,nextnextInd,AccNo,chartNo
	Loop {
		if loadingNext
			sleep 200
		else {
			loadingNext:=1
			break
		}
	}
	
	while (++thisStudyInd<=reportListCount) && (reportList[thisStudyInd,statusCol]="已發報告") {
	}
	
	;~ loadingNext:=1
	if (thisStudyInd>reportListCount){
		settimer,moveMsgBox,20
		Msgbox,8192,, % "This is the LAST record!"
		return 
	}
	
	;~ gui,filter:show
	gosub filterShow
	gui,%guiInd%:hide
	nextGuiInd:=mod(++guiInd-1,totalGUI)+1
	,nextnextInd:=mod(guiInd,totalGUI)+1
	;~ ++monitorInd
	resetPicInfo()
	showHx(thisStudyInd)
	;~ if (!WB[nextGuiInd].ready){
		;~ WB[nextGuiInd].Refresh2()
	;~ }
	;~ if (!WBp[nextGuiInd].ready){
		;~ WBp[nextGuiInd].Refresh2()
	;~ }	
	;~ wingettitle,title,% "ahk_id " guiHwnd[nextGuiInd]
	;~ if trim(title[nextGuiInd])=""
		;~ msgbox
	AccNo:=reportList[thisStudyInd,AccNoCol], chartNo:=reportList[thisStudyInd,chartNoCol]
	gui,%nextGuiInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h),% title[nextGuiInd]
	shownGuiInd:=nextGuiInd
	thisTitle:=title[nextGuiInd]
	gosub setLogGui
	settimer,activateSimpleRis,-1
	;~ gosub filterHide
	;~ msgbox % loadedPic[nextGuiInd,1] "," AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"
	if (loadedPic[nextGuiInd,1]!=AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"){
		settimer,moveMsgBox,20
		MsgBox, 8192, , % "Patient/image not matched!"
	}else if (loadedPic[nextGuiInd,2]!="" && !instr(loadedPic[nextGuiInd,2]," " chartNo " 1.jpeg")){
		settimer,moveMsgBox,20
		MsgBox, 8192, , % "Patient/old image not matched!"
		;~ msgbox % loadedPic[nextGuiInd,2] "," AccNo "," chartNo
	}
	
	showPicInfo(1,substr(loadedPic[nextGuiInd,1],21,19))
	showPicInfo(2,substr(loadedPic[nextGuiInd,2],21,19))
	
	;~ clipboard:=WB%nextGuiInd%.location.href
	;~ WB%nextGuiInd%.document.getElementById("WindowLevelS0Se0Link").click()
	;~ WBp%nextGuiInd%.document.getElementById("WindowLevelS0Se0Link").click()
	
	;~ WB%nextGuiInd%.Navigate("javascript:var controller;if(controller){controller.itemAction('WindowLevelS0Se0',event );}")
	;~ WBp%nextGuiInd%.Navigate("javascript:var controller;if(controller){controller.itemAction('WindowLevelS0Se0',event );}")
	
	;~ gui,filter:hide
	
	;~ winactivate,% "ahk_id " guiHwnd[nextGuiInd]
	;~ setLogGui(title[nextGuiInd])
	
	;~ gui,%nextGuiInd%: show,% "x" monitors.3.l " y" monitors.3.t " w" (monitors.3.w) " h" (monitors.3.h)
	;~ if (guiInd>4){
		;~ if !isobject(reportList[thisStudyInd])
			;~ parseDataGrid(RisListHwnd,reportList, 0, [thisStudyInd])
		;~ loadImage(guiInd+totalGui-2,(thisStudyInd)+totalGUI-2)
	;~ }
	;~ ++globalInd	
	
	;~ msgbox,,,% globalInd,1
	if (++globalInd	>2){
		;~ loadMore(nextGuiInd+totalGUI-2,thisStudyInd+totalGUI-2)
		;~ while loadMoreFlag
			;~ sleep 500
		settimerF("loadMore",-1,[nextGuiInd+totalGUI-2,thisStudyInd+totalGUI-2],0)
		;~ msgbox %  "Loading: " (mod(guiInd+totalGUI-2-1,totalGUI)+1) "," (thisStudyInd+totalGUI-2)
	}
	gui,%nextnextInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate",% title[nextnextInd]
	
	showReportInfo(AccNo, chartNo,!prior?0:1)
	
	prior:=0
	
	loadingNext:=0
}

activateSimpleRis:
simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
winactivate,ahk_id %simpleRis%
winget,nextProcName,ProcessName,% "ahk_id " GetNextWindow(simpleRis)
if(nextProcName!="PacsIE.exe") {
	activateMain()
	winactivate,ahk_id %simpleRIS%
}
return

priorStudy(wParam=0, lParam=0, msg=0, hwnd=0){
	global
	local priorGuiInd,thisMonitor,AccNo,ChartNo
	if (thisStudyInd=2){
		settimer,moveMsgBox,20
		Msgbox,8192,, % "This is FIRST record!"
		return
	}
	--globalInd
	++prior,--thisStudyInd,priorGuiInd:=mod(--guiInd+totalGUI-1,totalGUI)+1
	resetPicInfo()
	
	showHx(thisStudyInd)
	if (prior=1){
		;~ wingettitle,title,% "ahk_id " guiHwnd[priorGuiInd]
		;~ gui,filter:show
		gosub filterShow
		gui,%priorGuiInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h),% title[priorGuiInd]
		thisTitle:=title[priorGuiInd]
		gosub setLogGui
		settimer,activateSimpleRis,-1
		AccNo:=reportList[thisStudyInd,AccNoCol], chartNo:=reportList[thisStudyInd,ChartNoCol]
		if (loadedPic[priorGuiInd,1]!=AccNo " " ChartNo "\" AccNo " " ChartNo " 1.jpeg"){
			settimer,moveMsgBox,20
			MsgBox, 8192, , % "Patient/image not matched!"
		}else if (loadedPic[priorGuiInd,2]!="" && !instr(loadedPic[priorGuiInd,2]," " ChartNo " 1.jpeg")){
			settimer,moveMsgBox,20
			MsgBox, 8192, , % "Patient/old image not matched!"
			
		}
		
		;~ gui,filter:hide
		;~ gosub filterhide
		;~ winactivate,% "ahk_id " guiHwnd[priorGuiInd]
		;~ setLogGui(title)
	}else{
		if !isobject(reportList[thisStudyInd])
			parseDataGrid(RisListRowsAcc,reportList, 1, [thisStudyInd])
		loadImage(priorGuiInd,thisStudyInd,"",1)	
	}
	
	showPicInfo(1,substr(loadedPic[priorGuiInd,1],21,19))
	showPicInfo(2,substr(loadedPic[priorGuiInd,2],21,19))
	showReportInfo(AccNo, chartNo,1)
}

loadMore(guiInd,studyInd){
	global 
	;~ msgbox,,,% guiINd "," studyInd,1
	;~ msgbox,,,1,1
	local loadMoreInd,thisMonitor,thisStudyInd
	
	loadMoreInd:=mod(guiInd-1,totalGUI)+1,loadMoreFlag:=1
	,thisStudyInd:=studyInd
	
	while (thisStudyInd<=reportListCount) && (reportList[thisStudyInd,statusCol]="已發報告")
		++thisStudyInd
	
	if(thisStudyInd>reportListCount)
		return
	
	;~ msgbox,,,2,1
	;~ msgbox % loadMoreInd "," studyInd
	;~ tooltip % !isobject(reportList[studyInd])
	if !isobject(reportList[thisStudyInd]){
		parseDataGrid(RisListRowsAcc,reportList, 1, [thisStudyInd])
	}
	;~ msgbox,,,loadMore,1
	;~ tooltip % loadMoreInd "," studyInd "loadmore"
	loadImage(loadMoreInd,thisStudyInd)
	;~ msgbox,,,4,1
	;~ tooltip % loadMoreInd "," studyInd
	title[loadMoreInd]:=reportList[thisStudyInd,AccNoCol] " " reportList[thisStudyInd,ChartNoCol] " " reportList[thisStudyInd,examNameCol] 
	;~ gui,%loadMoreInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h) " noactivate",% title:=reportList[studyInd,AccNoCol] " " reportList[studyInd,ChartNoCol] " " reportList[studyInd,examNameCol] 
	;~ msgbox % title
	;~ msgbox,,,5,1
	loadMoreFlag:=0
}
return



guiclose:
;~ ~!#q::
;~ esc::
exitapp
return
;~ ~!#r::
;~ Reload
;~ return
onexit:
;~ winshow,ahk_exe impax-client-main.exe
;~ loop 4 {
	;~ WB%a_index%.quit()
	;~ WBp%a_index%.quit()
;~ }
filedelete,% reportDir "\resumePacsIE"
winrestore,% "ahk_id " impaxopened()[2,1]
for k,v in threadPool {
	if (isobject(v.1)){
		v.1.ahkterminate()
		ahkthread_free(v.1)
	}
}
for k,v in downloaded {
	if !fileexist(v.1)
		filedelete, % v.2
}
winclose,ahk_exe getAllJpeg.exe
if(pToken)
	Gdip_Shutdown(pToken)
if noAdditionalHotkey
	winclose,ahk_exe simpleRIS.exe
exitapp
closeError:
return


WM_MOUSEMOVE( wparam, lparam, msg, hwnd ){
	if (wparam = 1){ ; LButton
		PostMessage, 0xA1, 2,,, A ;WM_NCLBUTTONDOWN
	}
	if !winactive("ahk_id " hwnd)
		winactivate,ahk_id %hwnd%
	
	
}
moveMsgBox:
if msgboxHwnd:=winexist("ahk_class #32770 ahk_exe AutoHotkey.exe") {
	winmove,ahk_id %msgBoxHwnd%,,% monitors.2.l+(monitors.2.w)/2,% (monitors.2.h)/2
	settimer,moveMsgBox,off
}
return
