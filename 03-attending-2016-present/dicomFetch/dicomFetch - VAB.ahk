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
onexit,onexit

#include <dcm4che>
#include <ParseTable>
#include <RegexSplit>

clip:=clipboard
, res:=RegExMatchall(clip, "is)\b[TYH]\w{10}\b")
,p:=0
,s1:=new dcm4che("PACSWFM2")
,s2:=new dcm4che()

;~ clip:=[["T__________"]]
,s2.storescp("","","{00100020} {00080050}/{00080018}.dcm")
for k,v in res.list
{	
	AccNo:=v[0]
	,info:=s1.getSeriesInfo(accNo)
	
	
	,count:=0
	for k,series in info {
		if InStr(series.SeriesDescription, "Tomo") 
			continue
		if !series.NumberofSeriesRelatedInstances
			continue
		count+=series.NumberofSeriesRelatedInstances
		s1.PACStoRAID(AccNo, {SeriesInstanceUID: series.SeriesInstanceUID})
		;~ ToolTip % "Moving series:`n" AccNo "`n" series.SeriesInstanceUID
		Sleep 500
	}
	
	if !(count){
		FileAppend,% AccNo ": no images`r`n",log.txt,utf-8
		continue
	}
		
	; wait pacs to raid finish
	count2:=0
	Loop {
		Sleep % 200 * (count-count2)
		count2:=s2.CountImages(s2.getSeriesInfo(AccNo))
		if (count<=count2)
			break
		
	}
	
	; move to local
	s2.MoveStudy(AccNo)
	
	; delete study in RAID
	Run,% "python.exe ""C:\Users\IDI\PycharmProjects\OsirixWeb\main.py"" " AccNo ,,Hide
	
}
ExitApp
return

OnExit:
s1:=""
s2:=""
ExitApp