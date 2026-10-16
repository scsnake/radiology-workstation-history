#NoTrayIcon
#Persistent
SetBatchLines,-1
settimer,exit,-120000
SetTimer,routine,1000
DetectHiddenWindows,on
#SingleInstance,Off
#include <portallib>
#include <JXON>
#include <ParseArg>
#include <WM_COPYDATA>

SplitPath,A_ScriptFullPath,,,,fileName 
args:=ParseArg()
;~ MsgBox % exploreobj(args)
;~ for k,v in args
	;~ if !(v~="i)" filename "(.ahk|.exe)"){
		;~ json:=v
		;~ break
	;~ }
json:=args[1]

;~ MsgBox % json

try
	json:=jxon_load(json)
catch
	ExitApp

for k,v in json
	%k%:=v

;~ MsgBox % exploreobj(json)
;~ threadStart:=1
;~ ,threadFinished:=0
;~ ,url:="" url ""
;~ ,AccNo:="" AccNo ""
;~ ,oldAccNo:="" oldAccNo ""
;~ ,oldChartNo:="" oldChartNo ""
;~ ,ChartNo:="" ChartNo ""
;~ ,reportDir:="" reportDir ""
;~ ,picWidth:="" PicWidth ""
;~ ,loginId:="" loginId ""
;~ ,loginPw:="" loginPw ""
;~ ,k:="" k "", i:="" i "", reportListCount:="" reportList.maxIndex() ""
;~ ,Alias(threadPoolCount, " getvar(threadPoolCount) ")


PacsWebLoginNew(oldAccNo, oldChartNo, loginId, loginPw)
	,PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " kk ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth*2,loginId,loginPw,3,100,1, "")
	ExitApp

	outputDict:={study_data:1}
	,outputDict[i-2]:={AccNo: AccNo, ChartNo: chartNo, expected_image_count:[]}
	;~ FileAppend,% a_now ": " i " - " chartNo "," accno,logtem.txt,utf-8
	if (AccNo="" || chartNo=""){
		;~ MsgBox % exploreobj(reportList)
		ExitApp
	}
	
	;~ if(thisStudy[statusCol]="已發報告"){
		;~ ++i
		
		;~ Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_miniPACS"), dwData, jxon_dump(outputDict))
		;~ goto continueLoop
		;~ if(leave)
			;~ exitapp
		;~ continue
	;~ }
	if(!WinExist("WM_COPYDATA_Listener_miniPACS"))
		ToolTip % "Downloading: " i-1 " / " reportListCount-1
	
	;~ msgbox % fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg")
	dict:={}, dictEmpty:=true, downloadNothing:=true
	;~ if !fileexist(reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " 1.jpeg") {
		; tooltip `% "downloading:" AccNo "," chartNo "," reportDir " " loginId loginPw 
		; PacsWebDownloadJpeg(AccNo,chartNo,"",reportDir,PicWidth,loginId,loginPw)
		output:=PacsWebInfoFlatten(PacsWebInfo(output,AccNo,chartNo,loginId,loginPw))
		;~ loadedPicCount[AccNo " " chartNo]:=output.maxindex()
		,max:=output.maxindex()
		
		
		
		for k,v in output {
			while (getJpegCount()>threadPoolLimit)
				sleep % downloadInterval
			if RegExMatch(v.objectUID,"[^\d\.]")
				continue
			dict[AccNo]:=k, dictEmpty:=false
			if fileexist(jpegFile:=reportDir "\" AccNo " " chartNo "\" AccNo " " chartNo " " k ".jpeg") && isValidJpeg(jpegFile)
				continue
			
			if InStr(examName,"Spine") && !(examName~="i)\b(CT|MRI?)\b")
				initThread(v.url, AccNo,chartNo, AccNo,ChartNo, max-k+1, i), downloadNothing:=false
			else
				initThread(v.url, AccNo,chartNo, AccNo,ChartNo, k, i), downloadNothing:=false
			
			;~ PacsWebDownloadJpeg2(v.url,AccNo,chartNo,AccNo " " chartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth,loginId,loginPw)
			;~ if !winexist("ahk_exe PacsIE.exe") {
				;~ traytip,% "Downloaded: " k "/" max " images (" (i-1) "/" (reportListCount-1) " studies)"
				;~ settimer,traytip,-2000
			;~ }
			;~ sleep 500
		}
		
		
	if !dictEmpty
		outputDict[i-2].expected_image_count.push(dict)
	else
		outputDict[i-2].expected_image_count[AccNo]:=0
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
				if relatedExam(v.ExamName,examName) && (regexreplace(v.ExamDate,"\D","")<=substr(regexreplace(thisStudy.getCell("ExamDate"),"\D",""),1,8)) && (strlen(oldAccNo:=v.AccessNo)>=11) {  ;may catch exam on the same day
					
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
							while (getJpegCount()>threadPoolLimit)
								sleep % downloadInterval
							dict[oldAccNo]:=q, dictEmpty:=false
							if fileexist(jpegFile:=reportDir "\" accno " " chartNo "\" oldAccNo " " oldChartNo " " q ".jpeg") && isValidJpeg(jpegFile)
								continue
							if InStr(examName,"Spine") && !(examName~="i)\b(CT|MRI?)\b")
								initThread(r.url, oldAccNo, oldChartNo, AccNo, chartNo, max-q+1, i), downloadNothing:=false
							else
								initThread(r.url, oldAccNo, oldChartNo, AccNo, chartNo, q, i), downloadNothing:=false
							;~ initThread(r.url, oldAccNo, oldChartNo, AccNo, chartNo, q, i)
							
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
		
	;~ MsgBox % exploreobj(outputDict	)
	Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_miniPACS"), dwData, jxon_dump(outputDict))


ExitApp
return

getJpegCount(){
	i:=0
	for k,v in processlist()
		if (v="getJpeg.exe")
			i++
	return i
}

initThread(url,oldAccNo,oldChartNo, AccNo,chartNo, k, i){
		global reportdir, picWidth, loginId, loginPw
	
	PacsWebLoginNew(oldAccNo, oldChartNo, loginId, loginPw)
	,PacsWebDownloadJpeg2(url,oldAccNo,oldChartNo,oldAccNo " " oldChartNo " " k ".jpeg",reportdir "\" AccNo " " chartNo,PicWidth*2,loginId,loginPw,3,100,1, "")
}

downloadCallback(){
	global
	if !winexist("ahk_exe PacsIE.exe") && !WinExist("miniPACS_bridge_main ahk_class AutoHotkeyGUI") {
		ToolTip,% "Downloaded: " k "/" max " images (" (i-1) "/" (reportListCount-1) " studies)"
	}
	;~ threadPoolCount--
	exitapp
}
exit:
;~ threadPoolCount--
exitapp


relatedExam(exam,thisExam){
	if (exam=thisExam)
		return 1
	else if regexmatch(exam,"is)chest\b.+?view") && regexmatch(thisExam,"is)chest\b.+?view")
		return 1
	
	return 0
}


routine:
if !WinExist("ahk_exe getAllJpeg.exe"){
	SetTimer,routine,Off
	SetTimer,exit,-10000
}
return
