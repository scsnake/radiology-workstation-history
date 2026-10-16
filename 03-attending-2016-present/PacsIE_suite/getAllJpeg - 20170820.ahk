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
#SingleInstance,ignore
DetectHiddenWindows,on
ComObjError(false)


if !(winexist("ahk_exe PacsIE.exe")) {
	hotkey,~!#q,onexit	
}else{
	OnMessage(0x4A, "On_WM_COPYDATA")
}

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

reportDir:=a_mydocuments "\feedRIS"
,reportList:=[]
,reportListCount:=parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisOpened()[2])),reportList, 0, 1)
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
RisSearchResultCount:=(RisSearchResultCount(RisOpened()[2])+1)
gosub getAllReportList

;~ loadedPicCount:=criticalobject(" (&loadedPicCount) ")
;~ thisStudyInd:=2
monitors:=monitorInfo()
,PicWidth:=monitors[2].w-6
,loginId:=loginId, loginPw:=loginPw
,sid:=login(loginId,loginPw)
;~ if !PacsWebLogin(loginId,loginPw) {
	;~ MsgBox, 8256, ,% "Can not log in PacsWeb!"
	;~ exitapp
;~ }
,i:=2
;~ settimer,routine,1000
,ThreadPoolCount:=0,threadPoolLimit:=30

;~ settimerF("updateThread",-500)
;~ sleep 1000

loop  {
	;~ thread,Priority,1
	;~ ToolTip % i "," RisSearchResultCount
	if(i>RisSearchResultCount)
		break
	;~ if(i>reportListCount){
		;~ exitapp
	;~ }
	thisStudy:=reportList[i]
	,AccNo:=reportList[i,AccNoCol],chartNo:=reportList[i,chartNoCol],examName:=reportList[i,examNameCol]
	if (AccNo="" || chartNo="")
		continue
	
	if(thisStudy[statusCol]="已發報告"){
		;~ ++i
		goto continueLoop
		;~ if(leave)
			;~ exitapp
		;~ continue
	}
	if(!PacsIEhwnd)
		ToolTip % "Downloading: " i " / " RisSearchResultCount

	;~ msgbox % fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg")
	if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") {
		; tooltip `% "downloading:" AccNo "," chartNo "," reportDir " " loginId loginPw 
		; PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,PicWidth,loginId,loginPw)
		output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
		;~ loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		,max:=output.maxindex()
		for k,v in output {
			while (threadPoolCount>threadPoolLimit)
				sleep 500
			if RegExMatch(v.objectUID,"[^\d\.]")
				continue
			initThread(v.url, AccNo,chartNo, AccNo,ChartNo, k, i)
			;~ PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo " " chartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
			;~ if !winexist("ahk_exe PacsIE.exe") {
				;~ traytip,% "Downloaded: " k "/" max " images (" (i-1) "/" (reportListCount-1) " studies)"
				;~ settimer,traytip,-2000
			;~ }
			;~ sleep 500
		}
		
	}
	goto continueLoop
	if(monitors.maxindex()>2 && !noOldFilm){
		anyPriorImage:=0
		loop % reportDir "\" AccNo " " chartNo "\* " chartNo " 1.jpeg"
			if regexmatch(a_loopfilename,"(\w+) \w+ 1\.jpeg",match) && (match1!=AccNo) {
				anyPriorImage:=1
				,oldAccNo:=match1
				break
			}
		
		if (!anyPriorImage && regexmatch(thisStudy[examNameCol],"is)(Chest.*(AP|PA))|(Chest.*Lateral)")){
			
			PacsHx:=getPacsHx(sid,chartNo)
			
			for k,v in PacsHx {
				if relatedExam(v.ExamName,examName) && (regexreplace(v.ExamDate,"\D","")<=substr(regexreplace(thisStudy[examDateCol],"\D",""),1,8)) && (strlen(oldAccNo:=v.AccessNo)>=11) {  ;may catch exam on the same day
					
					if regexreplace(v.AccessNo,"i)^[a-z]+","")>=regexreplace(AccNo,"i)^[a-z]+","") && regexreplace(v.AccessNo,"\d+$","")=regexreplace(AccNo,"\d+$","")
						continue
					
					;~ WBp[thisGuiInd].Navigate("about:blank")
					;~ WBp[thisGuiInd].Navigate(PacsWebUrl(v.AccessNo,thisStudy[chartNoCol],loginId,loginPw))
					anyPriorImage:=1
					,oldChartNo:=v.ChartNo
					
					if !fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " oldChartNo " 1.jpeg") {
						output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,oldChartNo,loginId,loginPw))
						,loadedPicCount[ oldAccNo " " oldChartNo ]:=output.maxindex()
						,max:=output.maxindex()
						for q,r in output {
							if RegExMatch(r.objectUID,"[^\d\.]")
								continue
							while (threadPoolCount>threadPoolLimit)
								sleep 500
							initThread(r.url, oldAccNo, oldChartNo, AccNo, chartNo, q, i)
							;~ PacsWebDownloadJpeg2(r.url,oldAccNo,chartNo,oldAccNo " " chartNo " " q ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
							;~ if !winexist("ahk_exe PacsIE.exe") {
								;~ traytip,% "Downloaded: " q "/" max " old images (" (i-1) "/" (reportListCount-1) " studies)"
								;~ settimer,traytip,-2000
							;~ }
							;~ sleep 500
						}
						;~ PacsWebDownloadJpeg(oldAccNo,chartNo,"",reportDir,thisMonitor.w-6,loginid,loginpw)
					}
					
					break
				}
			}
		}
	}
		
		
		
		
	
	
	continueLoop:
	if(leave)
		exitapp
	++i
}
leave:=1
ToolTip
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
	global reportdir, picWidth, loginId, loginPw, threadPool, reportListCount, threadPoolCount,loginId,loginPw
	
	while threadPoolCount>=threadPoolLimit
		Sleep 500
	
	threadPoolCount++
	;~ settimerFn("PacsWebDownloadJpeg2", -1, [url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw,3,100,1, "downloadCallback"])
	ahkmini("
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
		if !winexist(""ahk_exe PacsIE.exe"") {
			traytip,`% ""Downloaded: "" k ""/"" max "" images ("" (i-1) ""/"" (reportListCount-1) "" studies)""
		}
		threadPoolCount--
		exitapp
	}
	exit:
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

getAllReportList:
;~ parseDataGrid(RisListHwnd,reportList)
 
RisListRowsAcc:=acc_children(Acc_objectfromwindow(RisListHwnd))
,RisListRowsCount:=RisListRowsAcc.maxindex()
,parseDataGrid(RisListRowsAcc,reportList,1,0,"","","reportListProgress")

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
tooltip
if fileExist(jxonFile:=reportDir "\reportList.json")
	FileDelete,% jxonFile
FileAppend,% jxon_dump(reportList),% jxonFile,utf-8
;~ a:=jxon_load(b)
return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){
	global RisSearchResultCount, PacsIEhwnd
	tooltip % "Get list from RIS: " k-1 " / " RisSearchResultCount-1 " ..."
	;~ settimerFn("sendData", -1, [k])
	sendData(k)
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
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	
	;~ global PacsIEhwnd, sendDataLock
	;~ if(hwnd=PacsIEhwnd && lpData="received")
		;~ sendDataLock:=false
	
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