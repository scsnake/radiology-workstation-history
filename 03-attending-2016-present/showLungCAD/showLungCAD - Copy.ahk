﻿#include <hash>
#include <OnScreenDisplay>
#include <portallib>
#include <risimpax>
#include <GetActiveBrowserURL>
;~ #include <Acc>
;~ #include <CheckUpdate>
#include <NotifyCross>
#include <WM_COPYDATA>
#include <JXON>
#include <monitorInfo>
;~ #include <ProcessList>
#include <WinVisible>
#include <Socket>
ComObjError(false)
OnExit,OnExit
setbatchlines,-1
SendLevel,1
CoordMode,mouse,Screen
DetectHiddenWindows,on
SetTitleMatchMode,2
#SingleInstance,force
#InstallKeybdHook
#InstallMouseHook
try
	Menu, Tray, Icon,% A_ScriptDir "\showLungCAD.ico"

gosub sethotkey
;~ settimer,errorHandle,1000
if !CaptureTextPath()
	NoCaptureText:=true

if !WinExist("WM_COPYDATA_Listener_RegionGrowMorph") && OpenRegionGrow
	try {
		run % a_scriptdir "\RegionGrowMorph.exe" 
		winwait,ahk_class ConsoleWindowClass ahk_exe RegionGrowMorph.exe,,30
	}
;~ WinMinimize,ahk_class ConsoleWindowClass ahk_exe RegionGrowMorph.exe		
;~ SetTimerF("scs_sync", -1)
;~ goto test
;~ gosub setSocket

;~ gui,+ToolWindow +hwndinfo_hwnd +lastFound
;~ WinSetTitle,,,__nodule_info

;~ SplitPath,A_ScriptFullPath,,,,fileNoExt
;~ args:=[]
;~ Loop %0%
	;~ if !(%a_index%~="i)" fileNoExt)
		;~ args.push(%a_index%)

;~ if args.maxindex() {
	;~ mainHwnd:=args[1]
	;~ ,cornerHwnd:=args[2]
	;~ ,corner:=args[3]
	;~ goto grabCorner
;~ }else{
	;~ i:=0
	;~ for k,v in ProcessList() 
		;~ if (v.name = A_ScriptName)
			;~ i++
	;~ if i>1
		;~ ExitApp
;~ }

;~ feedbackIp:="localhost"
;~ feedbackIp:="intranet.hospital.example"
feedbackPort:=10007
,pwbs:=[]
,monitorInfo:=monitorInfo()
,OnMessage(0x4A, "On_WM_COPYDATA")

gui,+hwndguihwnd
WinSetTitle,ahk_id %guihwnd%,,showLungCAD_main

OnMessage(0x2001, "next")
,OnMessage(0x2002, "prior")
,OnMessage(0x8100, "search")
,cross:=new NotifyCross("white")
,clearReadUrl:="http://10.0.0.100:9104/?accession="




;~ Sleep 1000

;~ chartNo:="6______"
;~ gosub sendChartNo

return

errorHandle:
ifwinexist,ahk_class #32770,hotkeys have been received in the last
	ControlClick,Button1,ahk_class #32770,hotkeys have been received in the last
return

grabCorner:
info:=getImpaxFrameInfo(cornerHwnd, corner)
,info.CornerInfo:=1
,Send_WM_COPYDATA(mainHwnd, 19, jxon_dump(info))
return


On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 19) ; CMD_CURRENTPOSITION
	{
		try
			j:=JXON_load(str)
		catch
			return
		
		;~ if j.haskey("CornerInfo")
		
		SetTimerF("ParseInfo", -1, [j])
		
	}
}

ParseInfo(j, tried=0){
	global monitorInfo, info, which, frames, NoCaptureText
	
	if (j.area=0)
		return
	if (!NoCaptureText && !info.FOV){
		if (tried<3){
			ToolTip % "Waiting for OCR..."
			SetTimerF("ParseInfo", -500, [j, tried+1])
		}
		return
	}
	;~ which:=whichMonitor(j.Center_X, j.Center_Y, monitorInfo)
	;~ ,frames:=getViewFrame()
	ToolTip 
	if NoCaptureText && !info.FOV && !info.StudyDescription && !info.thickness && !info.WL && !info.WW && !info.z
		MsgBox,,,% "Please make IMPAX show corner informations!",5
	
	settimer,ReportGUI,-1
	SetTimerF("setReportGUI", -500, [info, j, frames[which.1-1,1,1]])
}

noduleLine(){
	global reporthwnd
	GuiControlGet,d1,%reportHwnd%:,rMinD
	GuiControlGet,d2,%reportHwnd%:,rMaxD
	GuiControlGet,lobe,%reportHwnd%:,selectLobe
	GuiControlGet,SE,%reportHwnd%:,rSE
	GuiControlGet,IM,%reportHwnd%:,rIM
	str:="A "
	, str.=d1=""||d2=""?d1 d2 "mm":(d2>=6||(d1=d2)?d2 "mm":d1 "*" d2 "mm (mean " Round(d1/2+d2/2) " mm)")
	, str.=" nodule in the " (lobe?lobe:"[lobe]") ". " (SE&&IM? "(SE" SE " IM" IM ")":"")
	,setReportGUIControl("rText", str)
	return str
}

setReportGUI(info, json, frameHwnd){
	global reporthwnd, ratio_coord_x, ratio_coord_y, rStudyDate, rAccNo, rChartNo
	
	WinGetPos,x,y,w,h,% "ahk_id " frameHwnd
	ratio_coord_x:=h>w?(json.Center_X - x)/w:  (json.Center_X - (x+w/2-h/2))/w
	,ratio_coord_y:=w>h?(json.Center_Y-y)/h: (json.Center_Y-(y+h/2-w/2))/w
	MouseMove,% x,% y,0
	MouseMove,1,1,2,R
	SEIM:=getSEIM()
	MouseMove,% json.Center_X,% json.Center_Y,0
	setReportGUIControl("rMinDp", json.min_diameter)
	,setReportGUIControl("rMaxDp", json.max_diameter)
	,setReportGUIControl("rSE", SEIM.1)
	,setReportGUIControl("rIM", SEIM.2)
	,setReportGUIControl("rLoc", info.Z)
	
	if (info.FOV>0){
		setReportGUIControl("rMinD", d1:=Round(json.min_diameter/w*info.FOV))
		,setReportGUIControl("rMaxD", d2:=Round(json.max_diameter/w*info.FOV))
		
		;~ , str:="A "
		;~ ,str.=d1=""||d2=""?d1 d2 "mm":(d2>=6||(d1=d2&&d2>0)?d2 "mm":d1 "*" d2 "mm (mean " Round(d1/2+d2/2) " mm)")
		;~ ,str.=" nodule in the [lobe]. (SE" SEIM.1 " IM" SEIM.2 ")"
		,str:=noduleLine()
		;~ ,setReportGUIControl("rText", str)
	}
	
	impaxHwnd:=ImpaxOpened()[2,1]
	,rStudyDate:=getImpaxExamDate(impaxHwnd)[1]
	,rAccNo:=getImpaxAccNo(impaxHwnd)
	,rChartNo:=getImpaxChartNo(impaxHwnd)
	
	guicontrol,%reporthwnd%:Move,rFP,w0 h0 x-1 y-1
	gui,%reporthwnd%:show,% "x" json.Center_X-30 " y" json.Center_Y+100 " noactivate",Nodule info #New
	settimer,HideGUIifInactive,-5000
}

setReportGUIControl(var, value){
	global reporthwnd
	guicontrol,%reporthwnd%:,% var,% value
}

DisplayNoduleInfo(noduleInd, isSameSeries){
	global reporthwnd, jsonData, rNoduleInd, coord, noduleListHwnd, ShowNoduleList, lastX, lastY, thisInd, EBMmode, ebm_show_x, ebm_show_y, noduleButtonText
	gosub ReportGUI
	
	thisInd:=noduleInd
	,nodule:=jsonData.Nodules[rNoduleInd:=noduleInd-1]
	;~ ,str:="A " Round(nodule.Diameter) "mm nodule in the [lobe]. "
	if (isSameSeries){
		setReportGUIControl("rSE", jsonData.SeriesNumber)
		,setReportGUIControl("rIM", nodule.InstanceNumber)
		;~ ,str.="(SE" jsonData.SeriesNumber " IM" nodule.InstanceNumber ")"
	}
	setReportGUIControl("rMinD", Round(nodule.Diameter))
	,setReportGUIControl("rLoc", Round(nodule.SliceLocation))
	;~ ,setReportGUIControl("rText", str)
	,noduleLine()
	if (nodule.hasKey("MalignancyProbability")){
		prb:=nodule.MalignancyProbability
		f:=A_FormatFloat
		SetFormat,FloatFast,0.2
		prb+=0.0
		SetFormat,FloatFast,% f
		,setReportGUIControl("rMaligProb", prb)
		,setReportGUIControl("rProb", prb>0.5?": > 0.5":": < 0.5")
	}
	
	
		
	guicontrol,%reporthwnd%:Move,rFN,w0 h0 x-1 y-1
	guicontrol,%reporthwnd%:,rFNtext,% ""
	if (ebm_show_x!="" && ebm_show_y!="")
		gui,%reporthwnd%:show,% "x" ebm_show_x " y" ebm_show_y " noactivate",Nodule info #%noduleInd%
	else
		gui,%reporthwnd%:show,% "x"coord.1-30 " y" coord.2+100 " noactivate",Nodule info #%noduleInd%
	
	
	for k,v in noduleButtonText {
		guicontrol,%noduleListHwnd%:,noduleButton%k%,% v
	}
	guicontrol,%noduleListHwnd%:,noduleButton%thisInd%,% "[" thisInd "]"
	
	width1:=80
	if (ebm_show_x!="" && ebm_show_y!="")
		gui,%noduleListHwnd%:show,% "x" ebm_show_x-80 " y" ebm_show_y " w" width1 " noactivate",List
	else if ShowNoduleList && lastX && lastY
		gui,%noduleListHwnd%:show,% "x" lastX " y" lastY " w" width1 " noactivate",List
	else
		gui,%noduleListHwnd%:show,% "x" coord.1-120 " y" coord.2+100 " w" width1 " noactivate",List
	settimer,HideGUIifInactive,-5000
}

HideGUIifInactive:
MouseGetPos,,,win
if !WinActive("ahk_id " reporthwnd) && win!=reporthwnd
	WinHide,% "ahk_id " reporthwnd
if !WinActive("ahk_id " noduleListHwnd) && win!=noduleListHwnd && !ShowNoduleList 
	WinHide,% "ahk_id " noduleListHwnd
return

#IfWinActive,Nodule info ahk_class AutoHotkeyGUI
~LButton::
MouseGetPos,,,,con,2
if (con!=TextHwnd)
	return
gosub CopyText
return
#IfWinActive


ReportGUI:
gui,report:new,+hwndReportHwnd +ToolWindow +AlwaysOnTop
gui,Font,s10,Verdana
gui,Color,ececec
;~ winset,TransColor,ececec,ahk_id %reporthwnd%
;~ winset,Trans,200,ahk_id %reporthwnd%
gui,Add,Text,,% "Size:"
gui,Add,Edit,xp+40 yp w40 vrMinD,
gui,Add,Text,xp+50 yp,×
gui,Add,Edit,xp+20 yp w40 vrMaxD,
gui,Add,Text,xp+50 yp,mm
gui,Add,Edit,xp+50 yp w40 vrMinDp,
gui,Add,Text,xp+50 yp vrMulp,×
gui,Add,Edit,xp+20 yp w40 vrMaxDp,
gui,Add,Text,xp+50 yp vrPixel,px

gui,Add,Text,xm,% "  "
gui,Add,Text,xp+20 yp,SE
gui,Add,Edit,xp+20 yp w40 vrSE
gui,Add,Text,xp+50 yp,IM
gui,Add,Edit,xp+20 yp w40 vrIM
gui,Add,ComboBox,xp+100 yp w150 gselectLobe vselectLobe,RUL|RML|RLL|LUL|LLL|lingular LUL

gui,Add,Text,xm,% "  "
gui,Add,Text,xp+20,Loc
gui,Add,Edit,vrLoc xp+40 w60
gui,Add,Text,xp+80,Malig Prob
gui,Add,Edit,xp+80 vrMaligProb w60
gui,Add,Text,xp+80 yp+5 vrProb,% "              "

gui,Add,Edit,xm r2 w400 vrText -VScroll hwndtextHwnd,

gui,Add,button,greportFP xm vrFP,Report FP
;~ gui,Add,Text,x+10 yp+5,: no further info needed
gui,Add,button,greportFN xp yp vrFN,Report FN

gui,Add,Text,x+10 yp+5 vrFNtext,: require at least SE/IM 
gui,Add,button,gundo x250 y+20,Undo last feedback

if !thickSliceMode
	gui,Add,button,gthickSliceMode xm,% "Thick slice mode"
else
	gui,Add,button,gthinSliceMode xm,% "Thin slice mode"
return

thinSliceMode:
thickSliceMode:=0
gosub magicResult
return
thickSliceMode:
thickSliceMode:=1
gosub magicResult
return

Undo:
gosub HideGUI
impaxHwnd:=ImpaxOpened()[2,1]
;~ ,rStudyDate:=getImpaxExamDate(impaxHwnd)[1]
,rAccNo:=getImpaxAccNo(impaxHwnd)
,rChartNo:=getImpaxChartNo(impaxHwnd)

feedback:={Undo: 1}
,feedback["AccessionNumber"]:=rAccNo
,feedback["PatientID"]:=rChartNo
,SetTimerF("MoveMsgbox", 100, ["Undo"])
MsgBox,4,Undo,% "Undo last feedback for " rChartNo "/" rAccNo " ?"
IfMsgBox,Yes
{
	sendFeedback(feedback)
	gosub HideGUI
}
return

MoveMsgbox(title){
	if h:=WinExist(title " ahk_class #32770 ahk_exe showLungCAD.exe") {
		MouseGetPos,x,y
		WinMove,ahk_id %h%,,% x-100,% y-200
		SetTimerF("MoveMsgbox", 0)
	}
}

selectLobe:
gui,%reporthwnd%:Submit,NoHide
;~ StringReplace,reportText,rText,% "[lobe]",% Trim(selectLobe)
reportText:=noduleLine()
gosub CopyText1
return

CopyText:
gosub selectLobe
return
CopyText1:
if selectLobe=
	return
clipboard:=noduleLine()
ToolTip % "Text copied !"
settimer,ToolTip,-2000
return

reportFP:
reportFN:
if EBMmode
	return
gui,%reporthwnd%:Default
gui,Submit,NoHide
gosub selectLobe
if (A_ThisLabel="reportFN") && (rSE="" || rIM=""){
	MsgBox,,, % "Please at least specify SE/IM to feedback!",5
	return
}

feedback:={}
,feedback[A_ThisLabel]:=1
if InStr(A_ThisLabel, "FN"){
	feedback["SE"]:=rSE
	,feedback["IM"]:=rIM
	,feedback["X-Ratio"]:=ratio_coord_x
	,feedback["Y-Ratio"]:=ratio_coord_y
	,feedback["SliceLocation"]:=info.z
	,feedback["MinDiameter"]:=rMinD
	,feedback["MaxDiameter"]:=rMaxD
	,feedback["MinPixelDiameter"]:=rMinDp
	,feedback["MaxPixelDiameter"]:=rMaxDp
	,feedback["AccessionNumber"]:=rAccNo
	,feedback["PatientID"]:=rChartNo
	,RegExMatch(rStudyDate, "s)^(\d+)\W(\d+)\W(\d+).+", m)
	,feedback["StudyDate"]:=m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3

}else{
	for k,v in jsonData
		if !IsObject(v)
			feedback["" k]:="" v
	feedback["Nodules"]:={}
	, nodule:=jsonData.Nodules[rNoduleInd]
	,thisInd:=rNoduleInd+1
	;~ a:= nodule.hasKey("NoduleIndBeforeSort")?nodule.noduleIndBeforeSort:rNoduleInd
	,feedback["Nodules", "" (nodule.hasKey("NoduleIndBeforeSort")?nodule.noduleIndBeforeSort:rNoduleInd)]:=nodule.clone()
	;~ MsgBox % jxon_dump(feedback)
}
;~ ToolTip % exploreobj(feedback)
sendFeedback(feedback)
gosub HideGUI
return

HideGUI:
try 
	gui,report:Hide
try {
	if !ShowNoduleList
		gui,noduleList:Hide
}
	
return

sendFeedback(feedback){
	global myTCP, feedbackIp, feedbackPort
	
	if !(myTCP:=new SocketTCP())
		goto sendFeedbackFail
	if myTCP.connect(feedbackIp, feedbackPort)
		goto sendFeedbackFail
	j:=jxon_dump(feedback)
	,l:=StrLen(j), Encoding:="UTF-8"
	,VarSetCapacity(Buffer, (Length:=StrPut(j, Encoding) * ((Encoding="UTF-16"||Encoding="cp1200") ? 2 : 1) )+4)
	,Length-=1
	,NumPut(Length, Buffer, 0, "UInt")
	,Length := StrPut(j, &Buffer+4, Encoding)
	,myTCP.send(&Buffer, Length+3)
	ToolTip % "Feedback successfully!"
	settimer,ToolTip,-3000
	return
sendFeedbackFail:
	MsgBox,,,% "Feedback fail, please contact YCH!",5
	return
}


setSocket:
;~ ip:="10.0.0.100"
;~ port:="54321"


;~ myTCP:=new SocketTCP()
;~ myTCP.onRecv:=Func("OnTCPRecv")
;~ myTCP.connect(ip, port)
return

;~ OnTCPRecv(this){
	;~ global chartNo
	;~ t:=this.recvText()
	;~ if RegExMatch(t, "is)doingLungCAD\|(.+)", match){
		;~ ToolTip % "Doing lung CAD: " match1
		;~ SetTimer,ToolTip,-2000
	;~ }else if RegExMatch(t, "is)Status: (.+)", match){
		;~ if(match1="OK")
			;~ this.sendText(A_IPAddress1 "|doLungCAD|" chartNo)
	;~ }
	
;~ }


ToolTip:
ToolTip
return


getPwb(instance, position="", Visible=true){
	global monitorInfo, pwbs
	if (position=""){
		mon:=monitorInfo[1]
		,position:={x: mon.l, y: mon.t, w: Floor(mon.w*0.75), h: Floor(mon.h*0.75)}
	}
	
	if !WinExist("ahk_id " pwbs[instance].hwnd){
		pwbs[instance]:=pwb:=ComObjCreate("InternetExplorer.Application")
		,pwb.Visible:=Visible
		WinMove,% "ahk_id " pwb.hwnd,,% position.x,% position.y,% position.w,% position.h
	}
	return pwbs[instance]
}




sethotkey:
iniPath:=A_ScriptDir "\showLungCAD.ini"
;~ IniRead,mainKey,% iniPath,Hotkey,QuerySyngovia,^i
IniRead,secondKey,% iniPath,Hotkey,QueryMagic,#i
IniRead,priorKey,% iniPath,Hotkey,Prior,#PgUp
IniRead,nextKey,% iniPath,Hotkey,Next,#PGDN
IniRead,ShowInBrowser,% iniPath,Hotkey,ShowInBrowser,0
IniRead,ShowInImpax,% iniPath,Hotkey,ShowInImpax,1
IniRead,OpenRegionGrow,% iniPath,Hotkey,OpenRegionGrow,1
IniRead,EBMmode,% iniPath,Hotkey,EBMmode,0
IniRead,ShowNoduleList,% iniPath,Hotkey,ShowNoduleList,1
IniRead,ReportFPKey,% iniPath,Hotkey,reportFP,#p
IniRead,reportFNKey,% iniPath,Hotkey,reportFN,#n
IniRead,dismissKey,% iniPath,Hotkey,quickClose,% "F2,F3,Esc"
IniRead,threshold,% iniPath,Hotkey,threshold,0.5
IniRead,ShowClearRead,% iniPath,Hotkey,ShowClearRead,0


GroupAdd,RisOrImpax,ahk_exe impax-client-main.exe
GroupAdd,RisOrImpax,ahk_exe Menu.exe
GroupAdd,RisOrImpax,ahk_exe WebViewerComSrvEC.exe
GroupAdd,RisOrImpax,ahk_exe WEBVIE~1.EXE
GroupAdd,RisOrImpax,ahk_exe simpleRIS.exe
GroupAdd,RisOrImpax,ahk_exe showLungCAD.exe


ips=
(
intranet.hospital.example
10.0.0.100
127.0.0.1:8000
localhost:8000
)
baseurl:=feedbackIp:=""
ToolTip % "Finding server ... "
if (A_IPAddress1~="^172.2")
	ips:="10.0.0.100`n"ips
Loop,parse,ips,`n
{
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	,whr.Open("GET",(url:="http://" (ip:=A_LoopField)) "/nodulePic/", true)
	,whr.Send()
	,whr.WaitForResponse(2)
	if InStr(whr.ResponseText, "Lung Nodule Finder"){
		baseurl:=url, feedbackIp:=ip
		break
	}
}
if (baseurl=""){
	MsgBox % "Can not connect to server!`nPlease contact YCH!"
	ExitApp
}
ToolTip
if(EBMmode){
	;~ baseurl:="http://127.0.0.1:8000"
	;~ ,feedbackIp:="127.0.0.1:8000"
	ShowInBrowser:=1
	,ShowInImpax:=0
}else{
	;~ baseurl:="http://intranet.hospital.example"
	;~ ,feedbackIp:="intranet.hospital.example"
}

;~ if ShowInBrowser
	;~ gosub createPwb

Hotkey,IfWinActive,ahk_group RisOrImpax
;~ Hotkey,% Trim(mainKey),main,on
Hotkey,% Trim(secondKey),magicResult,on
;~ Hotkey,% "^" Trim(priorKey),prior,on
;~ Hotkey,% "^" Trim(nextKey),next,on
Hotkey,% Trim(priorKey),prior,on
Hotkey,% Trim(nextKey),next,on
if(!EBMmode){
	Hotkey,% Trim(ReportFPKey),ReportFPHotkey,on
	Hotkey,% Trim(ReportFNKey),ReportFNHotkey,on

}
Loop,parse,dismissKey,`,
	Hotkey,% "~" Trim(A_LoopField),dismiss,on
Hotkey,IfWinActive

if OpenRegionGrow {
	Hotkey,IfWinExist,WM_COPYDATA_Listener_RegionGrowMorph
	Hotkey,~+LButton,~+LButton_
	Hotkey,IfWinExist	
}


;~ Hotkey,% "+" Trim(priorKey),prior,on
;~ Hotkey,% "+" Trim(nextKey),next,on

return

ReportFNHotkey:
;~ SetTimerF("MoveMsgbox", 100, ["Report FN"])
;~ MsgBox, 4,Report FN, Report False Negative? `n(New nodule)
;~ IfMsgBox,No
	;~ return
MouseGetPos,mx,my
which:=whichMonitor("", "", monitorInfo)
,frames:=getViewFrame()
if !NoCaptureText {
	ToolTip % "Waiting for OCR..."
	info:=getImpaxFrameInfo(frames[which.1-1,1,1], "LL")
}else
	info:={}
ToolTip
ParseInfo({Center_X:mx, Center_Y:my})
return

ReportFPHotkey:
SetTimerF("MoveMsgbox", 100, ["Report FP"])
MsgBox, 4,Report FP, Report False Positive? `n(Not a nodule)
IfMsgBox,No
	return
gosub ReportFP
return

search(){
	gosub magicResult
}
next(){
	gosub next
}
prior(){
	gosub prior
}


magicResult:
gosub HideGUI

gosub getChartNo
if (chartNo="") {
	msgbox,,,Failed to get chart No.,3
	return 
}
if (examDate=""){
	MsgBox,,,Failed to get exam date,3
	return
}
magicUrl:=(ip:=baseurl "/nodulePic/") (examDate:=SubStr(RegExReplace(examDate,"\D",""),1,8)) "/" chartNo "/"
,httprequest(magicUrl, post:="", header, "charset: utf-8")
,regexmatch(header," (\d+) ",code),regexmatch(header,"(?<=Content-Length: )\d+",len)
,FirstOpened:=true
if (code1<200 || code1>=300){
	MsgBox,260,, % "Can't find result of " chartNo " on " examDate " !`n`nRequest for CAD?",15
	IfMsgBox,Yes 
	{
		sid:=askForPortalIdPw()
		if (sid){
			if portalMessage(sid, "0900000000", examDate " " chartNo "希望有CAD!"){
				MsgBox,,,% "已發送簡訊給CHM!",3
			}else{
				MsgBox,,,% "發送簡訊給CHM失敗，請電話(52113)告知病歷號、檢查日期!",3
			}
		}
	}
	return
}

clipboard:=currentUrl:=magicUrl "#&gid=1&pid=1"

lastFound:="magic"
gosub UrlToBrowser
SetTimer,loadJson,-1
return


loadJson:
httprequest(jsonUrl:=baseurl "/lungNoduleResult/" chartNo "_" AccNo ".json"
	, post:="", header, "charset: utf-8")
try
	jsonData:=jxon_load(post)
catch {
	MsgBox,,,% "JSON data error, plz contact CHM or YCH!",5
	return
}
	
thisInd:=1
, nodCount:=jsonData.Nodules.SetCapacity(0)
, First:=true
if nodCount>0
	gosub noduleListGui
if nodCount=0
	goto noResult
gosub impaxSelect
return

noduleListGui:
gui,noduleList:new,+hwndNoduleListHwnd +ToolWindow +AlwaysOnTop
gui,Font,s12 w400,Verdana
gui,Color,ececec
noduleButtonText:=[]
;~ winset,TransColor,ececec,ahk_id %noduleListHwnd%
;~ winset,Trans,200,ahk_id %noduleListHwnd%
width1:=80, width2:=40
if (nodCount<=10){
	Loop % nodCount 
		guiNoduleButton(A_Index, width1, width2, 0, "+0")
	
		
}else{
	Loop % Floor(nodCount/2) 
		guiNoduleButton(2*(A_Index-1)+1, width2, width2, 0, "+0")
		,guiNoduleButton(2*(A_Index), width2, width2, "+0", "p")
		
	if Mod(nodCount,2)
		guiNoduleButton(nodCount, width2, width2, 0, "+0")
		
		
}
gui,Font,s10 w400,Verdana
gui,Add,button,gorderBySize w%width1% h%width2% x0 y+0 vorderBySizeButton,By Size
return

guiNoduleButton(_i, w, h, x, y){
	local conf,FontColor,t
	conf:=jsonData.Nodules[_i-1].Confidence
	gui,Font,% "s12 w" (conf>5?700:400),Verdana
	FontColor:=conf>threshold?"black":"gray"
	gui,Add,button,gjumpToNodule w%w% h%h% x%x% y%y% vnoduleButton%_i% c%FontColor%,%  t:=(conf>5)?("-" _i "-"):(" " _i " ")
	noduleButtonText[_i]:=t
}

orderBySize:
gosub hideGUI
orders:=[]
for k,nodule in jsonData.Nodules {
	key:=Floor(nodule.Diameter*1000)
	if !orders.hasKey(key)
		orders[key]:=[]
	orders[key].push(k)
}

newNodules:=[]
,Count:=jsonData.Nodules.maxindex()
,i:=0
for k,v in orders {
	for x,y in v
		newNodules[thisI:=Count-(i++)]:=jsonData.Nodules[y].clone()
		,newNodules[thisI, "NoduleIndBeforeSort"]:=y
}
	
jsonData.Nodules:=newNodules
,thisInd:=1
gosub noduleListGui
guicontrol,noduleList:Move,orderBySizeButton,w0 h0 x-1
gosub changeIm2

return

jumpToNodule:
if RegExMatch(A_GuiControl, "\d+", jumpNoduleInd){
	thisInd:=jumpNoduleInd
	gosub HideGUI
	if ShowNoduleList
		settimer,ShowNoduleListGUI,-1000
	gosub changeIm2
}
return

ShowNoduleListGUI:
gui,%nodulelisthwnd%:show,NoActivate
return
nextInd(ind){
	global nodCount, thisInd, threshold, jsonData
	if ind=
		ind:=thisInd
	
	Loop {
		if (++ind>nodCount)
			ind-=nodCount
		if (ind==thisInd) || (jsonData.Nodules[ind-1].Confidence>threshold)
			break
	}
	
	return ind
}
priorInd(ind){
	global nodCount, thisInd, threshold, jsonData
	if ind=
		ind:=thisInd
	
	Loop {
		if (--ind<1)
			ind:=nodCount
		if (ind==thisInd) || (jsonData.Nodules[ind-1].Confidence>threshold)
			break
	}

	return ind
}

disconnectSocket:
inUdp.disconnect()
for k,v in outUdp
	v.disconnect()
return

sendChartNo:
;~ outUdp(ip, port, A_IPAddress1 "|queryStatus")
return

getChartNo:
lastChartNo:=chartNo, lastAccNo:=AccNo
chartNo:=""
winget,pName,ProcessName,A
if (EBMmode || pName~="i)WebViewerComSrvEC.exe|WEBVIE~1.EXE"){
	if rChartNo:=getRisChartNo(RisOpened()[2])
		chartNo:=rChartNo, examDate:=getRisExamDate(RisHwnd:=RisOpened()[2])
		, AccNo:=getRIsAccNo(RisHwnd)
	else
		ret:=getEBMInfo()
		,chartNo:=ret.chartNo
		,examDate:=ret.examYear (StrLen(ret.examMonth)=1?"0":"") ret.examMonth (StrLen(ret.examDay)=1?"0":"") ret.examDay
		,AccNo:=ret.AccNo
}
	
else if iChartNo:=getImpaxChartNo(impaxHwnd:=ImpaxOpened()[2,1]){
	chartNo:=iChartNo, examDate:=getImpaxExamDate(impaxHwnd)[1]
	, AccNo:=getImpaxAccNo(impaxHwnd)
	if RegExMatch(examDate, "^(\d+)\/(\d+)\/(\d+)", m)
		examDate:=m1 (StrLen(m2)=1?"0":"") m2 (StrLen(m3)=1?"0":"") m3
}
else if rChartNo:=getRisChartNo(RisOpened()[2])
	chartNo:=rChartNo, examDate:=getRisExamDate(RisHwnd:=RisOpened()[2])
	, AccNo:=getRIsAccNo(RisHwnd)
else if regexmatch(clipboard,"\w{6}\d",match)
	chartNo:=match, AccNo:=""

;~ MsgBox % chartNo


return

main:
gosub HideGUI
chartNo:=AccNo:=examDate:=""
, jsonData:=[]
gosub getChartNo
if (chartNo="") {
	msgbox,,,Failed to get chart No.,3
	return 
}
test:
dateStr:=SubStr(examDate,1,4) SubStr(examDate,6,2) SubStr(examDate,9,2)


,ip:="http://10.0.0.100:8042/"
;~ chartNo:="6______"

,httprequest(url:=ip "patients/" SHA1dash(chartNo),post:="",header:="","charset: utf-8")
if (!post){
	goto fail
	return
}

patient:=json_from(post)
,url:="",processed:=0
Loop % patient.studies.maxindex() {
	httprequest(ip "studies/" patient.studies[A_Index],post:="",header:="","charset: utf-8") 
	if !post
		continue
	study:=json_from(post)
	if(study.MainDicomTags.StudyDate=dateStr){
		Loop % study.series.maxindex() {
			httprequest(ip "series/" study.series[A_Index],post:="",header:="","charset: utf-8") 
			if(!post)
				continue
			series:=json_from(post)
			;~ else if ()
			if(series.MainDicomTags.SeriesDescription="Evidence Documents MM Oncology Reading"){
				processed:=1
			}else if(series.MainDicomTags.SeriesDescription="Results MM Oncology Reading" || series.MainDicomTags.SeriesDescription="Hologic R2 ImageChecker CAD SC"){
				clipboard:=url:=ip "web-viewer/app/viewer.html?series=" study.series[A_Index]
				break 2
			}
			
		}
	}
}
if(url=""){
	if(processed){
		goto noResult
		return
	}else{
		goto fail
		return
	}
}

;~ if post
	;~ clipboard:=url:=ip "web-viewer/app/viewer.html?series=" json_from(post).series.1
;~ else 
	;~ goto fail

;~ test:
;~ clipboard:=url:=ip:="http://www.yahoo.com.tw/"
lastFound:="syngovia"
UrlToBrowser:
if (!ShowInBrowser && lastFound!="syngovia")
	return
;~ gosub createPwb
if(ShowClearRead && (AccNo!="")){
	getPwb(2).navigate(clearReadUrl AccNo)
	winactivate,% "ahk_id " getPwb(2).hwnd
}

getPwb(1).navigate(currentUrl)
winactivate,% "ahk_id " getPwb(1).hwnd
return

ifwinexist,ahk_class MozillaWindowClass
{
	winactivate,ahk_class MozillaWindowClass
	WinWaitActive,ahk_class MozillaWindowClass,,2
}else ifwinexist,ahk_class Chrome_WidgetWin_1
{
	WinActivate,ahk_class Chrome_WidgetWin_1
	WinWaitActive,ahk_class Chrome_WidgetWin_1,,2
}else{
	openNew:=false
	gosub openNewChromeOrFirefox
	if(openNew="firefox" && !err){
		WinActivate,ahk_class MozillaWindowClass
		WinWaitActive,ahk_class MozillaWindowClass,,2
	}else if(openNew="chrome" && !err){
		WinActivate,ahk_class Chrome_WidgetWin_1
		WinWaitActive,ahk_class Chrome_WidgetWin_1,,2
	}else if (err){
		
		MsgBox,,, % "The URL is copied. Please paste in FireFox or Chrome browser.",5
		return
	}
}


Sleep 500
if !InStr(activeUrl:=GetActiveBrowserURL(),ip) && activeUrl!="" {
	send ^t
	Sleep 200
}
send !d
sleep 200
send ^v
sleep 200
send {enter}
recoverClip:
;~ clipboard:=pClip
;~ ExitApp
return

openNewChromeOrFirefox:
appPath:=""
Loop,% a_desktop "\*.lnk"
	if InStr(A_LoopFileName, "firefox"){
		FileGetShortcut,% A_LoopFileFullPath, appPath
		break
	}
if(appPath!=""){
	run % """" appPath """ """ url """"
	err:=ErrorLevel	
	,openNew:="firefox"
	return
}
Loop,% A_DesktopCommon "\*.lnk"
	if InStr(A_LoopFileName, "firefox"){
		FileGetShortcut,% A_LoopFileFullPath, appPath
		break
	}
if(appPath!=""){
	run % """" appPath """ """ url """"
	err:=ErrorLevel	
	,openNew:="firefox"
	return
}
Loop,% a_desktop "\*.lnk"
	if InStr(A_LoopFileName, "chrome"){
		FileGetShortcut,% A_LoopFileFullPath, appPath
		break
	}
if(appPath!=""){
	run % """" appPath """ """ url """"
	err:=ErrorLevel	
	,openNew:="chrome"
	return
}
Loop,% A_DesktopCommon "\*.lnk"
	if InStr(A_LoopFileName, "chrome"){
		FileGetShortcut,% A_LoopFileFullPath, appPath
		break
	}
if(appPath!=""){
	run % """" appPath """ """ url """"
	err:=ErrorLevel	
	,openNew:="chrome"
	return
}
MsgBox,,, % "Please open Firefox or Chrome first!",5
openNew:=false
return

fail:
;~ msgbox,,,Not found!,3
MsgBox, 4164, ,% "Lung CAD not processed or study not found in SyngoVia?",60
;~ IfMsgBox,Yes
	;~ gosub sendChartNo
;~ goto recoverClip
return

noResult:
MsgBox,,,% "No lesion found by CAD !",3
;~ goto recoverClip
return


SHA1dash(str){
	str:=SHA(str)
	stringlower,str,str
	return substr(str,1,8) "-" substr(str,9,8) "-" substr(str,17,8) "-" substr(str,25,8) "-" substr(str,33,8)
}

next:
prior:
gosub HideGUI
key:=A_ThisLabel
,lastfound:=InStr(A_ThisHotkey, "^")?"syngovia":"magic"
gosub changeIm
return

changeIm:
thisInd:=key="next"?nextInd(thisInd):priorInd(thisInd)
changeIm2:
if ShowInBrowser 
	nd:=jsonData.Nodules[thisInd-1]
	,getPwb(1).navigate(RegExReplace(currentUrl, "(?<=pid=)\d+$", nd.hasKey("noduleIndBeforeSort")?nd.noduleIndBeforeSort+1:thisInd))
	
	


if (EBMmode)
	gosub EBMselect
if ShowInImpax {
	gosub impaxSelect
}
if ShowInBrowser {
	
	winactivate,% "ahk_id " getPwb(1).hwnd
	
}
return

activeWin:=WinExist("A")
MouseGetPos,beforeScrollX,beforeScrollY
if WinExist("ahk_class MozillaWindowClass")
	browser:="ahk_class MozillaWindowClass"
else if WinExist("ahk_class Chrome_WidgetWin_1")
	browser=ahk_class Chrome_WidgetWin_1
else
	return
WinActivate,%browser%
WinWaitActive,,,2

RegExMatch(currentUrl:=GetActiveBrowserURL(), "(?<=pid=)\d+$", lastInd)
,repeat:=false
WinGetPos,bx,by,bw,bh,% browser
if (LastFound="syngovia"){
	mousemove,% bx+bw-100,% by+Floor(bh/2),0
	Sleep 50
	send % (key="prior")?"{WheelUp}":"{WheelDown}"
	Sleep 50
}else{
	mouseclick,L,% bx+bw-10,% by+Floor(bh/2),1,0
	Sleep 50
	send % (key="next")?"{Right}":"{Left}"
	Loop {
		Sleep 100
	}until currentUrl!=GetActiveBrowserURL() || A_Index>10
	
	thisInd:=key="next"?nextInd(lastInd):priorInd(lastInd)
	repeat:=thisInd=1
	
}
;~ sleep 100
mousemove,% beforeScrollX,% beforeScrollY,0
WinActivate,ahk_id %activeWin%

if (lastFound!="syngovia")
	gosub impaxSelect

if (repeat && !First)
	MsgBox,,,% "Back to first picture!",2
First:=false
return

impaxSelect:
ebm_show_x:=ebm_show_y:=""
if EBMmode || (chartNo~="i)^[H]")
	goto EBMselect
if !ShowInImpax
	return
if (ShowNoduleList){
	WinGetPos,lastX,lastY
	WinHide,ahk_id %noduleListHwnd%
}

MouseGetPos,,,,mCon,2
if !(ControlGetText(mCon)~="Screen_\d+_format_\d+_Position_\d+_\d+")
	return
SEIM:=getSEIM()

if (jsonData.AccessionNumber=AccNo) && nodCount>0 {
	nodule:=jsonData.Nodules[thisInd-1]
	if ((originalThickness:=jsonData.spacing[3])=""){
		if RegExMatch(jsonData.spacing, "\[[\d\.]+\, *[\d\.]+\, *([\d\.]+)\]", match)
			originalThickness:=match1
		else
			originalThickness:=1.0
	}
	
	
	if(lastAccNo!=AccNo)
		thickSliceMode:=!(SEIM.1=jsonData.SeriesNumber)
		, z:=(SEIM.1=jsonData.SeriesNumber)?(nodule.InstanceNumber):Round(nodule.InstanceNumber*originalThickness/5)
	else 
		z:=!thickSliceMode?(nodule.InstanceNumber):Round(nodule.InstanceNumber*originalThickness/5)

	if z<1
		z:=1
	coord:=impaxSelectImageCurrent(nodule["X-Ratio"], nodule["Y-Ratio"], z)
	if (coord){
		cross.show(coord.1, coord.2)
		,OnScreenDisplay(thisInd, 400, 50, "white")
		,DisplayNoduleInfo(thisInd, SEIM.1=jsonData.SeriesNumber)
	}
	
	;~ if (!ShowInBrowser && thisInd=1 && !First)
		;~ MsgBox,,,% "Back to first picture!",2

	First:=false
}

return

EBMselect:
if (ShowNoduleList){
	WinGetPos,lastX,lastY
	WinHide,ahk_id %noduleListHwnd%
}
if (jsonData.AccessionNumber=AccNo) && nodCount>0 {
	nodule:=jsonData.Nodules[thisInd-1]
	if ((originalThickness:=jsonData.spacing[3])=""){
		if RegExMatch(jsonData.spacing, "\[[\d\.]+\, *[\d\.]+\, *([\d\.]+)\]", match)
			originalThickness:=match1
		else
			originalThickness:=1.0
	}
	MouseGetPos,mx,my
	
	IMnumber:= nodule.InstanceNumber
	,IMinfo:=originalThickness=1?IMnumber " (1mm)":IMnumber " , " Floor((IMnumber-1)*originalThickness + 1) " (1mm)"
	,IMinfo.=" , " Floor((IMnumber-1)*originalThickness/3 + 1) " (3mm)`n" (StrLen((s:=Floor((IMnumber-1)*originalThickness/5 + 1)))<3?" ":"") s " (5mm) , " Floor((IMnumber-1)*originalThickness/2.5 + 1) " (2.5mm)"
	
	
	coord:=[]
	,coord.1:=mx, coord.2:=my
	,which:=whichMonitor("", "", monitorInfo).1
	,ebm_show_x:=nodule["X-Ratio"]<0.5?Floor(monitorInfo[which].l+monitorInfo[which].w*2/3):Floor(monitorInfo[which].l+monitorInfo[which].w/8)
	,ebm_show_y:=nodule["Y-Ratio"]<0.5?Floor(monitorInfo[which].t+monitorInfo[which].h*2/3):Floor(monitorInfo[which].t+monitorInfo[which].h/4)
	OnScreenDisplay("# " thisInd "`n" IMinfo "`n( X , Y ) = ( " Floor(512*nodule["X-Ratio"]) " , " Floor(512*nodule["Y-Ratio"]) " )", 120000, 50, "CCCCCC", "Verdana", [monitorInfo[which].l+10, monitorInfo[which].b-500])
	,DisplayNoduleInfo(thisInd, true)
	
	
	;~ if (!ShowInBrowser && thisInd=1 && !First)
		;~ MsgBox,,,% "Back to first picture!",2

	First:=false
}

return

^!q::
exitapp
return

OnExit:
gosub disconnectSocket
for k,pwb in pwbs
	pwb.quit()
ExitApp



dismiss:
winget,pActiveHwnd,id,A
ControlGetFocus,pActiveControl,A
if WinVisible(reporthwnd)
	WinHide,% "ahk_id " reporthwnd
else if WinVisible(noduleListHwnd) {
	MouseGetPos,lastX,lastY
	WinHide,% "ahk_id " noduleListHwnd
}
if (A_ThisHotkey~="F\d"){
	MouseGetPos,lastX,lastY
	WinHide,% "ahk_id " noduleListHwnd
	WinHide,% "ahk_id " reporthwnd
	for k, pwb in pwbs
	{
		WinHide,% "ahk_id " pwb.hwnd
		WinMinimize,% "ahk_id " pwb.hwnd
		WinShow,% "ahk_id " pwb.hwnd
	}
		
}
OnScreenDisplay("", 1,1,"white")
winget,pName,ProcessName,% "ahk_id " pActiveHwnd
if(pName~="i)Menu.exe|impax-client-main.exe"){
	winactivate,% "ahk_id " pActiveHwnd
	ControlFocus,% pActiveControl,% "ahk_id " pActiveHwnd
}

return



#IfWinExist,WM_COPYDATA_Listener_RegionGrowMorph
~+LButton_:
;~ ToolTip % "OCR for corner info, please wait ... "
settimer,LButton_Shift,-500
settimer,LButtonUP,100
gosub HideGUI
which:=whichMonitor("", "", monitorInfo)
,frames:=getViewFrame()
if !NoCaptureText
	info:=getImpaxFrameInfo(frames[which.1-1,1,1], "LL")
else
	info:={}

;~ MsgBox % exploreobj(info)
;~ ToolTip
return

LButton_Shift:
if GetKeyState("Shift") && GetKeyState("Lbutton") {
	MouseGetPos,x,y
	Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_RegionGrowMorph"), 25, jxon_dump({"start":1
	, "mouse_pos": [x,y]}))
}

LButtonUp:
if !GetKeyState("LButton") {
	settimer,LButton_Shift,Off
	settimer,LButtonUp,Off
	Send_WM_COPYDATA(WinExist("WM_COPYDATA_Listener_RegionGrowMorph"), 25, jxon_dump({"end":1
	, "mouse_pos": [x,y]}))
	
}
return

#IfWinExist

#IfWinActive,ahk_exe Menu.exe
~*F3::
lastX:=lastY:=""
WinHide,% "ahk_id " reporthwnd
WinHide,% "ahk_id " noduleListHwnd
return
#IfWinActive

~Rbutton::
mousegetpos,,,win,con,2
if(win==reporthwnd || win==noduleListHwnd) && !instr(WinGetClass(con),"edit"){
	winhide,% "ahk_id " reporthwnd
	winhide,% "ahk_id " noduleListHwnd
}
return