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

;~ msgbox %1% , %2%
;~ exitapp
;~ 0:=1
;~ 1:="-fast"

if %0% {
	param:=[]
	loop %0%
		param.push(%a_index%)
	for k,v in param {
		if(v="-offline"){
			offlineMode:=1
		}else if(v="-nogdi"){
			nogdi:=1
		}else if(v="-fast"){
			fastMode:=1
		}
	}
}
;~ msgbox % offlineMode
;~ updateLibPath()

;~ if !getListenerHwnd()
	;~ try
		;~ run % A_ScriptDir "\miniPACS.exe"

ToolTip % "Press SHIFT for FAST MODE!"
KeyWait,Shift,D T1.5
if (!ErrorLevel) {
	fastMode:=true
	ToolTip % "FAST MODE !"
	settimer, ToolTip,-2000
}else{
	fastMode:=false
	ToolTip 
}

#include <portallib>
#include <RisImpax>
#include <Acc>
#include <.NetGetControl>
#include <Gdip>
#include <SetTimerFn>
#include <EmptyMem>
#include <WinGetAtCoords>
#include <RXMS>
#include <WinVisible>
#include <PrettyReport>
#include <Class_RichEdit>
#include <JXON>
#include <WM_COPYDATA>
;~ #include <WorkerThread>

;~ InitWorkerThread()

;~ SetTimerFn("EmptyMem",60000, [], -2)

gui,main:Default
gui,+hwndguihwnd
WinSetTitle,% "ahk_id " guihwnd,,miniPACS_bridge_main

WinClose,ahk_exe Hotstring Helper.exe
OnMessage(0x4a, "On_WM_COPYDATA")
,thisHwnd:=WinExist("ahk_pid " thisPid := DllCall("GetCurrentProcessId"))
,dwData:=17
gosub openMiniPACS
iniread,reportDir,% ini,Settings,暫存資料夾
if !instr(fileexist(reportDir),"D")
	reportDir:=a_mydocuments "\feedRIS"
;~ reportList:=CriticalObject()
reportList:=[]
;~ if fileexist(reportDir "\reportList.json")
	;~ filedelete,% reportDir "\reportList.json"

gosub checkRisOpened

reportListLoaded:=0
WinClose,ahk_exe getAllJpeg.exe
if (!offlineMode && !winexist("ahk_exe getAllJpeg.exe")){
	run,% a_scriptdir "\getAllJpeg.exe  getAllJpeg.ahk" (fastMode?" -noOldFilm":" ") " " thisHwnd
	winwait,ahk_exe getAllJpeg.exe,,60
	
}

GroupAdd,MyGUI,ahk_exe python.exe
GroupAdd,MyGUI,ahk_exe miniPACS.exe


;~ while !fileexist(reportDir "\reportList.json") && (count:=a_index)<200
		;~ sleep 500
;~ if(count>=200)
	;~ showErrorAndExit("Can't find reportList.json in " reportDir ".`nThis application will exit.")
;~ while (count:=a_index)<200 {
	;~ try{
		;~ fileread,jxon,% reportDir "\reportList.json"
		;~ reportList:=jxon_load(jxon)
	;~ }catch{
		;~ sleep 500
		;~ continue
	;~ }
	;~ break
;~ }
;~ if(count>=200)
	;~ showErrorAndExit("Can't read reportList.json in " reportDir ".`nThis application will exit.")
RisSearchResultCount:=(RisSearchResultCount(RisOpened()[2])+1)
,waitLoadedCount:=RisSearchResultCount<10?RisSearchResultCount:10

;~ while (reportListLoaded<waitLoadedCount){
	;~ ToolTip % reportListLoaded " loaded"
	;~ Sleep 500
;~ }
;~ reportListLoaded:=1
;~ sleep 2000

settimer,openOthers,-1


if(!noGDI)
	pToken := Gdip_Startup()

root:=substr(a_scriptdir,1,1)
,ini:=a_scriptdir "\PacsIE.ini"
gosub setHotKey


;~ reportDir:=a_mydocuments "\feedRIS"
;~ reportDir:=root ":/scripts/Radiology/feedRIS"

;~ winget,thisHwnd,id,ahk_exe PacsIE.exe

onmessage(0______,"next")
,onmessage(0______,"prior")
,onmessage(0______,"exit")
,OnMessage(0______,"activateMain")
,OnMessage(0______,"sendReport")
,OnMessage(0______,"openImpax")

askForPortalIdPw()
;~ iniread,loginId,% ini,Settings,portal帳號
;~ iniread,loginPw,% ini,Settings,portal密碼
if !(sid:=login(loginId,loginpw)){
	msgbox,4144,, % "Portal無法登入：帳號密碼錯誤或是portal暫時無法使用"
	
	run % ini
	exitapp
}
if (!offlineMode){
	;~ if !PacsWebLogin(loginId,loginPw){
		;~ MsgBox, 4145, ,% "PacsWeb????,???????"
		;~ ifmsgbox,OK
			;~ if A_IsCompiled
				;~ run PacsIE.exe -offline
			;~ else
				;~ run PacsIE.exe PacsIE.ahk -offline
		;~ exitapp
	;~ }
}

monitors:=monitorInfo()
;~ if monitors.maxindex()<2 {
	;~ showErrorAndExit("Single monitor not supported! `n This application will exit.")
;~ }
monitorInd:=0
,monitorCount:=monitors.maxIndex()-1
,fixedMonitor:=2
,totalGUI:=monitorCount*(monitorCount=1?4:2),guiInd:=1
;~ ,hx:=CriticalObject(),pHx:=&hx
;~ ,hx2Yr:=CriticalObject()
;~ ,hx:=[]
;~ ,hx2Yr:=[]
,threadPool:=[]
,title:=[]
,downloaded:=[]
;~ settimerF("threadMonitor",3000)
,boneKeywords:=["rib","fracture","bone","bony","\bsclero","lytic"]
,lungKeyWords:=["(lung|pulmonary) (nodule|mass|tumor|lesion|metasta)"]
,cancerKeywords:=["cancer","malignant","malignancy","lymphoma","leukemia","tumor"]

,RisState:=risopened()
,AccNoHwnd:=getRisAccNoHwnd(RisState[2])
,RisListHwnd:=getRisList(RisState[2])
,RisListRowsAcc:=acc_children(acc_objectfromwindow(risListHwnd))

;~ if (fileexist(reportDir "\resumePacsIE")){
	;~ fileread,resumePacsIE,% reportDir "\resumePacsIE"
	;~ RegExMatch(resumePacsIE,"i)[TY]\w{9}\d(?:[\s\r\n]*$)",thisAccNo)
;~ }

;~ if(!reportListLoaded)
	;~ ,reportList:=parseDataGrid2(risListHwnd)
	;~ ,reportListCount:=reportListLoaded:=reportList.maxindex()
;~ else
	;~ ,reportListCount:=RisSearchResultCount(RisState[2])+1

;~ for k,v in reportList[1] {
	;~ if (v="照會單號") {
		;~ AccNoCol:=k
	;~ }
	;~ if (v="病歷號") {
		;~ chartNoCol:=k
	;~ }
	;~ if (v="檢查名稱") {
		;~ examNameCol:=k
	;~ }
	;~ if (v="狀態") {
		;~ statusCol:=k
	;~ }
	;~ if (v="檢查日") {
		;~ examDateCol:=k
	;~ }
	
;~ }
,notFound:=0
,initFinish:=true


;~ gosub findStartAccNo
;~ ,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({total_study_count: reportListCount}))
;~ msgbox % ExploreObj(reportList)
;~ clipboard:= ExploreObj(reportList)

return

findStartAccNo:
if !initFinish
	settimer,,-500

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

Loop % reportListCount 
	if !(reportList[reportListCount-A_Index+1, AccNoCol]~="\w{9}\d")
		reportList.remove(reportListCount-A_Index+1)
	else
		break
reportListCount:=reportList.maxindex()

if !(AccNoCol!="" 
	&& ChartNoCol!="" 
	&& examNameCol!="" 
	&& statusCol!="" 
	&& examDateCol !=""){
	settimer,findStartAccNo,-500
	return
}

if(currentAccNo:=controlgettext(AccNoHwnd)){
	thisStudyInd:=1,foundPos:=0
	goto findStartAccNo1
	
}else{
	
	thisStudyInd:=1
	goto findStartAccNo3
}

findStartAccNo2:
;~ msgbox % thisAccNo "," reportList.maxindex()
if (thisAccNo=""){
	settimer,findStartAccNo,-500
	return
	;~ showErrorAndExit("No available report on the list.`nThis application will exit.")
}else{
	Send_WM_COPYDATA(WinExist("getAllJpeg_main ahk_class AutoHotkeyGUI"), dwData, jxon_dump({start_from: thisStudyInd}))
	,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({start_from: thisStudyInd-2}))
	
	gosub continueInit
}
return

;~ esc::exitapp

findStartAccNo1:
;~ ToolTip % "                        " thisStudyInd "," reportList.maxindex() "," reportList.setcapacity(0)
if(++thisStudyInd>reportListCount)
	goto findStartAccNo2
if(!reportList.haskey(thisStudyInd) || !IsObject(reportList[thisStudyInd])){
	if(++notFound>9){
		;~ msgbox % WinExist("getAllJpeg_main ahk_class AutoHotkeyGUI")
  		SendMessage,0x8000,% thisStudyInd,,,getAllJpeg_main ahk_class AutoHotkeyGUI
		;~ msgbox % ErrorLevel
		++notFound
	}
	--thisStudyInd
	settimer,findStartAccNo1,-1000
}
;~ if(thisStudyInd=21)
	;~ b:=1
if !foundPos && reportList[thisStudyInd,AccNoCol]!=currentAccNo
	goto findStartAccNo1
foundPos:=1
if (reportList[thisStudyInd,statusCol]="已發報告")
	goto findStartAccNo1
thisAccNo:=reportList[thisStudyInd, AccNoCol]
if thisAccNo!="" && !fileexist(reportDir "\" thisAccNo "*.txt")
	goto findStartAccNo2
goto findStartAccNo1
return

findStartAccNo3:
if(++thisStudyInd>reportListCount)
	goto findStartAccNo2
if(!reportList.haskey(thisStudyInd) || !IsObject(reportList[thisStudyInd])){
	if(++notFound>9){
		SendMessage,0x8000,% thisStudyInd,,,getAllJpeg_main ahk_class AutoHotkeyGUI
		++notFound
	}
	--thisStudyInd
	settimer,findStartAccNo3,-1000
}
if (reportList[thisStudyInd, statusCol]="已發報告")
	goto findStartAccNo3
thisAccNo:=reportList[thisStudyInd, AccNoCol]
if thisAccNo!="" && !fileexist(reportDir "\" thisAccNo "*.txt")
	goto findStartAccNo2
goto findStartAccNo1
return

continueInit:
;~ while(reportListLoaded<thisStudyInd){
	;~ ToolTip % reportListLoaded "," thisStudyInd
	;~ Sleep 500
;~ }

;~ if (!reportListLoaded)
	;~ gosub getAllReportList
;~ settimer,closeError,500
globalInd:=1



activeFn:=0
if !fastMode
	gosub getOldHx
;~ gosub createGUI
;~ sleep 1000
;~ gosub init

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
;~ EmptyMem(pid)
;~ settimerf("EmptyMem",60000,[pid])
;~ DetectHiddenWindows,off
;~ groupadd,impaxGroup,ahk_exe impax-client-main.exe
winminimize,% "ahk_id " impaxopened()[2,1]
;~ DetectHiddenWindows,on
return

getOldHx:


if (thisStudyInd>reportList.maxindex()){
	settimer,,-1000
	return
}
if (thisStudyInd>reportListCount)
	return

;~ thisStudy:=reportList[thisStudyInd]
;~ ,WorkerThread%A_Index%:=new CWorkerThread("getOldHxWorkerThread")
;~ ,WorkerThread%A_Index%.start(thisStudyInd)

;~ activeFn++
;~ SetTimerFn("getOldHxWorkerThread", -1, [thisStudyInd])
loadHistory(thisStudyInd)
,thisStudyInd++
settimer,getOldHx,-1000
return

getOldHxWorkerThread(ind){
	global activeFn
	loadHistory(ind)
	;~ ,activeFn--
}

getListenerHwnd(){
	return WinExist("WM_COPYDATA_Listener_miniPACS")
	;~ if h1:=WinExist("WM_COPYDATA_Listener ahk_exe python.exe")
		;~ return h1
	;~ else if h2:=WinExist("WM_COPYDATA_Listener_miniPACS")
		;~ return h2
}

openMiniPACS:
if !getListenerHwnd() && !WinExist("miniPACS.exe") {
	miniPacsPath:=A_ScriptDir "\miniPACS.exe"
	if !FileExist(miniPacsPath){
		msgbox % "Cannot found miniPACS.exe!"
		ExitApp
	}
	run % miniPacsPath
	winwait,WM_COPYDATA_Listener,,30
	if(ErrorLevel){
		msgbox % "Error opening miniPACS.exe"
		ExitApp
	}
}
;~ miniPacsHwnd:=WinExist("ahk_exe miniPACS.exe")
Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({setBridgeHwnd: guiHwnd+0}))
,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({fast_mode: fastMode?1:0}))
return

openImpax(){
	gosub openInImpax
}

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	global AccNoCol, examDateCol, examNameCol, ChartNoCol, statusCol
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
	
	
	if (from:=json.from)!="" {
		if(from="open_impax")
			settimerF("openInImpax", -1, [json.AccNo])
		else if(from="sendReport"){
			;~ thisTick:=A_TickCount
			;~ if !(thisTick-lastTick<1000)
				settimerF("sendReport1",-1, [json.AccNo, json.ChartNo])
			;~ lastTick:=thisTick
		}
	}else if (json.sendReport){
		;~ thisTick:=A_TickCount
		;~ if !(thisTick-lastTick<1000)
			settimer,sendReport,-1
		;~ lastTick:=thisTick
	}else if(json.activateSimpleRIS){
		settimer,activateSimpleRis,-1
	}else if(json.exit){
		;~ WinGet,pname,ProcessName,WM_COPYDATA_Listener
		
		;~ WinClose,ahk_exe %pname%
		
		ExitApp
	}else if(json.AccNoCol){
		for k,v in ["AccNoCol", "examDateCol", "examNameCol", "ChartNoCol", "statusCol"]
			%v%:=json[v]
	}else if(json.showStudy){
		settimerF("loadSavedReport", -500, [json.index+2, json.AccNo])
	}else
		parseReportListData(json)
		;~ SetTimerFn("parseReportListData" , -1 [json])
	;~ ,sendData("received")	
	
	
}

loadSavedReport(index, AccNo){
	global reportList, AccNoCol, reportDir, ChartNoCol
	row:=reportList[index]
	if (row[AccNoCol]!=AccNo)
		return
	if !FileExist(path:=reportDir "\" AccNo " " row[ChartNoCol] ".txt")
		return
	
	fileread,r,% path
	controlget,editHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
	Edit_SetText(editHwnd, r:=RegExReplace(r, "s)\r?\n-=-=-=-=-\r?\n.*$", ""))
	,edit_setsel(editHwnd, l:=StrLen(r), l)
	,Edit_ScrollCaret(editHwnd)
}


parseReportListData(json){
	global reportList, reportListLoaded
	;~ ToolTip % str
	
	
	;~ msgbox % ExploreObj(json)
	
	for k,v in json
		reportList[k+0]:=v
		,reportListLoaded++
	gosub findStartAccNo
	;~ ToolTip % reportListLoaded
}

sendData(str){
	if(h:=WinExist("ahk_exe getAllJpeg.exe"))
		Send_WM_COPYDATA(h, 0, str)

}


activateMain(){
	global 
	active:=true
	Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"activate_main":1}))
	winminimize,% "ahk_id " impaxopened()[2,1]
}

MinimizeMain(){
	global 
	local arr
	critical
	;~ gui,%shownGuiInd%: show
	if (!shownGuiInd)
		shownGuiInd:=1
	arr:=[simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI"), reportInfoHwnd, hxHwnd, info1hwnd, info2hwnd, guiHwnd[shownGuiInd], filterHwnd]
	Loop % totalGUI-1
		arr.push(guiHwnd[Mod(shownGuiInd+A_Index-1, totalGUI)+1])
	
	for k,v in arr
		winminimize,% "ahk_id " v
	
}

openOthers:
if !winexist("ahk_exe feedRIS.exe")
	run % a_scriptdir "\feedRIS.exe"
if !winexist("ahk_exe simpleRIS.exe"){
	run % a_scriptdir "\simpleRIS.exe -waitJson"
	;~ simpleRisOpened:=1
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
	hotkey,ifwinactive,ahk_exe simpleRIS.exe
	hotkey,% sendReportKey,sendReport,P10
	hotkey,ifwinactive
	hotkey,IfWinExist,ahk_group MyGUI
	hotkey,% sendReportKey,sendReport,P1
	Hotkey,IfWinExist
	
	hotkey,% activateSimpleRisKey " UP",activateSimpleRis,P10
	if(activateSimpleRisKey="CapsLock"){
		settimer,setcapslockstate,500
		hotkey,% "#" activateSimpleRisKey,toggleCapslockState,P10
	}
}catch e{
	tooltip % e.Message
}
;~ if !winexist("ahk_exe PacsIEMain.exe") {
	;~ hotkey,~!#q,guiclose,P10
;~ }
return

setcapslockstate:
SetCapslockstate,% capslockstate?"on":"off"
return

toggleCapslockState:
capslockstate:=!capslockstate
gosub setcapslockstate
return

sendReport(wParam, lParam, msg, hwnd){
	;~ ToolTip % "SEND"
	gosub sendReport
}



sendReport:
;~ ToolTip miniPACS_bridge
Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"request_info":1, "from": "sendReport"}))
return

sendReport1(AccNo, ChartNo){
	global
	;~ msgbox % accno "," chartNo
	if (!editHwnd || !controlexist(editHwnd))
		controlget,editHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
	if !controlexist(editHwnd)
		return
	if (text:=trim(controlgettext(editHwnd)))=""
		return
	Text:=RegExReplace(Text, "[ \;]+$", ".")
	,Text:=RegExReplace(Text, "i)\/(placement|metal)", ".$1")
	,Text:=RegExReplace(Text, "i)placement of", ".placement of")
	if InStr(Text, "suggest clinical correlation.")
		Text:=RegExReplace(Text, "i)suggest clinical correlation.", "") "suggest clinical correlation. "
	if RegExMatch(Text, "i)\.?\w+\/?placement", match) && !InStr(match, "replacement"){
		MsgBox, 4404, Typo in report, Continue?
		IfMsgBox,No
			return
	}
	ToolTip
	for k, v in reportList
		if v[AccNoCol]=AccNo
			break
	;~ msgbox % k
	examDate:=RegExReplace(reportList[thisStudyInd:=k, examDateCol], "\D" ,"")
	;~ msgbox % examDate
	now:=A_Now
	now-=examDate, Days
	if(examDate!="" && now>90 && !InStr(Text, "this study is reassigned to current radiologist on "))
		text.="this study is reassigned to current radiologist on " A_YYYY "/" a_mm "/" a_dd ". "
	checkReport(text, AccNo, ChartNo, ExamName:=reportList[thisStudyInd, examNameCol])
	;~ msgbox % examname
	;~ controlsettext,,% "",ahk_id %editHwnd%
	;~ Edit_SetText(editHwnd, "")
	,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"sendReportEnd": 1}))

	postmessage,0x2024,,,,simple RIS ahk_class AutoHotkeyGUI
	nextStudy()
	
	postmessage,0x1011,,,,feedRIS ahk_class AutoHotkey
	;~ if !fastMode
		;~ SoundBeep
	return
}
checkReport(text, AccNo, ChartNo, examName){
	global reportDir,offlineMode,editHwnd,title, shownGuiInd
	Exam:=ExamName,thisAccNo:=AccNo,thisChartNo:=ChartNo
	;~ msgbox % superior aspect of	am "," thisAccNo "," thisChartNo
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
		
	filedelete,% filePath:=reportDir "\" thisAccNo " " thisChartNo ".txt"
	fileappend,% addTitle(newText,Exam,thisAccNo,thisChartNo) "`r`n-=-=-=-=-`r`n",% filePath,utf-8
	tooltip % "Saved !"
	settimer,tooltip,-1000
}	

addTitle(newText,exam="",accNo="",chartNo=""){
	global showAccNo, showChartNo, addNormalHeartSize, fastMode
	;~ msgbox % newText "`n`n" exam "`n`n" accNo "`n`n" chartNo
	risState:=RisOpened()
	
	if instr(newText,"EXAMINATION:")
		return newText
	if instr(newText,"shows")
		newText:=RegExReplace(newText,"is)^.+shows\s*","")
		,newText:=stringupper(substr(newText,1,1)) substr(newText,2)
	
	if (!fastMode && addNormalHeartSize && RegExMatch(exam,"is)Chest : (PA|AP) View") && !regexmatch(newText,"i)normal heart size|cardiomegaly|borderline heart size|heart border|opacified (left|right) hemithorax"))
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

if (risopened()[1]!=2){
	showErrorAndExit("Open RIS first.`nThis application will exit.")
}

return

;~ n::
;~ nextStudy()
;~ return
exit(){
	
	exitapp
}


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
F5::
gosub openInImpax
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



#ifwinactive

PGUP::
PGDN::
Critical
if(A_PriorHotkey=A_ThisHotkey && A_TimeSincePriorHotkey<300)
	return
wheelGui:=1
gosub changePic
return


~wheeldown::
~wheelup::
Critical
if(A_PriorHotkey=A_ThisHotkey && A_TimeSincePriorHotkey<300)
	return
;~ mousegetpos,mx,my,mouseWin
;~ winget,processName,processName,ahk_id %mouseWin%
;~ if(processName!="PacsIE.exe")
	;~ return
;~ wheelGui:=(mx>monitors.2.r)?2:1
changePic:
if(!active)
	return
MouseGetPos,mx,my,mouseWin
winget,processName,processName,ahk_id %mouseWin%
if(processName!="python.exe" && processName!="miniPACS.exe")
	return
Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"next_image": (InStr(A_ThisHotkey, "UP")?0:1)
	, "x": mx
	, "y": my}))
return


createGUI:
WB:=[],GuiHwnd:=[],WBp:=[],loadedPic:=[],guiHwnd2:=[]
;~ ,loadedPicCount:=CriticalObject()
,loadedPicCount:=[]
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
	
	;~
	WB.push(WBhwnd%a_index%)
	,WBp.push(WBphwnd%a_index%)
	;~ }
	;~ WB%a_index%.Navigate("about:blank")
	;~ WBp%a_index%.document.body.style.backgroundColor := "black"
	,GuiHwnd.push(hwnd)
	
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

;~ gui,filter:color,black
;~ gui,filter:+toolwindow -caption +alwaysontop +lastfound +hwndfilterHwnd
;~ winset,transparent,200
;~ gui,filter:show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate"

return


getReportList:
;~ parseDataGrid(RisListRowsAcc,reportList, 1, totalGUI,0, [AccNoCol, thisAccNo])
return
offLineModeReportList:
;~ parseDataGrid(RisListRowsAcc,reportList,1)
;~ msgbox % reportList.maxindex()
if (reportList.maxindex()!=reportListCount){
	settimer,offLineModeReportList, -500
	return
}
oldReportList:=reportList.clone()
,reportList:=[]
for k,v in oldReportList {
	;~ test:=fileexist(reportDir "\" v[AccNoCol] " " v[ChartNoCol] "\" v[AccNoCol] " " v[ChartNoCol] " 1.jpeg")
	if (k=1) || fileexist(reportDir "\" v[AccNoCol] " " v[ChartNoCol] "\" v[AccNoCol] " " v[ChartNoCol] " 1.jpeg")
		reportList.push(v.clone())
}
reportListCount:=reportList.maxindex()
;~ msgbox % reportList.maxindex()
if fileExist(jxonFile:=reportDir "\reportList.json")
	FileDelete,% jxonFile
FileAppend,% jxon_dump(reportList),% jxonFile,utf-8
return


init:
;~ critical
;~ reportListCount:=parseDataGrid(RisListRowsAcc,reportList, 1, 1)

;~ if !(AccNoCol && chartNoCol && examNameCol && statusCol){
	;~ settimer,init,-500
	;~ return
;~ }
if offLineMode 
	gosub offLineModeReportList
;~ else 
	;~ settimer,getReportList,-1

;~ initSearch:

;~ matched:=0
;~ for k,v in reportList {
	;~ if (v[AccNoCol]=thisAccNo){
		;~ matched:=1,thisStudyInd:=k
		;~ break
	;~ }
;~ }


;~ if (!matched){
	;~ settimer,initSearch,-1000
	;~ return
;~ }




;~ gosub showfilter

;~ gosub curtainThread

totalStudyCount:=reportListCount-thisStudyInd+1
,studyCount:=1
,tick0:=a_tickcount

,loadImage(guiInd,thisStudyInd,"",1)
,showReportInfo(reportList[thisStudyInd,AccNoCol],reportList[thisStudyInd,ChartNoCol],1)
winsettitle,ahk_id %logHwnd%,,% "PacsIE Log GUI " thisHwnd ": " reportList[thisStudyInd,AccNoCol] " " reportList[thisStudyInd,ChartNoCol] " " reportList[thisStudyInd,examNameCol] 

;~ msgbox
initLoad:=0
loop {
	if (initLoad >= totalGui-1)
		break
	while (reportList[thisStudyInd+a_index, AccNoCol]="" || reportList[thisStudyInd+a_index, ChartNoCol]="")
		sleep 500
	
	if (reportList[thisStudyInd+a_index, StatusCol]="已發報告")
		continue
	
	++initLoad
	,loadImage(guiInd+initLoad,thisStudyInd+a_index)
	Sleep 500
	
}


;~ }
;~ msgbox
monitorInd:=1
;~ gui,filter:hide
;~ settimer,filterHide,-1000
;~ winactivate,% reportList[thisStudyInd,AccNoCol] " ahk_class AutoHotkeyGUI"
gosub activateSimpleRis
;~ WinActivate,simple RIS ahk_class AutoHotkeyGUI

;~ setLogGui(reportList[thisStudyInd,AccNoCol])
;~ settimer,loadMore,-1000


settimer,show2ndGUI,-1000
;~ if(!offlineMode)
	;~ settimer,getAllReportList,-2000
getAllHxInd:=thisStudyInd
if !fastMode
	;~ settimer,getAllHx,-1,-2
	;~ SetTimerFn("getAllHx",-1, [], -2)
	;~ SetTimer, getAllHxThread, -1
;~ settimer,getAllJpeg,-10000

gosub simpleRISnoUpdate
settimer,simpleRISnoUpdate,1000

if (!fastMode){
	Loop 4 {
		loadHistory(thisStudyInd+A_Index-1)
	}
}

return

simpleRISnoUpdate:
postmessage,0x2022,,1,,simple RIS ahk_class AutoHotkeyGUI
return

getAllJpeg:
/*
ahkmini("
(
#persistent
#notrayicon
setbatchlines,-1
#include <portallib>
reportList:=criticalobject(" (&reportList) ")
,loadedPicCount:=criticalobject(" (&loadedPicCount) ")
,thisStudyInd:=" thisStudyInd ", totalGUI:=" totalGUI "
,reportListCount:=" reportListCount ", AccNoCol:=" AccNoCol "
,ChartNoCol:=" chartNoCol ", reportDir:=""" reportDir """
,PicWidth:=" monitors[fixedMonitor].w "-6
,loginId:=""" loginId """, loginPw:=""" loginPw """
,i:=thisStudyInd+totalGUI+a_index-1
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
			,loadedPicCount[AccNo "" "" chartNo]:=output.maxindex()
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
*/




getAllReportList:

;~ ahkmini("
;~ (
;~ #persistent
;~ #notrayicon
;~ setbatchlines,-1
;~ SetControlDelay,-1
;~ #include <risimpax>
;~ #include <acc>
;~ reportList:=criticalobject(" (&reportList) ")
;~ RisListHwnd:=" rislisthwnd ", thisStudyInd:=" thisStudyInd "
;~ RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
parseDataGrid(RisListRowsAcc,reportList,1,0,100,thisStudyInd)
;~ return
;~ )")
if fileExist(jxonFile:=reportDir "\reportList.json")
	FileDelete,% jxonFile
FileAppend,% jxon_dump(reportList),% jxonFile,utf-8
return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){
	global reportListCount
	tooltip % "Get list from RIS: " k " / " reportListCount " ..."
}

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
;~ topGuiInd:=mod(guiInd-1,totalGUI)+1

return
;~ winset,transparent,200,ahk_id %filterHwnd%
;~ gui,filter:show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)" noactivate"
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
;~ filterHide:
;~ if (!filterHideThread) {
	;~ filterHideThread:=ahkmini(createscript("
;~ (
;~ #persistent
;~ #notrayicon
;~ setbatchlines,-1
;~ transValue:=200,filterHwnd:=" filterHwnd "
;~ settimer,<filterHide,-1
;~ settimer,routine,1000
;~ return
;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ return

;~ <filterHide:filterHide>
;~ )"))
;~ }else{
	;~ filterHideThread.ahkassign.transValue:="200"
	;~ filterHideThread.ahkLabel("<filterHide",1)
;~ }
;~ return
;~ <filterHide:
;~ transValue+=0
;~ if show && (transValue:=transValue+50)>200
	;~ return
;~ else if !show && (transValue:=transValue-50)<0 {
	;~ winhide,ahk_id %filterHwnd%
		winset,transparent,200,ahk_id %filterHwnd%
	;~ return
;~ }
;~ winset,transparent,% transValue,ahk_id %filterHwnd%
;~ settimer,<filterHide,-50
;~ filterHide>:
;~ return

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
return
thisTitle:=WinGetAtCoords(1700,300)
winsettitle,ahk_id %logHwnd%,,% "PacsIE Log GUI " thisHwnd ": " thisTitle
regexmatch(thisTitle,"^(\w{11}) (\w{6}\d)",match)
controlget,editHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
if (match1!="" && match2!=""){
	currentLogAccNo:=match1
	if fileexist(path:=reportDir "/" match ".txt") && (simpleRISHwnd:=winexist("simple RIS ahk_class AutoHotkeyGUI")) && priorLogAccNo!=currentLogAccNo {
		fileread,report,% path
		regexmatch(report,"is)FINDINGS:\r?\n(.+)\r?\n-=-=-=-=-",match)
		;~ controlsettext,Edit1,% match1,ahk_id %simpleRISHwnd%
		Edit_SetText(editHwnd, match1)
		,edit_setsel(editHwnd,len:=strlen(match1),len)
	}else{
		;~ controlsettext,Edit1,% "",ahk_id %simpleRISHwnd%
		;~ Edit_SetText(editHwnd, "")
		;~ postmessage,0x2024,,,,simple RIS ahk_class AutoHotkeyGUI
	}
	priorLogAccNo:=currentLogAccNo
}else{
	msgbox % "Can't get info!"
}
setLogGui>:
return

threadMonitor(){
	
}

bitmap2gui(picHwnd,imgPath,w="",h=""){
	global monitors
	mW:=monitors.2.w
	,mH:=monitors.2.h
	if(imgPath=""){
		pBitmap:=Gdip_CreateBitmap(mW, mH)
		,G := Gdip_GraphicsFromImage(pBitmap)
		;~ pBrush := Gdip_BrushCreateSolid(0x00000000)
		;~ Gdip_FillRectangle(G, pBrush, 0, 0, mW,  mH)
		,Gdip_GraphicsClear(G, 0xFF000000)
		
		,hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
		,ret:= SetImage(picHwnd, hBitmap)
		
		,Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap) 
		;~ ToolTip % "remove image" ret
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
		,w:=(h*width)//height
	}else if(w>mW){
		w:=mW
		,h:=(w*height)//width
	}
	
	pBitmap2 := Gdip_CreateBitmap(mW, mH)
	,G2 := Gdip_GraphicsFromImage(pBitmap2)
	,Gdip_GraphicsClear(G2, 0xFF000000)
	
	;~ pBrush := Gdip_BrushCreateSolid(0x00000000)
	;~ Gdip_FillRectangle(G2, pBrush, 0, 0, mW,  mH)
	;~ Gdip_DeleteBrush(pBrush)
	
	,Gdip_DrawImage(G2, pBitmap, (mW-w)//2, 0, w, h, 0, 0, Width, Height)
	,Gdip_SetInterpolationMode(G2, 7)
	,Gdip_SetSmoothingMode(G2, 7)
	,hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap2)
	,ret:= SetImage(picHwnd, hBitmap)
	,Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap) 
	,Gdip_DeleteGraphics(G2), Gdip_DisposeImage(pBitmap2)
	;~ ToolTip % "Setimage" ret
	return ret
	
}	

checkLoadedPicCount(accno,chartNo,folderAcc="",folderChartNo=""){
	global loadedPicCount,reportDir
	k:=0
	loop,% reportDir "\" (folderAcc?folderAcc:AccNo) " " (folderChartNo?folderChartNo:chartNo) "\" AccNo " " ChartNo " *.jpeg"
	{
		if regexmatch(a_loopfilename,"\d+\.jpeg") && (A_LoopFileSizeKB>10)
			++k
	}
	loadedPicCount[AccNo " " chartNo]:=k
	
}

showImage(thisGuiInd,whichMonitor,byref thisMonitor,FolderAccNo,FolderChartNo,AccNo="",chartNo="",ind=1){
	global
	
	if(AccNo="")
		AccNo:=FolderAccNo
	
	if(ChartNo="")
		ChartNo:=FolderChartNo
	else if (ChartNo="*")
		loop % reportDir "\" FolderAccNo " " FolderChartNo "\* 1.jpeg"
			if regexmatch(a_loopfilename,"(\w+) (\w+) 1\.jpeg",match) && (match1!=FolderAccNo) {
				anyPriorImage:=1
				,ChartNo:=match2
				break
			}
	
	
	if(!pToken){
		picHwnd:=whichMonitor=1?WB[thisGuiInd]:WBp[thisGuiInd]
		
		;~ gui,%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)
		
		guicontrol,-redraw,% picHwnd
		
		
		loop 3 {
			guicontrol,,% picHwnd,% "*w" thisMonitor.w " *h-1 " reportDir "\" FolderAccNo " " FolderChartNo "\" AccNo " " chartNo " " ind ".jpeg"
			if (!errorlevel ){
				loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " FolderChartNo "\" AccNo " " chartNo " " ind ".jpeg", fail:=false
				break
			}else
				loadedPic[thisGuiInd,whichMonitor]:="", fail:=true
		}
		
		if(fail)
			msgbox % "Failed to load image!!!"
		
		
		guicontrol,+redraw,% picHwnd
	}else{
		ret:=bitmap2gui(whichMonitor=1?WB[thisGuiInd]:WBp[thisGuiInd],reportDir "\" FolderAccNo " " FolderChartNo "\" AccNo " " chartNo " " ind ".jpeg",thisMonitor.w)
		;~ if (ret!=0)
			;~ msgbox % "Error in SetImage!!!"  ret 
		;~ else 
			loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " FolderChartNo "\" AccNo " " chartNo " " ind ".jpeg"
		;~ else
			;~ loadedPic[thisGuiInd,whichMonitor]:=""
	}
	
	
	
	;~ checkLoadedPicCount(AccNo,chartNo,folderAccNo)
}


showReportInfo(AccNo,chartNo,noUpdate=0){
	global
	if(!noUpdate){
		thisTick:=A_TickCount
		,floatFormat:=A_FormatFloat
		setformat,float,0.1
		totalReportTime:=(thisTick-tick0)//6000/10
		,meanReportTime:=(thisTick-tick0)/studyCount//100/10
		setformat,float,%floatFormat%
		++studyCount
	}
	guicontrol,reportInfo:,reportInfoText,% AccNo "`n" chartNo (!noUpdate?"`nStudy: " studyCount " / " totalStudyCount "`nTotal time: " totalReportTime "min`nMean time: " meanReportTime "s":"")
	gui,reportInfo:show,% "x" (monitors.2.r)-250 " y" (monitors.2.b)-150 " noactivate"
	winset,AlwaysOnTop,off,% "ahk_id " simpleRIS
	WinInsertAfter(reportInfoHwnd, simpleRIS)
	winset,AlwaysOnTop,on,% "ahk_id " simpleRIS
	fileappend,% AccNo "`n",% reportDir "\resumePacsIE",utf-8
}


loadImage(GuiInd,studyInd,ChartNo="",show=0){
	global
	local AccNo,thisGuiInd,thisMonitor,thisStudy,PacsHx,k,v,thisStudyInd,anyPriorImage,th,output,oldAccNo,oldChartNo
	thisStudyInd:=studyInd
	
	;~ msgbox,,,1,1
	if(thisStudyInd>reportListCount){
		;~ msgbox,,,err1,1
		Return
	}
	if !isobject(thisStudy:=reportList[thisStudyInd]){
		parseDataGrid(RisListRowsAcc,reportList, 1, [thisStudyInd])
		,thisStudy:=reportList[thisStudyInd]
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
		,resetPicInfo()
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
		,loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		for k,v in output {
			if RegExMatch(v.objectUID,"[^\d\.]")
				continue
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
		,thisTitle:=title[thisGuiInd]
		settimer,setLogGui,-500
		gosub activateSimpleRis
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
		loop % reportDir "\" AccNo " " chartNo "\* 1.jpeg"
			if regexmatch(a_loopfilename,"(\w+) (\w+) 1\.jpeg",match) && (match1!=AccNo) {
				anyPriorImage:=1
				,oldAccNo:=match1,oldChartNo:=match2
				break
			}
		
		if(anyPriorImage){
			showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo,oldChartNo)
			,checkLoadedPicCount(oldAccNo,oldChartNo,accNo,chartNo)
			
		}else if (regexmatch(thisStudy[examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")) && !offlineMode && !fastMode {
			
			PacsHx:=getPacsHx(sid,chartNo)
				
			for k,v in PacsHx {
				if RegExMatch(v.ExamName,"is)Chest.*(AP|PA)") && (regexreplace(v.ExamDate,"\D","")<=substr(regexreplace(thisStudy[examDateCol],"\D",""),1,8)) && (strlen(oldAccNo:=v.AccessNo)>=11) {  ;may catch exam on the same day
					
					if regexreplace(v.AccessNo,"i)^[a-z]+","")>=regexreplace(AccNo,"i)^[a-z]+","") && regexreplace(v.AccessNo,"\d+$","")=regexreplace(AccNo,"\d+$","")
							continue
					
					;~ WBp[thisGuiInd].Navigate("about:blank")
					;~ WBp[thisGuiInd].Navigate(PacsWebUrl(v.AccessNo,thisStudy[chartNoCol],loginId,loginPw))
					anyPriorImage:=1,oldChartNo:=v.ChartNo
					if !fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " oldChartNo " 1.jpeg") {
						output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,oldChartNo,loginId,loginPw))
						,loadedPicCount[ oldAccNo " " oldChartNo ]:=output.maxindex()
						for q,r in output {
							if RegExMatch(r.objectUID,"[^\d\.]")
								continue
							PacsWebDownloadJpeg2(r.url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " q ".jpeg",reportdir "\" AccNo " " chartNo,(thisMonitor).w-6,loginId,loginPw)
							;~ sleep 2000
						}
						;~ PacsWebDownloadJpeg(oldAccNo,chartNo,"",reportDir,thisMonitor.w-6,loginid,loginpw)
					}else{
						checkLoadedPicCount(oldAccNo,oldChartNo,accNo,chartNo)
					}
					
					showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo,oldChartNo)
					
					if(show)
						showPicInfo(2,oldAccNo " " oldChartNo)
					
					break
				}
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
			,loadedPicCount[oldAccNo " " oldChartNo]:=0
		}
		
		showPicInfo(2,oldAccNo " " oldChartNo)
	}
	
	
	
	
	;~ downloaded.push(loadedPic[thisGuiInd].clone())
	;~ settimer,deleteReportedPic,-1
	;~ msgbox,,,4,1
	
	;~ while loadHistoryFlag
		;~ sleep 500
	
	
	;~ settimerF("loadHistory",-1,[thisStudyInd, show],0)
	;~ msgbox % thisGuiInd
	;~ th:=ahkmini("
;~ (
;~ #persistent
;~ #notrayicon
;~ #include <portalLib>
;~ threadFinish:=0,threadReturn:=0
;~ hx:=CriticalObject(" (&Hx) "),studyInd:=" thisStudyInd "
;~ hx2Yr:=CriticalObject(" (&hx2Yr) ")
;~ ,examNameCol:=" examNameCol ",sid:=""" sid """,loginId:=""" loginId """,loginPw:=""" loginPw """
;~ ,chartNoCol:=" chartNoCol "
;~ Alias(boneKeyWords," getvar(boneKeyWords) ")
;~ Alias(lungKeyWords," getvar(lungKeyWords) ")
;~ reportList:=CriticalObject(" (&reportList) ")
;~ if loadHistory(studyInd)
	;~ threadFinish:=1,threadReturn:=studyInd
;~ settimer,routine,1000
;~ return
;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ return
	
;~ )" function1 )
	;~ msgbox % script 
	;~ th:=ahkmini(script)
	
	if(show && !fastMode){
		hxStudyInd:=studyInd
		settimer,waitHxLoaded,-1
	}
	
	
	
	;~ loadHistory(thisStudyInd)
	;~ if(show)
		;~ showHx(thisStudyInd)
	;~ msgbox,,,5,1
	return 1
}

waitHxLoaded:
thread,priority,-10
	;~ global hx,hxDll
	;~ msgbox % (hx[studyInd]="" || !hxDll)
	if (!hxDll || hxDll.getvar("i")<=studyInd) {
		settimer,waitHxLoaded,-500
		return
	}
	
		hxDll.ahkExec("showHx(" hxStudyInd ")")
	
	
return

getAllHx(){
	return
	global getAllHxInd, reportListCount
	Loop {
		if (getAllHxInd >reportListCount )
			return
		while !(reportList[getAllHxInd,chartNoCol])
			sleep 500
		
		loadHistory(getAllHxInd)
		;~ ToolTip % "Loaded hx: " getAllHxInd
		getAllHxInd++
	}
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
	gui,info%which%:show,% "x" (monitors[which+1].l+5) " y5 noactivate"
	winset,AlwaysOnTop,off,% "ahk_id " simpleRIS
	WinInsertAfter(info%which%hwnd, simpleRIS)
	winset,AlwaysOnTop,on,% "ahk_id " simpleRIS
	;~ WinInsertAfter(guiHwnd[shownGuiInd], info%which%hwnd)
	;~ if(title="simple RIS")
		;~ winactivate,ahk_id %activeHwnd%
}


loadHistory(studyInd,show=0){
	global 
	local RisReport2Yr,priorExamItem,keyword,k,v,thisStudyInd,thisHx,thisChartNo, thisAccNo
	;~ Thread,Priority,-2
	thisStudyInd:=studyInd
	;~ ToolTip % "loading hx: " studyInd
	if !isobject(reportList[thisStudyInd])
		return
	
	if !regexmatch(reportList[thisStudyInd,examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")
		return
	
	thisChartNo:=reportList[thisStudyInd,chartNoCol]
	,thisAccNo:=reportList[thisStudyInd,AccNoCol]
	,sid:=checksid(sid)?sid:sid:=login(loginid,loginpw)
	if FileExist(p:=A_ScriptDir "\loadOldHx.exe"){
		;~ hx2Yr[thisChartNo]
		run % """" p """ " sid " " thisChartNo " " thisAccNo
		return
	}
	
	keyword:="",loadHistoryFlag:=1
	;~ ToolTip % "loadin chartNo: " thisChartNo
	
	if !isobject(RisReport2Yr:=hx2Yr[thisChartNo]){
		RisReport2Yr:=parseRisReport2Yr(RisReport2Yr(sid,reportList[thisStudyInd,chartNoCol]))
		,hx2Yr[thisChartNo]:=RisReport2Yr.clone()
	}
	
	for k,v in RisReport2Yr {
		if regexmatch(priorExamItem:=v.1.1,"is)Chest.*(AP|PA)") && (++CXRind<11) {
			tmp:=matchText(v.2,boneKeyWords)
			,keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CXR: " tmp)
		}else if regexmatch(priorExamItem,"is)CT.*Chest|low dose") && (++CTind<2) {
			tmp:=matchText(v.3,lungKeyWords)
			,keyWord.=tmp=""?"":(RegExReplace(substr(v.1.3,1,10),"\/","") "CT: "  tmp)
		}
	}
	
	;~ msgbox % thisStudyInd
	hx[thisStudyInd]:=keyword "   "
	
	,dict:={"oldHx": {}}
	,dict["oldHx", thisAccNo]:=keyword "   "
	,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump(dict))
	;~ ToolTip % "keyword: " keyword
	;~ if(show)
		;~ showHx(thisStudyInd)
	
	loadHistoryFlag:=0
	return true
}


showHx(studyInd){
	global
	local keyword,hxMonitor,thisStudyInd
	thread,Priority,-2
	;~ msgbox
	thisStudyInd:=studyInd
	gui,hx:default
	gui,destroy
	RE.__Delete()
	
	if(!hxLoaded[thisStudyInd]){
		hxDll.ahkassign("ind", thisStudyInd)
		,hxDll.ahkLabel("getHx")
		,SetTimerFn("showHx", -500, [thisStudyInd])
		return
	}
	
	if ((keyword:=filterDuplicate(trim(hx[thisStudyInd])))=""){
		;~ RE.__Delete()
		return
	}
	gui,color,black
	gui,+alwaysontop +hwndhxHwnd +toolwindow -Caption
	gui,font,s14 csilver,Verdana
	gui,add,text,cblack hwndhxTextHwnd,% keyword
	controlgetpos,,,TW,TH,,ahk_id %hxTextHwnd%
	;~ tooltip % TW "," TH
	RE:=new RichEdit("hx","x0 y0 w" TW+50 " h" TH+20)
	,RE.setOptions(["readonly"])
	,RE.ShowScrollBar(0,false)
	,RE.ShowScrollBar(1,false)
	;~ RE.WordWrap(1)
	,RE.setText(keyword)
	;~ ,settimerF("colorRadReport",-1,[RE, 0])
	;~ colorRadReportFn:=Func("colorRadReport").bind(RE, 0)
	;~ Settimer,% ColorRadReportFn, -1
	,SetTimerFn("colorRadReport", -1, [RE, 0])
	;~ ,ahkmini("
	;~ (LTrim
	;~ #include <prettyReport>
	;~ #notrayicon
	;~ Alias(RE, " getVar(RE) ") 
	;~ colorRadReport(RE ,0)
	;~ exitapp
	;~ )")
	
	;~ RE.setBorder([0,0,0,0],[4,4,4,4])
	;~ hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	,hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	gui,show,% "x" hxMonitor.l+20 " y" hxMonitor.b-TH-20 " autosize noactivate",PacsIE Hx
	;~ wingetpos,x,y,w,h,ahk_id %hxHwnd%	
	;~ controlmove,,,,% w,% h,% "ahk_id " RE.hwnd
	;~ winmove,ahk_id %hxHwnd%,,% hxMonitor.l+20,% hxMonitor.b-h,w,h
	
	;~ gui,show,% "x" hxMonitor.l+50 " y" hxMonitor.b-200 " autosize noactivate",PacsIE Hx
	;~ settimer,killGui,% -1000+(-1)*strlen(keyword)*50
	WinActivate,simple RIS ahk_class AutoHotkeyGUI
}



matchText(byref str,byref arrOfKeyWords){
	ret:=""
	;~ for k,v in arrOfKeyWords {
		;~ ret.=(s:=RXMS(str,"is)[^\.;\r\n]*" v "[^\.;\r\n]*([\.;\r\n]|$)","r"))=""?"":s "`n"
	;~ }
	rt:=new ReportText(str)
	for k,v in arrOfKeyWords {
		con:=rt.contains(v, false, false)
		if !(con)
			continue
		for m,n in con 
			if !InStr(rt, n)
				ret.=n "`n"
	}
	return RegExReplace(ret, "i)[a-z ]+show[a-z]* *","")
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
	global dwData
	Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"next_study":1}))
}




ensureStudy(AccNo, chartNo, guiInd, thisTitle){
	global
	local thisGetTitle
	thisGetTitle:=WinGetAtCoords(1700,300)
	,regexmatch(thisGetTitle,"^(\w{11}) (\w{6}\d)",match)
	if(match1!=AccNo || match2!=chartNo){
		ToolTip % "Error showing image!"
		gui,%guiInd%: show,% "noactivate",% thisTitle
	}
	
}

activateSimpleRis:
active:=true
simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
SendMessage,0x2028,,,,ahk_id %simpleRIS%
;~ activateMain()
return

winactivate,ahk_id %simpleRis%
ControlFocus,Scintilla1,ahk_id %simpleRIS%
;~ winget,nextProcName,ProcessName,% "ahk_id " GetNextWindow(simpleRis)
;~ if(nextProcName!="PacsIE.exe") {
	;~ activateMainsuperior aspect of
winset,AlwaysOnTop,on,ahk_id %simpleRIS%
if !getListenerHwnd()
	winset,AlwaysOnTop,Off,ahk_id %guihwnd%

;~ }
return

priorStudy(wParam=0, lParam=0, msg=0, hwnd=0){
	global dwData
	Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"next_study":0}))
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
	,title[loadMoreInd]:=reportList[thisStudyInd,AccNoCol] " " reportList[thisStudyInd,ChartNoCol] " " reportList[thisStudyInd,examNameCol] 
	;~ gui,%loadMoreInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h) " noactivate",% title:=reportList[studyInd,AccNoCol] " " reportList[studyInd,ChartNoCol] " " reportList[studyInd,examNameCol] 
	;~ msgbox % title
	;~ msgbox,,,5,1
	
	;~ if(!fastMode)
		;~ loadHistory(studyInd)
	
	loadMoreFlag:=0
}
return



;~ guiclose:
;~ ~!#q::
;~ esc::
critical
exitapp
return
;~ ~!#r::
;~ Reload
;~ return
^!+q::
onexit:
if !WinExist("ahk_exe feedRIS.exe")
	WinShow,% "ahk_id " risopened()[2]
winactivate
;~ winshow,ahk_exe impax-client-main.exe
;~ loop 4 {
	;~ WB%a_index%.quit()
	;~ WBp%a_index%.quit()
;~ }
filedelete,% reportDir "\resumePacsIE"
SendMessage,0______,,,,getAllJpeg_main ahk_class AutoHotkeyGUI
WinClose,ahk_pid %pid%
process,Exist,getAllJpeg.exe
if(!ErrorLevel)
	filedelete,% reportDir "\reportList.json"
winrestore,% "ahk_id " impaxopened()[2,1]
;~ for k,v in threadPool {
	;~ if (isobject(v.1)){
		;~ v.1.ahkterminate()
		;~ ,ahkthread_free(v.1)
	;~ }
;~ }
for k,v in downloaded {
	if !fileexist(v.1)
		filedelete, % v.2
}
Loop {
	process,close,loadOldHx.exe
}until !ErrorLevel
;~ winclose,ahk_exe getAllJpeg.exe
if(pToken)
	Gdip_Shutdown(pToken)
;~ if noAdditionalHotkey
	;~ winclose,ahk_exe simpleRIS.exe
winactivate,PacsIE Main ahk_class AutoHotkeyGUI
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
if msgboxHwnd:=winexist("ahk_class #32770 ahk_exe PacsIE.exe") {
	winmove,ahk_id %msgBoxHwnd%,,% monitors.2.l+(monitors.2.w)/2,% (monitors.2.h)/2
	winset,AlwaysOnTop,on,ahk_id %msgBoxHwnd%
	;~ winset,AlwaysOnTop,off,ahk_id %msgBoxHwnd%
	settimer,moveMsgBox,off
}
return

openInImpax:
active:=false
,Send_WM_COPYDATA(getListenerHwnd(), dwData, jxon_dump({"request_info":1, "from":"open_impax"}))
return
;~ MinimizeMain()
openInImpax(AccNo){
	WinShow,% "ahk_id " impaxopened()[2,1]
	;~ WinShow,% "ahk_id " impaxopened()[2,2]
	;~ WinShow,% "ahk_id " impaxopened()[2,3]
	WinRestore,% "ahk_id " impaxopened()[2,1]
	;~ winset,AlwaysOnTop,on,% "ahk_id " impaxopened()[2,1]
	;~ winset,AlwaysOnTop,off,% "ahk_id " impaxopened()[2,1]
	DllCall("SetWindowPos", "Ptr", impaxopened()[2,1], "Ptr", -2, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
	Winactivate,% "ahk_id " impaxopened()[2,1]
	cmdContextServer(str:="ADD_TO_DISPLAY_LIST || " (AccNo) " || SYNC_DISPLAY || " AccNo " || ", WinExist("ahk_exe ImpaxContextServer.exe"))
}
return
cmdContextServer(str,hwnd=""){
	DetectHiddenWindows,on
	if !hwnd && !hwnd:=winexist("ahk_exe ImpaxContextServer.exe")
		return 1
	Send_WM_COPYDATA(hwnd, 0, str)
}


^;::
controlget,editHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
Edit_SetText(editHwnd, "post-operative changes.")
gosub sendReport
return

;~ #include <WorkerThread>
