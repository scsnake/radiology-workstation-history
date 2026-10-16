/*
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
#notrayicon
#include <Acc>
#include <.NetGetControl>
#include <risimpax>
onexit,onexit


settimer,auto,-5


return

auto:
if !execute 
	gosub #2
return

#1:
^!1::
execute:=1
searchDate:="today"
gosub init

return

#2:
^!2::
execute:=1
searchDate:="yesterday"
gosub init
return

^!e::
settimer,main,off
return
;~ sleep 3000
init:
sleep 1000
shiftPressed:=getkeystate("shift")

settimer,tooltip,-2000

if (shiftPressed) {
	settimer,main,% (-1)*(wait:=(27-a_hour>24?3-a_hour:27-a_hour))*3______
	tooltip,% "Automatic LungCAD starts in " wait " hours."
	
}else {
	tooltip,% "Automatic LungCAD starts in 2 seconds."
	sleep 2000
	settimer,main,-1
}

return


main:
syngoViaLogin()
sleep 5000
syngoVia:=new SyngoVia()
settimer,syngoViaError,500
syngoVia.setDate(searchDate)
syngoVia.setSeriesDescription("LungCARE")
syngoVia.search()
syngoVia.waitSeconds(5)
prevResult:=""
firstStudy:=1,skipCount:=0
loop {
LoopStart:
	
	syngoVia.selectResult(a_index=1?0:1,0)
	sleep 500
	info:=syngoVia.getSelectInfo()
	if (prevResult=info)
		break
	prevResult:=info
	
	
	
	if instr(info,"completed") || instr(info,"progress") {
		++skipCount
		continue
	}
	if !instr(info,"LDCT") && !instr(info,"lung") && !instr(info,"Chest") && !instr(info,"thorax") {
		++skipCount
		continue
	}
	
	if !firstStudy && (skipCount<10)
		syngoVia.waitSeconds(10-skipCount)
	
	syngoVia.selectResult(0,1)
	syngoVia.waitSeconds(15)
	
	if syngoVia.wait(60) {
		Tooltip Time out!
		goto skip
	}
	
	result:=syngoVia.showLungCADResult()
	if (result=-1){
		syngoVia.startLungCAD()
		if syngoVia.wait(600) {
			tooltip Time out!
			goto skip
		}
	}
	syngoVia.waitSeconds(4)
	syngoVia.acceptAllLungCAD()
	syngoVia.waitSeconds(2)
	
	syngoVia.closePatientTab()
	syngoVia.closeDialogue(1)
	firstStudy:=skipCount:=0
	
	continue
	
skip:
	syngoVia.closePatientTab()
	syngoVia.closeDialogue()
	
}
tooltip,Finished!
settimer,tooltip,-2000
settimer,main,% (-1)*(27-a_hour>24?3-a_hour:27-a_hour)*3______
settimer,syngoViaError,off
return

tooltip:
ToolTip
return

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
	
	getSelectLoc(mouseMove=0){
		if fileexist("MMOnc.png"){
			imagesearch,x,y,0,0,% a_screenwidth,% a_screenheight,MMOnc.png
			if errorlevel
				return 1
			if mousemove=1
				mousemove,% x,% y,0
			return {x:x,y:y}
		}
	}
	
	getSelectInfo(loc="",width="",height=16){
		if width=
			width:=a_screenwidth
		if loc || isobject(loc:=this.getSelectLoc()) {
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			sleep 500
			Clipboard:=""
			run % a_mydocuments "\Capture2Text\Capture2Text.exe 0 " loc.y " " width " " loc.y+height " output.txt"
			clipwait,2
			return clipboard
			
		}
			;~ msgbox % getOCR(0,loc.y,a_screenwidth,16)
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
	
	resultListLoc(){
		id:=getNetAcc(this.hwnd,"","WindowsForms10",0,0,"","MassBlind")
		return loc:=acc_location(acc_objectfromwindow(id))
	}
	
	resultOutput(loc=""){
		if loc || loc:=this.resultListLoc() {
			winactivate,% "ahk_id " this.hwnd
			winwaitactive,% "ahk_id " this.hwnd,,2
			run % a_mydocuments "\Capture2Text\Capture2Text.exe " loc.x " " loc.y " " loc.w " " loc.h " output.txt"
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
		imagesearch,x,y,0,0,% a_screenwidth,% a_screenheight, *10 progressBar1.png
		err&=ErrorLevel
		imagesearch,x,y,0,0,% a_screenwidth,% a_screenheight, *10 progressBar2.png
		err&=ErrorLevel
		imagesearch,x,y,0,0,% a_screenwidth,% a_screenheight, *10 progressBar3.png
		err&=ErrorLevel
		
		return !err
	}
	
	wait(timeOut=30){
		j:=0
		loop {
			sleep 1000
			i:=a_index
			j+=!this.getProgressIndicatorControl()
			tooltip,% "Waiting for processing... (" i "s)"
		}until (i>timeOut*2) || j>4
		tooltip
		return (i>timeOut*2)
	}
	
	waitSeconds(s=5){
		j:=0
		loop {
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
				break
			}
		}
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
	showLungCADResult(click=1){
		id:=getNetAcc(this.hwnd,"OncologyTask_CP_Oncology@ShowHideLungCAD","Button",0,0)
		if (click){
			controlclick,,ahk_id %id%
			sleep 200
			if dialogue:=winexist("LungCAD ahk_exe syngo.Common.Container.exe",""){
				controlclick,OK,ahk_id %dialogue%
				return -1
			}else{
				return 0
			}
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
		mousemove,% x+w-30,% y+30,0
		sleep 1000
		imagesearch,x,y,% x,% y,% x+w,% y+h,startCAD.png
		if errorlevel 
			return errorlevel
		mouseclick,l,% x+30,% y+10,1,1
	}
	
	getLungCADLesion(win="",which=1){
		if win=
			win:=winexist("syngo ahk_exe syngo.Common.Container.exe")
		for k,v in c:=getControls(win) 
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
		
		loop {
			sleep 500
			i:=a_index
			accept:=this.getLungCADaccept(win)
			if !accept.maxindex()
				break
			acc_objectfromwindow(accept[1]).accDoDefaultAction()
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
		imagesearch,x,y,0,0,% a_screenwidth,% a_screenheight,*10 Export.png
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
	else if id:=winexist("syngo ahk_exe syngo.Common.Container.exe")
		return [2,id]
	else 
		return [0,0]	
}

syngoViaLogin(){
	syngoViaState:=syngoViaOpened()
	if (syngoViaState[1]=2) {
		;~ settimerF("syngoViaLogin",0)
		return
	} else if (syngoViaState[1]=0) {
		run % """C:\Program Files (x86)\Siemens\syngo.via\bin\syngo.Common.Container.exe"" -start -cache -v -f ""C:\Program Files (x86)\Siemens\syngo.via\bin\..\Starter.log"" [ set IKM.AT.DeploymentContext=Basic_Client_1_2 ] -SW.VOR"
		;~ settimerF("syngoViaLogin",500)
		sleep 2000
		syngoViaLogin()
	} else if (syngoViaState[1]=1) {
		controlsettext,Edit2,mmwp,% "ahk_id " syngoViaState[2]
		acc_objectfromwindow(getNetControl2(syngoViaState[2],"","myHostedTextbox","","WindowsForms10.EDIT","","","",0)[1]).accValue:="mmwp"
		
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