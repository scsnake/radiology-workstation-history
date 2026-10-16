/*
20140821
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
SetBatchLines, -1
;~ coordMode,mouse,screen
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
CoordMode,caret,client
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
;~ SetFormat, float, 2.1
comobjerror(false)
onexit,onexit
;~ #include <portalLib>
#include <SetWindowsHookEx>
#include <RisImpax>
#include <EditFunctions>
#include <WindowShellEvent>
#include <AltTab_window_list>
#include <SetTimerF>

reportType:=0
OnMessage( 0x200, "WM_MOUSEMOVE" ) 


gosub loadHotkey

RegExMatch(hotKeys,"fontFamily=(?P<fontFamily>[^\r\n]*)",match)
RegExMatch(hotKeys,"fontSize=(?P<fontSize>[^\r\n]*)",match)
RegExMatch(hotKeys,"guiColor=(?P<guiColor>[^\r\n]*)",match)

gui,color,%matchguiColor%
gui,+lastfound +hwndguiHwnd
;~ winset,transcolor,CCCCCC 50,ahk_id %guiHwnd%
gui,+toolwindow -caption
gui,font,s%matchfontSize%,%matchfontFamily%
;~ gui,add,text,vtext,% "Exam        "
;~ gui,add,text,x+100 valert hwndalertHwnd,% "                                      "
gui,add,edit,vedit1 w600 h300 hwndeditHwnd1,test1
;~ gui,add,text,vtext2,% "Impression      "
gui,add,edit,y+0 vedit2 w600 h300 hwndeditHwnd2,test2
;~ gui,show,autosize,RisTyper


undoStack:=[],undoIndex:=-1,stacks:=1000,detectInterval:=200,ptick:=0, undoDepth:=0
,pStack:={tick:a_tickcount, selStart:0, selEnd:0, text: "", Edit: 1}
,endCharKeyCode1:="0x200xDC0xBF0xBD0xDB0xDD0xDE0xBA0xBC0xBE0xD0x9"
,endCharKeyCode2:="0x390x300xDB0xDD0xBA0xDE0xBF0x31"
,caretAdjustX:=15
,reportState:={1: {undoIndex: undoIndex, undoDepth: undoDepth, undoStack: []}, 2:{undoIndex: undoIndex, undoDepth: undoDepth, undoStack: []}}

hHookKeybd := SetWindowsHookEx(WH_KEYBOARD_LL	:= 13, RegisterCallback("Keyboard", "Fast"))
hHookMouse := SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseMove", "Fast"))
WindowShellEvent("ShellEvent")
settimer,routine,500
settimer,noIdle,540000



return

loadHotkey:
iniFile:=a_scriptdir "\RisTyper.ini"

fileread,hotKeys,% iniFile
hotKeyPairs:={復原:["undo","^z"]
	,還原:["redo","^y"]
	,更新:["update","^s"]
	,下筆:["next","F12"]
	,上筆:["previous","F11"]
	,暫存:["save1","F1"]
	,存檔:["save2","F2"]
	,發送:["save3","F3"]
	,臨床報告:["clinical","F4"]
	,Impax:["image","F5"]
	,focus:["focus","CapsLock"]
	,移到清單:["moveToList","^l"]
	,SEIM:["getImageNumber","^i"]
	,insertText:["insertText","^k"]}
errors:=[]
try{

loop,parse,hotKeys,`n
{
	if regexmatch(A_LoopField,"\[([^]])\]",match)
		continueIniRead:=match1="Hotkey"?0:1
	
	if (continueIniRead)
		continue
	
	if !RegExMatch(a_loopfield,"is)([^=]+)=([^\r\n]*)",match) || (var:=hotKeyPairs[match1,1])=""
		continue
	var:=hotKeyPairs[match1,1]
	if var in focus,moveToList,insertText
	{
		hotkey,ifwinactive
	}else {
		hotkey,ifwinactive,RisTyper ahk_class AutoHotkeyGUI
	}
	%var%Key:=trim(match2)=""?hotKeyPairs[match1,2]:match2
	;~ hotkey,ifwinactive,RisTyper ahk_class AutoHotkeyGUI
	hotkey,% %var%Key,%var%
}

hotkey,ifwinactive

hotkey,% focusKey,focus
if focusKey in CapsLock,ScrollLock,NumLock,AppsKey,PrintScreen,Pause
	hotkey,% "+" focusKey,shiftCombine

} catch e {
	errors.push(e)
}
if (errors.maxindex()){
	errorMsg:=""
	for k,v in errors
		errorMsg.="Runtime Error!!`nLine: " e.Line "`nFunction: " e.What "`nMessage: " e.Message "`n`n"
	MsgBox, 566, , % errorMsg
	ifmsgbox,Cancel
		ExitApp
	else ifmsgbox,Retry
		goto loadHotkey
}
return

focus:
mousegetpos,,,Win
if (win=ImpaxState[2,1])
	imageNumber:=getSEIM()

if(winactive("ahk_Id " guiHwnd))
	gui,hide
else {
	
	if !isRisImpaxOnTop()
		winactivate,% "ahk_id " RisState[2]
	gosub guishow
	winactivate,% "ahk_id " guihwnd
	;~ controlfocus,,ahk_id %editHwnd%
}
return

shiftCombine:
send % "{" substr(a_thishotkey,2) "}"
return

;~ :*:t::abc{tab}

ShellEvent(wParam, lParam){
	global RisState,guiHwnd
	static pActiveWin
	static WS_EX_TOPMOST := 0x00000008 
	if (wParam=4 || wParam=32772){
		;~ tooltip,% pActiveWin "," guiHwnd
		WinGet, ES, ExStyle, ahk_id %guiHwnd%
		guiOnTop:=ES & WS_EX_TOPMOST
		if (lParam=RisState[2] && !guiOnTop && WinVisible("ahk_id " guiHwnd) && !winexist("kReport ahk_class #32770")){
			winset,alwaysontop,on,ahk_id %guiHwnd%
			;~ winactivate,ahk_id %guiHwnd%
			;~ tooltip,% AltTab_window_list[1] "," AltTab_window_list[2]
		}else if ((!winactive("ahk_id " guiHwnd) || winexist("kReport ahk_class #32770")) && guiOnTop ){
			winset,alwaysontop,off,ahk_id %guiHwnd%
			winactivate,ahk_id %lParam%
		}
		pActiveWin:=winactive("A")
	}
	
}

WM_MOUSEMOVE( wparam, lparam, msg, hwnd ){
	if wparam = 1 ; LButton
		PostMessage, 0xA1, 2,,, A ; WM_NCLBUTTONDOWN
	if !winactive("ahk_id " hwnd)
		winactivate,ahk_id %hwnd%
	
}


~wheelup::
~wheeldown::
if (refractory)
	return
settimer,activateImpax,-1
settimer,activateRis,-1
refractory:=1
settimer,recover,-500
return

activateImpax:
if Winactive("ahk_exe impax-client-main.exe")
	return
mousegetpos,,,win1
winget,pName,processName,% "ahk_id " win1
if (pName="impax-client-main.exe"){
	winactivate,ahk_id %win1%
}
return

activateRis:
if Winactive("ahk_exe Menu.exe")
	return
mousegetpos,,,win2
winget,pName,processName,% "ahk_id " win2
if (pName="Menu.exe"){
	winactivate,ahk_id %win2%
}
return

MouseMove(nCode, wParam, lParam){
	global refractory,rClicks,editHwnd1,editHwnd2,guiHwnd
	static priorX,priorY
	If nCode 
		return
	;~ X := lParam & 0xFFFF      ;  in case I need the mouse X position
	;~ Y := lParam >> 16         ;  in case I need the mouse Y position
	;~ static priorX,priorY
	if (wParam=0x20A){
		
	}else if (wParam = 0x204 && winactive("ahk_id " guihwnd)){ ;rbuttondown
		
		send {lbutton down}
		if(++rClicks>=3){
			mousegetpos,,,con,3
			edit_selectLine(0,true,con)
		}
		settimer,resetRClick,-400
		return 1
	}else if (wParam = 0x205 && winactive("ahk_id " guihwnd)){ ;rbuttonup
		send {lbutton up}
		settimer,sendBS,-50
		return 1
	}else if (wParam = 0x200){
		
		
		
		x:=NumGet(lParam+0, 0, "int")
		,y:=NumGet(lParam+0, 4, "int")
		;~ ,AltTab_window_list:=AltTab_window_list()
		if (x>a_screenwidth && ((priorx-x)**2+(priorY-y)**2>2500) && !Winactive("ahk_exe impax-client-main.exe") && !refractory){
			settimer,activateImpax,-100
			refractory:=1
			settimer,recover,-300
			;~ for k,v in AltTab_window_list {
				;~ winget,pName,processname,% "ahk_id " v.hwnd
				;~ if (pName="impax-client-main.exe") {
					;~ winactivate,% "ahk_id " v.hwnd
					;~ break
				;~ }
			;~ }
			priorX:=x,priorY:=y
		}
	;~ traytip,,% x "," y
		
		if priorX=
			priorX:=x,priorY:=y
	}
		
	Return CallNextHookEx(nCode, wParam, lParam)
}
recover:
refractory:=0
return

#ifwinactive,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe
~$lbutton::
if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500) 
	return
mousegetpos,,,win,con,3
if (con=RisReports[2,1] || con=RisReports[2,2]){
	undoStacking("f")
	
	loop 2 {
		i:=3-a_index
		controlsettext,,% reportState[i].undoStack[reportState[i].undoIndex].text controlgettext(RisReports[2,i]),% "ahk_id " editHwnd%i%
		Edit_Select(reportState[i].undoStack[reportState[i].undoIndex].selStart, reportState[i].undoStack[reportState[i].undoIndex].selEnd, editHwnd%i%)
	}
	undoStacking("f")
	
	;~ lastInd:=reportState[!reportType].undoStack.maxIndex()
	;~ ,reportState[!reportType].undoStack[nextInd:=mod(lastInd+1,stacks)]:=reportState[!reportType].undoStack[lastInd].clone()
	;~ ,reportState[!reportType].undoIndex:=nextInd
	;~ ,reportState[!reportType].undoDepth:=0
	;~ ,reportState[!reportType,"undoStack",nextInd,"text"]:=reportState[!reportType,"undoStack",nextInd,"text"] controlgettext(RisReports[2,(!reportType)+1])
	
	winactivate,ahk_id %guiHwnd%
	controlfocus,,ahk_id %editHwnd1%
}
return

#ifwinactive

guiShow:
	if (!winexist("ahk_id " RisReports[1,1]) || !winexist("ahk_id " RisReports[1,2]))
		gosub getRisHwnds
	
	
	
	p:=DllCall("GetParent","uint",RisReports[1,1])
	controlgetpos,x,y,w,h,,ahk_id %p%
	guicontrol,move,edit1,% "w" w-20 " h" h
	
	p:=DllCall("GetParent","uint",RisReports[1,1])
	controlgetpos,,,w,h,,ahk_id %p%
	guicontrolget,var,pos,edit1
	guicontrol,move,edit2,% "w" w-20 " h" h " x" varx " y" vary+varh
	
	
	;~ p:=DllCall("GetParent","uint",RisReports[1,2])
	;~ controlgetpos,x,y,w,h2,,ahk_id %p%
	;~ if (!reportType){
		;~ p:=DllCall("GetParent","uint",examReport)
		;~ controlgetpos,x,y,w,h1,,ahk_id %p%
	;~ }else{
		;~ h1:=0
	;~ }
	;~ guicontrol,move,edit,% "w" w-24 " h" h1+h2-25
	gui,show,% "autosize x" x-6 " y" y-5,RisTyper
return



getRisHwnds:
	RisReports:=getRisReports(RisState[2]),examReport:=RisReports[1,1]
	,nextHwnd:=getNetControl2(RisState[2],"下筆","cmdRunNext","下筆","WindowsForms10.BUTTON.app","","","",0)[1]
	,previousHwnd:= getNetControl2(RisState[2],"上筆","cmdRunFoword","上筆","WindowsForms10.BUTTON.app","","","",0)[1]
	,save1Hwnd:= getNetControl2(RisState[2],"暫存","cmdRunSave","暫存","WindowsForms10.BUTTON.app","","","",0)[1]
	,save2Hwnd:= getNetControl2(RisState[2],"存檔","cmdRunVerify","存檔","WindowsForms10.BUTTON.app","","","",0)[1]
	,save3Hwnd:=getNetControl2(RisState[2],"存檔發送","cmdRunVerifySend","存檔發送","WindowsForms10.BUTTON.app","","","",0)[1]
	,clinicalHwnd:= getNetControl2(RisState[2],"臨床報告","cmdHisReport","臨床報告","WindowsForms10.BUTTON.app","","","",0)[1]
	,imageHwnd:= getNetControl2(RisState[2],"IMPAX6","cmdDs3000","IMPAX6","WindowsForms10.BUTTON.app","","","",0)[1]
return

routine:

impaxState:=impaxOpened()
if (RisState:=RisOpened())[1]!=2 {
	;~ gui,hide
	RisReports:=[]
	return
}
if ((priorRisHwnd!=RisState[2] && (priorRisHwnd:=RisState[2])) || !(RisReports.maxIndex()) || !winexist("ahk_id " RisReports[1,1]) || !winexist("ahk_id " RisReports[1,2])){
	gosub getRisHwnds
}

if ((pChartNo!=getRisChartNo(RisState[2])) && (pChartNo:=getRisChartNo(RisState[2]))){
	gosub guishow
}else{
	return
}

if (winexist("ahk_id " examReport:=RisReports[1,1]) && !(guiVisible:=WinVisible("ahk_id " guiHwnd))) {
	gosub guiShow
	WinActivate,% "ahk_id " RisState[2]
	winactivate,ahk_id %guiHwnd%
	getFromRis()
}
;~ tooltip,% getRisChartNo(RisState[2])
else if (guiVisible ){

	{
		;~ pChartNoChanged:=1
		;~ tooltip,% pchartno
		getFromRis()
		;~ gosub tab2
		;~ getFromRis()
		;~ gosub tab2
	}
	
	;~ if (ImpaxState[1]=2 && pChartNo!=getImpaxChartNo(ImpaxState[2,1])){
		;~ controlsettext,,    (Chart No mismatch!!),ahk_id %alertHwnd%
	;~ }else if (controlgettext(alertHwnd)!=""){
		;~ controlsettext,,,ahk_id %alertHwnd%
	;~ }
	
}




return


;~ ^j::
;~ tick:=a_tickcount
;~ inputbox,times,,,,,,,,,,10000
;~ if !errorlevel
	;~ return
;~ loop % times
	;~ getImpaxChartNo(ImpaxState[2,1])
;~ msgbox % a_tickcount-tick
;~ return

getFocused(){
	static GuiThreadInfoSize = 48
	VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
	DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
	return FocusedHWND := NumGet(GuiThreadInfo, 12)  ; Retrieve the hwndFocus field from the struct.
}


Keyboard(nCode, wParam, lParam)
{
	global ptick,endCharKeyCode1,endCharKeyCode2,cEndCharFlag,pEndCharFlag,pStack,detectInterval,funDown,guiHwnd
	Critical
	SetFormat, Integer, H
	keyCode:=NumGet(lParam+0,0)
	setformat,integer,D
	;~ 
	If (wParam = 0x101 && !(getkeystate("ctrl") || getkeystate("alt") || getkeystate("win")))  
	{
		;~ if  getkeystate("alt")
			;~ msgbox
		;~ if ()=0x9 && !funDown
			;~ gosub tab1
		
		pEndCharFlag:=cEndCharFlag
		if (instr(endCharKeyCode1,keyCode) || (instr(endCharKeyCode2,keyCode) && getkeystate("shift"))) {
			cEndCharFlag:=1
			,focused:=guiGetFocused()
	
			if ((a_tickcount - pStack.tick > detectInterval) && pStack.Edit=focused && !pEndCharFlag) {
				settimerF("undoStacking",-10,[focused],0)
			}
			pStack.tick:=a_tickcount
			;~ undoDepth:=0
			;~ undoStack[mod(++undoIndex,stacks)]:=controlgettext(editHwnd)
			;~ KeyName := GetKeyName("vk" keyCode)
			;~ Tooltip, % (wParam = 0x100) ? KeyName " Down" : KeyName " Up"
		}else{
			cEndCharFlag:=0
		}
	}
	
	Return CallNextHookEx(nCode, wParam, lParam)
}

~ctrl::
~alt::
funDown:=1
return

~ctrl up::
~alt up::
funDown:=0
return

guiGetFocused(){
	global
	guicontrolget,focusCon,focus
	if regexmatch(focusCon,"Edit(\d+)",match)
		return match1
}

caretMove:
focused:=guiGetFocused()
Edit_GetSelection(selStart,selEnd,editHwnd%focused%)
reportState[focused].undoStack[reportState[focused].undoIndex].selStart2:=selStart
,reportState[focused].undoStack[reportState[focused].undoIndex].selEnd2:=selEnd
return

isRisImpaxOnTop(){
	risFlag:=0
	impaxFlag:=0
	AltTab_window_list:=AltTab_window_list()
	for k,v in AltTab_window_list {
		winget,processname,processname,% "ahk_id " v.hwnd
		if processName=Menu.exe
			risFlag:=1
		else if processname=impax-client-main.exe
			impaxFlag:=1
		else
			break
	}
	return risFlag && impaxFlag
}

;~ undoStacking2:
;~ loop 2 {
	;~ i:=a_index
	;~ Edit_GetSelection(selStart,selEnd,editHwnd%i%)
	;~ ,pStack:={tick:a_tickcount, selStart:selStart, selEnd:selEnd, text: controlgettext(editHwnd%i%),Edit:i}
	;~ if !(reportState[i].undoStack[reportState[i].undoIndex].text=pStack.text)
		;~ reportState[i].undoStack[reportState[i].undoIndex:=mod(++reportState[i].undoIndex,stacks)]:=pStack.clone()
		;~ ,reportState[i].undoDepth:=0
	;~ else if !(reportState[i].undoStack[reportState[i].undoIndex].selStart=pStack.selStart && reportState[i].undoStack[reportState[i].undoIndex].selEnd=pStack.selEnd)
		;~ reportState[i].undoStack[reportState[i].undoIndex].selStart2:=pStack.selStart
		;~ ,reportState[i].undoStack[reportState[i].undoIndex].selEnd2:=pStack.selEnd
;~ }
;~ return

undoStacking(i=""){
	global pStack,reportState,editHwnd1,editHwnd2,stacks
	if (i=""){
		loop 2 {
			i:=a_index
			Edit_GetSelection(selStart,selEnd,editHwnd%i%)
			,pStack:={tick:a_tickcount, selStart:selStart, selEnd:selEnd, text: controlgettext(editHwnd%i%),Edit:i}
			if !(reportState[i].undoStack[reportState[i].undoIndex].text=pStack.text)
				reportState[i].undoStack[reportState[i].undoIndex:=mod(reportState[i].undoIndex+1,stacks)]:=pStack.clone()
				,reportState[i].undoDepth:=0
			else if !(reportState[i].undoStack[reportState[i].undoIndex].selStart=pStack.selStart && reportState[i].undoStack[reportState[i].undoIndex].selEnd=pStack.selEnd)
				reportState[i].undoStack[reportState[i].undoIndex].selStart2:=pStack.selStart
				,reportState[i].undoStack[reportState[i].undoIndex].selEnd2:=pStack.selEnd
		}
		return
	}else if (i="f"){
		i:=guiGetFocused()
	}
	
	Edit_GetSelection(selStart,selEnd,editHwnd%i%)
	,pStack:={tick:a_tickcount, selStart:selStart, selEnd:selEnd, text: controlgettext(editHwnd%i%),Edit:i}
	if !(reportState[i].undoStack[reportState[i].undoIndex].text=pStack.text)
		reportState[i].undoStack[reportState[i].undoIndex:=mod(reportState[i].undoIndex+1,stacks)]:=pStack.clone()
		,reportState[i].undoDepth:=0
	else if !(reportState[i].undoStack[reportState[i].undoIndex].selStart=pStack.selStart && reportState[i].undoStack[reportState[i].undoIndex].selEnd=pStack.selEnd)
		reportState[i].undoStack[reportState[i].undoIndex].selStart2:=pStack.selStart
		,reportState[i].undoStack[reportState[i].undoIndex].selEnd2:=pStack.selEnd
	return
}


WinVisible(Title) {
	DetectHiddenWindows Off ; Force to not detect hidden windows
	Return WinExist(Title) ; Return 0 for hidden windows or the ahk_id
	DetectHiddenWindows On ; Return to "normal" state
}

sendToRis(clear=0){
	global RisReports,reportType,editHwnd1,editHwnd2
	;~ targethwnd:=RisReports[1,reportType+1]
	
	loop 2 
		controlsettext,,% regexreplace(RegExReplace(controlgettext(editHwnd%a_index%),"\r|^[\n\s\t]+|[\n\s\t]{2,}$",""),"\n","`r`n") ,% "ahk_id " RisReports[1,a_index]
	
	if (clear)
		loop 2
			controlsettext,,% "",% "ahk_id " editHwnd%a_index%
}

getFromRis(){
	global RisReports,reportType,editHwnd1,editHwnd2
	loop 2  {
		controlsettext,,% t:=controlgettext(RisReports[1,a_index]),% "ahk_id " editHwnd%a_index%
		if t=
			controlsettext,,,% "ahk_id " editHwnd%a_index%
	}
}

#ifwinactive,RisTyper ahk_class AutoHotkeyGUI



undo:
focused:=guiGetFocused()
if controlgettext(editHwnd%focused%)!=reportState[focused].undoStack[reportState[focused].undoIndex].text {
	undoStacking(focused)
}
if !(reportState[focused].undoDepth>=0 && reportState[focused].undoDepth<=stacks-2)
	return
controlsettext,,% (undoState:=reportState[focused].undoStack[reportState[focused].undoIndex:=mod(reportState[focused].undoIndex-1,stacks)]).text,% "ahk_id " editHwnd%focused%
if (undoState.selStart2){
	;~ controlclick,% "x" undoState.selStart2 " y" undoState.selEnd2,ahk_id %editHwnd%
	Edit_Select(undoState.selStart2, undoState.selEnd2, editHwnd%focused%)
}else{
	;~ controlclick,% "x" undoState.selStart " y" undoState.selEnd,ahk_id %editHwnd%
	Edit_Select(undoState.selStart, undoState.selEnd, editHwnd%focused%)	
}
reportState[focused].undoDepth:=reportState[focused].undoDepth+1
return

redo:
focused:=guiGetFocused()
if (reportState[focused].undoDepth>0){
	controlsettext,,% (redoState:=reportState[focused].undoStack[reportState[focused].undoIndex:=mod(reportState[focused].undoIndex+1,stacks)]).text,% "ahk_id " editHwnd%focused%
	;~ controlclick,% "x" redoState.selStart " y" redoState.selEnd,ahk_id %editHwnd%
	Edit_Select(redoState.selStart, redoState.selEnd, editHwnd%focused%)
	reportState[focused].undoDepth:=reportState[focused].undoDepth-1
}
return


;~ tab1:
;~ sendToRis()
;~ tab2:
;~ gosub undoStacking2
;~ reportState[reportType]:={undoIndex: undoIndex, undoDepth: undoDepth, undoStack: undoStack.clone()}
;~ ,undoIndex:=reportState[!reportType].undoIndex
;~ ,undoDepth:=reportState[!reportType].undoDepth
;~ ,undoStack:=reportState[!reportType].undoStack.clone()
;~ controlsettext,,% (recoverState:=undoStack[undoIndex]).text,ahk_id %editHwnd%
;~ Edit_Select(recoverState.selStart,recoverState.selEnd,editHwnd)

;~ reportType:=!reportType
;~ gosub guiShow
;~ guicontrol,,text,% reportType?"Impression":"Exam"
;~ return

update:
sendToRis()
return

;~ tab::
;~ if(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<500){
	;~ gosub tab1
;~ }else{
	;~ send {tab}
;~ }
;~ return

next:
gosub update
controlclick,,% "ahk_id " nextHwnd
winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return
previous:
gosub update
controlclick,,% "ahk_id " previousHwnd
winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return

save1:
gosub update
controlclick,,% "ahk_id " save1Hwnd
winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return
save2:
gosub update
controlclick,,% "ahk_id " save2Hwnd
winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return
save3:
gosub update
controlclick,,% "ahk_id " save3Hwnd
winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return
clinical:
controlclick,,% "ahk_id " clinicalHwnd
;~ winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return
image:
controlclick,,% "ahk_id " imageHwnd
;~ winactivate,,% "ahk_id " RisState[2]
winactivate,,ahk_id %guiHwnd%
return

;~ ^h::
;~ msgbox % "," Edit_GetFullLine(0,1,editHwnd) ","
;~ return

resetRClick:
rClicks:=0
return

~$lbutton::
++lClicks
if (a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<300){
	settimer,resetLClicks,-300
}
if (lClicks>=3){
	lClicks:=0
	mousegetpos,,,,con,3
	Edit_SelectLine(0, true, con)
}
return

$tab::
focused:=guiGetFocused()
undoStacking(focused)
send {tab}
focused:=3-focused
if (selStart:=reportState[focused].undoStack[reportState[focused].undoIndex].selStart2) && (selEnd:=reportState[focused].undoStack[reportState[focused].undoIndex].selEnd2){
}else{
	selStart:=reportState[focused].undoStack[reportState[focused].undoIndex].selStart
	,selEnd:=reportState[focused].undoStack[reportState[focused].undoIndex].selEnd
}
Edit_Select(selStart,selEnd,editHwnd%focused%)
return


$home::
$end::
$pgup::
$pgdn::
$left::
$right::
$up::
$down::
focused:=guiGetFocused()
if  (controlgettext(editHwnd%focused%)!=reportState[focused].undoStack[reportState[focused].undoIndex].text) {
	undoStacking(focused)
}
settimer,caretMove,-50
controlsend,,% "{" substr(a_thishotkey,2) "}",% "ahk_id " editHwnd%focused%
return

resetLClicks:
lClicks:=0
return


$numpadenter::
$enter::
focused:=guiGetFocused()
Edit_GetSelection(selStart,selEnd,editHwnd%focused%)
ControlGet, line, CurrentLine,,,% "ahk_id " editHwnd%focused%
controlget,thisLine,line,% line,,% "ahk_id " editHwnd%focused%
controlget,priorLine,line,% line-1,,% "ahk_id " editHwnd%focused%
SendMessage, 0xBB, line-1, 0 ,,% "ahk_id " editHwnd%focused% ; EM_LINEINDEX
offset:=errorlevel
,allText:=controlgettext(editHwnd%focused%)
,count:=0
,texts:=[substr(allText,1,selStart),substr(alltext,selStart+1,selEnd-selStart),substr(alltext,selEnd+1)]
loop,parse,alltext,`n
{
	count+=strlen(a_loopfield)+1
	if (count>offset){
		thisLine:=a_loopfield "`n"
		break
	}else{
		priorLine:=a_loopfield "`n"
	}
}
RegExMatch(thisLine,regex:="is)^(\s*)(\d+|[\w>=*^#@-])([^\r\n\w]*)(.*)",match)
,RegExmatch(lineText:=(offset=selStart)?((match2="" || match3="")?thisLine:priorLine):thisLine,"is)^(\s*)(\d+|[\w>=*^#@-])([^\r\n\w]*)(.*)",match)
,addLine:=match1 match2 match3 
;~ if (match2!="" && match4="") {
	;~ controlsend,,% "{bs " strlen(match2)+strlen(match3) "}",ahk_id %editHwnd%
	;~ controlsend,,% "{enter}" match1,ahk_id %editHwnd%
;~ }else

if(!regexmatch(match2,"\W") && match3="" || match4="") {
	;~ controlsend,,% "{enter}",ahk_id %editHwnd%
	controlsettext,,% texts[1] "`r`n" texts[3],% "ahk_id " editHwnd%focused%
	Edit_Select(selStart+2,selEnd+2,editHwnd%focused%)
	;~ send {enter}
}else if !regexmatch(match2,"\d") {
	
	if (offset=selStart){
		;~ controlsendraw,,% match1 match2 match3,ahk_id %editHwnd%	
		;~ controlsend,,{enter},ahk_id %editHwnd%
		controlsettext,,% texts[1] addLine "`r`n" texts[3],% "ahk_id " editHwnd%focused%
		Edit_Select(selStart+2+strlen(addLine),selEnd+2+strlen(addLine),editHwnd%focused%)
	
	}else{
		;~ msgbox % match3=" "
		;~ controlsend,,{enter},ahk_id %editHwnd%
		;~ controlsendraw,,% match1 match2 match3,ahk_id %editHwnd%	
		controlsettext,,% texts[1] "`r`n" match1 match2 match3 texts[3] ,% "ahk_id " editHwnd%focused%
		Edit_Select(selStart+2+strlen(addLine),selEnd+2+strlen(addLine),editHwnd%focused%)
	
	}
		;~ send % "{enter}" match1 match2 match3
}else if regexmatch(match2,"\d") {
		settimer,numbering,-50
}else{
	controlsend,,{enter} ,% "ahk_id " editHwnd%focused%

}
undoStacking(focused)
return

numbering:
;~ Edit_GetSelection(selStart,selEnd,editHwnd)
match:="",parsed:="",number:=""

if (offset=selStart)
	allText:=texts[1] addLine "`r`n" texts[3]
else
	allText:=texts[1] "`r`n"  addLine texts[3]

loop,parse,allText,`n
{
	RegExMatch(a_loopfield,"isS)^(\s*)(\d+)([^\r\n\w]*)(.*)$",match)
	if ((match2="") || (match3="")) {
		parsed.=a_loopfield "`n"
	}else if (number=""){
			number:=match2
			parsed.=a_loopfield "`n"
	}else {
		parsed.=match1 (++number) match3 match4 "`n"
	}
}
parsed:=RegExReplace(parsed,"\r?\n$","")
controlsettext,,% parsed,% "ahk_id " editHwnd%focused%
Edit_Select(selStart+strlen(addLine)+2,selStart+strlen(addLine)+2,editHwnd%focused%)
return

;~ ~$del::
;~ ~$bs::
;~ settimer,numbering,-20
;~ return
getImageNumber:

;~ edit_getSelection(selStart,selEnd,editHwnd)
;~ ,allText:=controlgettext(editHwnd)
;~ controlsettext,,% substr(alltext,1,selStart) "SE" imageNumber[1] " IM" imageNumber[2] substr(alltext,selEnd+1)
;~ edit_select(selStart,selStart,editHwnd)
focused:=guiGetFocused()
Edit_InsertText("SE" imageNumber[1] " IM" imageNumber[2],editHwnd%focused%)
return

;~ rbutton::lbutton



#ifwinactive

sendBS:
if getkeystate("rbutton","P")
	return
undoStacking("f")
send {bs}
return

moveToList:
controlclick,,% "ahk_id " getNetControl2(RisState[2],"報告工作清單","B_ACTIVE","報告工作清單","WindowsForms10.BUTTON.app","","","",0)[1]
winactivate,,% "ahk_id " RisState[2]
controlgetpos,x,y,,,,% "ahk_id " getNetControl2(RisState[2],"","DataGridView1","DataGridView","WindowsForms10.Window.8.app","","","",0)[1]
mousemove,% x+50,% y+50,1
return

insertText:
clipboardTemp:=clipboardAll
clipboard:=""
send ^c
clipwait,0.5
Edit_InsertText(clipboard,editHwnd1)
clipboard:=clipboardTemp
return

~esc::
if !(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500)
	return
guiclose:
exitapp
return

onexit:
UnhookWindowsHookEx(hHook)
gosub update
ExitApp
return

noIdle:
if  RisState[1]!=2
	return
mousegetpos,,,win
if (win=RisState[2])
{
	mousemove,1,0,0,R
	mousemove,-1,0,0,R
}else {
	for k,v in risControls:=GetControls(RisState[2])
	if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {
		controlsend,,{space},% "ahk_id " v.Hwnd
		break
	}
}
return


getSEIM(){
	global impaxState
	impaxImageHwnd:=impaxState[2,1]
	SEIM:=getNetControl2(impaxImageHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)
	for k,v in SEIM
		if text:=controlgettext(v)
			break
	;~ controlgettext,t,,ahk_id %impaxImageHwnd%
	;~ msgbox % t
	RegExMatch(text,"i)S:\s+(\d+)\s+I:\s+(\d+)",match)
	return [match1,match2]
}