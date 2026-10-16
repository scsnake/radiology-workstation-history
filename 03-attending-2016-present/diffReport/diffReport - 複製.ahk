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

#include <RisImpax>
#include <IEget>
#include <Acc>
#include <.NetGetControl>


;~ if !fileexist(js:="diff_match_patch.js") {
	;~ Msgbox % "File " js " not exist!"
	;~ exitapp
;~ }

;~ fileread,diffJs,% js

if (RisState:=risopened())[1]!=2 {
	Msgbox % "請先登入RIS！"
	exitapp
}

;~ gui,+lastfound
;~ DllCall( "RegisterShellHookWindow", UInt,winexist() )
;~ MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
;~ OnMessage( MsgNum, "ShellMessage" )

;~ t:=a_tickcount
chkAutoImage:=acc_objectfromwindow(getNetControl2(RisState[2],"自動開啟影像","chkAutoImage","自動開啟影像","WindowsForms10.BUTTON.app","","","",0)[1])


;~ msgbox % a_tickcount-t "," chkAutoImage
;~ exitapp

if((chkAutoImageState:=chkAutoImage.accState)=1______){
	chkAutoImage.accDoDefaultAction()
	if typeReport:=acc_objectfromwindow(getNetControl2(RisState[2],"報告撰打作業","B_ACTIVE","報告撰打作業","WindowsForms10.BUTTON.app","","","",0)[1]) {
		tooltip,請先關閉「報告撰打作業」再開啟，以關閉「自動開啟影像」。
		settimer,tooltip,-10000
		typeReport.accDoDefaultAction()
		sleep 200
		for k,v in RisControls:=getControls(RisState[2])
			if v.hwnd=acc_windowfromobject(typeReport) {
				acc_objectfromwindow(RisControls[k+1].hwnd).accDoDefaultAction()
				break
			}

	}
}else{
	typeReport:=acc_objectfromwindow(getNetControl2(RisState[2],"報告撰打作業","B_ACTIVE","報告撰打作業","WindowsForms10.BUTTON.app","","","",0)[1])
}
gosub detectNewPatient
settimer,routine,500

return

;~ ShellMessage( wParam,lParam ) 
;~ {
	;~ global RisState
	if (lParam=RisState[2])
		tooltip,% wparam
	;~ if (lParam=RisState[2] && (wParam=4 || wParam=3 || wParam=32772) && id:=winactive("RIS Report Compare ahk_class IEFrame")){
		;~ winactivate,ahk_id %id%
		;~ return false
	;~ }
;~ }
		

;~ #ifwinactive,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe
;~ lbutton::
;~ if(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500){
	;~ settimer,waitNew,-1
;~ }else{
	;~ mousegetpos,x,y,win,con,3
	;~ if instr(controlgettext(con),"上筆") || instr(controlgettext(con),"下筆") {
		;~ settimer,waitNew,-1
	;~ }
;~ }
;~ send {lbutton}
;~ return

;~ F11::
;~ settimer,waitNew,-1
;~ send {f11}
;~ return
;~ F12::
;~ settimer,waitNew,-1
;~ send {f12}
;~ return
;~ #IfWinActive

waitNew:
loop
	sleep 500
until getRisSheetNo(RisState[2])!=sheetNo || a_index=20
gosub detectNewPatient
return


routine:
IfWinExist,ahk_class #32770,要停止執行這個指令碼嗎
	controlclick,Button2,ahk_class #32770,要停止執行這個指令碼嗎
if (RisState:=risopened())[1]!=2 {
	return
}
if (sheetNo:=getRisSheetNo(RisState[2]))=priorSheetNo
	return
else {
	gosub detectNewPatient
	priorSheetNo:=sheetNo
}
	
return

detectNewPatient:
t:=a_tickcount
if (!checkRis(RisState) || !RisReport[1,1])
	RisReport:=getRisReports(RisState[2])
examText:=getTextByHwnd(RisReport[1,1])
chartNo:=getChartNo(RisState[2])
;~ sheetNo:=getRisSheetNo(RisState[2])

if (priorExamText=examText && priorChartNo=chartNo)
	return
priorExamText:=examText,priorChartNo:=chartNo 
gosub clickReportHistory
return

tooltip:
ToolTip
return


clickReportHistory:

typeReport.accDoDefaultAction()
RisCheck:=checkRis(RisState)
;~ tabQuery:=getNetControl(RisState[2],"tabQuery","","WindowsForms")
if (!RisCheck || !tabQuery)
	tabQuery:=getNetControl2(RisState[2],"","tabQuery","","WindowsForms10.SysTabControl32","","","",0)[1]
SendMessage, 0x1330, 3,, ,ahk_id %tabQuery%  ; 0x1330 is TCM_SETCURFOCUS.
Sleep 0  ; This line and the next are necessary only for certain tab controls.
SendMessage, 0x130C, 3,, ,ahk_id %tabQuery%  ; 0x130C is TCM_SETCURSEL.

if (!RisCheck || !dgReportLogHwnd)
	dgReportLogHwnd:=getNetControl2(RisState[2],"","dgReportLog","","WindowsForms10.Window.8.app","","","",0)[1]
if (!dgReportLogHwnd)
	return 
dgReportLog:=acc_objectfromwindow(dgReportLogHwnd)
reportVS:=""
for k1,v1 in acc_children(dgReportLog) {
	if k1=1
		continue
	if !reportVS {
		reportVS:=acc_children(v1)[4].accValue
	}else if(reportVS!=acc_children(v1)[4].accValue){
		v1.accSelect(ComObj(3,3),0)
		break
	}
}
sleep 200

if (!RisCheck || !logExam)
	logExam:=getNetControl2(RisState[2],"","LOG_EXAM_TEXT","","WindowsForms10.EDIT.app","","","",0)[1]
logExamText:=getTextByHwnd(logExam)
if(priorLogExamText=logExamText)
	return
priorLogExamText:=logExamText
gosub compare
return

compare:
if !pwb.document.body.innerHTML
	gosub ie
;~ examText:=getTextByHwnd(getNetControl(RisState[2],"EXAM","","WindowsForms"))
if (!checkRis(RisState) || !RisReport[1,2])
	RisReport:=getRisReportsHwnd(RisState[2])
impressionText:=getTextByHwnd(RisReport[1,2])



if (!RisCheck || !logImpHwnd)
	logImpHwnd:=getNetControl2(RisState[2],"","LOG_IMPRESSION_TEXT","","WindowsForms10.EDIT.app","","","",0)[1]
logImpressionText:=getTextByHwnd(logImpHwnd)
;~ reports:=getRisReports(RisId[2])
;~ finding1:=getTextByHwnd(reports[1,1])
;~ finding2:=getTextByHwnd(reports[2,1])
;~ gosub ie
;~ js1:="<script type=""text/javascript"">" diffJs "</script>"
;~ js2=
;~ (
;~ <script type="text/javascript">
;~ aaa=new diff_match_patch;
;~ alert(aaa.diff_prettyHtml(aaa.diff_main('text1', 'text2')));
;~ </script>
;~ )

pwb.document.getElementById("chartNo").innerText:=chartNo
pwb.document.getElementById("name").innerText:=getTextByHwnd(getNetControl2(RisState[2],"","FID_TEXT","姓名","WindowsForms10.EDIT.app","","","",0)[1])
pwb.document.getElementById("age").innerText:=getTextByHwnd(getNetControl2(RisState[2],"","FID_TEXT","年齡","WindowsForms10.EDIT.app","","","",0)[1])
pwb.document.getElementById("gender").innerText:=getTextByHwnd(getNetControl2(RisState[2],"","FID_TEXT","性別","WindowsForms10.EDIT.app","","","",0)[1])
pwb.document.getElementById("orderDep").innerText:=getTextByHwnd(getNetControl2(RisState[2],"","FID_TEXT","開單科別","WindowsForms10.EDIT.app","","","",0)[1])


pwb.document.getElementById("text1").innerText:=examText
pwb.document.getElementById("text2").innerText:=logExamText
pwb.document.getElementById("text3").innerText:=impressionText
pwb.document.getElementById("text4").innerText:=logImpressionText
;~ pwb.Navigate("javascript:" diffJs )
pwb.Navigate("javascript:function $(a){return document.getElementById(a);}a=new diff_match_patch();c=new diff_match_patch();b=a.diff_main($('text2').innerText,$('text1').innerText);d=c.diff_main($('text4').innerText,$('text3').innerText);a.diff_cleanupSemantic(b);c.diff_cleanupSemantic(d);$('diff').innerHTML=a.diff_prettyHtml(b)+'<br/><hr/><br/>'+c.diff_prettyHtml(d);void 0;")
winactivate,ahk_id %ieId%
return

#ifwinactive,RIS Report Compare ahk_class IEFrame
F11::
;~ settimer,waitNew,-1
if (!checkRis(RisState) || !RunForward)
	RunForward:=getNetControl(RisState[2],"cmdRunFoword","","WindowsForms")
acc_objectfromwindow(RunForward).accDoDefaultAction()
return
F12::
;~ settimer,waitNew,-1
if (!checkRis(RisState) || !RunNext)
	RunNext:=getNetControl(RisState[2],"cmdRunNext","","WindowsForms")
acc_objectfromwindow(RunNext).accDoDefaultAction()
return
F5::
if (!checkRis(RisState) || !RunNext)
	openImpax:=getNetControl(RisState[2],"cmdDs3000","","WindowsForms")
acc_objectfromwindow(openImpax).accDoDefaultAction()
return
esc::
pwb.quit()
winactivate,% "ahk_id " RisState[2]
return
#ifwinactive


ie:
run % "iexplore.exe " a_scriptdir "\diffReport.html"
Loop
	sleep 200
until ieId:=winexist("RIS Report Compare ahk_class IEFrame")
pwb:=WBGet("ahk_id " ieId)
Loop
	sleep 200
until !pwb.busy
pwb.visible:=true
return

embedIE:
;;;; embed IE
COM_AtlAxWinInit()
Gui, +LastFound +Resize
;pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),top,left,width,height, "Shell.Explorer") )  ;left these here just for reference of the parameters
pwb := COM_AtlAxGetControl(COM_AtlAxCreateContainer(WinExist(),0,0,a_screenwidth,a_screenheight-100, "Shell.Explorer") )
;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
pipa := COM_QueryInterface(pwb, IOleInPlaceActiveObject_Interface)
;;;;

pwb.visible:=true
gui,show
return

onexit:
pwb.quit()
if(chkAutoImageState=1______)
	chkAutoImage.accDoDefaultAction()

;~ Acc_UnhookWinEvent(hHook)

SendMessage, 0x1330, 0,, ,ahk_id %tabQuery%  ; 0x1330 is TCM_SETCURFOCUS.
Sleep 0  ; This line and the next are necessary only for certain tab controls.
SendMessage, 0x130C, 0,, ,ahk_id %tabQuery%  ; 0x130C is TCM_SETCURSEL.

ExitApp
return

~!q::
exitapp
return
