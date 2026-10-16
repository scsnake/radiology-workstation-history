#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
CoordMode,caret,screen
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
comobjerror(false)
onexit,onexit
#NoTrayIcon

#include <Acc>
#include <risimpax>
#include <winvisible>
#include <Class_CTLCOLORS>
#include <Class_RichEdit>
#include <prettyReport>
#include <WM_COPYDATA>
#include <Edit>
;~ #include <SCI>

RisState:=RisOpened()


if (RisState[1]=0) {
	ToolTip % "Remote Mode !"
	SetTimer, ToolTip, -2000
	remoteMode:=true
}else
	cAccNo:=getRisAccNo(RisState[2])
	,RisReports:=getRisReports(RisState[2])


thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
	,RISImpaxRegister([  {app: "Ris", type: "State", hwnd: thisHwnd, msg: {msg: 0x8000}}
		, {app: "Ris", type: "AccNo", hwnd: thisHwnd, msg: {msg: 0x1122}}
		, {app: "Ris", type: "OldReport", hwnd: thisHwnd, msg: {msg: 0x1123}} ])
	,OnMessage(0x8000, "RisStateChange")
	,OnMessage(0x1122, "RisAccNoChange")
	,OnMessage(0x1123, "RisOldReportChange")

gui,main:Default
gui,+hwndguiHwnd
WinSetTitle,ahk_id %guihwnd%,,mirrorRIS_main

if (remoteMode)
	OnMessage(0x4A, "On_WM_COPYDATA")


gosub gui
;~ SetTimer,routine
;~ gosub simpleRisNoUpdate
;~ SetTimer,simpleRisNoUpdate,5000

return

ToolTip:
ToolTip
return 

On_WM_COPYDATA(wParam, lParam, msg, hwnd){
	global editHwndArr
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	try
		d:=jxon_load(lpData)
	catch 
		return
	
	for k,v in d {
		if editHwndArr.hasKey(k) 
			Edit_SetText(editHwndArr[k], v)
		else if (k="ptName")
			Edit_SetText(editHwndArr.editPatient, d.ptName " " d.ptAge " " d.ptGender)
		else if (k="ptType")
			Edit_SetText(editHwndArr.editOrderFrom, (d.ptType="O"?"OPD":d.ptType="E"?"ER":d.ptWard) " " d.ptDept " " d.orderDr)
	}
	
}

RisStateChange(){
	global
	RisState:=RisOpened()
}
RisAccNoChange(){
	global
	cAccNo:=getRisAccNo(RisState[2])
	,RisReports:=getRisReports(RisState[2])
	gosub update
}
RisOldReportChange(){
	gosub ReloadOldRad
}


gui:
gui,+hwndguiHwnd 
gui,Color,black
gui,Font,s14 cwhite,Verdana

editHwndArr:=[]
gui,Add,Edit,% "hwndeditAccNo w200",
editHwndArr["EditAccNo"]:=EditAccNo

gui,Add,Edit,% "hwndeditChartNo w150 yp x+20",
editHwndArr["editChartNo"]:=editChartNo

gui,Add,Edit,% "hwndeditDate w220 yp x+20",
editHwndArr["editDate"]:=editDate

gui,Add,Edit,% "hwndeditPatient w160 yp x+20",
editHwndArr["editPatient"]:=editPatient

gui,Add,Edit,% "hwndeditStatus w120 yp x+20",
editHwndArr["editStatus"]:=editStatus

gui,Add,Edit,% "hwndeditOrderFrom w200 yp x+20",
editHwndArr["editOrderFrom"]:=editOrderFrom

gui,Font,s12 cwhite,Verdana
RE_hx:=new RichEdit("1","y+20 xs w" A_ScreenWidth-30 " h500")
,RE_hx.WordWrap(1)
,RE_hx.ShowScrollBar(0,false)
,RE_hx.SetBkgndColor("Black")
,RE_hx.SetDefaultFont({"Name": "Verdana", "Size": 14, "Color": "White"})
,RE_hx.SetParaSpacing({"After": 2})

;~ sci_hx := new scintilla(guihwnd,1,1,1,1)
;~ ,SR_hx:=sciSettings(sci_hx, false)

gui,Font,s14 cwhite,Verdana
gui,Add,Edit,% "hwndeditExams w400 y+20 xs h200 section",
editHwndArr["editExams"]:=editExams

gui,Add,ListView,% "hwndLVOldExams w400 y+20 h600 gLVclick AltSubmit BackgroundBlack cWhite", % "Date|VS|Exam"
LV_ModifyCol(1, 100)
,LV_ModifyCol(2, 100)

,RE_Exam:=new RichEdit("1","w750 x+20 ys h600")
,RE_Exam.WordWrap(1)
,RE_Exam.ShowScrollBar(0,false)
,RE_Exam.SetBkgndColor("Black")
,RE_Exam.SetDefaultFont({"Name": "Verdana", "Size": 14, "Color": "White"})
,RE_Exam.SetParaSpacing({"After": 2})

,RE_Imp:=new RichEdit("1","w750 xp y+20 h200")
,RE_Imp.WordWrap(1)
,RE_Imp.ShowScrollBar(0,false)
,RE_Imp.SetBkgndColor("Black")
,RE_Imp.SetDefaultFont({"Name": "Verdana", "Size": 14, "Color": "White"})
,RE_Imp.SetParaSpacing({"After": 2})

gui,Add,Button,% "x700 y+20 gactionButton w100",% "上筆"
gui,Add,Button,% "x+20 yp gactionButton w100",% "下筆"
gui,Add,Button,% "x+20 yp gactionButton w100",% "暫存"
gui,Add,Button,% "x+20 yp gactionButton w100",% "發送"

for k,editHwnd in editHwndArr
	CtlColors.Change(editHwnd, "000000", "FFFFFF")

SysGet,workArea,MonitorWorkArea ,1
gui,Show,% "x0 y0 w" A_ScreenWidth-5 " h" (workAreaBottom-workAreaTop-20),mirror RIS
return

ColorRichEdit:
guicontrol,-Redraw,% RE_exam.hwnd
guicontrol,-Redraw,% RE_Imp.hwnd
colorRadReport(RE_exam,1,1,0)
colorRadReport(RE_Imp,1,1,0)
guicontrol,+Redraw,% RE_exam.hwnd
guicontrol,+Redraw,% RE_Imp.hwnd
return

actionButton:

return


update:


Edit_SetText(EditAccNo, cAccNo)
,Edit_SetText(editChartNo, getRisChartNo(RisState[2]))

,Edit_SetText(editDate, ControlGetText(getNetControl2(RisState[2],"","EXAM_DATE_TIME","","WindowsForms10.EDIT")[1]))

,ptName:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","姓名","WindowsForms10.EDIT")[1])
,ptGender:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","性別","WindowsForms10.EDIT")[1])
,ptAge:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","年齡","WindowsForms10.EDIT")[1])
,Edit_SetText(editPatient, ptName " " ptAge " " ptGender)

,Edit_SetText(editStatus, ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","狀態","WindowsForms10.EDIT")[1]))

,ptType:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","診別","WindowsForms10.EDIT")[1])
,ptWard:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","病房","WindowsForms10.EDIT")[1])
,ptDept:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","開單科別","WindowsForms10.EDIT")[1])
,orderDr:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","開單醫師姓名","WindowsForms10.EDIT")[1])
,Edit_SetText(editOrderFrom, (ptType="O"?"OPD":ptType="E"?"ER":ptWard) " " ptDept " " orderDr)

guicontrol,-Redraw,% RE_hx.hwnd
RE_hx.SetText(txt:=ControlGetText(getNetControl2(RisState[2],"","txtALL","","WindowsForms10.EDIT")[1]))
,RE_hx.setSel(0,strlen(txt))
,RE_hx.SetFont({"Name": "Verdana", "Size": 12, "Color": "White"})
,RE_hx.setSel(-1,-1)
guicontrol,+Redraw,% RE_hx.hwnd

exam:=""
for k,v in parseRisExamItems(getRisExamItems(RisState[2]))[2]
	exam.=trim(v) "`n"
Edit_SetText(editExams, SubStr(exam, 1, -1))

SetTimer,loadRadHx,-1
return

LVclick:
if(A_GuiEvent="Normal"){
	RadHxAcc[A_EventInfo+1].accSelect(ComObj(3,3),0)
	Sleep 200
	SetTimer,ReloadOldRad,-1
}
return

ReloadOldRad:
guicontrol,-Redraw,% RE_exam.hwnd
RE_exam.SetText(txt:=ControlGetText(getNetControl2(RisState[2],"","HISTORY_EXAM_TEXT","","WindowsForms10.EDIT")[1]))
,RE_exam.setSel(0,strlen(txt))
,RE_exam.SetFont({"Name": "Verdana", "Size": 12, "Color": "White"})
,RE_exam.setSel(-1,-1)
guicontrol,+Redraw,% RE_exam.hwnd

guicontrol,-Redraw,% RE_Imp.hwnd
RE_Imp.SetText(txt:=ControlGetText(getNetControl2(RisState[2],"","HISTORY_IMPRESSION_TEXT","","WindowsForms10.EDIT")[1]))
,RE_Imp.setSel(0,strlen(txt))
,RE_Imp.SetFont({"Name": "Verdana", "Size": 12, "Color": "White"})
,RE_Imp.setSel(-1,-1)
guicontrol,+Redraw,% RE_Imp.hwnd

SetTimer,ColorRichEdit,-1
return


loadRadHx:
if !RadHxHwnd:=getNetAcc(RisState[2], "dgHisReport", "WindowsForms10.Window", 0, 0)
	return

loadRadHxTh.terminate()
,RadHx:=CriticalObject()
,RadHxAcc:=acc_children(acc_objectfromwindow(RadHxHwnd))
,RadHxTotal:=0
,loadRadHxTh:=ahkmini("
(
#persistent
#notrayicon
#include <ACC>
#include <RisImpax>
RadHx:=CriticalObject(" (&RadHx) ")
,Alias(RadHxTotal," getvar(RadHxTotal) ")
,RadHxAcc:=acc_objectfromwindow(" RadHxHwnd ")
,parseDataGrid(acc_children(RadHxAcc),RadHx,1)
,RadHxTotal:=RadHx.maxIndex()
exitapp
)")

,RadHxLoadingInd:=1
Loop {
	if RadHxTotal && RadHxLoadingInd>RadHxTotal
		break
	
	if !IsObject(newRow:=RadHx[RadHxLoadingInd]){
		Sleep 500
		continue
	}
	
	if(RadHxLoadingInd=1){
		for m,n in newRow {
			if (n="報告醫師"){
				examVSCol:=m
			}else if (n="檢查日"){
				examDateCol:=m
			}else if (n="檢查名稱"){
				examNameCol:=m
			}
		
		}
		
	}else{
		LV_Add("", TrimDate(newRow[examDateCol]), (vs:=newRow[examVSCol])?vs:" ", trimExamName(newRow[examNameCol]))
	}
	++RadHxLoadingInd
}
LV_Modify(1,"+Select")
return

TrimDate(date){
	return RegExReplace(date, "^" A_Year "\/", "")
}
trimExamName(examName){
	if RegExMatch(examName, "i)(CT|MRI) (With)?\/?(Without)? Contrast\-([\w ]+)", match)
		return match1 " " (match2&&match3?"±":match1?"+":"-") (InStr(match4,"neck")?"Neck":match4)
	else if RegExMatch(examName, "i)Chest : (PA|AP) View", match)
		return "CXR" (match1="AP"?" (AP)":"")
	else if (examName="Abdomen:KUB")
		return "KUB"
	else
		return examName
}
;~ routine:
if !((RisState:=RisOpened()) && (RisHwnd:=RisState[2])){
	return
}
if !((controlexist(AccNoHwnd) || (AccNoHwnd:=getRisAccNoHwnd(RisHwnd))) && (cAccNo:=ControlGetText(AccNoHwnd))){
	return
}
if (pAccNo=cAccNo){
	return
}

gosub update


routineEnd:
pAccNo:=cAccNo
return

;~ Edit_SetText(hwnd, Text){
	;~ Edit_SetText,,% Text,ahk_id %hwnd%
;~ }


GuiClose:
;~ esc::
#q::
OnExit:
th.terminate()
ExitApp
return