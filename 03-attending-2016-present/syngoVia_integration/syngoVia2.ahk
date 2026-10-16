/*
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
;~ #notrayicon
#include <Acc>
#include <.NetGetControl>
#include <risimpax>
#include <WinVisible>
onexit,onexit
SetTimer,closeMsg,500
SetTimer,syngoCrash,-500
;~ Sleep 1000
;~ syngoVia:=new SyngoVia()
;~ MsgBox % resultInfo:=syngoVia.searchResultInfo()
;~ ExitApp

;~ settimer,auto,-5

Menu,tray,Add,Reload,Reload

Menu,tray,Add

Menu,tray,Add,Today Chest CT,MenuTask
Menu,tray,Add,Yesterday Chest CT,MenuTask
Menu,tray,Add,Last 3 Days Chest CT,MenuTask
Menu,tray,Add,Last week Chest CT,MenuTask

Menu,tray,Add

Menu,tray,Add,Today LungCARE,MenuTask
Menu,tray,Add,Yesterday LungCARE,MenuTask
Menu,tray,Add,Last 3 Days LungCARE,MenuTask
Menu,tray,Add,Last week LungCARE,MenuTask

LimitLungCare:=0
searchDate:="yesterday"
settimer,main,% (-1)*(wait:=(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______

return
closeMsg:
WinClose,ahk_exe rebootMsg.exe
IfWinExist,syngo.Common.Container.exe,傳送與問題相關
	WinClose
return 

syngoCrash:
ifWinExist,syngo.Common.Container.exe,停止運
{
	WinClose,syngo.Common.Container.exe,停止運
	gosub abortRestart
}
SetTimer,syngoCrash,-500
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
SetTimer,MenuTask,-1
return

MenuTask:
if RegExMatch(A_ThisMenuItem, "is)^(.+) (Chest CT|LungCARE)$",match)
	lastMenuItem:=A_ThisMenuItem
else if RegExMatch(lastMenuItem, "is)^(.+) (Chest CT|LungCARE)$",match) || RegExMatch(lastMenuItem:="Last 3 Days Chest CT", "is)^(.+) (Chest CT|LungCARE)$",match)
	dummy:=0

searchDate:=(match1="last week")?"last 7 days":match1
LimitLungCare:=(match2="LungCARE")
menuTrigger:=1
gosub init
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
gosub init

return

#2:
^!2::
;~ ^+!2::
execute:=1
searchDate:="yesterday"
gosub init
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
	settimer,main,% (-1)*(wait:=(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______
	tooltip,% "Automatic LungCAD starts in " wait " hours."
	
}else {
	
	tooltip,% "Automatic LungCAD starts in 2 seconds."
	sleep 2000
	instantTrigger:=1
	settimer,main,-1
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

main:
SetTimer,main,Off
while Aborting
	Sleep 2000
if(!instantTrigger){
	SetTimer,hint1,-1
	SetTimer,hint2,-180000
	SetTimer,hint3,-240000
	Sleep 300000
}
instantTrigger:=0
loop 3 {
	WinClose,ahk_exe syngo.Common.Container.exe
	Sleep 500
}
if !syngoViaLogin()
	sleep 5000
syngoVia:=new SyngoVia()

settimer,syngoViaError,500
syngoVia.setDate(searchDate)
syngoVia.setSeriesDescription(LimitLungCare?"LungCARE":"")
FileAppend,% a_now ": " searchDate ", " (LimitLungCare?"LungCARE":"") "`n",temp.log,utf-8
syngoVia.search()
syngoVia.waitSeconds(5)
prevResult:=""
firstStudy:=1,skipCount:=skipPage:=pageSkipped:=0

syngoVia.sortByStudyDateTime()
Sleep 2000
breakCount:=breakCount2:=0
omitSuspended:=1
loopAgain:
loop {
	if(Aborting){
		break
	}
LoopStart:
	
	
	
	
	if(A_Index=1)
		controlsend,,{Home},% "ahk_id " getNetAcc(syngoVia.hwnd,"","WindowsForms10",0,0,"","MassBlind")
	else if(!skipPage){
		syngoVia.selectResult(1,0)
		send {WheelDown}
	}
	
	if (skipPage)
		pageSkipped:=1
	skipPage:=0
	
	sleep 500
	;~ resultInfo:=syngoVia.searchResultInfo()
	
	selLoc:=syngoVia.getSelectLoc()
	cSelLoc:=selLoc.x "," selLoc.y
	
	info:=syngoVia.getSelectInfo(selLoc)
	RegExMatch(info, "\w{2}\d{5}",cResultChartNo)
	
	if(pSelLoc=cSelLoc && cResultChartNo=pResultChartNo){
		if(syngoVia.resultScrollToEnd())
			++breakCount
		++breakCount2
	}else
		breakCount:=0, breakCount2:=0
	
	pSelLoc:=cSelLoc
	pResultChartNo:=cResultChartNo
	
	if(breakCount>2 || breakCount2>4)
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
	
	if syngoVia.searchResultThisPageDone(omitSuspended) {
		ControlFocus,,% "ahk_id " id:=getNetAcc(syngoVia.hwnd,"","WindowsForms10",0,0,"","MassBlind")
		controlsend,,{PGDN},% "ahk_id " id
		loop 14 {
			send {WheelDown}
			Sleep 500
			if(Aborting)
				break, 2
	
		}
		skipCount:=0, skipPage:=1
		continue
	}
	
	
	if instr(info,"completed") || instr(info,"progress") || (omitSuspended && instr(info,"suspended")) {
		
		++skipCount
		continue
	}
	
	;~ if !LimitLungCare && !regexmatch(info,"i)LDCT|lung|chest|thorax|low") && !syngoVia.containsLungCARE() {
		;~ ++skipCount
		;~ continue
	;~ }
	if LimitLungCare && !syngoVia.containsLungCARE() {
		++skipCount
		continue
	}
	if(Aborting)
		break
	
	
	reassign:=0
	if !InStr(info, "Oncology"){
		reassign:=1
		syngoVia.assignMMOncology()
		syngoVia.waitSeconds(10)
	}
	
	if(Aborting)
		break
	
	if pageSkipped
		pageSkipped:=0
	else if !reassign && (!firstStudy && (skipCount<10))
		syngoVia.waitSeconds(10-skipCount)
	
	if(Aborting)
		break
	
	syngoVia.selectResult(0,1)
	
	syngoVia.waitSeconds(18)
	
	if(Aborting)
		break
	
	while syngoVia.isOverLoaded() {
		if (waitOverload:=A_Index)>20 {
			
			break
		}
		if(Aborting)
			break, 2
	
		syngoVia.waitSeconds(60)
		syngoVia.selectResult(0,1)
		syngoVia.waitSeconds(18)
		
	}
	if(waitOverload>20){
		syngoViaLog("Overloaded")
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
	
	result:=syngoVia.showLungCADResult()
	if (result=-1){
		if syngoVia.startLungCAD() {
			result:=-2
		}else{
			Sleep 5000
			result:=syngoVia.showLungCADResult()
			if syngoVia.wait(600) {
				tooltip Time out!
				goto skip
			}
		}
	}
	if(Aborting){
		break
	}
	syngoVia.waitSeconds(4)
	syngoVia.acceptAllLungCAD()
	syngoVia.waitSeconds(4)
	
	if syngoVia.closePatientTab() {
		;~ Aborting:=1
		;~ SetTimer,abortRestart,-1
		;~ Sleep 1000
		;~ break
	}
		
	
	if(result=-2)
		syngoVia.closeDialogue(3)
	else
		syngoVia.closeDialogue(1)
	
	firstStudy:=skipCount:=0
	
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
if(Aborting){
	Aborting:=0
	return
}
if(omitSuspended=1){
	omitSuspended:=0
	goto loopAgain
}
abortMain:
tooltip,Finished!
settimer,tooltip,-2000
;~ if(searchDate="today")
	;~ settimer,main,% (-1)*(24+(a_hour<2?2-a_houra:a_hour<5?5-a_hour:26-a_hour))*3______
;~ else 
	settimer,main,% (-1)*(a_hour<2?2-a_hour:a_hour<5?5-a_hour:26-a_hour)*3______
searchDate:=a_hour<2?"yesterday":a_hour<5?"last 3 days":"yesterday"
LimitLungCare:=false
settimer,syngoViaError,off
SetTimer, closeSyngoVia,-300000

;~ FileAppend,% a_now,SyngoViaLog,utf-8
return

closeSyngoVia:
WinClose,% "ahk_id " syngoVia.hwnd
WinClose,ahk_exe syngo.Common.Container.exe
process,close,syngo.Common.Container.exe
return

tooltip:
ToolTip
return


syngoViaLog(msg){
	FileAppend,% msg,SyngoViaLog,utf-8
}

syngoViaError:
if winexist("General problem ahk_exe syngo.Common.Container.exe")
	controlclick,OK,% "ahk_id " winexist("General problem ahk_exe syngo.Common.Container.exe")
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
		this.hwnd:=this.syngoViaState[2]
		this.closeDialogueText:=["Complete with archiving","Complete","Suspend","Reset"],this.closeDialogueText[0]:="Cancel"
		wingetpos,x,y,w,h,% "ahk_id " this.hwnd
		this.loc:={x:x, y:y, w:w, h:h}
		this.CaptureTextPath:=a_mydocuments "\Capture2Text\Capture2Text.exe"
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
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 StudyDateTimeCol.png
		if ErrorLevel
			return 1
		mouseclick,l,% x+50,% y+5,1,1
	}
	
	assignMMOncology(){
		selLoc:=this.getSelectLoc()
		MouseClick,r,% selLoc.x,% selLoc.y,1,0
		Sleep 500
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 reassign.png
		if ErrorLevel
			return 1
		mouseclick,l,% x+5,% y+5,1,0
		Sleep 500
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 MMOnc2.png
		if ErrorLevel
			return 1
		mouseclick,l,% x+5,% y+5,1,0
		Sleep 500
	}
	
	resultScrollToEnd(){
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,scrollToEnd.png
		if !errorlevel
			return 1
		
	}
	
	
	isOverLoaded(){
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*20 ClaimWorkItem.png
		if errorlevel
			return 0
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*20 Ok.png
		mouseclick,l,% x+5,% y+5, 1, 0
		return 1
		
	}
	
	getSelectLoc(mouseMove=0){
		if fileexist("blueselection.png"){
			
			imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,blueselection.png
			if errorlevel
				return 1
			if mousemove=1
				mousemove,% x+5,% y+5,0
			return {x:x,y:y}
		}
	}
	
	getSelectInfo(loc="",width="",height=16){
		if width=
			width:=this.loc.w
		if loc || isobject(loc:=this.getSelectLoc()) {
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			sleep 500
			Clipboard:=""
			this.DeleteCaptureOutput()
			run % """" this.CaptureTextPath """ " this.loc.x " " loc.y " " loc.x+width " " loc.y+height " output.txt"
			clipwait,5
			return clipboard
			
		}
			;~ msgbox % getOCR(0,loc.y,a_screenwidth,16)
	}
	
	deleteCaptureOutput(){
		FileDelete,% a_mydocuments "\Capture2Text\output.txt"
	}
	
	searchResultThisPageDone(IgnoreSuspended=1){
		Text:=this.searchResultInfo()
		if(Text=""){
			fileread,Text,% RegExReplace(this.CaptureTextPath,"i)Capture2Text\.exe$","output.txt")
		}
		match:="Completed"
		,RegExReplace(Text, "i)" match, m, Count1)
		if(IgnoreSuspended)
			match:="Suspended"
			,RegExReplace(Text, "i)" match, m, Count2)
		else
			Count2:=0
		
		match:="Progress"
		,RegExReplace(Text, "i)" match, m, Count3)
		;~ ToolTip % (Count1+Count2+Count3)
		return (Count1+Count2+Count3)>=16
	}
	
	searchResultInfo(){
		if !id:=getNetAcc(this.hwnd,"","WindowsForms10",0,0,"","MassBlind")
			return 1
		ControlGetPos,x,y,w,h,,ahk_id %id%
		Clipboard:=""
		this.DeleteCaptureOutput()
		run % """" this.CaptureTextPath """ " this.loc.x+x " " this.loc.y+y " " this.loc.x+x+w " " this.loc.y+y+h " output.txt"
		Sleep 100
		clipwait,5
		return clipboard
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
		loc:=this.resultListLoc()
		imagesearch,x,y,% this.loc.x,% this.loc.y+loc.y+loc.h,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h, *10 CARE.png
		return !ErrorLevel
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
			sleep 100
			return clipboard
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
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h, *10 progressBar1.png
		err&=ErrorLevel
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h, *10 progressBar2.png
		err&=ErrorLevel
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h, *10 progressBar3.png
		err&=ErrorLevel
		
		return !err
	}
	
	wait(timeOut=30){
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
			}else{
				this.activate()
				ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 LungCADisRunning.png
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
		ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 WarningLungCAD.png
		return !ErrorLevel
	}
	
	showLungCADResult(click=1){
		id:=getNetAcc(this.getSyngoCommonContainerWindows(),"OncologyTask_CP_Oncology@ShowHideLungCAD","Button",0,0)
		if (click && id){
			while !this.lungCADResultShown() {
				controlclick,,ahk_id %id%
				sleep % 1000*A_Index
				if dialogue:=winexist("LungCAD ahk_exe syngo.Common.Container.exe",""){
					controlclick,OK,ahk_id %dialogue%
					return -1
				}
				if(A_Index>5)
					return -2
			}
			
			ImageSearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 LungCADisRunning.png
			if !ErrorLevel
				return -1
			else
				return 0
			
		}else{
			return id
		}
	}
	
	getViewArea(which=1){
		for k,v in c:=getControls(this.hwnd) 
			if v.text="DocumentViewArea.DocumentViewArea"
				return c[k+which].hwnd
	}
	
	startLungCAD(){
		viewArea:=this.getViewArea(4)
		controlgetpos,x,y,w,h,,ahk_id %viewArea%
		this.activate()
		mousemove,% this.loc.x+x+w-30,% this.loc.y+y+30,0
		sleep 1000
		imagesearch,x,y,% x,% y,% x+w,% y+h,*10 startCAD.png
		if (errorlevel){
			viewArea:=this.getViewArea(1)
			controlgetpos,x,y,w,h,,ahk_id %viewArea%
			this.activate()
			mousemove,% this.loc.x+x+w-30,% this.loc.y+y+30,0
			sleep 1000
			imagesearch,x,y,% x,% y,% x+w,% y+h,*10 startCAD.png
			if ErrorLevel
				return ErrorLevel
		}
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
		win:=this.getSyngoCommonContainerWindows()
		i:=1,breakCount:=0
		loop {
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
		imagesearch,x,y,% this.loc.x,% this.loc.y,% this.loc.x+this.loc.w,% this.loc.y+this.loc.h,*10 Export.png
		if errorlevel
			return 1
		mouseclick,l,% x+10,% y+10,1,1
		Loop
			sleep 500
		until winexist("Export.. ahk_exe syngo.Common.Container.exe")
		sleep 1000
		
		controlclick,Export,Export.. ahk_exe syngo.Common.Container.exe
		
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





;~ esc::
~^!q::
exitapp
return


onexit:
ExitApp
return