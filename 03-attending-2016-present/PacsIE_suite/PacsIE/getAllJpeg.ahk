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
;~ #include <settimerF>
#SingleInstance,ignore
DetectHiddenWindows,on

if !winexist("ahk_exe PacsIE.exe") {
	hotkey,~!#q,onexit	
}

if %0% {
	param:=[]
	loop %0%
		param.push(%a_index%)
	for k,v in param {
		if(v="-noOldFilm"){
			noOldFilm:=1
		}
	}
}
reportDir:=a_mydocuments "\feedRIS"
reportList:=[]
reportListCount:=parseDataGrid(controlexist(RisListHwnd)?RisListHwnd:(RisListHwnd:=getRisList(RisOpened()[2])),reportList, 0, 1)



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
gosub,getAllReportList

;~ loadedPicCount:=criticalobject(" (&loadedPicCount) ")
;~ thisStudyInd:=2
monitors:=monitorInfo()
PicWidth:=monitors[2].w-6
loginId:=loginId, loginPw:=loginPw
sid:=login(loginId,loginPw)
;~ if !PacsWebLogin(loginId,loginPw) {
	;~ MsgBox, 8256, ,% "Can not log in PacsWeb!"
	;~ exitapp
;~ }
i:=2
;~ settimer,routine,1000
ThreadPoolCount:=0,threadPoolLimit:=30

settimerF("updateThread",-500)
;~ sleep 1000
loop % RisSearchResultCount {
	i:=a_index
	;~ if(i>reportListCount){
		;~ exitapp
	;~ }
	thisStudy:=reportList[i]
	AccNo:=reportList[i,AccNoCol],chartNo:=reportList[i,chartNoCol],examName:=reportList[i,examNameCol]
	if (AccNo="" || chartNo="")
		continue
	
	if(thisStudy[statusCol]="已發報告"){
		;~ ++i
		goto continueLoop
		;~ if(leave)
			;~ exitapp
		;~ continue
	}

	;~ msgbox % fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg")
	if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") {
		; tooltip `% "downloading:" AccNo "," chartNo "," reportDir " " loginId loginPw 
		; PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,PicWidth,loginId,loginPw)
		output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
		;~ loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		max:=output.maxindex()
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
	
	if(monitors.maxindex()>2 && !noOldFilm){
		anyPriorImage:=0
		loop % reportDir "\" AccNo " " chartNo "\* " chartNo " 1.jpeg"
			if regexmatch(a_loopfilename,"(\w+) \w+ 1\.jpeg",match) && (match1!=AccNo) {
				anyPriorImage:=1
				oldAccNo:=match1
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
					oldChartNo:=v.ChartNo
					
					if !fileexist(reportDir "\" accno " " chartNo "\" oldAccNo " " oldChartNo " 1.jpeg") {
						output:=PacsWebInfoFlatten(PacsWebInfo(output, oldAccNo,oldChartNo,loginId,loginPw))
						loadedPicCount[ oldAccNo " " oldChartNo ]:=output.maxindex()
						max:=output.maxindex()
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
	
}
leave:=1
exitapp
return

updateThread(){
	global threadPool, threadPoolCount, threadPoolLimit

	count:=0
	for k,v in threadPool {
		if !isobject(v)
			continue
		if v.ahkgetvar("threadStart") && v.ahkgetvar("threadFinished"){
			v.ahkTerminate()
			if !(threadPool.removeAt(k))
				threadPool.Delete(k)
		}else{
			++Count
		}
	}
	threadPoolCount:=count
	
	;~ if(threadPoolCount > 0.8* threadPoolLimit)
		;~ settimerF("updateThread",-500)
	;~ else
		;~ settimerF("updateThread",-2000)
}
return

initThread(url,oldAccNo,oldChartNo, AccNo,chartNo, k, i){
	global reportdir, picWidth, loginId, loginPw, threadPool, reportListCount
	
	threadPool.push(ahkmini("
	(Ltrim
	#persistent
	#notrayicon
	setbatchlines,-1
	threadStart:=1
	#include <portallib>
	threadFinished:=0
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
	PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo "" "" oldChartNo "" "" k "".jpeg"",reportdir ""\"" AccNo "" "" chartNo,PicWidth,loginId,loginPw)
	/*
	if !winexist(""ahk_exe PacsIE.exe"") {
		traytip,% ""Downloaded: "" k ""/"" max "" images ("" (i-1) ""/"" (reportListCount-1) "" studies)""
		threadFinished:=1
		sleep 2000
	}
	*/
	threadFinished:=1
	return
	)"))
	
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
;~ msgbox % RisListRowsAcc.maxindex()
parseDataGrid(RisListRowsAcc,reportList,1,0,"","","reportListProgress")
tooltip
if fileExist(jxonFile:=reportDir "\reportList.json")
	FileDelete,% jxonFile
FileAppend,% jxon_dump(reportList),% jxonFile,utf-8
;~ a:=jxon_load(b)
return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc){
	global RisSearchResultCount
	tooltip % "Get list from RIS: " k-1 " / " RisSearchResultCount-1 " ..."
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