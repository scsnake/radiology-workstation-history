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

#include <dcm4che>
#include <portalLib>
;~ #include <WM_COPYDATA>
#include <JXON>
#include <exploreobj>

InitWorkerThread()
,dispatchClientPath:="C:\Users\IDI\PycharmProjects\test\dispatch_client.py"
,sid:=askForPortalIdPw()
;~ ,sid:=login(loginId, loginPw)

;~ SetTimer, mainTimer, 3______
;~ OnMessage(0x4A, "On_WM_COPYDATA")
;~ goto test
gosub main

return

test:
filePath:=A_ScriptDir "\20170805171224_1.txt"
run python "%dispatchClientPath%" --file "%filepath%"
ExitApp


mainTimer:
if(A_Hour="00")
	SetTimer, main, -1
else
	SetTimer,main,% (-1)*(24-A_Hour)
return

main:
;~ if(executeDate=A_YYYY a_mm a_dd)
	;~ return

;~ YesterdayDate:=A_Now
;~ YesterdayDate+= -1,D
;~ YesterdayDate:=SubStr(YesterdayDate, 1, 8)
;~ executeDate:=A_YYYY a_mm a_dd
;~ YesterdayDate:="20170522"

fileLogDir:=A_ScriptDir "\RAID2SyngoviaLog"
if !InStr(FileExist(fileLogDir),"D")
	FileCreateDir,% fileLogDir

if(A_Hour=0){
	searchDate:=A_Now
	searchDate+= -1,D
	searchDate:=SubStr(searchDate,1,8)
	,searchTime:="230000-"
	,searchHour:=23
	,vip:=(A_WDay=7 || A_WDay=5 || A_WDay=2)
}else if(A_Hour<6){
	ExitApp
}else if(A_Hour<24){
	searchDate:=SubStr(a_now,1,8)
	,searchTime:=(searchHour:=A_Hour-1) "0000-" (searchHour) "5959"
	,vip:=(A_WDay=6 && A_Hour<13) || (A_WDay=3 && A_Hour<13) || (A_WDay=4 && A_Hour>12)
}

dcmRAID:=new dcm4che("RAID")
;~ ,results:=dcmRAID.getStudyByDate(searchDate)
,AllSeries:=dcmRAID.getSeriesByDate(searchDate, {"Modality":"CT"}, ["SeriesDescription", "NumberOfSeriesRelatedInstances", "PatientID", "AccessionNumber", "SeriesInstanceUID", "StudyTime"])
,results:=collectSeriesToResults(AllSeries)
,included:=[]


,selectedSeries:=[], filtered1:=[], SeriesUID1s:=[]
for k, result in results {
	if !(result.PatientID~="^\w{6}\d$" && result.AccessionNumber~="i)^[TY]\w{9}\d$")
		continue

	studyDescription:=result.StudyDescription
	
	,series:=result.series
	,maxInstances:=0, maxSeriesUID:="", hasLDCT:=false
	for i, s in series
		if(s.NumberofSeriesRelatedInstances>maxInstances)
			maxInstances:=s.NumberofSeriesRelatedInstances
			,maxSeriesUID:=s.SeriesInstanceUID
			,hasLDCT|=RegExMatch(s.SeriesDescription, "i)ldct|(lung *care)")
	
	;~ ToolTip % A_Index "/" results.maxIndex() " " result.PatientID ": " studyDescription
	
	if(studyDescription~="i)chest|lung|thora|ldct|(lung *care)" || hasLDCT) && maxInstances>200
		selectedSeries.push([result.PatientID, result.AccessionNumber, maxSeriesUID])
		,SeriesUID1s.push(maxSeriesUID)
	else
		filtered1.push(result)
	
	;~ if(filtered1.maxIndex()>10)
		;~ break
}

ToolTip


FileDelete,% filepath:=fileLogDir "\" searchDate "_" searchHour "_1.txt"
FileAppend,% JXON_dump(selectedSeries), % filePath, utf-8
dcmRAID.Move(SeriesUID1s, "SYNGOVIA")
selectedSeries:=[]
;~ if (vip){
	;~ run python "%dispatchClientPath%" --file "%filepath%"
;~ }
;~ ExitApp

prefix:=A_Now
run,%comspec% /c "del %prefix%_*.txt",% A_ScriptDir,Hide

if (true || vip){
patientChartNos:=collectChartNos(filtered1)
,finishedWorkerCount:=0, hasChestCTChartNos:=[], totalWorkerCount:=patientChartNos.maxIndex(),activeWorkerCount:=0
for k, chartNo in patientChartNos {
	;~ while activeWorkerCount>10
		;~ Sleep 500
	
	Loop {
		winget,list,list,ahk_exe RAID2Syngovia.exe
		if list<10
			break
		Sleep 2000
	}
	
	++activeWorkerCount
	WorkerThread%k%:=new CWorkerThread("searchChestCT")
	;~ ,WorkerThread%k%.Handler.OnFinish:="searchChestCT_onFinish"
	,WorkerThread%k%.start(chartNo, searchDate, prefix, sid, k, totalWorkerCount, ShowToolTip)
	Sleep 2000
	;~ if(hasChestCTChartNos.maxIndex()>2)
		;~ break
}

Loop 
	Sleep 500
until finishedWorkerCount=totalWorkerCount || A_Index>240

Loop,Files,% A_ScriptDir "\" prefix "_*.txt"
	if RegExMatch(A_LoopFileName, prefix "_(\w+).txt", match){
			while strlen(match1)<7
				match1:="0" match1
			hasChestCTChartNos.push(match1)
		}
run,%comspec% /c "del %prefix%_*.txt",% A_ScriptDir,Hide


;~ while ThreadLeft>0 
	;~ Sleep 1000
results:=collectResultMatchChartNo(filtered1, hasChestCTChartNos), SeriesUID2s:=[]
for k, result in results {
	maxInstances:=0, maxSeriesUID:=""
	for k, s in result.series
		if(s.NumberofSeriesRelatedInstances>maxInstances)
			maxInstances:=s.NumberofSeriesRelatedInstances
			,maxSeriesUID:=s.SeriesInstanceUID
			
	if(maxInstances>200)
		selectedSeries.push([result.PatientID, result.AccessionNumber, maxSeriesUID])
		, SeriesUID2s.push(maxSeriesUID)
	
}



;~ FileDelete,% filepath:=fileLogDir "\" searchDate "_" searchHour "_2.txt"
;~ FileAppend,% JXON_dump(selectedSeries), % filePath, utf-8
;~ run "%dispatchClientPath%" --file "%filepath%"
}

if (true || vip)
	dcmRAID.Move(SeriesUID2s, "SYNGOVIA")
ExitApp

return 

collectSeriesToResults(AllSeries){
	global searchHour
	tmp:=[]
	for k, series in AllSeries {
		if SubStr(series.StudyTime,1,2)!=searchHour
			continue
		if !tmp.hasKey(series.AccessionNumber)
			tmp[series.AccessionNumber]:={series:[], AccessionNumber:series.AccessionNumber, PatientID: series.PatientID, StudyDescription: series.studyDescription, StudyInstanceUID: series.StudyInstanceUID}
		
		tmp[series.AccessionNumber].series.push(series)
	}
	return tmp
}

searchChestCT(WorkerThread, chartNo, searchDate, prefix, sid, ind, totalCount, ShowToolTip){
	;~ SetTimer,exit,-120000
	PacsCTHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid)).getNodeByNames("置頂","報告","影核醫報告").arr
	
	for k,v in PacsCTHx {
		RegExMatch(v.innerText,"is)^([\d\/]{10})\_(.+)", match)
		,match1:=RegExReplace(match1, "\D", "")
		
		
		if (match1=searchDate && instr(match2, "CT")
			&& match2~="i)chest|thora|lung"){
			if ShowToolTip
				ToolTip % ind "/" totalCount " " chartNo " (HAS chest CT)"
			Sleep 2000
			FileAppend,,% A_ScriptDir "\" prefix "_" chartNo ".txt",utf-8
			return chartNo
		}
	}
	if ShowToolTip
		ToolTip % ind "/" totalCount " " chartNo " (NO chest CT)"
	Sleep 2000
	return ""
}

searchChestCT_onFinish(WorkerThread, result){
	global finishedWorkerCount, hasChestCTChartNos, activeWorkerCount
	finishedWorkerCount++, activeWorkerCount--
	MsgBox % result
	if(result!="")
		hasChestCTChartNos.push(result)
	;~ ToolTip % result "`n" exploreobj(hasChestCTChartNos)
}

;~ esc::ExitApp

logInfo(arr){
	static path:=A_ScriptDir "\logMove.txt"
	str:=""
	for k,v in arr
		str.=v ", "
	FileAppend,% a_now ": " SubStr(str, 1, -2) "`n",% path, utf-8
}

collectResultMatchChartNo(results, included){
	arr1:=[]
	for k,result in results
		if itemInArray(result.PatientID, included)
			arr1.push(result)
	;~ for k,v in arr1
		;~ arr2.push(k)
	return arr1
}

itemInArray(item, arr){
	for k,v in arr
		if(v=item)
			return true
	return false
}

collectChartNos(results){
	arr1:=[], arr2:=[]
	for k, result in results
		arr1["_" result.PatientID]:=0
	for k,v in arr1
		arr2.push(SubStr(k,2))
	return arr2
}

~^!s::
ShowToolTip:=!ShowToolTip
return

#include <WorkerThread>