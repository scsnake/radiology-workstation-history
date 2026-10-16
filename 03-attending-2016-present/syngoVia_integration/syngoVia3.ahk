/*
scsnake@gmail.com
*/


			;~ imagesearch,x,y,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\Completed.png"
;~ MsgBox % ErrorLevel
;~ ExitApp

;~ syngovia:=new syngovia()
;~ thinLoc:=syngoVia.searchResultThisPageNotDone(4)
;~ MouseMove,% thinLoc.1,% thinLoc.2,0

;~ MsgBox % lo


;~ ExitApp

FileEncoding,utf-8
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
;~ SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
;~ #notrayicon
#include <Acc>
#include <.NetGetControl>
#include <risimpax>
#include <WinVisible>
#include <DoublyLinkedList>
#include <Socket>
#include <NoTrayOrphans>
#include <settimerf>

OnMessage(0x1099, "PauseStateQuery")
,OnMessage(0x1098, "pauseToggle")
,OnMessage(0x1097, "reload")
onexit,onexit
SetTimer,closeMsg,-500
;~ Sleep 1000
;~ syngoVia:=new SyngoVia()
;~ MsgBox % resultInfo:=syngoVia.searchResultInfo()
;~ ExitApp

logFile:=A_ScriptDir "\log.txt"

;~ settimer,auto,-5
queue:=new Queue
gosub loadQueue

Menu,tray,Add,Reload,Reload

Menu,tray,Add

Menu,tray,Add,Today Chest CT,MenuTask
Menu,tray,Add,Yesterday Chest CT,MenuTask
Menu,tray,Add,Last 3 Days Chest CT,MenuTask
Menu,tray,Add,Last week Chest CT,MenuTask

searchDate:="yesterday"
settimerf("main",(-1)*(wait:=(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______)
SetTimer,checkQueue,-1
SetTimer,syngoCrash,-1
gosub setServer
;~ gosub errorControl
;~ SetTimer,MenuTask,-2000

GroupAdd,SyngoVia,ahk_exe syngo.Common.Container.exe
return

setServer:

;~ port:="54321"
;~ TCPclients:=[]


;~ myTCP:=new SocketTCP()
;~ myTCP.bind("addr_any", port)
;~ myTCP.onAccept:=Func("OnTCPAccept")
;~ myTCP.onRecv:=Func("OnTCPRecv")
;~ myTCP.listen()
return

OnTCPAccept(this){
	global TCPclients
	TCPclients.push(newTcp:=this.accept())
	;~ global newTcp
	;~ newTcp:=this.accept()
	newTcp.sendText("Connected")
	newTcp.onRecv:=Func("OnTCPRecv")
}

OnTCPRecv(this){
	global queue
	t:=this.recvText()
	if RegExMatch(t, "is)^([^\|]+)\|doLungCAD\|([^\|]{7})$", match) {
		ToolTip % "Request of lung CAD: " match2
		SetTimer,ToolTip,-2000
		queue.enqueue(match2)
		this.sendText("doingLungCAD|" match2)
	}else if RegExMatch(t, "is)^([^\|]+)\|queryStatus", match){
		this.sendText("Status: OK")
	}
}



disconnectSocket:
myTCP.disconnect()
for k,v in TCPclients
	v.disconnect()
return

loadQueue:
fileread,queueText,% queueFile:=A_ScriptDir "\queue.txt"
loop,Parse,queueText,`,
	if(Trim(A_LoopField)!="")
		queue.enqueue(Trim(A_LoopField))
FileDelete, % queueFile
return

saveQueue:
FileDelete,% queueFile
while % (item:=queue.dequeue())
	FileAppend,% item ",",% queueFile,utf-8
return

checkQueue:
if (queue.isEmpty()){
	SetTimer,checkQueue,-600
	return
}
if(mainRunning){
	SetTimer,checkQueue,-600000
	return
}
gui,1:Default
gui,Destroy
gui,Font,s12,Verdana
gui,Add,Text,,Can I run lung CAD now?
gui,Add,button,glungCADbyChartNo,% "Ok, GO!"
gui,Add,button,glungCADlatter,% "Maybe 10min latter"
gui,show,AutoSize,Lung CAD
SetTimer,lungCADbyChartNo,-180000
SetTimer,checkQueue,-600000
return

lungCADbyChartNo:
gui,1:Destroy
chartNoMode:=instantTrigger:=1
searchDate:=""
SetTimerF("main", -1)
return

lungCADlatter:
gui,1:Destroy
SetTimer,checkQueue,-600000
return
/*
errorControl:
ahkmini("
(
#persistent
Alias(Aborting, " getVar(Aborting) ")
Alias(logFile, " getVar(logFile) ")
settimer,errorMonitor,-500
return

errorMonitor:
IfWinExist,syngo.Common.Container.exe,傳送與問題相關
{
	WinClose,syngo.Common.Container.exe,傳送與問題相關
	FileAppend,% a_now ": SyngoVia Error `n",% logFile,utf-8
	SetTimer,errorMonitor,-30000
	settimer,abortRestart,-1
}
ifWinExist,syngo.Common.Container.exe,停止運
{
	WinClose,syngo.Common.Container.exe,停止運
	FileAppend,% a_now ": SyngoVia Crash `n",% logFile,utf-8

	SetTimer,errorMonitor,-30000
	settimer,abortRestart,-1
}

settimer,errorMonitor,-500
return

abortRestart:
Aborting:=1
loop {
	Sleep 500
} until !Aborting || A_Index>60
process,close,syngo.Common.Container.exe
process,close,syngo.MediaClient.exe
process,close,syngoClientBootstrapping.exe
Sleep 1000
SetTimer,init,-1
FileAppend,% a_now ": restart`n",% logFile,utf-8
return

)")
return
*/

closeMsg:
Critical
WinClose,ahk_exe rebootMsg.exe
IfWinExist,syngo.Common.Container.exe,傳送與問題相關
{
	WinClose,syngo.Common.Container.exe,傳送與問題相關
	FileAppend,% a_now ": SyngoVia Error `n",% logFile,utf-8
	SetTimer,closeMsg,-30000
	syngoViaLog("restart due to 傳送與問題相關")
	settimer,abortRestart,-1
}
SetTimer,closeMsg,-500
return 

syngoCrash:
Critical
ifWinExist,syngo.Common.Container.exe,停止運
{
	WinClose,syngo.Common.Container.exe,停止運
	FileAppend,% a_now ": SyngoVia Crash `n",% logFile,utf-8

	SetTimer,syngoCrash,-30000
	syngoViaLog("restart due to 停止運作")
	settimer,abortRestart,-1
}
SetTimer,syngoCrash,-500
;~ ToolTip % A_TickCount
return

abortRestart:
Aborting:=1
loop {
	Sleep 500
} until !Aborting || A_Index>60
Aborting:=0
gosub closeSyngoVia
Sleep 1000
resetSuspended:=true
SetTimer,init,-1
FileAppend,% a_now ": restart`n",% logFile,utf-8
return

MenuTask:
if RegExMatch(A_ThisMenuItem, "is)^(.+) (Chest CT|LungCARE)$",match)
	lastMenuItem:=A_ThisMenuItem
else if RegExMatch(lastMenuItem, "is)^(.+) (Chest CT|LungCARE)$",match) || RegExMatch(lastMenuItem:="Last 3 Days Chest CT", "is)^(.+) (Chest CT|LungCARE)$",match)
	dummy:=0

if (searchDate:=(match1="last week")?"last 7 days":match1)=""
	searchDate:="last 3 days"

menuTrigger:=1
SetTimer,init,-1
return
Reload:
Reload
return

auto:
if !execute 
	gosub #1
return

#1:
^!1::
;~ ^+!1::
execute:=1
searchDate:="today"
SetTimer,init,-1

return

#2:
^!2::
;~ ^+!2::
execute:=1
searchDate:="yesterday"
SetTimer,init,-1
return


^!e::
settimer,main,off
Aborting:=1
return


init:
shiftPressed:=getkeystate("shift")

settimer,tooltip,-2000
menuTrigger:=0
if (shiftPressed) {
	settimerf("main",(-1)*(wait:=(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______)
	tooltip,% "Automatic LungCAD starts in " wait " hours."
	SetTimer,ToolTip,-2000
}else {
	
	tooltip,% "Automatic LungCAD starts in 2 seconds."
	SetTimer,ToolTip,-2000
	sleep 2000
	instantTrigger:=1
	SetTimerF("main", -1)
}

return

hint1:
MsgBox, 4144, Lung CAD, % "5 分鐘後將進行SyngoVia Lung CAD，請先暫停目前作業並存檔！", 180
return
hint2:
MsgBox, 4144, Lung CAD, % "2 分鐘後將進行SyngoVia Lung CAD，請先暫停目前作業並存檔！", 60
return
hint3:
MsgBox, 4144, Lung CAD, % "1 分鐘後將進行SyngoVia Lung CAD，請先暫停目前作業並存檔！", 60
return

setCloseSyngoviaSchedule:
if(a_hour+0=6)
	gosub closeSyngoVia
else
	settimer,setCloseSyngoviaSchedule,-3______
return

main(){
global
SetTimer,main,Off
while Aborting
	Sleep 2000
if(!instantTrigger){
	SetTimer,hint1,-1
	SetTimer,hint2,-180000
	SetTimer,hint3,-240000
	Sleep 300000
}
gosub controlGUI
mainRunning:=1
,instantTrigger:=0

gosub closeSyngoVia
Sleep 500

if !syngoViaLogin()
	sleep 5000

syngoVia:=new SyngoVia()
settimer,setCloseSyngoviaSchedule,-1
if syngoVia.waitMain(10) {
	MsgBox,,, % "Cannot login",10
	mainRunning:=0
	gosub controlGUIdestroy
	return
}
settimer,syngoViaError,-500
syngoVia.setDate(searchDate)
,syngoVia.setSeriesDescription("")
,syngoVia.resetSuspended:=resetSuspended
,resetSuspended:=false
,searchType:=-1
chartModeLoopAgain:
if(chartNoMode){
	if ((searchChartNo:=queue.dequeue())=""){
		mainRunning:=Aborting:=chartNoMode:=0
		gosub controlGUIdestroy
		goto abortMain
		
		return
	}
	SyngoVia.setChartNo(searchChartNo)
	searchType:=3
}
FileAppend,% a_now ": " searchDate (chartNoMode?"," searchChartNo:"") "`n",% logFile,utf-8
syngoVia.search()
,syngoVia.waitSeconds(5)
,prevResult:=""
,firstStudy:=1,skipCount:=skipPage:=pageSkipped:=0

,syngoVia.sortByStudyDateTime()
if(chartNoMode){
	Sleep 500
	syngoVia.sortByStudyDateTime()
}
Sleep 2000
breakCount:=breakCount2:=0

/*
searchType:
0 -> assign "To Be Assigned"
1 -> Ready to Read
2 -> Suspended
3 -> Others
4 -> traditional
*/
ChestCtList:=loadChestCTList(searchDate)

;~ searchType:=0
loopAgain:
searchType++

if(!chartNoMode)
	FileAppend,% a_now ": Loop type = " searchType "`n",% logFile,utf-8
FinishCount:=0
loop {
	NoTrayOrphans()
	DllCall("SystemParametersInfo", Int,17, Int,0, UInt,NULL, Int,2)
	if(Aborting){
		break
	}
LoopStart:
	; wait for search list being active (study tab may not closed)
	if(SyngoVia.waitMain(20)){
		SyngoVia.closePatientTab()
		,SyngoVia.closeDialogue()
		if(SyngoVia.waitMain(20)){
			syngoViaLog("Time out waiting for active search tab")
			SetTimer,abortRestart,-1
			Aborting:=1
			Sleep 1000
			break
		}
	}
	if(Aborting)
		break
	
	if(A_Index=1)
		; to the top of result
		controlsend,,{Home},% "ahk_id " getNetAcc(syngoVia.hwnd,"","WindowsForms10",0,0,"","MassBlind")
	else if(!skipPage){
		;select next result
		syngoVia.selectResult(1,0)
		send {WheelDown}
	}
	
	if (skipPage)
		pageSkipped:=1
	skipPage:=0
	
	sleep 500
	;~ resultInfo:=syngoVia.searchResultInfo()
	
	selLoc:=syngoVia.getSelectLoc()
	,cSelLoc:=selLoc.x "," selLoc.y
	
	; text of the selected result by OCR
	,info:=syngoVia.getSelectInfo(selLoc)
	,RegExMatch(info, "\w{2}\d{5}",cResultChartNo)
	
	; test if end of result
	if(pSelLoc=cSelLoc && cResultChartNo=pResultChartNo){
		if(syngoVia.resultScrollToEnd())
			++breakCount
		++breakCount2
	}else
		breakCount:=0, breakCount2:=0
	
	pSelLoc:=cSelLoc
	,pResultChartNo:=cResultChartNo
	
	if(breakCount>1 || breakCount2>2)
		break
	
	;~ continue
	
	
	;~ if (pResultChartNo=cResultChartNo){
		;~ if(++loopToEnd>2){
			
			;~ break
		;~ }else{
			;~ ++loopToEnd
			;~ Sleep 500
			;~ continue
		;~ }
	;~ }
	;~ pResultChartNo:=cResultChartNo
	;~ loopToEnd:=0
	if(Aborting)
		break
	
	; cursor may induce tooltip that interfere OCR
	MouseMove,% A_ScreenWidth/2,% A_ScreenHeight,0
	
	; test if next target result existed
	if !(nextStudy:=syngoVia.searchResultThisPageNotDone(searchType)) {
		; if not, jump next page
		controlsend,,{PGDN},% "ahk_id " resultListHwnd:=getNetAcc(syngoVia.hwnd,"","WindowsForms10",0,0,"","MassBlind")
	
		if !syngoVia.resultScrollToEnd() 
			; scroll result, make selected result on the top
			loop (syngoVia.resultsCol-2) {
				ControlFocus,,% "ahk_id " resultListHwnd
				send {WheelDown}
				Sleep 200
				if(Aborting)
					break, 2
		
			}
		skipCount:=0, skipPage:=1
		continue
	}
	
	if(Aborting)
		break
	
	; skip "completed" or "in progress" study for search type 4
	if (searchType=4) && (instr(info,"completed") || instr(info,"progress")) {
		++skipCount
		continue
	}
	
			
	if(searchType!=4){ 
		; click/select next target study
		mouseclick,l,% nextStudy.1,% nextStudy.2,1,0
		if !syngoVia.resultScrollToEnd() {
			; make the target study on the top of list
			loop % (tmp:=syngoVia.CoordToRow(nextStudy)-1) {
				ControlFocus,,% "ahk_id " resultListHwnd:=getNetAcc(syngoVia.hwnd,"","WindowsForms10",0,0,"","MassBlind")
				send {WheelDown}
				Sleep 200
				if(Aborting)
					break

			}
		}
	}
	
	; get selected study text
	info:=syngoVia.getSelectInfo(selLoc:=syngoVia.getSelectLoc())
	,RegExMatch(info, "\w{2}\d{5}",cResultChartNo)

	
	

	if(Aborting)
		break
	
	;~ syngoVia.resetSuspended:=true
	if(searchType=5) || (searchType=2 && syngoVia.resetSuspended){
		; some "suspended" or "in progress" may be stucked unless cancelled and reassigned
		selLoc:=syngoVia.getSelectLoc()
		,SyngoVia.CancelWorkflow([selLoc.x, selLoc.y])
		,syngoVia.waitSeconds(15)
		,info:=syngoVia.getSelectInfo(selLoc)
		,RegExMatch(info, "\w{2}\d{5}",cResultChartNo)
	}else if (searchType=0 && (isChestCTList(ChestCtList, cResultChartNo) || (info~="i)ldct|lung ?care|low\W?dose") || syngoVia.containsLungCARE())){
		; assign "to be assigned" study
		syngoVia.assignMMOncology()
		Sleep 2000
		continue
	}
	
	
	reassign:=0
	if !InStr(info, "Oncology"){
		reassign:=1
		,syngoVia.assignMMOncology()
		,syngoVia.waitSeconds(10)
	}
	
	if(searchType=0)
		continue
	
	if(Aborting)
		break
	
	if pageSkipped
		pageSkipped:=0
	else if !reassign && (!firstStudy && (skipCount<5))
		; wait for previous study completed
		syngoVia.waitSeconds(5-skipCount)
	
	if(Aborting)
		break
	
	; double click to open the study
	syngoVia.selectResult(0,1)
	;~ syngoVia.selectResult(0,0)
	;~ thinLoc:=syngoVia.seriesInfoGetThinSliceCoord()
	;~ mouseclick,l,% thinLoc.1,% thinLoc.2,2,0
	MouseMove,% A_ScreenWidth/2,% A_ScreenHeight,0
	syngoVia.waitSeconds(5)
	; error may appeared after opening the study, need cancel and reassign the study
	if (errorHwnd:=winexist("Error ahk_exe syngo.Common.Container.exe")){
		ControlClick,Ok,% "ahk_id " errorHwnd
		WinClose,% "ahk_id " errorHwnd
		syngoVia.closePatientTab()
		,syngoVia.closeDialogue()
		,syngoVia.waitSeconds(5)
		,SyngoVia.CancelWorkflow([selLoc.x, selLoc.y])
		,syngoVia.waitSeconds(15)
		,syngoVia.assignMMOncology()
		,syngoVia.waitSeconds(5)
		continue
	}
	syngoVia.waitSeconds(15)
	
	if(Aborting)
		break
	
	; deal with error "Overloaded"
	while syngoVia.isOverLoaded() {
		if (waitOverload:=A_Index)>20 {
			
			break
		}
		if(Aborting)
			break, 2
		; rest and retry opening the study
		syngoVia.waitSeconds(60)
		,syngoVia.selectResult(0,1)
		,syngoVia.waitSeconds(18)
		
	}
	if(waitOverload>20){
		syngoViaLog("restart due to overloaded")
		SetTimer,abortRestart,-1
		Aborting:=1
		Sleep 1000
		break
	}
	
	if syngoVia.wait(300) {
		Tooltip Time out!
		goto skip
	}
	if(Aborting)
		break
	
	; click "show LungCAD result", if still processing, wait until finished
	result:=syngoVia.showLungCADResult()
	if (result=-1){
		; activate LungCAD
		waitTimeout:=0
		if syngoVia.startLungCAD() {
			result:=-2
		}else{
			Sleep 5000
 			result:=syngoVia.showLungCADResult()
			
			; wait for 600 seconds at most
			;~ waitCount:=0
			waitTimeout:=syngoVia.wait(600, true)
			
			
			;~ loop {
				;~ if syngoVia.wait(55)
					;~ break
				;~ if(A_Index>=600){
					;~ waitCount:=600
					;~ break
				;~ }
				
				;~ if !syngoVia.lungCADisRunning()
					;~ break
				
				;~ Sleep 1000
				
				;~ if Mod(A_Index, 60)=0 {
					; sometimes the progress bar stops refreshing, need reactivate to show true progress
					;~ syngoVia.clickLungCADResult()
					;~ Sleep 2000
					;~ syngoVia.clickLungCADResult()
				;~ }
			;~ }
			if (waitTimeout) {
				tooltip Time out!
				syngoViaLog("Lung CAD time out for chart No: " cResultChartNo)
				goto skip
			}
		}
	}
	if(Aborting){
		break
	}
	syngoVia.waitSeconds(3)
	; accept all candidates
	,syngoVia.acceptAllLungCAD()
	,syngoVia.waitSeconds(3)
	
	if syngoVia.closePatientTab() {
		;~ Aborting:=1
		;~ SetTimer,abortRestart,-1
		;~ Sleep 1000
		;~ break
	}
		
	
	if(result=-2)
		syngoVia.closeDialogue(3)
	else{
		syngoVia.closeDialogue(1)
		,finishCount++
	}
	
	firstStudy:=skipCount:=0
	MouseMove,% A_ScreenWidth/2,% A_ScreenHeight,0
	continue
	
skip:
	if syngoVia.closePatientTab() {
		;~ Aborting:=1
		;~ SetTimer,abortRestart,-1
		;~ Sleep 1000
		;~ break
	}
	syngoVia.closeDialogue()
	
}
FileAppend,% a_now ": Loop finished - " finishCount "`n",% logFile,utf-8
Aborting:
if(Aborting){
	mainRunning:=Aborting:=chartNoMode:=0
	gosub controlGUIdestroy
	FileAppend,% a_now ": Abort`n",% logFile,utf-8
	return
}
if(chartNoMode){
	
	goto chartModeLoopAgain
}
if(searchType=4){
	loop 60 {
		Sleep 990
		if (Aborting)
			break
	}
	if(Aborting || !WinExist("ahk_id " SyngoVia.hwnd))
		goto Aborting
}
if(searchType<5){
	goto loopAgain
}
abortMain:
mainRunning:=0
gosub controlGUIdestroy
tooltip,Finished!
settimer,tooltip,-2000
FileAppend,% a_now ": Finished!`n",% logFile,utf-8
;~ if(searchDate="today")
	;~ settimerf("main",(-1)*(24+(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______)
;~ else 
	settimerf("main",(-1)*(a_hour<5||a_hour>=23?5-a_hour:24-a_hour)*3______)
searchDate:=a_hour<5||a_hour>=23?"last 3 days":"yesterday"

settimer,syngoViaError,off
SetTimer,closeSyngoVia,-300000
resetSuspended:=false
;~ FileAppend,% a_now,SyngoViaLog,utf-8
return
}

closeSyngoVia:
WinClose,% "ahk_id " syngoVia.hwnd
WinClose,ahk_exe syngo.Common.Container.exe
WinClose,ahk_exe syngoClientBootstrapping.exe
WinClose,ahk_exe syngo.MediaClient.exe
Sleep 500
process,close,syngo.Common.Container.exe
process,close,syngoClientBootstrapping.exe
process,close,syngo.MediaClient.exe
syngoViaLog("Close syngovia")
return

tooltip:
ToolTip
return


syngoViaLog(msg){
	global logFile
	FileAppend,% a_now ": " msg "`n",% logFile,utf-8
}

syngoViaError:
if (errorHwnd:=winexist("General problem ahk_exe syngo.Common.Container.exe")){
	controlclick,OK,% "ahk_id " errorHwnd
	WinClose,% "ahk_id " errorHwnd
	if(++errorCount>5){
		errorCount:=0
		SetTimer,syngoViaError,Off
		syngoViaLog("restart due to general problem")
		SetTimer,abortRestart,-1
	}
}
;~ ToolTip syngovia
SetTimer,syngoViaError,-500
return


;~ a::
;~ if !text:=!!(SyngoVia.getProgressIndicatorControl()) 
	;~ send {printscreen}
;~ tooltip % text
;~ return

;~ ^b::
;~ clipboard:=listcontrols(winexist("syngo ahk_exe syngo.Common.Container.exe"))
;~ return

routine:
syngoViaState:=syngoViaOpened()
return

class SyngoVia {
	__new() {
		this.syngoViaState:=syngoViaOpened()
		,this.hwnd:=this.syngoViaState[2]
		,this.closeDialogueText:=["Complete with archiving","Complete","Suspend","Reset"],this.closeDialogueText[0]:="Cancel"
		wingetpos,x,y,w,h,% "ahk_id " this.hwnd
		this.loc:={x:x, y:y, w:w, h:h}
		,this.CaptureTextPath:=a_mydocuments "\Capture2Text\Capture2Text.exe"
		,this.resetSuspended:=false
		,this.resultsCol:=24 ;16
	}
	
	
	getContainer(){
		for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'syngo.Common.Container.exe'") {
			winget,id,id,% "ahk_pid " process.processid
			return id
		}
	}
	
	listControls(){
		return listControls(this.hwnd)
	}
	
	
	setDataSource(s){
		;~ winactivate,% "ahk_id " this.hwnd
		;~ winwaitactive,,,1
		this.DataSourceDropdown()
		sleep 100
		loc:=acc_location(acc_objectfromwindow(id:=this.getContainer()))
		loop,parse,s,`,
			if (a_loopfield="Local"){
				mouseclick,l,% loc.x+13,% loc.y+13,1,0
			}else if(a_loopfield="RAID"){
				mouseclick,l,% loc.x+13,% loc.y+165,1,0
			}
		this.DataSourceDropdown()
	}
	
	DataSourceDropdown(){
		id:=getNetControl2(this.hwnd,"","","Data Source","BUTTON","","","",0)[1]
		acc_objectfromwindow(id).accDoDefaultAction()
		return id
		
	}
	
	
	setPatientId(s){
		return this.setChartNo(s)
	}
	setChartNo(s){
		while StrLen(s)<7
			s:="0" s
		if id:=getNetControl2(this.hwnd,"Patient ID","myLabel","","STATIC","","","",2)[1]
			controlsettext,,% s,% "ahk_id " id
		else
			return 1
	}
	
	setDate(s){
		if id:=getNetControl2(this.hwnd,"Study Date and Time","myLabel","","STATIC","","","",2)[1]
			controlsettext,,% s,% "ahk_id " id
		else
			return 1
	}
	
	
	setSeriesDescription(s){
		if id:=getNetControl2(this.hwnd,"Series Description","myLabel","","STATIC","","","",2)[1]
			controlsettext,,% s,% "ahk_id " id
		else
			return 1
	}
	
	setSearchField(s,field){
		if id:=getNetControl2(this.hwnd,field,"myLabel","","STATIC","","","",2)[1]
			controlsettext,,% s,% "ahk_id " id
		else
			return 1
	}
	
	search(){
		if id:=getNetAcc(this.hwnd,"myStripesPanel","WindowsForms",1,0)
			controlsend,,{Enter},% "ahk_id " id
		else
			return 1
	}
	
	getResult(){
		static id
		if id || id:=getNetAcc(this.hwnd,"myInfoLabel","STATIC",0,0)
			controlgettext,s,,% "ahk_id " id
		else
			return 1
		
		if instr(s,"Query") {
			sleep 500
			this.getResult()
			return
		}else if (s="This view contains no items.")
			return -1
		else {
			
		}
	}
	
	
	
	sortByStudyDateTime(){
		this.activate()
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\StudyDateTimeCol.png"
		if ErrorLevel
			return 1
		mouseclick,l,% x+50,% y+5,1,1
	}
	
	assignMMOncology(){
		selLoc:=this.getSelectLoc()
		MouseClick,r,% selLoc.x,% selLoc.y,1,0
		Sleep 500
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\reassign.png"
		if ErrorLevel
			return 1
		mouseclick,l,% x+5,% y+5,1,0
		Sleep 500
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\MMOnc2.png"
		if ErrorLevel
			return 1
		mouseclick,l,% x+5,% y+5,1,0
		Sleep 500
	}
	
	resultScrollToEnd(){
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\scrollToEnd.png"
		if !errorlevel
			return true
		
	}
	
	
	isOverLoaded(){
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\ClaimWorkItem.png"
		if errorlevel
			return 0
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\Ok.png"
		mouseclick,l,% x+5,% y+5, 1, 0
		return 1
		
	}
	
	getSelectLoc(mouseMove=0){

			
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\blueselection.png"
		if errorlevel
			return 1
		if mousemove=1
			mousemove,% x+5,% y+5,0
		return {x:x,y:y}
		
	}
	
	getSelectInfo(loc="",width="",height=16){
		if width=
			width:=this.loc.w
		if loc || isobject(loc:=this.getSelectLoc()) {
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			sleep 500
			this.DeleteCaptureOutput()
			run % """" this.CaptureTextPath """ " this.loc.x " " loc.y " " loc.x+width " " loc.y+height " output.txt"
			return this.getCapturedText()
			
		}
			;~ msgbox % getOCR(0,loc.y,a_screenwidth,16)
	}
	
	deleteCaptureOutput(){
		this.activate()
		clipboard:=""
		FileDelete,% a_mydocuments "\Capture2Text\output.txt"
		process,close,Capture2Text.exe
		
	}
	
	getCapturedText(){
		ClipWait,10
		if ErrorLevel
			fileread,t,% a_mydocuments "\Capture2Text\output.txt"
		else
			t:=Clipboard
		
		return t
	}
	
	/*
	searchType:
	0 -> to be assigned
	1 -> Ready to Read
	2 -> Suspended
	3 -> Others
	4 -> traditional methods
	5 -> In progress (failed study need re-scheduled)
	*/
	searchResultThisPageNotDone(searchType=1){
		loc:=this.resultListLoc()
		if(searchType=1 || searchType=2){
			imagesearch,x,y,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% "*10 " A_ScriptDir "\image\" (searchType=1?"ReadyToRead":"Suspended") ".png"
			;~ if errorlevel
				;~ imagesearch,x,y,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,%  "*10 " (searchType=1?"ReadyToRead":"Suspended") "2.png"
			if ErrorLevel
				return false
			else 
				return [x+10,y+5]
		}else if (searchType=3 || searchType=0){
			imagesearch,x1,y1,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% "*10 " A_ScriptDir "\image\toBeAssign2.png"
			errLvl1:=ErrorLevel
			imagesearch,x2,y2,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% "*10 " A_ScriptDir "\image\toBeAssign1.png"
			errLvl2:=ErrorLevel
			imagesearch,x3,y3,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% A_ScriptDir "\image\emptyLong1.png"
			errLvl3:=ErrorLevel
			imagesearch,x4,y4,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% A_ScriptDir "\image\emptyLong2.png"
			errLvl4:=ErrorLevel
			
			if !(x1 || x2 || x3 || x4)
				return false
			
			retx:=rety:=""
			loop 4 {
				v:=y%a_index%
				if(v!="" && (v<rety || rety=""))
					rety:=y%a_index%
					,retx:=x%a_index%
			}
			return [retx+10, rety+5]
			
		}else if (searchType=4){
			Text:=this.searchResultInfo()
			match:="Completed"
			,RegExReplace(Text, "i)" match, m, Count1)
			match:="Suspended"
			,RegExReplace(Text, "i)" match, m, Count2)
			match:="Progress"
			,RegExReplace(Text, "i)" match, m, Count3)
			;~ ToolTip % (Count1+Count2+Count3)
			return (Count1+Count2+Count3)<this.resultsCol
		}else if (searchType=5){
			imagesearch,x,y,% this.loc.x+loc.x,% this.loc.y+loc.y,% this.loc.x+loc.x+440,% this.loc.y+loc.y+loc.h,% "*10 " A_ScriptDir "\image\InProgress.png"
			return ErrorLevel?false:[x+10,y+5]
		}
	}
	
	searchResultInfo(){
		if !id:=getNetAcc(this.hwnd,"","WindowsForms10",0,0,"","MassBlind")
			return 1
		ControlGetPos,x,y,w,h,,ahk_id %id%
		this.DeleteCaptureOutput()
		run % """" this.CaptureTextPath """ " this.loc.x+x " " this.loc.y+y " " this.loc.x+x+w " " this.loc.y+y+h " output.txt"
		return this.getCapturedText()
	}
	
	selectResult(s=1,run=0){ ;1=next, 0=current, -1=previous
		if !id:=getNetAcc(this.hwnd,"","WindowsForms10",0,0,"","MassBlind")
			return 1
		controlfocus,,% "ahk_id " id
		if s=1
			controlsend,,{down},ahk_id %id%
		else if s=-1
			controlsend,,{up},ahk_id %id%
		
		if (run=1){
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			this.getSelectLoc(1)
			click,2
		}
	}
	
	containsLungCARE(){
		this.activate()
		
		loc:=this.resultListLoc()
		imagesearch,x,y,% this.loc.x,% this.loc.y+loc.y+loc.h,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\CARE.png"
		return !ErrorLevel
	}
	
	getSeriesInfo(){
		this.activate()
		loc:=this.resultListLoc()
		loop {
			imagesearch,x,y,% this.loc.x,% this.loc.y+loc.y+loc.h,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\seriesIcon.png"
			e:=ErrorLevel
			Sleep 500
		}until !e || (A_Index>10)
		
		this.DeleteCaptureOutput()
		run % """" this.CaptureTextPath """ " (x+13) " " (y) " " A_ScreenWidth " " A_ScreenHeight " output.txt"
		seriesInfo:=this.getCapturedText()
		arr:=[]
		loop,Parse,seriesInfo,`n
			if RegExMatch(A_LoopField, "is)^([^,]+), ([^,]+)(?:, ([^,]+))?$", match)
				arr.push([match1, match2, match3])
			
		return arr
		
	}
	
	seriesInfoGetThinSliceCoord(){
		seriesInfo:=this.getSeriesInfo()
		static seriesRowHeight:=23
		i:=0,j:=2
		for k,v in seriesInfo
			if(InStr(v.3,"CT") && v.2>i)
				i:=v.2, j:=k
		
		loop {
			imagesearch,x,y,% this.loc.x,% this.loc.y+loc.y+loc.h,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\seriesIcon.png"
			e:=ErrorLevel
			Sleep 500
		}until !e || (A_Index>10)
		
		return [x+30, y+5+(j-1)*seriesRowHeight]
	}
	
	
	resultListLoc(){
		id:=getNetAcc(this.hwnd,"","WindowsForms10",0,0,"","MassBlind")
		return loc:=acc_location(acc_objectfromwindow(id))
	}
	
	resultOutput(loc=""){
		if loc || loc:=this.resultListLoc() {
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			this.DeleteCaptureOutput()
			run % """" this.CaptureTextPath """ " loc.x " " loc.y " " loc.x+loc.w " " loc.h " output.txt"
			
			return this.getCapturedText()
		}
		
	}
	
	clickResult(i=1){
		loc:=this.resultListLoc()
		winactivate,% "ahk_id " this.hwnd
		winwaitactive,,,1
		mouseclick,l,% loc.x+loc.w/2,% loc.y+6+(i-1)*27+9,1,0
	}
	
	import(){
		id:=getNetAcc(this.hwnd,"TransferJobPreparer@RetrieveButton","BUTTON",0,0)
		acc_objectfromwindow(id).accDoDefaultAction()
	}
	
	getProgressIndicatorControl(){
		;~ return id:=getNetControlGlobal("","ProgressIndicatorControl")
		err:=1
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\progressBar1.png"
		err&=ErrorLevel
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\progressBar2.png"
		err&=ErrorLevel
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\progressBar3.png"
		err&=ErrorLevel
		
		return !err
	}
	
	wait(timeOut=30, checkLungCAD=false){
		global Aborting
		j:=0
		loop {
			if(Aborting){
				return 0
			}
			sleep 1000
			i:=a_index
			if (processing:=this.getProgressIndicatorControl()){
				j:=0
				continue
			}else {
				this.activate()
			
				if(checkLungCAD){
					if !this.lungCADResultShown()
						this.clickLungCADResult()
					else if j=0
						this.clickLungCADResult()
						,this.clickLungCADResult()
				}
				ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\LungCADisRunning.png"
				if (!ErrorLevel){
					j:=0
					continue
				}
				j+=1
			}		
			tooltip,% "Waiting for processing... (" i "s)"
		}until (i>timeOut*2) || j>4
		tooltip
		return (i>timeOut*2)
	}
	
	waitSeconds(s=5){
		global Aborting
		j:=0
		loop {
			if (Aborting)
				break
				
			sleep 1000
			i:=a_index
			
			tooltip,% "Waiting for processing... (" i " / " s "s)"
		}until i>=s
		tooltip
		
	}
	
	;~ wait(timeOut=30){
		;~ loop {
			;~ sleep 500
			;~ i:=a_index
		;~ }until (i>timeOut*2) || !this.getProgressIndicatorControl()
		;~ return (i>timeOut*2)
	;~ }
	
	getPatientTab(acc=0){
		return id:=getNetAcc(this.hwnd,"default@PatientTabAccess","WindowsForms",0,!!acc)
	}
	
	closePatientTab(which=1){
		tab:=this.getPatientTab(1)
		obj:=acc_get("object",which,0,tab)
		id:= acc_windowfromobject(obj)
		for k,v in c:=getControls(this.hwnd) {
			if (v.hwnd=id) {
				loc:=acc_location(acc_objectfromwindow(c[k+5].hwnd))
				this.activate()
				mouseclick,l,% loc.x+(loc.w/2),% loc.y+(loc.h/2),1,0
				return 0
			}
		}
		return 1
	}
	
	closeDialogue(choice=3){   ; 1=complete with archiving, 2=complete, 3=suspend, 4=reset, 0=cancel
		winwait,Close Patient ahk_exe syngo.Common.Container.exe,,5
		if errorlevel
			return 1
		sleep 500
		for k,v in c:=getControls(id:=winexist("Close Patient ahk_exe syngo.Common.Container.exe")) {
			if (v.text=this.closeDialogueText[choice]){
				acc_objectfromwindow(buttonId:=choice?c[k-1].hwnd:v.hwnd).accDoDefaultAction()
				break
			}
		}
	}
	
	activate(timeout=1){
		winactivate,% "ahk_id " this.hwnd
		winwaitactive,,,%timeout%
		return errorlevel
	}
	
	getSyngoCommonContainerWindows(){
		winget,list,list,ahk_exe syngo.Common.Container.exe
		arr:=[]
		loop % list
			arr.push(list%a_index%)
		return arr
	}
	
	lungCADResultShown(){
		ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\WarningLungCAD.png"
		return !ErrorLevel
	}
	
	clickLungCADResult(id=""){
		if (!id) && (!id:=getNetAcc(this.getSyngoCommonContainerWindows(),"OncologyTask_CP_Oncology@ShowHideLungCAD","Button",0,0))
			return 1
		
		currentState:=this.lungCADResultShown()
		
		ControlClick,,ahk_id %id%
		Sleep 2000
		if (currentState = this.lungCADResultShown()){
			ControlFocus,,ahk_id %id%
			send {Space}
		}
	}
	
	showLungCADResult(click=1){
		id:=getNetAcc(this.getSyngoCommonContainerWindows(),"OncologyTask_CP_Oncology@ShowHideLungCAD","Button",0,0)
		if (click && id){
			while !this.lungCADResultShown() {
				controlclick,,ahk_id %id%
				if(A_Index>2){
					ControlFocus,,ahk_id %id%
					send {Space}
				}
	
				sleep % 1000*(A_Index<5?A_Index:5)
				if dialogue:=winexist("LungCAD ahk_exe syngo.Common.Container.exe",""){
					controlclick,OK,ahk_id %dialogue%
					return -1
				}
				if(A_Index>5)
					return -2
			}
			
			;~ ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\LungCADisRunning.png"
			if this.lungCADisRunning()
				return -1
			else
				return 0
			
		}else{
			return id
		}
	}
	
	lungCADisRunning(){
		if !this.lungCADResultShown()
			this.clickLungCADResult()
		ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\LungCADisRunning.png"
		return !ErrorLevel

	}
	
	getViewArea(){
		arr:=[],parent:=0
		for k,v in c:=getControls(this.hwnd) 
			if v.text="DocumentViewArea.DocumentViewArea"
				loop {
					hwnd:=c[k+A_Index].hwnd
					if (!parent)
						parent:=DllCall("GetParent",UInt, hwnd)
					
					if (parent=DllCall("GetParent",UInt, hwnd)){
						ControlGetPos,x,y,w,h,,ahk_id %hwnd%
						arr.push({hwnd: hwnd, x: this.loc.x+x, y: this.loc.y+y, w: w, h: h})
					}
					
				}until !hwnd
		return arr
	}
	
	getMainViewArea(ByRef AllViewArea=""){
		if !IsObject(AllViewArea)
			AllViewArea:=this.getViewArea()
		
		sort:=""
		for k,v in AllViewArea {
			hwndStr:=v.hwnd
			while StrLen(hwndStr)<10
				hwndStr.=" "
			sort.=hwndStr v.w "`n"
		}
		
		sort,sort,N P11
		
		arr:=[]
		loop,Parse,sort,`n
			if RegExMatch(A_LoopField, "is)(.{10})(.+)", match)
				arr.push({hwnd: Trim(match1), w: match2})
			
		ret:=[]	
			
		if (arr.maxindex()=4) && (arr.4.w>arr.3.w && arr.4.w>arr.2.w && arr.4.w>arr.1.w){
			return [arr.4.hwnd]
		}else if (arr.maxindex()=6) && (arr.6.w>arr.4.w && arr.6.w>arr.3.w && arr.5.w>arr.2.w && arr.5.w>arr.1.w)
			return [arr.5.hwnd, arr.6.hwnd]
		else {
			for k,v in arr
				ret.push(v.hwnd)
			return ret
		}
	}
	
	startLungCAD(ViewAreaHwnd=""){
		if IsObject(ViewAreaHwnd){
			for k,v in ViewAreaHwnd
				this.startLungCAD(v)
			return
		}else if (ViewAreaHwnd=""){
			ViewAreaHwnd:=this.getViewArea()
			mainViewArea:=this.getMainViewArea(ViewAreaHwnd)
			this.startLungCAD(mainViewArea)
			return
		}else{
			viewArea:=ViewAreaHwnd
		}
		
		controlgetpos,x,y,w,h,,ahk_id %viewArea%
		this.activate()
		mousemove,% this.loc.x+x+w-30,% this.loc.y+y+30,0
		sleep 1000
		imagesearch,x,y,% x,% y,% x+w,% y+h,% "*10 " A_ScriptDir "\image\startCAD.png"
		;~ if (errorlevel){
			;~ viewArea:=this.getViewArea()[1]
			;~ controlgetpos,x,y,w,h,,ahk_id %viewArea%
			;~ this.activate()
			;~ mousemove,% this.loc.x+x+w-30,% this.loc.y+y+30,0
			;~ sleep 1000
			;~ imagesearch,x,y,% x,% y,% x+w,% y+h,% "*10 " A_ScriptDir "\image\startCAD.png"
			;~ if ErrorLevel
				;~ return ErrorLevel
		;~ }
		if !ErrorLevel
			mouseclick,l,% x+30,% y+10,1,1
	}
	
	getLungCADLesion(win="",which=1){
		;~ if win=
			;~ win:=winexist("syngo ahk_exe syngo.Common.Container.exe")
		win:=this.getSyngoCommonContainerWindows()
		for x,y in win
			for k,v in c:=getControls(y) 
				;~ if (which=1 && (v.text="hScrollBar1" && c[k+7].text="C1")) || ((v.text="C" which-1) && (c[k+6].text="C" which))
				if (v.text="hScrollBar1" && c[k+7].text="C" which)
					return c[k+7].hwnd
		return 0
	}
	
	getLungCADaccept(win=""){
		arr:=[]
		if (win="")
			win:=this.getSyngoCommonContainerWindows()
		arr:=getNetControl2(win,"","btnAccept","C","BUTTON")
		return arr
	}
	
	acceptAllLungCAD(){
		global Aborting
		win:=this.getSyngoCommonContainerWindows()
		i:=1,breakCount:=0
		loop {
			if Aborting
				break
			sleep 1000
			
			accept:=this.getLungCADaccept(win)
			if !accept.maxindex() {
				break
				;~ ++breakCount
				;~ Sleep 1000
				;~ continue
			}
			;~ if(breakCount>2)
				;~ break
			this.activate()
			controlgetpos,x,y,w,h,,% "ahk_id " accept[1]
			mouseclick,l,% this.loc.x+x+w*2, % this.loc.y+y,1,0
			Sleep 400
			acc_objectfromwindow(accept[1]).accDoDefaultAction()
			++i
			;~ continue
			
			;~ if !lesion:=this.getLungCADLesion(win,a_index)
				;~ break
			;~ this.activate()
			;~ controlgetpos,x,y,w,h,,ahk_id %lesion%
			;~ mouseclick,l,% this.loc.x+x+w/2, % y+h/2,1,0
			;~ sleep 200
			;~ if accept:=GetOtherControl(lesion,-2,getControls(win))
				;~ acc_objectfromwindow(accept).accDoDefaultAction()
		}
		if i=1
			return 1
		
	}
	
	exportAllLesions(){
		results:=getNetControlGlobal("","ListControlCFNItem","","WindowsForms")[1]
		first:=results[1]
		last:=results[results.maxindex()]
		wingetpos,x1,y1,w1,h1,ahk_id %first%
		wingetpos,x2,y2,w2,h2,ahk_id %last%
		this.activate()
		sleep 1000
		mouseclick,l,% x1+w1/3,% y1+h1/2,1,1
		sleep 1000
		send {shift down}
		mouseclick,l,% x2+w2/3,% y2+h2/2,1,1
		sleep 1000
		send {shift up}
		sleep 1000
		mouseclick,r,% x1+w1/3,% y1+(y2-y1)/2,1,1
		sleep 1000
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\Export.png"
		if errorlevel
			return 1
		mouseclick,l,% x+10,% y+10,1,1
		Loop
			sleep 500
		until winexist("Export.. ahk_exe syngo.Common.Container.exe")
		sleep 1000
		
		controlclick,Export,Export.. ahk_exe syngo.Common.Container.exe
		
	}
	
	waitMain(timeout=10){
		global Aborting
		loop {
			if(Aborting)
				return 0
			imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,% "*10 " A_ScriptDir "\image\main.png"
			if !ErrorLevel
				return 0
			Sleep 1000
		}until A_Index>=timeout
		return 1
	}
	
	CoordToRow(coord){
		static rowHeight:=27
		y:=coord.2
		loc:=this.resultListLoc()
		return Floor((y-loc.y-this.loc.y)/rowHeight)+1
		
	}
	
	CancelWorkflow(coord){
		mouseclick,r,% coord.1,% coord.2,1,0
		loop 10 {
			Sleep 500
			imagesearch,x,y,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\CancelWorkflow.png"
		}until !ErrorLevel
		if(x="" || y="")
			return 1
		
		mouseclick,l,% x+10,% y+10,1,0
		
		loop 10 {
			Sleep 500
			imagesearch,x,y,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\Yes.png"
		}until !ErrorLevel
		if(x="" || y="")
			return 1
		
		mouseclick,l,% x+10,% y+10,1,0
		
		return 0
	}
}


syngoViaOpened(){
	if id:=winexist("syngo login ahk_exe syngo.Common.Container.exe")
		return [1,id]
	else if id:=winexist("syngo ahk_exe syngo.Common.Container.exe"){
		winget,list,list,% "syngo ahk_exe syngo.Common.Container.exe"
		
		minX:="",leftWin:=""
		loop % list {
			wingetpos,x1,,,,% "ahk_id " list%a_index%
			if(minX="" || x1<minX)
				minX:=x1,leftWin:=list%a_index%
		}
		return [2,leftWin]
	}else 
		return [0,0]	
}

syngoViaLogin(){
	syngoViaState:=syngoViaOpened()
	if (syngoViaState[1]=2) {
		;~ settimerF("syngoViaLogin",0)
		return 1
	} else if (syngoViaState[1]=0) {
		if FileExist("C:\Program Files (x86)\Siemens\syngo.via\bin\syngo.Common.Container.exe")
			run % """C:\Program Files (x86)\Siemens\syngo.via\bin\syngo.Common.Container.exe"" -start -cache -v -f ""C:\Program Files (x86)\Siemens\syngo.via\bin\..\Starter.log"" [ set IKM.AT.DeploymentContext=Basic_Client_1_2 ] -SW.VOR"
		else if FileExist("C:\Program Files\Siemens\syngo.via\bin\syngo.Common.Container.exe")
			run % """C:\Program Files\Siemens\syngo.via\bin\syngo.Common.Container.exe"" -start -cache -v -f ""C:\Program Files\Siemens\syngo.via\bin\..\Starter.log"" [ set IKM.AT.DeploymentContext=Basic_Client_1_2 ] -SW.VOR"
		else {
			MsgBox % "Can't find the SyngoVia"
			ExitApp
		}
		;~ settimerF("syngoViaLogin",500)
		sleep 5000
		syngoViaLogin()
	} else if (syngoViaState[1]=1) {
		controlsettext,Edit2,mmwp2,% "ahk_id " syngoViaState[2]
		acc_objectfromwindow(getNetControl2(syngoViaState[2],"","myHostedTextbox","","WindowsForms10.EDIT","","","",0)[1]).accValue:="mmwp2"
		
		acc_objectfromwindow(getNetControl2(syngoViaState[2],"","btnOK","","WindowsForms10.BUTTON","","","",0)[1]).accDoDefaultAction()
		
	}
	
}


controlGUI:
PauseState:=0
gosub controlGUIdestroy
gui,+hwndguihwnd +ToolWindow +AlwaysOnTop -Caption -Resize
gui,Add,button,w50 h50 gpause vpause,Pause/`nContinue`n(Enter)
gui,Add,button,w50 h50 yp x+10 greload,Stop
gui,show,% "NoActivate y0 x" (A_ScreenWidth-200)
GroupAdd,SyngoVia,ahk_id %guihwnd%
settimer,keepOnTop,1000
return

keepOnTop:
winset,AlwaysOnTop,on,ahk_id %guihwnd%
return

#IfWinActive,ahk_group SyngoVia
~Enter::
~NumpadEnd::
Pause
return 
#IfWinActive

Pause:
Pause
return


controlGUIdestroy:
gui,Destroy
settimer,keepOnTop,Off
return

PauseStateQuery(wParam, lParam, msg, hwnd){
	SendMessage,0x1100,,% A_IsPaused,,ahk_id %hwnd%
}

pauseToggle(wParam, lParam, msg, hwnd){
	pause,Toggle
}

Reload(wParam, lParam, msg, hwnd){
	Reload
}


;~ esc::
;~ Critical
~^!q::
exitapp
return

;~ esc::Pause

onexit:
gosub disconnectSocket
gosub saveQueue
syngoViaLog("Exit")
NoTrayOrphans()
DllCall("SystemParametersInfo", Int,17, Int,1, UInt,NULL, Int,2)
ExitApp
return



loadChestCTList(searchDate){
	static dateDuration:={"today":0, "yesterday":1, "last 3 days":3, "last 7 days":7}
	dates:=[SubStr(a_now,1,8)]
	,ret:=[], day:=a_now
	loop % dateDuration[searchDate] {
		day+= -1,D
		dates.push(SubStr(day,1,8))
	}
	if(searchDate="yesterday")
		dates.remove(1)
	
	for k, date in dates {
		ret[date]:=","
		loop,Files,% A_ScriptDir "\RAID2SyngoviaLog\" date "_*.txt"
		{
			fileread,tmp,% A_LoopFileLongPath
			try 
				j:=jxon_load(tmp)
			catch
				continue
			for a,b in j
				ret[date].= b.1 ","
		}
	}
	return ret
}

isChestCTList(list, chartNo, date=""){
	if(date!="")
		if InStr(list[date], "," chartNo ",")
			return true
	else
		for k,v in List
			if InStr(v, "," chartNo ",")
				return true
	return false
}