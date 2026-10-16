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
;~ #notrayicon


;~ sleep 3000
;~ send ^p

;~ exitapp


#include <portalLib>

askForPortalIdPw()

gui,font,s10,Verdana
gui,add,edit,% "w" a_screenwidth/2 " h" a_screenwidth/6 " vchartNos",% "病歷號以逗點分隔"
gui,add,button,ggo,GO!
gui,show,autosize,健保醫材申請
return

go:
if !checksid(sid)
	sid:=login(loginId,loginPw)
gui,submit
next:=0
loop,parse,chartNos,`,
{
	ind:=a_index
	loop
		sleep 500
	until ((next) || (ind=1))
	;~ msgbox % ((next) || (a_index=1))
	next:=0
	if ! regexmatch(a_loopfield,"\w{6}\d",match)
		continue
	pt:=patientBasicInfo(chartNo:=match,sid)
	winactivate,健保事前 ahk_exe WINWORD.EXE
	winwaitactive,健保事前 ahk_exe WINWORD.EXE,,5
	if errorlevel
		goto error
	;~ send {tab}
	;~ sleep 100
	;~ send +{tab}
	;~ sleep 100
	clipboard=
	clipboard:=a_year "/" a_mm "/" a_dd
	clipwait,1
	send ^v{tab}
	sleep 500
	
	clipboard=
	clipboard:=chartNo
	clipwait,1
	send ^v{tab}
	sleep 500
	loop 4 {
		send {tab}
		sleep 500
	}
	
	
	clipboard=
	clipboard:=pt.name
	clipwait,1
	send ^v{tab}
	sleep 500
	
	clipboard=
	clipboard:=pt.birthYear "/" pt.birthMonth "/" pt.birthDay
	clipwait,1
	send ^v{tab}
	sleep 500
	loop 2 {
		send {tab}
		sleep 500
	}
	
	clipboard=
	clipboard:=pt.personId
	clipwait,1
	send ^v{tab}
	sleep 500
	
	;~ send ^p
	;~ sleep 2000
	;~ send {esc}
	
	;~ pass=1
	;~ gosub #s
	;~ pass=0
	;~ sleep 500
	url:="http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid "&PatClass=I&WardCode=12PW&ChartNo=" chartNo "&HospitalCode=T0&Seed=" A_now "&IntervalDay=-9"
	if pwb:=IEGet2("報告查詢次頁")
		pwb.navigate(url)
	else
		run % "iexplore.exe " url
	
	
}
gui,show,autosize
return




#ifwinactive,ahk_exe WINWORD.EXE
#right::
next:=1
return

#s::
if (!pass) {
	if !regexmatch(clipboard,"\w{6}\d",match) {
		temp:=clipboardall
		clipboard:=""
		send ^c
		clipwait,1
		cliptemp:=clipboard
		clipboard:=temp
		if !regexmatch(cliptemp,"\w{6}\d",match){
			msgbox % "Please copy a chart number !"
			return
		}
		chartNo:=match
	}

	if !checksid(sid)
		sid:=login(loginId,loginPw)
	pt:=patientBasicInfo(chartNo?chartNo:(chartNo:=match),sid)		
}
send {f12}
winwait,ahk_class bosa_sdm_msword,,5
if errorlevel
	goto error
sleep 500
controlgettext,filename,RichEdit20W2,ahk_class bosa_sdm_msword
newfilename:=RegExReplace(filename,"is)\d{4}(\W)?\d{2}(\W)?\d{2}(\W).+?(\W)\w{6}\d",a_year "$1" a_mm "$2" a_dd "$3" (pt.name) "$4" chartNo)
;~ msgbox % newfilename
controlsettext,RichEdit20W2,% newfilename,ahk_class bosa_sdm_msword
sleep 500
loop {
	controlgettext,filename,RichEdit20W2,ahk_class bosa_sdm_msword
	if (trim(fileName)!=trim(newFileName)) && a_index<100
		controlsettext,RichEdit20W2,% newfilename,ahk_class bosa_sdm_msword
	else 
		break
	
	sleep 200
}
winactivate,ahk_class bosa_sdm_msword
sleep 500
winwaitactive,ahk_class bosa_sdm_msword,,5
controlsend,RichEdit20W2,{Enter},ahk_class bosa_sdm_msword
return
#ifwinactive

error:
msgbox Error!
return

guiclose:
;~ esc::
~!q::
exitapp
return

;~ ~esc::
;~ Pause
;~ return
