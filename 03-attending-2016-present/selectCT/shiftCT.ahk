﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Off
SetBatchLines, -1
coordMode,mouse,screen
CoordMode,caret,screen
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
#NoTrayIcon
comobjerror(false)
onexit,onexit

#include <portallib>
#include <RisImpax>

gosub pointsDef
gosub loadHx
reportList:=parseDataGrid2(RisListHwnd:=getRisList(RisOpened()[2]))
,reportListCount:=reportList.maxindex()
,extractTitleCol(reportList[1], reportListTitleCol:=[])

,RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd))
,RisListRowsAcc[2].accSelect(ComObj(3,3),0)
,RisListRowsAcc[2].accSelect(ComObj(3,16),0)
,Count:=0
for k,rowValue in reportList {
	if(k=1)
		continue
	RisListRowsAcc[k].accSelect(ComObj(3,16),0)
	if !((ChartNo:=rowValue[reportListTitleCol["病歷號"]])~="\w{6}\d") 
			|| !((ExamName:=Trim(rowValue[reportListTitleCol["檢查名稱"]]))~="is)CT.+with.*contrast.*chest|low dose (lung|chest)")
			|| (Trim(rowValue[reportListTitleCol["狀態"]])="已發報告")
		continue
	
	if RisListInfo.haskey(AccNo:=rowValue[reportListTitleCol["照會單號"]]){
		data:=RisListInfo[AccNo]
	}else{
		continue
		;~ data:=[], toBeSearch.push(k)
	}
	abr:=strAbbr(ExamName:=rowValue[reportListTitleCol["檢查名稱"]], ["i)with\/without contrast-chest", "i)with contrast-chest", "i)without contrast-chest", "i)low dose (lung|chest)"], ["-+C", "+C", "-C", "LDCT"])
	,Pay:=rowValue[reportListTitleCol["保險別"]], ["自費", "健保"], ["自", "健"]
	, est_point:=(point:=pointsArr[ExamName]/data.parts/10*0.2)*( (InStr(Pay, "自費")&&abr!="LDCT") || (abr="LDCT" && point<100)?1.3:1)
	
	;~ if est_point>50
		;~ MsgBox
	
	if (est_point<50 || (est_point < 75 && !data.mets && !data.op)) && abr!="LDCT" && InStr(rowValue[reportListTitleCol["診別"]],"門診")
		RisListRowsAcc[k].accSelect(ComObj(3,8),0), Count++
}
MsgBox % "Finished!`nTotal: " Count
ExitApp
return


loadHx:
hxFile:=A_ScriptDir "\RisListInfo.txt"
fileread,RisListInfoTxt,% hxFile
RisListInfo:=[]
Loop,parse,RisListInfoTxt,`n,`r
	if RegExMatch(A_LoopField, "i)([TY]\w{9}\d),(\d+),(\d),(\d)", match)
		RisListInfo[match1]:={parts: match2, mets: match3, op: match4}
return

extractTitleCol(ByRef reportListFirstRow, ByRef reportListTitleCol){
	for k,v in reportListFirstRow
		if Trim(v)!=""
			reportListTitleCol[v]:=k
}


strAbbr(str, patternArr, abbrArr){
	for k,v in patternArr
		if RegExMatch(str, v) 
			return abbrArr[k]
	return str
}


pointsDef:
pointsArr:={"CT With/Without Contrast-Chest": 5035
	, "CT With Contrast-Chest": 4560
	, "CT Without Contrast-Chest": 3800 
	, "Low dose lung cancer screening CT": 6000 
	, "Low dose lung cancer screening CT for employee(N Hospital)": 6000 
	, "CT Without Contrast for low dose lung cancer screening": 6000 }

return

OnExit:
ExitApp