#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#persistent
;~ #notrayicon
setbatchlines,-1
#include <portallib>
#include <risimpax>
#include <JXON>
#include <ACC>
#include <WinVisible>
#include <settimerFn>
#include <WM_COPYDATA>
#include <AhkSelf>
#SingleInstance,ignore
DetectHiddenWindows,on
ComObjError(false)
dwData:=17


gui,main:Default
gui,+hwndguihwnd
WinSetTitle,% "ahk_id " guihwnd,,getAllJpeg_main

if !(winexist("ahk_exe PacsIE.exe") || WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI")) {
	hotkey,~!#q,onexit	
}
OnMessage(0x4A, "On_WM_COPYDATA")
,OnMessage(0x8000, "request_ind")
,OnMessage(0______, "exit")
,AhkSelf:=AhkSelf()

if %0% {
	param:=[]
	loop %0%
		param.push(%a_index%)
	for k,v in param {
		if(v="-noOldFilm"){
			noOldFilm:=1
		}else if WinExist("ahk_id " v)
			PacsIEhwnd:=v
	}
}

if !(PacsIEhwnd)
	PacsIEhwnd:=WinExist("ahk_exe PacsIE.exe")
	,PacsIEhwnd:=PacsIEhwnd?PacsIEhwnd:WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI")

reportDir:=a_mydocuments "\feedRIS"
,reportList:=[]
,RisState:=risopened()
,AccNoHwnd:=getRisAccNoHwnd(RisState[2])
,RisListHwnd:=getRisList(RisState[2])
;~ ,reportListCount:=parseDataGrid(RisListRowsAcc:=acc_children(acc_objectfromwindow(risListHwnd)),reportList, 1, 1)
,reportList:=parseDataGrid2(RisListHwnd)
,reportListCount:=reportList.maxindex()
,settimerFn("sendData", -1, [1], -1)


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

Send_WM_COPYDATA(WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI"), 0, jxon_dump({AccNoCol: AccNoCol
	, chartNoCol: chartNoCol
	, examNameCol: examNameCol
	, statusCol: statusCol
	, examDateCol: examDateCol}))
,RisSearchResultCount:=(RisSearchResultCount(RisOpened()[2])+1)
,monitors:=monitorInfo()
,PicWidth:=monitors[2].w-6
,loginId:=loginId, loginPw:=loginPw
,askForPortalIdPw()

;~ ,i:=2
,ThreadPoolCount:=0,threadPoolLimit:=30

gosub getAllReportList
;~ settimer,test,1000
return


test:
ToolTip % "                        " i "," reportList.maxindex() "," reportList.setcapacity(0) "," IsObject(reportList[21])
return

startDownload:


download:
	;~ thread,Priority,1
	;~ ToolTip % i "," RisSearchResultCount
	;~ ToolTip % i
	
	
	if (i=""){
		settimer,download,-500
		return
	}
	
	if(i>reportListCount)
		goto downloadEnd
	;~ if(i>reportListCount){
		;~ exitapp
	;~ }
	if(!reportList.haskey(i) || !IsObject(reportList[i])){
		settimer,download,-500
		return
	} 
	
	thisStudy:=reportList[i]
	,AccNo:=reportList[i,AccNoCol],chartNo:=reportList[i,chartNoCol],examName:=reportList[i,examNameCol]
	,outputDict:={study_data:1}
	,outputDict[i-2]:={AccNo: AccNo, ChartNo: chartNo, expected_image_count:[]}
	;~ FileAppend,% a_now ": " i " - " chartNo "," accno,logtem.txt,utf-8
	if (AccNo="" || chartNo=""){
		;~ MsgBox % exploreobj(reportList)
		settimer,, -500
		return
	}
	
	if(thisStudy[statusCol]="已發報告"){
		;~ ++i
		
		Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_miniPACS"), dwData, jxon_dump(outputDict))
		goto continueLoop
		;~ if(leave)
			;~ exitapp
		;~ continue
	}
	if(!PacsIEhwnd)
		ToolTip % "Downloading: " i-1 " / " RisSearchResultCount-1
	
	;~ msgbox % fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg")
	dict:={}, dictEmpty:=true
	;~ if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") {
		; tooltip `% "downloading:" AccNo "," chartNo "," reportDir " " loginId loginPw 
		; PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,PicWidth,loginId,loginPw)
		,output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
		;~ loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		,max:=output.maxindex()
		
		
		
		for k,v in output {
			while (threadPoolCount>threadPoolLimit)
				sleep 500
			if RegExMatch(v.objectUID,"[^\d\.]")
				continue
			dict[AccNo]:=k, dictEmpty:=false
			if fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " " k ".jpeg")
				continue
			
			initThread(v.url, AccNo,chartNo, AccNo,ChartNo, k, i)
			
			;~ PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo " " chartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
			;~ if !winexist("ahk_exe PacsIE.exe") {
				;~ traytip,% "Downloaded: " k "/" max " images (" (i-1) "/" (reportListCount-1) " studies)"
				;~ settimer,traytip,-2000
			;~ }
			;~ sleep 500
		}
		
		
	if !dictEmpty
		outputDict[i-2].expected_image_count.push(dict)
	;~ goto continueLoop
	dict:={}, dictEmpty:=true
	if(monitors.maxindex()>2 && !noOldFilm){
		anyPriorImage:=0, priorImage:={}
		;~ loop % reportDir "\" AccNo " " chartNo "\*.jpeg"
			;~ if regexmatch(a_loopfilename,"(\w+) \w+ (\d+)\.jpeg",match) && (match1!=AccNo) {
				;~ anyPriorImage:=1
				;~ ,oldAccNo:=match1
				;~ ,priorImage[oldAccNo]:=match2
			;~ }
		
		
			
			PacsHx:=getPacsHx(sid,chartNo)
			
			for k,v in PacsHx {
				if relatedExam(v.ExamName,examName) && (regexreplace(v.ExamDate,"\D","")<=substr(regexreplace(thisStudy[examDateCol],"\D",""),1,8)) && (strlen(oldAccNo:=v.AccessNo)>=11) {  ;may catch exam on the same day
					
					if regexreplace(v.AccessNo,"i)^[a-z]+","")>=regexreplace(AccNo,"i)^[a-z]+","") && regexreplace(v.AccessNo,"\d+$","")=regexreplace(AccNo,"\d+$","")
						continue
					
					;~ WBp[thisGuiInd].Navigate("about:blank")
					;~ WBp[thisGuiInd].Navigate(PacsWebUrl(v.AccessNo,thisStudy[chartNoCol],loginId,loginPw))
					anyPriorImage:=1
					,oldChartNo:=v.ChartNo
					
					
						output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,oldChartNo,loginId,loginPw))
						,loadedPicCount[ oldAccNo " " oldChartNo ]:=output.maxindex()
						,max:=output.maxindex()
						
						for q,r in output {
							if RegExMatch(r.objectUID,"[^\d\.]")
								continue
							while (threadPoolCount>threadPoolLimit)
								sleep 500
							dict[oldAccNo]:=q, dictEmpty:=false
							if fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " oldChartNo " " q ".jpeg")
								continue
							initThread(r.url, oldAccNo, oldChartNo, AccNo, chartNo, q, i)
							
							;~ PacsWebDownloadJpeg2(r.url,oldAccNo,chartNo,oldAccNo " " chartNo " " q ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
							;~ if !winexist("ahk_exe PacsIE.exe") {
								;~ traytip,% "Downloaded: " q "/" max " old images (" (i-1) "/" (reportListCount-1) " studies)"
								;~ settimer,traytip,-2000
							;~ }
							;~ sleep 500
						}
						;~ PacsWebDownloadJpeg(oldAccNo,chartNo,"",reportDir,thisMonitor.w-6,loginid,loginpw)
					
					
					
					break
				}
			}
		
	}
	if !dictEmpty
		outputDict[i-2].expected_image_count.push(dict)
		
		
		
	Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_miniPACS"), dwData, jxon_dump(outputDict))
	;~ ExitApp

	continueLoop:
	if(leave)
		exitapp
	++i
	settimer,download,-500
return 

downloadEnd:
leave:=1
ToolTip

while A_Index<240 && threadPoolCount>0
	Sleep 500

if(!PacsIEhwnd)
	MsgBox % "Finished download!"
exitapp
return




;~ updateThread(){
	;~ global threadPool, threadPoolCount, threadPoolLimit

	;~ count:=0
	;~ for k,v in threadPool {
		;~ if !isobject(v)
			;~ continue
		;~ if v.ahkgetvar("threadStart") && v.ahkgetvar("threadFinished"){
			;~ v.ahkTerminate(), ahkthread_free(v)
			;~ ,threadPool.removeAt(k)
		;~ }else{
			;~ ++Count
		;~ }
	;~ }
	;~ threadPoolCount:=count
	
	;~ if(threadPoolCount > 0.8* threadPoolLimit)
		;~ settimerF("updateThread",-500)
	;~ else
		;~ settimerF("updateThread",-2000)
;~ }
;~ return

downloadCallback(){
	global threadPoolCount
	threadPoolCount--
	;~ ToolTip % "--count"
}

initThread(url,oldAccNo,oldChartNo, AccNo,chartNo, k, i){
	global reportdir, picWidth, loginId, loginPw, threadPool, reportListCount, threadPoolCount,loginId,loginPw, threadPoolLimit
	
	while threadPoolCount>=threadPoolLimit
		Sleep 500
	;~ PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth*2,loginId,loginPw,3,100,1)
	;~ if i=8
		;~ aaa=1
	threadPoolCount++
	;~ settimerFn("PacsWebDownloadJpeg2", -1, [url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw,3,100,1, "downloadCallback"])
	,ahkmini("
	(LTrim
	#NoTrayIcon
	#Persistent
	SetBatchLines,-1
	settimer,exit,-60000
	#include <portallib>
	threadStart:=1
	,threadFinished:=0
	,url:=""" url """
	,AccNo:=""" AccNo """
	,oldAccNo:=""" oldAccNo """
	,oldChartNo:=""" oldChartNo """
	,ChartNo:=""" ChartNo """
	,reportDir:=""" reportDir """
	,picWidth:=""" PicWidth """
	,loginId:=""" loginId """
	,loginPw:=""" loginPw """
	,k:=""" k """, i:=""" i """, reportListCount:=""" reportListCount """
	,Alias(threadPoolCount, " getvar(threadPoolCount) ")
	PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo "" "" oldChartNo "" "" k "".jpeg"",reportdir ""\"" AccNo "" "" chartNo,PicWidth*2,loginId,loginPw,3,100,1, ""downloadCallback"")
	return
	downloadCallback(){
		global
		if !winexist(""ahk_exe PacsIE.exe"") && !WinExist(""miniPACS_bridge_main ahk_class AutoHotkeyGUI"") {
			ToolTip,% ""Downloaded: "" k ""/"" max "" images ("" (i-1) ""/"" (reportListCount-1) "" studies)""
		}
		threadPoolCount--
		exitapp
	}
	exit:
	threadPoolCount--
	exitapp
	)")
	;~ PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth*2,loginId,loginPw,3,100,1, "downloadCallback")
	
	
	
	Sleep 500
	return
	
	;~ return
	;~ th:=AhkThread("
	;~ (Ltrim
	;~ #notrayicon
	;~ setbatchlines,-1
	;~ #include <portallib>
	;~ threadStart:=1
	;~ ,threadFinished:=0
	;~ ,url:=""" url """
	;~ ,AccNo:=""" AccNo """
	;~ ,oldAccNo:=""" oldAccNo """
	;~ ,oldChartNo:=""" oldChartNo """
	;~ ,ChartNo:=""" ChartNo """
	;~ ,reportDir:=""" reportDir """
	;~ ,picWidth:=""" PicWidth """
	;~ ,loginId:=""" loginId """
	;~ ,loginPw:=""" loginPw """
	;~ ,k:=""" k """, i:=""" i """, reportListCount:=""" reportListCount """
	;~ ,Alias(threadPoolCount, " getvar(threadPoolCount) ")
	;~ ,PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo "" "" oldChartNo "" "" k "".jpeg"",reportdir ""\"" AccNo "" "" chartNo,PicWidth,loginId,loginPw)
	;~ loop 100 
		;~ tooltip `% threadPoolCount "","" a_index
	
	;~ if !winexist(""ahk_exe PacsIE.exe"") {
		;~ traytip,`% ""Downloaded: "" k ""/"" max "" images ("" (i-1) ""/"" (reportListCount-1) "" studies)""
	;~ }
	;~ Sleep 1000
	;~ threadFinished:=1
	;~ ,threadPoolCount--
	;~ exitapp
	;~ )")
	;~ while !th.ahkReady()
		;~ Sleep 100
}


relatedExam(exam,thisExam){
	if (exam=thisExam)
		return 1
	else if regexmatch(exam,"is)chest\b.+?view") && regexmatch(thisExam,"is)chest\b.+?view")
		return 1
	
	return 0
}

;~ esc::ExitApp

getAllReportList:
;~ parseDataGrid(RisListHwnd,reportList)
 loadFinished:=false
,RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
,RisListRowsCount:=RisListRowsAcc.maxindex()
;~ ,parseDataGrid(RisListRowsAcc,reportList,1,loadReportListInd:=20,"","","reportListProgress")
;~ ,parseDataGrid(RisListRowsAcc,reportList,1,loadReportListInd:=0,"","","reportListProgress")

Loop % reportListCount 
	if !(reportList[reportListCount-A_Index+1, AccNoCol]~="\w{9}\d")
		reportList.remove(reportListCount-A_Index+1)
	else
		break
reportListCount:=reportList.maxindex()
,Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_miniPACS"), dwData, jxon_dump({total_study_count: reportListCount-1}))
,Send_WM_COPYDATA(WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI"), 0, jxon_dump(reportList))
;~ parseDataGrid(RisListRowsAcc,reportList,1,[21, 30],"""","""","""")
;~ getInterval:=Floor(RisListRowsCount/5)+1
;~ parseThreadCount:=0
;~ Loop 5 {
	;~ ahkThread("
	;~ (LTrim
	;~ #include <RisImpax>
	;~ #include <Acc>
	;~ #persistent
	;~ #notrayicon
	;~ SetBatchLines,-1
	;~ reportList:=CriticalObject(" (&reportList) ")
	;~ ,Alias(RisListRowsAcc, " getvar(RisListRowsAcc) ")
	;~ ,Alias(parseThreadCount, " parseThreadCount ")
	;~ ,parseDataGrid(RisListRowsAcc,reportList,1," getInterval ",0," 1+(a_index-1)*getInterval ",""reportListProgress"")
	;~ ,++parseThreadCount
	;~ exitapp
	;~ )")
;~ }

;~ while parseThreadCount<5
	;~ Sleep 500
ToolTip
;~ settimer,keepLoadReportList,-2000
;~ settimer,keepLoadReportListTh,-2000
if !WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI"){
	i:=2
	gosub startDownload
}
return


keepLoadReportListTh:
ahkthread("
(%
#persistent
#notrayicon
#include <risimpax>
#include <jxon>
#include <ahkSelf>
DetectHiddenWindows,on
SetTitleMatchMode,2
Alias(RisListRowsAcc, " getvar(RisListRowsAcc) ")
,Alias(loadReportListInd, " getvar(loadReportListInd) ")
,Alias(reportListCount, " getvar(reportListCount) ")
,Alias(loadFinished, " getvar(loadFinished) ")
,Alias(PacsIEhwnd, " getvar(PacsIEhwnd) ")
;~ ,Alias(reportList, " getvar(reportList) ")
;~ ,reportList:=CriticalObject(" (&reportList) ")
,AhkSelf:=CriticalObject(" (&ahkself) ")
,batch:=10
,keepLoadReportList()
return
keepLoadReportList(){
	local obj, i
	output:=[]
	;~ MsgBox % reportList.maxindex() "","" reportlist.setcapacity(0) "","" loadReportListInd+1 
	
	,parseDataGrid(RisListRowsAcc,output,1,[loadReportListInd+1, loadReportListInd+batch],"""","""","""")
	,obj:={}, i:=loadReportListInd
	,Send_WM_COPYDATA(WinExist(""miniPACS_bridge_main ahk_class AutoHotkeyGUI""), 0, str:=jxon_dump(output))
	MsgBox % str
	if (output.setcapacity(0)>0)
		AhkSelf.Func(""writeReportList"", str)
	else
		ExitApp
	;~ Loop 10
		;~ if (i+A_Index>reportListCount){
			;~ AhkSelf.sub(""saveResult"")
			;~ ,loadReportListInd:=i+A_Index-1
			;~ ,loadFinished:=true
			
			;~ Sleep 1000
			;~ ToolTip 
			;~ ExitApp
		;~ }else
			;~ obj[i+A_Index]:=reportList[i+A_Index]
			;~ obj["""" i+A_Index]:=reportList[i+A_Index]
			;~ reportList[i+A_Index]:=obj[i+A_Index]
			
	
	;~ Send_WM_COPYDATA(WinExist(""miniPACS_bridge_main ahk_class AutoHotkeyGUI""), 0, jxon_dump(obj))
	loadReportListInd+=batch
	ToolTip % ""loaded: "" loadReportListInd
	settimer,keepLoadReportList,-500
}
)")
return

writeReportList(str){
	global reportListCount, reportList
	try 
		json:=jxon_load(str)
	catch
		return
	for k,v in json
		if k>reportListCount
			return
		else
			reportList[k]:=v
}


keepLoadReportList(){
	local obj, i, batch:=10
	parseDataGrid(RisListRowsAcc,reportList,1,[loadReportListInd+1, loadReportListInd+batch],"","","")
	,obj:={}, i:=loadReportListInd
	Loop 10
		if (i+A_Index>reportListCount){
			gosub saveResult
			loadReportListInd:=i+A_Index-1
			,loadFinished:=true
			,Send_WM_COPYDATA(PacsIEhwnd, 0, jxon_dump(obj))
			Sleep 1000
			ToolTip
			return
		}else
			;~ obj[i+A_Index]:=reportList[i+A_Index]
			obj[i+A_Index]:=reportList[i+A_Index]
	
	Send_WM_COPYDATA(PacsIEhwnd, 0, jxon_dump(obj))
	,loadReportListInd+=batch
	ToolTip % "loaded: " loadReportListInd
	settimer,,-1000
}
ToolTip:
ToolTip
return

saveResult:
if fileExist(jxonFile:=reportDir "\reportList.json")
	FileDelete,% jxonFile
FileAppend,% jxon_dump(reportList),% jxonFile,utf-8

return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){
	global reportListCount, PacsIEhwnd, startDownload
	;~ if k<100
		tooltip % "Get list from RIS: " k-1 " / " reportListCount-1 " ..."
	;~ settimerFn("sendData", -1, [k])
	;~ sendData(k)
	;~ if(k=10){
		;~ startDownload:=true
		;~ settimer,startDownload,-1,-1
	;~ }
}



sendData(k){
	thread,Priority,-1
	global reportList, PacsIEhwnd, sendDataLock
	if (PacsIEhwnd){
		obj:=[]
		,obj[k]:=reportList[k]
		
		;~ while sendDataLock || A_Index<50
			;~ Sleep 100
		;~ sendDataLock:=true
		,Send_WM_COPYDATA(PacsIEhwnd, 0, jxon_dump(obj))
		
	}
	
}


On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	global i
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ global PacsIEhwnd, sendDataLock
	;~ if(hwnd=PacsIEhwnd && lpData="received")
		;~ sendDataLock:=false
		
	try
		j:=jxon_load(str)
	catch e
		return
		
		
	if (dwData=17){
		if(j.haskey("start_from") && i=""){
			i:=j.start_from
			settimer,startDownload,-1
		}
	}
	
}


request_ind(wParam,lParam,msg,hwnd){
	local obj, k
	Critical 
	;~ ToolTip % "request" wParam
	parseDataGrid(RisListRowsAcc,reportList,1,1,"",k:=wParam)
	,obj:=[]
	,obj[k]:=reportList[k]
	,Send_WM_COPYDATA(WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI"), 0, jxon_dump(obj))
}

traytip:
TrayTip
return

;~ routine:
;~ ifwinnotexist,ahk_exe PacsIE.exe
	;~ exitapp
;~ return
onexit:
if (++leave>1){
	;~ winclose,ahk_exe PacsIE.exe
	exitapp
}else{
	sleep 5000
	;~ winclose,ahk_exe PacsIE.exe
	exitapp
}
return


exit(){
	ExitApp
}