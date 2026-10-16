/*
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,ignore
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

0:=1
1:="-offline"

if %0% {
	param:=[]
	loop %0%
		param.push(%a_index%)
	for k,v in param {
		if(v="-offline"){
			offlineMode:=1
		}
	}
}
;~ msgbox % offlineMode
;~ updateLibPath()
if (!offlineMode)
	run,% a_scriptdir "\getAllJpeg.exe"


#include <portallib>
#include <risimpax>


gosub checkRisOpened


if pToken := Gdip_Startup()
	totalGUI:=1
else
	totalGUI:=monitorCount*(monitorCount=1?4:2)

root:=substr(a_scriptdir,1,1)
reportDir:=a_mydocuments "\feedRIS"
;~ reportDir:=root ":/scripts/Radiology/feedRIS"

;~ winget,thisHwnd,id,ahk_exe PacsIE.exe
thisHwnd:= WinExist("Ahk_PID " pid:=DllCall("GetCurrentProcessId"))
onmessage(0______,"next")
onmessage(0______,"prior")
onmessage(0______,"exit")

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

loginId:=loginId
loginPw:=loginPw
monitors:=monitorInfo()
if monitors.maxindex()<2 {
	msgbox % "Single monitor not supported!"
	ExitApp
}
monitorInd:=0
monitorCount:=monitors.maxIndex()-1
fixedMonitor:=2
guiInd:=1
hx:=CriticalObject(),pHx:=&hx
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
thisAccNo:=controlgettext(AccNoHwnd)
if (thisAccNo=""){
	reportListCount:=parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisState[2])),reportList, 0, 2)
	for k,v in reportList[1] {
		if (v="照會單號") {
			AccNoCol:=k
			break
		}
	}
	thisAccNo:=reportList[2,AccNoCol]
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
settimerf("EmptyMem",12000,[pid])
;~ DetectHiddenWindows,off
;~ groupadd,impaxGroup,ahk_exe impax-client-main.exe
winminimize,% "ahk_id " impaxopened()[2,1]
;~ DetectHiddenWindows,on
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
,thisPic:=loadedPic[guiInd,wheelGui]
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

showImage(guiInd,wheelGui,monitors[wheelGui+1],substr(match1,1,11),substr(match1,13,7),substr(match2,1,11),ind:=substr(nextPic,21,-5))
showPicInfo(wheelGui,substr(match2,1,-1),ind)
return

#ifwinactive



createGUI:
WB:=[],GuiHwnd:=[],WBp:=[],loadedPic:=[],loadedPicCount:=CriticalObject(),guiHwnd2:=[],hbm:=[],obm:=[],pGraphics:=[]
if(pToken){
	Gui,1: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd
	gui,1:show,% "w" monitors.2.w " h" monitors.2.h " x" monitors.2.l " y0"
	guiHwnd.push(hwnd)
	groupadd,MyGUI,ahk_id %hwnd%
	
	if(monitorCount>1){
		Gui,21: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd2
		gui,21:show,% "w" monitors.3.w " h" monitors.3.h " x" monitors.3.l " y0"
		guihwnd2.push(hwnd2)
		groupadd,MyGUI,ahk_id %hwnd2%
	}
	
	hdc:=CreateCompatibleDC()
	
}
loop % totalGUI {
	gui,color,black
	;~ Gui,%a_index%: +LastFound +ToolWindow  +hwndHwnd -border
	if (pToken){
		hbm[a_index,1]:=hbm1:=CreateDIBSection(w:=(monitors.2.w), h:=(monitors.2.h))
		obm[a_index,1] := SelectObject(hdc, hbm1)
		pGraphics[a_index,1] := G:= Gdip_GraphicsFromHDC(hdc)
		Gdip_GraphicsClear(G, 0xc0000000)
		UpdateLayeredWindow(guiHwnd[1], hdc,monitors.2.l,monitors.2.t,w,h)
		



		if (monitorCount>1){
			;~ Gui,2%a_index%: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd2
			;~ guiHwnd2.push(hwnd2)
			;~ groupadd,MyGUI,ahk_id %hwnd2%
			hbm[a_index,2]:=hbm2:=CreateDIBSection(w:=(monitors.3.w), h:=(monitors.3.h))
			obm[a_index,2] := SelectObject(hdc, hbm2)
			pGraphics[a_index,2] := G2:= Gdip_GraphicsFromHDC(hdc)
			Gdip_GraphicsClear(G2, 0xc0000000)
			UpdateLayeredWindow(guiHwnd2[1], hdc,monitors.3.l,monitors.3.t,w,h)
		}


		
	}else {
		Gui,%a_index%: -Caption +LastFound +ToolWindow -border +hwndHwnd
	;~ if (!pToken) {
		Gui,%a_index%: Add, Picture, % " BackgroundBlack x0 y0 vWB" a_index " w" (monitors.2.w) " h-1", 
		if monitorCount>1
			Gui,%a_index%: Add, Picture, % " BackgroundBlack x" monitors.2.w+1 " y0 vWBp" a_index " w" (monitors.3.w) " h-1" ,
		
		GuiHwnd.push(hwnd)
	
		groupadd,MyGUI,ahk_id %hwnd%
	}
		;~ WB.push(WB%a_index%)
		;~ WBp.push(WBp%a_index%)
	;~ }
	;~ WB%a_index%.Navigate("about:blank")
	;~ WBp%a_index%.document.body.style.backgroundColor := "black"
	
}
	pBitmap:=Gdip_CreateBitmapFromFile(reportdir "\T__________ 8______\T__________ 8______ 1.jpeg")
width:=Gdip_GetImageWidth(pBitmap)
height:=Gdip_GetImageHeight(pBitmap)
tooltip % Gdip_DrawImage(pGraphics[1,1], pBitmap, 0,0,monitors.2.w,monitors.2.h,0,0,width,height)
tooltip % UpdateLayeredWindow(guiHwnd[1], hdc, hdc,monitors.2.l,monitors.2.t,w,h)	
		
;~ msgbox % bitmap2gui(1,1,reportdir "\T__________ 8______\T__________ 8______ 1.jpeg", monitors.2.w)
exitapp


gui,log: +hwndLogHwnd +toolwindow

gui,info1: font,s24 cSilver,Verdana
gui,info1: color,black
gui,info1: +ToolWindow  +hwndinfo1Hwnd -border  +lastFound
WinSet, TransColor, black
gui,info1:add,text,vinfotext1,9999/9999
groupadd,MyGUI,ahk_id %info1hwnd%
if (monitorCount>1) {
	gui,info2: font,s24 cSilver,Verdana
	gui,info2: color,black
	gui,info2: +ToolWindow  +hwndinfo2Hwnd -border  +lastfound
	winset,transcolor,black
	gui,info2: add,text,vinfotext2,9999/9999
	groupadd,MyGUI,ahk_id %info2hwnd%
}
	
;~ sleep 1000
;~ gui,add,text,,test
;~ gui,log:show

;~ WB.Navigate(PacsWebUrl("T__________","",loginId,loginPw))
;~ sleep 5000
;~ gui,show,% "x" monitors.3.l " y" monitors.3.t " w" (monitors.3.w) " h" (monitors.3.h)
return


getReportList:
parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisState[2])),reportList, 0, totalGUI,0, [AccNoCol, thisAccNo])
return
offLineModeReportList:
parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisState[2])),reportList)
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
reportListCount:=parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisState[2])),reportList, 0, 1)
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
if (!offlineMode){
	PacsWebLogin(loginId,loginPw)
}

sid:=login(loginId,loginpw)

gosub showfilter

loadImage(guiInd,thisStudyInd,"",1)

;~ msgbox
loop % totalGUI-1 
	loadImage(guiInd+a_index,thisStudyInd+a_index)
	
;~ gui,1:show
;~ gui,21:show
;~ }
;~ msgbox
monitorInd:=1
;~ gui,filter:hide
settimer,filterHide,-1000
winactivate,% reportList[thisStudyInd,AccNoCol] " ahk_class AutoHotkeyGUI"
WinActivate,simple RIS ahk_class AutoHotkeyGUI
;~ setLogGui(reportList[thisStudyInd,AccNoCol])
;~ settimer,loadMore,-1000

if !pToken
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
reportList:=criticalobject(" (&reportList) ")
RisListHwnd:=" rislisthwnd ", thisStudyInd:=" thisStudyInd ", totalGUI:=" totalGUI "
parseDataGrid(RisListHwnd,reportList,0,0,2000,thisStudyInd+totalGUI)
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
	
bitmap2gui(guiInd,whichMonitor,imgPath,w="",h=""){
	global 
	
	;~ obm[guiInd,whichMonitor]:=SelectObject(hdc, hbm[guiInd,whichMonitor])
	
	if(imgPath=""){
		
		Gdip_GraphicsClear(pGraphics[guiInd ,whichMonitor], 0xc0000000)
		return UpdateLayeredWindow(whichMonitor=1?guiHwnd[guiInd]:guiHwnd2[guiInd], hdc, 0, 0, w, h)
	}
	
	if ! (pBitmap := Gdip_CreateBitmapFromFile(imgPath))
		return -1
	width := Gdip_GetImageWidth(pBitmap), height := Gdip_GetImageHeight(pBitmap)
	if(w="" && h=""){
		w := width, h := height
	}else if(h=""){
		h:=(w*height)//width
	}else if(w=""){
		w:=(h*width)//height
	}
	
	G:=pGraphics[guiInd,whichMonitor]
	;~ Gdip_SetInterpolationMode(G, 7)
	Gdip_DrawImage(G, pBitmap, 0, 0, w, h, 0, 0, Width, Height)
	
	return UpdateLayeredWindow(whichMonitor=1?guiHwnd[guiInd]:guiHwnd2[guiInd], hdc)
	
	
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
		guicontrol,-redraw,WBp%thisGuiInd%
		
		loop 3 {
			guicontrol,,% WBp%thisGuiInd%,% "*w" thisMonitor.w " *h-1 " reportDir "\" FolderAccNo " " chartNo "\" AccNo " " chartNo " " ind ".jpeg"
			if (!errorlevel ){
				loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"
				break
			}else
				loadedPic[thisGuiInd,whichMonitor]:=""
		}
		
		guicontrol,+redraw,WBp%thisGuiInd%
	}else{
		;~ gui,%thisGuiInd%: destroy
		;~ if(whichMonitor=1){
			;~ Gui,%thisGuiInd%: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd
			;~ guiHwnd[thisGuiInd]:=hwnd
		;~ }else{
			;~ Gui,2%thisGuiInd%: -Caption +E0x80000 +LastFound +ToolWindow -border +hwndHwnd2
			;~ guiHwnd2[thisGuiInd]:=hwnd2
		;~ }
		;~ gui,%thisGuiInd%:hide
		;~ gui,2%thisGuiInd%:hide
	
	
		if bitmap2gui(thisGuiInd,whichMonitor,reportDir "\" FolderAccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg",thisMonitor.w)
			loadedPic[thisGuiInd,whichMonitor]:=FolderAccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"
		else
			loadedPic[thisGuiInd,whichMonitor]:=""
	}
	;~ checkLoadedPicCount(AccNo,chartNo,folderAccNo)
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
		parseDataGrid(RisListHwnd,reportList, 0, [thisStudyInd])
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
	
	
	
	
	
	if (show){
		;~ ++monitorInd
		;~ msgbox % "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h)
		gui,%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (thisMonitor.w) " h" (thisMonitor.h),% title[thisGuiInd]
		showPicInfo(1,AccNo " " chartNo)
		showImage(thisGuiInd,1,thisMonitor,AccNo,chartNo)

		;~ setLogGui(title)
		thisTitle:=title[thisGuiInd]
		gosub setLogGui
		
	}else{
		;~ gui,%thisGuiInd%: hide
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
			gui,2%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (monitors.3.w) " h" (thisMonitor.h),% oldAccNo " " chartNo " "
			showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo)
			checkLoadedPicCount(oldAccNo,chartNo,accNo)
			
		}else if (regexmatch(thisStudy[examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")){
			
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
					
					
					
					if(show){
						gui,2%thisGuiInd%: show,% "x" (thisMonitor.l) " y" thisMonitor.t " w" (monitors.3.w) " h" (thisMonitor.h),% oldAccNo " " chartNo " " v.ExamName
						showPicInfo(2,oldAccNo " " chartNo)
						showImage(thisGuiInd,2,thisMonitor,AccNo,chartNo,oldAccNo)
					}
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
					loadedPic[thisGuiInd,2]:=""
				guicontrol,+redraw,WBp%thisGuiInd%
			}else{
				bitmap2gui(thisGuiInd,2,"")
			}
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
	;~ msgbox % script 
	;~ th:=ahkmini(script)

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
		gui,info1:hide
		gui,info2:hide
		return
	}
	guicontrol,info%which%:,infotext%which%,% ind "/" count
	gui,info%which%:show,% "x" (monitors[which+1].l+5) " y5"
	if(title="simple RIS")
		winactivate,ahk_id %activeHwnd%
}


loadHistory(studyInd,show=0){
	global 
	local RisReport2Yr,priorExamItem,keyword,k,v,thisStudyInd
	thisStudyInd:=studyInd
	if !isobject(reportList[thisStudyInd])
		return
	
	if !regexmatch(reportList[thisStudyInd,examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")
		return
	
	keyword:="",loadHistoryFlag:=1
	
	
	for k,v in RisReport2Yr:=parseRisReport2Yr(RisReport2Yr(checksid(sid)?sid:sid:=login(loginid,loginpw),reportList[thisStudyInd,chartNoCol])) {
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
	gui,+alwaysontop +hwndguiHwnd +toolwindow -Caption
	gui,font,s14 csilver,Verdana
	gui,add,text,,% keyword:=filterDuplicate(keyword)
	;~ hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	hxMonitor:=monitors[monitors.maxindex()>2?3:1]
	gui,show,% "x" hxMonitor.l+50 " y" hxMonitor.b-200 " autosize noactivate",PacsIE Hx
	settimer,killGui,% -1000+(-1)*strlen(keyword)*50
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

nextStudyGdip(){
	global
	local AccNo,chartNo
	resetPicInfo()
	showHx(thisStudyInd)
	AccNo:=reportList[thisStudyInd,AccNoCol], chartNo:=reportList[thisStudyInd,chartNoCol]
	loadImage(1,thisStudyInd,1)
	showPicInfo(1,substr(loadedPic[1,1],21,19))
	showPicInfo(2,substr(loadedPic[1,2],21,19))
	settimer,activateSimpleRis,-1
	prior:=0
	loadingNext:=0
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
	
	;~ loadingNext:=1
	if (++thisStudyInd>reportListCount){
		Msgbox,8192,, % "This is the LAST record!"
		return 
	}
	if(pToken){
		nextStudyGdip()
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
	thisTitle:=title[nextGuiInd]
	gosub setLogGui
	;~ gosub filterHide
	;~ msgbox % loadedPic[nextGuiInd,1] "," AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"
	if (loadedPic[nextGuiInd,1]!=AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg"){
		MsgBox, 8192, , % "Patient/image not matched!"
	}else if (loadedPic[nextGuiInd,2]!="" && !instr(loadedPic[nextGuiInd,2]," " chartNo " 1.jpeg")){
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
	
	winactivate,% "ahk_id " guiHwnd[nextGuiInd]
	;~ setLogGui(title[nextGuiInd])
	settimer,activateSimpleRis,-1
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
	
	prior:=0
	
	loadingNext:=0
}

activateSimpleRis:
WinActivate,simple RIS ahk_class AutoHotkeyGUI
return

priorStudy(wParam=0, lParam=0, msg=0, hwnd=0){
	global
	local priorGuiInd,thisMonitor,AccNo,ChartNo
	if (thisStudyInd=2){
		Msgbox,8192,, % "This is FIRST record!"
		return
	}
	--globalInd
	++prior,--thisStudyInd,priorGuiInd:=mod(--guiInd+totalGUI-1,totalGUI)+1
	if(pToken){
		nextStudyGdip()
		return
	}
	resetPicInfo()
	
	showHx(thisStudyInd)
	
	if (prior=1){
		;~ wingettitle,title,% "ahk_id " guiHwnd[priorGuiInd]
		;~ gui,filter:show
		gosub filterShow
		gui,%priorGuiInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h),% title[priorGuiInd]
		thisTitle:=title[priorGuiInd]
		gosub setLogGui
		AccNo:=reportList[thisStudyInd,AccNoCol], chartNo:=reportList[thisStudyInd,ChartNoCol]
		if (loadedPic[priorGuiInd,1]!=AccNo " " ChartNo "\" AccNo " " ChartNo " 1.jpeg"){
			MsgBox, 8192, , % "Patient/image not matched!"
		}else if (loadedPic[priorGuiInd,2]!="" && !instr(loadedPic[priorGuiInd,2]," " ChartNo " 1.jpeg")){
			
			MsgBox, 8192, , % "Patient/old image not matched!"
			
		}
		
		;~ gui,filter:hide
		;~ gosub filterhide
		winactivate,% "ahk_id " guiHwnd[priorGuiInd]
		;~ setLogGui(title)
	}else{
		if !isobject(reportList[thisStudyInd])
			parseDataGrid(RisListHwnd,reportList, 0, [thisStudyInd])
		loadImage(priorGuiInd,thisStudyInd,"",1)	
	}
	
	showPicInfo(1,substr(loadedPic[priorGuiInd,1],21,19))
	showPicInfo(2,substr(loadedPic[priorGuiInd,2],21,19))
	
}

loadMore(guiInd,studyInd){
	global 
	;~ msgbox,,,% guiINd "," studyInd,1
	;~ msgbox,,,1,1
	local loadMoreInd,thisMonitor,thisStudyInd
	
	loadMoreInd:=mod(guiInd-1,totalGUI)+1,loadMoreFlag:=1
	,thisStudyInd:=studyInd
	;~ msgbox,,,2,1
	;~ msgbox % loadMoreInd "," studyInd
	;~ tooltip % !isobject(reportList[studyInd])
	if !isobject(reportList[thisStudyInd]){
		parseDataGrid(RisListHwnd,reportList, 0, [thisStudyInd])
	}
	;~ msgbox,,,loadMore,1
	;~ tooltip % loadMoreInd "," studyInd "loadmore"
	;~ if(!pToken){
		loadImage(loadMoreInd,thisStudyInd)
		title[loadMoreInd]:=reportList[thisStudyInd,AccNoCol] " " reportList[thisStudyInd,ChartNoCol] " " reportList[thisStudyInd,examNameCol] 
	;~ }
	;~ gui,%loadMoreInd%: show,% "x" (thisMonitor:=monitors[fixedMonitor]).l " y" thisMonitor.t " w" (thisMonitor.w+(monitorCount>1?monitors.3.w:0)) " h" (thisMonitor.h) " noactivate",% title:=reportList[studyInd,AccNoCol] " " reportList[studyInd,ChartNoCol] " " reportList[studyInd,examNameCol] 
	;~ msgbox % title
	;~ msgbox,,,5,1
	loadMoreFlag:=0
}
return



guiclose:
~!#q::
;~ esc::
exitapp
return
~!#r::
Reload
return
onexit:
;~ winshow,ahk_exe impax-client-main.exe
;~ loop 4 {
	;~ WB%a_index%.quit()
	;~ WBp%a_index%.quit()
;~ }
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
if(pToken){
	loop % totalGUI {
		SelectObject(hdc, obm[a_index,1])
		DeleteObject(hbm[a_index,1])
		Gdip_DeleteGraphics(pGraphics[a_index,1])
		SelectObject(hdc, obm[a_index,2])
		DeleteObject(hbm[a_index,2])
		Gdip_DeleteGraphics(pGraphics[a_index,2])
	}
	DeleteDC(hdc)
	Gdip_Shutdown(pToken)
}
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
