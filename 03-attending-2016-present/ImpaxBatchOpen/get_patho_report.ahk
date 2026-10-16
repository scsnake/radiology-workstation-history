#include <RisImpax>
#include <PortalLib>
#include <ImpaxContextServer>
#include <JXON>
SetBatchLines,-1
#SingleInstance,Off
;~ OnExit,OnExit
FileEncoding,utf-8-Raw
patho_clip:=Clipboard
json_dir := "E:\scsnake\2020 lung ca\reports\"
json_files:=[]
Loop,files,% json_dir "*.json",F
	json_files.push(A_LoopFileLongPath)
output:=""
for k,v in json_files
{
	SplitPath,v,,,,fileName
	chartNo:=fileName
	fileread,jsonstr,% v
	jsonObj:=jxon_load(jsonstr)
	ExamDate:=jsonObj[1].ExamDate
	notSaved:=false
	if RegExMatch(patho_clip, chartNo "\t(\d{8})\t\d{8} ([^\t]+)", m){
		if(!ExamDate) || (ExamDate<m1){
			pathoReport:=[]
			pathoReport.Type:="Patho"
			pathoReport.Date:=m1
			pathoReport.Report:=m2
			jsonObj.push(pathoReport)
			FileDelete,% v
			FileAppend,% jxon_dump(jsonObj),% v, utf-8-Raw
		}else
			notSaved:=true
	}else{
		notsaved:=true
	
	}
	if notSaved
		output.= chartNo "`t" ExamDate "`n"
}

ExitApp
SplitPath,A_ScriptFullPath,,,,fileName
if %0%
	goto main2
;~ portalId:=loginId
;~ portalPw:=loginPw
gosub main
return

main:
;~ fileread,stas_result,stas_result.txt

;~ FileDelete,temp_result.txt
clip:=clipboard
,sid:=askForPortalIdPw()
,source:=[]
Loop,Parse,clip,`n
{
	i:=RegExMatch(A_LoopField, "is)\b[a-zA-Z\d]{7}\b", match)
	if (match="")
		continue
	chartNo:=match
	if InStr(stas_result, chartNo "`t2")
		continue
	i:=RegExMatch(A_LoopField, "is)\b\d{8}\b", match)
	;~ exam_date:="20200101"
	if (match="")
		continue
	exam_date:=match
	
	;~ if Mod(A_Index,10)!=0 {
		;~ continue
	;~ }
	
	;~ goto test
	processLimit()
	run % Commands(fileName ".exe", chartNo, exam_date, sid)
	Sleep 300
	
	if Mod(A_Index,10)=0 {
		processLimit("", 1)
		;~ Sleep 5000
		;~ ImpaxContextServer_RemoveAll()
	}
	
	;~ ExitApp
}
;~ Sleep 5000
;~ ImpaxContextServer_RemoveAll()
ExitApp
return

main2:
chartNo=%1%
exam_date=%2%
sid=%3%
;~ MsgBox % chartNo "`n" sid

while StrLen(chartNo)<7
	chartNo:="0" chartNo
test:
RisReport2Yr:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))
;~ PacsHx:=getPacsHxByPortal(sid, chartNo)
;~ MsgBox % exploreObj(PacsHx)

;~ for k,v in PacsHx {
	;~ if (thisExamName~="i)biopsy|guide|localiza"){
		;~ bx_date:=v.ExamDate
		;~ break
	;~ }

;~ }
;~ if bx_date=
	;~ bx_date:=exam_date

for k,v in RisReport2Yr {
	;~ if (v.innerText~="i)coronary|cardiovascular|EPS"){
	;~ MsgBox % v.innerText
	;~ ToolTip % thisExamName "," v.ExamDate
	thisExamDate := SubStr(v[1][3],1,4) SubStr(v[1][3],6,2) SubStr(v[1][3],9,2)
	thisExamName:=v[1][1]
	if (thisExamDate==exam_date) && ((thisExamName~="CT" && thisExamName~="i)lung|chest|thora")) {
	;~ if (v.ExamDate<bx_date) && SubStr(v.ExamDate,1,4)="2020" && ((thisExamName~="is)Requesting.+CT") || (thisExamName~="CT" && thisExamName~="i)lung|chest|thora")) {
	;~ if (v.ExamDate==exam_date) && ((thisExamName~="i)biopsy|guide") || (thisExamName~="i)\bCT\b")) && !(thisExamName~="RFA"){
		jsonpath:= "E:\scsnake\2020 lung ca\reports\" chartNo ".json"
		jsonObj:=[]
		if FileExist(jsonpath){
			fileread,jsonstr,% jsonpath
			try
				jsonObj:=jxon_load(jsonstr)
		}
		thisReport:=[]
		thisReport.Type:="RAD"
		thisReport.ExamDate :=thisExamDate
		thisReport.ExamName := thisExamName
		thisReport.ReportVS:= v[1][2]
		thisReport.Report:=v[2]
		thisReport.Impression:=v[3]
		jsonObj.push(thisReport)
		if !jsonObj.haskey("ChartNo")
			jsonObj.ChartNo:=chartNo
		FileDelete,% jsonPath
		FileAppend,% jxon_dump(jsonObj),% jsonpath,utf-8-Raw
		;~ ImpaxContextServer_Add( v.AccNo)
		;~ ,ImpaxContextServer_Show( v.AccNo)
		opened:=true
		;~ Sleep 300
		
		break
	}
}
;~ Sleep 5000
;~ ImpaxContextServer_RemoveAll()
if !opened
{
	jsonpath:= "E:\scsnake\2020 lung ca\reports\" chartNo ".json"
	jsonObj:=[]
	if FileExist(jsonpath){
		fileread,jsonstr,% jsonpath
		try
			jsonObj:=jxon_load(jsonstr)
	}
			if !jsonObj.haskey("ChartNo")
			jsonObj.ChartNo:=chartNo
		FileDelete,% jsonPath
		FileAppend,% jxon_dump(jsonObj),% jsonpath,utf-8-Raw
}
ExitApp
return

;~ esc::ExitApp