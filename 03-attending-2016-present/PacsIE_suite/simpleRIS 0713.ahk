#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
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
#include <prettyReport>
#include <Class_RichEdit>
#include <winvisible>
#include <wingetatcoords>
#include <SCI>
#include <SetTimerF>
#include <SetWindowsHookEx>
;~ runTimeBP("###")
gosub setHotkey
history:=[]
historySize:=100
historyInd:=0
onmessage(0x2021,"update")
onmessage(0x2022,"noUpdateMode")
;~ OnMessage( 0x111, "focusMsg" )
mouseHooks:=[]
monitors:=monitorInfo()
settimer,loadRisText,-1
;~ gosub update
;~ settimer,update,-1000
;~ gosub hookMouse
gosub gui
settimer,prettyReportGui,-1
settimer,autoActivate,300


;~ settimer,sizing,1000
;~ gosub windowHook
;~ settimer,caretPos,-500
settimer,updateRisAccNo,2000
settimer,setFocus,200
settimer,GrabFocus,1000
Loop, 4
{
	Gui, notify%A_Index%: -Caption +ToolWindow +AlwaysOnTOp
	Gui, notify%A_Index%: Color, white
}
;~ settimer,test,200
OnMessage( 0x200, "WM_MOUSEMOVE" ) 
return

;~ esc::ListLines


test:
ControlGetText(sci)
return	

GrabFocus:
focused:=getFocused()
if (focused=RisReports[1,1]){
	edit_getsel(RisReports[1,1],caretS,caretE)
	send {tab}
	ControlFocus,,% "ahk_id " risreports[1,2]
	winactivate,% "ahk_id " guihwnd
	controlfocus,,% "ahk_id " editHwnd
	if (!noUpdateMode){
		sci.SetSel(caretS,caretE)
		;~ Edit_ScrollCaret(editHwnd)
		sci.ScrollCaret()
	}
	newX:=a_caretx,newY:=A_CaretY+6,frame:=400
	settimer,show,-1
}
return 	

setHotkey:
if fileexist(iniFile:=a_scriptdir "/simpleRIS.ini") {
	
}else if fileexist(iniFile:=a_scriptdir "/RisHelper.ini"){
	
}

IniRead,initAtCenter,% iniFile,Setting,initAtCenter,1

iniread,focusImpressionKey,% iniFile,Hotkey,focusImpression,^space
iniread,updateTextKey,% iniFile,Hotkey,updateText,^b
iniread,resetTextKey,% iniFile,Hotkey,resetText,^n

try{
	hotkey,ifwinactive,ahk_group MyGui
	hotkey,% focusImpressionKey,focusImpression
	hotkey,% updateTextKey,updateText
	hotkey,% resetTextKey,resetText
	
	hotkey,ifwinactive
}


if winexist("ahk_exe autorun.exe") || winexist("ahk_exe PacsIE.exe")
	return
hotkey,capslock up,activateSimpleRis
settimer,setcapslockstate,500
hotkey,% "#Capslock",toggleCapslockState



iniread,sendReportKey,% iniFile,Hotkey,發送,F3
iniread,saveReportKey,% iniFile,Hotkey,存檔,F2
iniread,tempReportKey,% iniFile,Hotkey,暫存,F1


try{
	hotkey,ifwinactive,ahk_exe simpleRIS.exe
	hotkey,% sendReportKey,sendReport
	hotkey,% saveReportKey,sendReport
	hotkey,% tempReportKey,sendReport	
	hotkey,ifwinactive
}	

return

sendReport:
RisState:=RisOpened()
if(a_thishotkey="F3")
	getNetAcc(RisState[2],"cmdRunVerifySend","WindowsForms10.BUTTON.app").accDoDefaultAction()
else if(a_thishotkey="F2")
	getNetAcc(RisState[2],"cmdRunVerify","WindowsForms10.BUTTON.app").accDoDefaultAction()
else if(a_thishotkey="F1")
	getNetAcc(RisState[2],"cmdRunSave","WindowsForms10.BUTTON.app").accDoDefaultAction()
return


setcapslockstate:
SetCapslockstate,% capslockstate?"on":"off"
return

toggleCapslockState:
capslockstate:=!capslockstate
gosub setcapslockstate
return

activateSimpleRis:
;~ simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
winactivate,ahk_id %guihwnd%
settimer,setontop,-1
return

setontop:
if(A_TickCount-setontoptick)<500
	goto setontopreturn
;~ simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
IfWinNotActive,ahk_exe impax-client-main.exe
	DllCall("SetWindowPos", "UINT", guihwnd, "UINT", 0, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
	,DllCall("SetWindowPos", "UINT", guihwnd, "UINT", -1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
else 
	winset,AlwaysOnTop,Off,ahk_id %guihwnd%
	
	
	;~ ,DllCall("SetWindowPos", "UINT", impaxOpened()[2,1], "UINT", guihwnd, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
	;~ settimer,setNotOnTop,-1000

setontopreturn:
setontoptick:=A_TickCount
return
setNotOnTop:
;~ simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
winset,AlwaysOnTop,Off,ahk_id %guihwnd%
return

setFocus:
guicontrolget,guifocused,focus
if !instr(guifocused,"scintilla")
	guicontrol,focus,scintilla1
return

noUpdateMode(wParam, lParam, msg, hwnd, reactivation=-10000){
	global noUpdateMode:=lParam
	settimer,ReactivateUpdateMode,% reactivation
}
ReactivateUpdateMode:
noUpdateMode:=0
gosub update
return



#ifwinactive,ahk_exe simpleRIS.exe





F9::
F10::
insertBefore:=(a_thishotkey="F9")?1:0
sBeforeSearch:=sci.getAnchor(),eBeforeSearch:=sci.getcurrentpos()
wingetpos,x,y,w,h,ahk_id %guiHwnd%
inputbox,searchWord,Jump...,% insertBefore?"before":"after",,300,200,% x+w/2-150,% y-200
if(searchWord="")
	return
;~ sci.gettext(sci.GetTextLength()+1,text:="")
text:=ControlGetText(sci)
searchResult:=searchText(searchWord, text)
if(!searchResult.maxIndex())
	return
resultInd:=findClosedResult(searchResult, searchWordLen:=strlen(searchWord), sBeforeSearch, eBeforeSearch)
if(resultInd="")
	return
sci.Setsel(searchedPos:=(insertBefore?searchResult[resultInd]:searchResult[resultInd]+searchWordLen)-1, searchedPos)
newX:=a_caretx,newY:=A_CaretY+6,frame:=400
settimer,show,-1
return

F7::
F8::
if((searchResultCount:=searchResult.maxindex())<2)
	return
if(a_thishotkey="F7"){
	resultInd:=mod(resultInd-2+searchResultCount,searchResultCount)+1
}else{
	resultInd:=mod(resultInd,searchResultCount)+1
}
sci.Setsel(searchedPos:=(insertBefore?searchResult[resultInd]:searchResult[resultInd]+searchWordLen)-1, searchedPos)
newX:=a_caretx,newY:=A_CaretY+6,frame:=400
settimer,show,-1
return

#IfWinActive

findClosedResult(arr, len, s, e){
	min:="", minInd:=""
	for k,v in arr
		if (min="" || min<(newMin:=getMinDis(arr-s, arr-e, arr+len-s, arr+len-e)))
			min:=newMin,minInd:=k
	
	return k
}

getMinDis(param*){
	min:=""
	
	for k,v in param
		if(min="" || min<v)
			min:=v
		
	return min
		
}

searchText(findWhat, inText){
	arr:=[],i:=0,match:="0"
	findWhat:=RegExReplace(findWhat,"\W","\$0")
	
	while (i:=regexmatch(inText, "i)" findWhat, match, i+strlen(match))) {
		arr.push(i)
	}
	return arr
}

;~ #ifwinactive,ahk_group pr
~lbutton::
mousegetpos,,,win
;~ winget,processName,processName,ahk_id %win%
if !(win=prettyReportGuiHwnd || win=prettyReportGui2Hwnd)
	return
if !(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<400)
	return
gosub renewRis
gosub renewRisReports
controlsettext,,% RegExReplace(controlgettext(risreports[1,2]) controlgettext(risReports[2,2]), "\r?\n", "`r`n"),% "ahk_id " risReports[1,2]
;~ controlsettext,,% text:=controlgettext(risreports[1,1]) controlgettext(risReports[2,1]),% "ahk_id " editHwnd
sci.setText(unused, tmp:=text:=controlgettext(risreports[1,1]) controlgettext(risReports[2,1]))
controlsettext,,% RegExReplace(text, "\r?\n", "`r`n"),% "ahk_id " risReports[1,1]

return
;~ #IfWinActive

prettyReportGui:
gui,pr:default
gui,+hwndprettyReportGuiHwnd
gui,+toolwindow -caption -border  +lastfound 
gui,color,0xcdcdcd
winset,transcolor,0xcdcdcd
gui,font,s10,Verdana
RE:=new RichEdit("pr","x0 y0 w1 h1")
RE.setOptions(["readonly"])
RE.ShowScrollBar(0,false)
;~ RE.ShowScrollBar(1,true)
RE.WordWrap(1)
RE.SetDefaultFont({"Name": "Verdana"})
RE.SetParaSpacing({"After": 2})



;~ gui,show,x-1 y-1 noactivate

gui,pr2:default
gui,+hwndprettyReportGui2Hwnd
gui,+toolwindow -caption -border  +lastfound 
gui,color,0xcdcdcd
winset,transcolor,0xcdcdcd
gui,font,s10,Verdana
RE2:=new RichEdit("pr2","x0 y0 w1 h1")
RE2.setOptions(["readonly"])
RE2.ShowScrollBar(0,false)
;~ RE2.ShowScrollBar(1,true)
RE2.WordWrap(1)
RE2.SetDefaultFont({"Name": "Verdana"})
RE2.SetParaSpacing({"After": 2})


;~ gui,show,x-1 y-1 noactivate

Groupadd,pr,% "ahk_id " prettyReportGuiHwnd
Groupadd,MyGUI,% "ahk_id " prettyReportGuiHwnd
Groupadd,pr,% "ahk_id " prettyReportGui2Hwnd
Groupadd,MyGUI,% "ahk_id " prettyReportGui2Hwnd
settimer,updateHx,-1000
return

;~ runTimeBP(n){
	;~ FileAppend,% a_now ": " n "`n",% A_ScriptDir "\simpleRisBP.log",utf-8
;~ }

updateHx:
Thread,Priority,-1
if (noUpdateMode){
	gui,pr2:hide
	gui,pr:hide
	;~ winhide,ahk_id %prettyReportGui2Hwnd%
	goto updateHxEnd
	return
}
;~ runTimeBP(1)
gosub renewRis
gosub renewRisReports
wingetpos,risX,risY,,,% "ahk_id " RisState[2]
;~ runTimeBP(2)
controlgetpos,x,y,w,h,,% "ahk_id " oldReportHwnd:=risreports[2,1]
coordHwnd:=wingetatcoords(risX+x,risY+y,"ID")
oldReport:=controlgettext(oldReportHwnd)
;~ runTimeBP(3)
if !(oldReportHwnd) || !(coordHwnd=risState[2] && controlvisible(oldReportHwnd)) || (oldReport=""){
;~ msgbox % controlvisible(risreports[2,1])
;~ if !(oldReportHwnd:=risreports[2,1]) || (!controlvisible(oldReportHwnd)) {
	gui,pr2:hide
	gui,pr:hide
	;~ winhide,ahk_id %prettyReportGui2Hwnd%
	goto updateHxEnd
	return
}else{
	;~ tooltip % "show: " a_tickcount
	WinInsertAfter(prettyReportGui2Hwnd, prettyReportGuiHwnd)
	WinInsertAfter(RisState[2], prettyReport2GuiHwnd)
	gui,pr:show,NoActivate
	gui,pr2:show,NoActivate
	gosub pastHxGUIOnTop
	
}
;~ runTimeBP(4)

if((oldReport)=pOldReport)
	goto updateHxEnd

;~ gosub pastHxGUIOnTop
;~ gui,pr:show,NoActivate
;~ gui,pr2:show,NoActivate

;~ runTimeBP(5)
RE.setText(pOldReport:=oldReport)
RE.setSel(0,strlen(pOldReport))
RE.setFont({"Name": "Verdana"})
controlgetpos,x,y,w,h,,% "ahk_id " RisReports[2,1]
try
	gui,pr:show,% "x" risX+x+1 " y" risY+y+1 " w" w " h" h " noactivate"
controlmove,,,,% w,% h,% "ahk_id " RE.hwnd
;~ runTimeBP(6)

RE2.setText(txt:=controlgettext(risReports[2,2]))
RE2.setSel(0,strlen(txt))
RE2.setFont({"Name": "Verdana"})
controlgetpos,x,y,w,h,,% "ahk_id " RisReports[2,2]
;~ runTimeBP(7)
try
	gui,pr2:show,% "x" risX+x+1 " y" risY+y+1 " w" w " h" h " noactivate"
controlmove,,,,% w,% h,% "ahk_id " RE2.hwnd

colorRadReport(RE)
colorRadReport(RE2)

gosub pastHxGUIOnTop
;~ runTimeBP(8)
updateHxEnd:
settimer,updateHx,-1000
;~ runTimeBP(9)
return

pastHxGUIonTop:
;~ winOrder:=GetWindowOrder(prettyReportGuiHwnd)
;~ gosub renewRis
;~ isBeforeRIS:=0,idx:=winOrder.index
;~ for k,v in winOrder.arr
	;~ if (k>idx) && (v=RisState[2]) {
		;~ isBeforeRIS:=1
		;~ return
	;~ }
;~ winset,AlwaysOnTop,Off,simple RIS ahk_class AutoHotkeyGUI


;~ gui,pr:show,NoActivate
;~ winset,alwaysontop,on,ahk_id prettyReportGuiHwnd
;~ Sleep 100
;~ gui,pr2:show,NoActivate
;~ winset,alwaysontop,on,ahk_id prettyReportGui2Hwnd
;~ settimer,pastHxGUINotOnTop,-500
;~ gui,pr:show,NoActivate
;~ gui,pr2:show,NoActivate
;~ WinShow,% "ahk_id " prettyReportGui2Hwnd
DllCall("SetWindowPos", "UINT", prettyReportGuiHwnd, "UINT", -1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
DllCall("SetWindowPos", "UINT", prettyReportGui2Hwnd, "UINT", -1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
;~ DllCall("SetWindowPos", "UINT", RisState[2], "UINT", prettyReportGui2Hwnd, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
;~ DllCall("SetWindowPos", "UINT", RisState[2], "UINT", prettyReportGui2Hwnd, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)

return
pastHxGUINotOnTop:
winset,alwaysontop,Off,ahk_id prettyReportGuiHwnd
winset,alwaysontop,Off,ahk_id prettyReportGui2Hwnd
return

sciSettings:
; Set some options
sci.SetWrapMode(true), sci.SetLexer(SCLEX_CONTAINER), sci.StyleClearAll()
,sci.SetCodePage(65001)
,sci.AUTOCSETCASEINSENSITIVEBEHAVIOUR(1)
,sci.AUTOCSETSEPARATOR(0xA)
SciAutoCompleteList=


; Change a style
sci.SETSELALPHA(100)
,sci.SETCARETWIDTH(2)
;~ sci.StyleSetBack(32, 0x000000)
sci.StyleSetFore(SCLEX_CONTAINER, 0xDDDDDD), sci.StyleSetBack(SCLEX_CONTAINER, 0x000000), sci.StyleSetBold(SCLEX_CONTAINER, false), sci.StyleSetFont(SCLEX_CONTAINER, "Georgia"), sci.StyleSetSize(SCLEX_CONTAINER, 14)
,sci.StyleSetFore(STYLE_DEFAULT, 0xDDDDDD), sci.StyleSetBack(STYLE_DEFAULT, 0x000000), sci.StyleSetBold(STYLE_DEFAULT, false), sci.StyleSetFont(STYLE_DEFAULT, "Georgia"), sci.StyleSetSize(STYLE_DEFAULT, 14)
,sci.StyleSetFore(SCE_AHKL_USERDEFINED1, 0xFFFFFF), sci.StyleSetBack(SCE_AHKL_USERDEFINED1, 0x000000), sci.StyleSetBold(SCE_AHKL_USERDEFINED1, true), sci.StyleSetFont(SCE_AHKL_USERDEFINED1, "Georgia"), sci.StyleSetSize(SCE_AHKL_USERDEFINED1, 13)
,sci.SetCaretFore(0xFFFFFF)
,sci.SetText(unused, ""),  sci.GrabFocus(), sci.SetMarginWidthN(1,0)
sr:=new StyleRange(""), sci.Notify:="Notify"
return
Notify(wParam, lParam, msg, hwnd, obj){
    global sci,SciAutoCompleteList,sr, DoNotTriggerModified,AccNoHwnd,thisAccNo,priorAccNo
    if (obj.scnCode = SCN_MODIFIED){
		SetTimer,SCI_ColorRadReport, -1000
		settimer,update,-2000
		settimer,setontop,-500
		if (priorAccNo!=thisAccNo)
			priorAccNo:=thisAccNo:=ControlGetText(AccNoHwnd)
    }
    ;~ if (obj.scnCode = SCN_CHARADDED && SciAutoCompleteList!="" ){
        ;~ currentPos:=sci.GetCurrentPos()
        ;~ wordStartPos := sci.WordStartPosition(currentPos,true)
        ;~ if((len:=currentPos - wordStartPos)>0)
            ;~ SetTimerF("AutoComplete",-300,[len])
        ;~ else
            ;~ SetTimerF("AutoComplete",0)
    ;~ }
    return
}
updateToRis:
;~ sci.gettext(sci.gettextLength()+1,text:="")
text:=ControlGetText(sci)
Edit_SetText(RisReports[1,1], text)
Edit_SetSel(RisReports[1,1], sci.getAnchor(), sci.GetCurrentPos())
return
SCI_ColorRadReport:
if (!noUpdateMode){
	;~ DoNotTriggerModified:=1
	;~ SetTimer,SCI_ColorRadReport, Off
	;~ settimer,update,Off
	sci.Notify:=""
	SCI_ColorRadReport(sci,sr,0)
	sci.Notify:="Notify"
}
return
AutoComplete(len){
    global
    sci.AutoCShow(len, lst:=SciAutoCompleteList)
}

gui:
gui,1:default
gui,+hwndguiHwnd 
groupadd,MyGui,ahk_id %guiHwnd%
gui,+toolwindow -caption
gui,color,,black
gui,font,s14 csilver,Georgia
gui,add,button,w0 h0 gnothing
sci := new scintilla
sci.Add(guihwnd,5,5,1000,300)
gosub sciSettings
;~ gui,add,edit,xp yp vedit w1000 h300 hwndeditHwnd,
;~ gui,add,edit,vedit2 w1000 h0 hwndedit2Hwnd,
if !initAtCenter
	gui,show,% "x" monitors.2.l+Floor(monitors.2.w/2)-505 " y" monitors.2.b-150 " w1010 h310",simple RIS
else if monitors.maxindex()=1
	gui,show,% "x" Floor(a_screenwidth/2)-500 " y" a_screenheight-310 " w1010 h310",simple RIS
else
	gui,show,% "x" monitors.2.l+Floor(monitors.2.w/2)-505 " y" Floor(monitors.2.b/2)-155 " w1010 h310",simple RIS
controlget,editHwnd,hwnd,,scintilla1,% "ahk_id " guihwnd
;~ if(monitors.maxindex()<3){
	;~ guicontrol,-redraw,% editHwnd
	;~ redraw:=0
	;~ settimer,editRedraw,5
;~ }
return

nothing:
return

editRedraw:
;~ guicontrol,% ((redraw:=!redraw)?"+":"-") "redraw",% editHwnd
return

caretPos:
if(selectAll){
	selectAll:=0
	;~ settimer,caretPos,-5000
	return
}else if ((editText:=controlgettext(editHwnd))!="") {
	;~ Edit_GetSel(editHwnd,cStart,cEnd)
	cStart:=sci.getAnchor(),cEnd:=sci.GetCurrentPos()
	if(cStart=0 && cEnd=strlen(editText) && pStart!="" && pEnd!="" && winactive("ahk_id " guiHwnd)){
		sci.SetSel(pStart,pEnd)
	}else{
		pStart:=cStart,pEnd:=cEnd
	}
}
;~ settimer,caretPos,-500
return

focusEdit:
if(winactive("ahk_id " guiHwnd)){
	guicontrolget,focused,Focus
	if (focused!="Scintilla1"){
		guicontrol,Focus,scintilla1
	}
}

return


sizing:

return

focusMsg(p_w, p_l, p_m, p_hw){
	global editHwnd
	; EN_KILLFOCUS
	if ( p_w & 0x2000000 ){
		if(p_l=editHwnd){
			controlfocus,,ahk_id %editHwnd%
		}
	}
}


update(){
	gosub update
}

windowHook:
;~ DllCall( "RegisterShellHookWindow", UInt, guiHwnd )
;~ MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
;~ OnMessage( MsgNum, "ShellMessage" )
return

#ifwinactive,ahk_exe Menu.exe
~lbutton::
if(a_priorhotkey=a_thishotkey && a_timesincepriorhotkey<500){
	;~ settimer,update,Off
	sleep 500
	gosub renewRIs
	gosub renewRisReports
	;~ controlsettext,,% controlgettext(RisReports[1,1]),% "ahk_id " editHwnd
	sci.SetText(unused, tmp:=controlgettext(RisReports[1,1]))
	;~ settimer,update,-2000
}
settimer,updateHx,-100
return

;~ ~^b::
;~ gosub renewRis
;~ gosub renewRisReports
;~ if(getFocused()!=RisReports[1,1])
	;~ return

;~ return

#ifwinactive

#ifwinexist,ahk_ex Menu.exe
~^up::
~^down::
settimer,updateHx,-500
return
#IfWinExist

#ifwinactive,simple RIS ahk_class AutoHotkeyGUI
;~ ~lbutton::
;~ gosub unhookMouse
;~ OnMessage( 0x200, "WM_MOUSEMOVE" ) 
;~ return

;~ ~lbutton up::
;~ OnMessage( 0x200, "" ) 
;~ return

#IfWinActive

#ifwinactive,ahk_group MyGui
resetText:
;~ ^n::
if(A_PriorHotkey = A_ThisHotkey && A_TimeSincePriorHotkey < 500)
	controlsettext,,,% "ahk_id " RisReports[1,1]
gosub renewRis
gosub renewRisReports
;~ controlsettext,,,% "ahk_id " editHwnd
gosub resetEdit
;~ controlsettext,,,% "ahk_id " RisReports[1,1]
return
updateText:
;~ ^b::
gosub update
;~ gosub loadRisText
return


;~ ~rbutton::
;~ keywait, rbutton, t0.3
;~ if errorlevel = 1
;~ {
	;~ gosub loadRisText
;~ }

;~ ~^a::
;~ selectAll:=1
;~ return


focusImpression:
;~ ^space::
;~ if !(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<400)
	;~~ return
gosub renewRis
gosub renewRisReports
focusImpression:=1
gosub update
controlfocus,,% "ahk_id " RisReports[1,2]
winactivate,% "ahk_id " RisState[2]
controlfocus,,% "ahk_id " RisReports[1,2]
return

F11::
F12::
gosub PacsIEnextStudy
if !winexist("ahk_exe PacsIE.exe")
	gosub RisNextStudy
;~ controlsettext,,% "",ahk_id %editHwnd%
gosub resetEdit
;~ sci.clearAll()
;~ priorAccNo:=""
;~ settimer,update,-2000
settimer,updateHx,-3000
return

;~ F11::
;~ gosub PacsIEnextStudy
;~ return

;~ ~Enter::
;~ ~numpadEnter::
;~ ~,::
;~ ~.::
;~ ~:::
;~ ~;::
;~ ~-::
;~ ~)::
;~ ~pgup::
;~ ~pgdn::
;~ ~space::
;~ gosub update
;~ return


~F3::
;~ ~F12::
;~ ~F11::
~F1::
settimer,resetEdit,-500
settimer,updateHx,-3000
return

~#up::
~#down::
historyInd:=mod(historyInd + (instr(a_thishotkey,"up")?(historySize-1):1), historySize)
;~ controlsettext,,% history[mod(historyInd-1,historySize)+1],ahk_id %editHwnd%
sci.SetText(unused, tmp:=history[mod(historyInd,historySize)])
tooltip,% "Stored report #" historyInd+1
settimer,tooltip,-1000
return

#ifwinactive

tooltip:
ToolTip
return

RisNextStudy:
getNetAcc(RisState[2],instr(a_thishotkey,"F12")?"cmdRunNext":"cmdRunFoword","WindowsForms10.BUTTON").accDoDefaultAction()
return

resetEdit:
;~ text2:=controlgettext(editHwnd)
;~ noUpdateMode(0, 1, 0x2022, guihwnd, -2000)
;~ settimer,update,-2000
;~ ToolTip % sci.GetTextLength()+1
;~ text2:=""
;~ sci.gettext(sci.GetTextLength()+1,text2)
;~ if(text2!="" && text2!=history[historyInd])
	;~ history[mod((++historyInd)-1,historySize)+1]:=text2
;~ controlsettext,,% "",ahk_id %editHwnd%
;~ DoNotTriggerModified:=1
SetTimer,SCI_ColorRadReport, Off
settimer,update,Off
sci.Notify:=""
,sci.ClearAll()
,sci.Notify:="Notify"
;~ sci.SetText(unused, text:="")
;~ priorAccNo:=""
return

PacsIEnextStudy:
wingettitle,title,PacsIE Log GUI ahk_exe PacsIE.exe
regexmatch(title,"PacsIE Log GUI (\w+):",pacsIeHwnd)
sendmessage,% a_thishotkey="F12"?0______:0______,,,,ahk_id %pacsIeHwnd1%
return

#ifwinactive,ahk_exe Menu.exe
~rbutton::
keywait, rbutton, t0.3
if errorlevel = 1
{
	gosub update
}
return

~F3::
~+F3::
~F4::
~F2::
~F12::
~F11::
~F1::
~+F1::
settimer, resetEdit,-500
;~ settimer,update,-2000
return
#ifwinactive

checkActive:
if !winactive("ahk_id " guihwnd) && !hooked
 	gosub hookMouse
return

~#!q::
if(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<300)
;~ esc::
	exitapp

hookMouse:
;~ OnMessage( 0x200, "" ) 
mouseHooks.push(SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast")))
;~ hooked:=1
return


autoActivate:
	;~ global prettyReportGuiHwnd,prettyReportGui2Hwnd
	;~ static pMouseOverWin,MouseOverWin,lastActivateWin
	if getkeystate("Lbutton") || getkeystate("Rbutton") || getkeystate("Mbutton")
		return
	mousegetpos,,,MouseOverWin
	
	winget,processName,processName,ahk_id %MouseOverWin%
	if(ProcessName="Menu.exe" && (pMouseOverWin=prettyReportGui2Hwnd || pMouseOverWin=prettyReportGuiHwnd))
		winactivate,ahk_id %MouseOverWin%
	else if (MouseOverWin=prettyReportGui2Hwnd || MouseOverWin=prettyReportGuiHwnd) && (pProcessName="Menu.exe") {
		winactivate,ahk_id %MouseOverWin%
	
	;~ if(pMouseOverWin!=MouseOverWin){
		;~ if(processName="simpleRIS.exe"){
			;~ winget,lastActivateWin,id,A
			;~ winactivate,ahk_id %MouseOverWin%
		;~ }
		;~ else if (lastActivateWin){
			;~ winactivate,ahk_id %lastActivateWin%
			;~ lastActivateWin:=0
		;~ }
	}
	pMouseOverWin:=MouseOverWin
	pProcessName:=ProcessName
	
	winget,activeWin,id,A
	winget,ActiveProcessName,ProcessName,ahk_id %activeWin%
	if(pActiveWin!=activeWin){
		if(activeWin=risopened()[2])
			gosub update
		else if (activeWin=guihwnd)
			winset,AlwaysOnTop,on,ahk_id %guihwnd%
		else if (ActiveProcessName="impax-client-main.exe"){
			winset,AlwaysOnTop,Off,ahk_id %guihwnd%
			DllCall("SetWindowPos", "UINT", guihwnd, "UINT", 1, "INT", 0, "INT", 0, "INT", 0, "INT", 0, "UINT", 0x0013)
		}
	}
	pActiveWin:=activeWin
	
	
	
	
return

unhookMouse:
for k,v in mouseHooks
	UnhookWindowsHookEx(v)
;~ mouseHooks:=[]
;~ hooked:=0
return

onexit:
noUpdateMode:=0
gosub update
;~ gosub unhookMouse
;~ ListLines
;~ Sleep 10000
;~ runTimeBP("---")
exitapp
return


AddHistory(text){
	global history, historyInd, historySize
	if(text!="" && text!=history[Mod(historyInd, historySize)])
		history[mod((++historyInd),historySize)]:=text
}
	

loadRisText:
gosub renewRis
gosub renewRisReports

;~ text2:=controlgettext(editHwnd)
;~ sci.gettext(sci.GetTextLength()+1,text2:="")

AddHistory(text2:=ControlGetText(sci))

;~ controlsettext,,% text:=controlgettext(RisReports[1,1]),% "ahk_id " editHwnd
sci.SetText(unused, tmp:=text:=controlgettext(RisReports[1,1]))
sci.SetSel(len:=strlen(text),len)
;~ Edit_ScrollCaret(editHwnd)
sci.ScrollCaret()
return

updateRisAccNo:
gosub renewRis
gosub renewRisReports
gosub renewAccNo
thisAccNo:=controlgettext(AccNoHwnd)
;~ if(priorAccNo && thisAccNo!=priorAccNo){
	;~ controlsettext,,,% "ahk_id " editHwnd
	;~ if(++updateAccNoCount>2)
	
		;~ gosub resetEdit
		;~ updateAccNoCount:=0
;~ }
;~ priorAccNo:=thisAccNo
return

getFocused(){
	static GuiThreadInfoSize = 48
	VarSetCapacity(GuiThreadInfo, GuiThreadInfoSize)
	NumPut(GuiThreadInfoSize, GuiThreadInfo, 0)
	DllCall("GetGUIThreadInfo", uint, 0, str, GuiThreadInfo)
	return FocusedHWND := NumGet(GuiThreadInfo, 12)  ; Retrieve the hwndFocus field from the struct.
}

show:
if (frame<20){
	settimer,show,off
	settimer,hide,-1
	return
}
cornerX1:=floor(newX-frame/2),cornerY1:=floor(newY-frame/2)
,cornerX2:=floor(newX+frame/2),cornerY2:=floor(newY+frame/2)
Gui, notify1: Show, % "x" cornerX1 " y" cornerY1 " w" frame " h2 NoActivate"
Gui, notify4: Show, % "x" cornerX1 " y" cornerY2 " w" frame " h2 NoActivate"
Gui, notify2: Show, % "x" cornerX1 " y" cornerY1 " w2 h" frame " NoActivate"
Gui, notify3: Show, % "x" cornerX2 " y" cornerY1 " w2 h" frame " NoActivate"
frame:=floor(frame/2)
settimer,show,-50

return


hide:
loop 4
	gui, notify%a_index%:hide
return

;~ f::
update:
critical
if (noUpdateMode)
	return
gosub renewRis
gosub renewRisReports
gosub renewAccNo

;~ if controlgettext(editHwnd)=""
	;~ msgbox 
thisAccNo:=controlgettext(AccNoHwnd)
text1:=controlgettext(risreports[1,1])
;~ text2:=controlgettext(editHwnd)
;~ ToolTip % textLen:=sci.GetTextLength()
;~ ToolTip % "Get Text"
text2:=RegExReplace(sciText:=ControlGetText(sci), "\r?\n","`r`n")
if(sciText!=text2){
	pos:=sci.GetCurrentPos()
	sci.SetText(unused, tmp:=text2)
	sci.SetSel(len:=StrLen(RegExReplace(SubStr(sciText,1,pos),"\r?\n","`r`n")), len)
	
}
;~ sci.gettext(sci.GetTextLength()+1,text2)
;~ if winactive(RisState[2]){
	;~ if (text1!=text2) && !(trim(text2)=""){
		;~ controlsettext,,% text,% "ahk_id "editHwnd
		;~ sci.SetSel(len:=strlen(text),len)
		;~ Edit_ScrollCaret(editHwnd)
	;~ }
;~ }else {

;~ if(InStr(text2,"AA"))
	;~ aaaaa:=1
;~ thisAccNo:=ControlGetText(AccNoHwnd)
if(priorAccNo!=thisAccNo){
	gosub resetEdit
	text2:=""
	if(!waitAndUpdate){
		waitAndUpdate:=1
		settimer,update,-1000
		goto updateEnd
	}else{
		waitAndUpdate:=0
	}
}
	
StringCaseSense,on
;~ if(priorAccNo!=thisAccNo && text1!=text2){
if(text1!="" && text2=""){
	;~ if(text2!="")
		;~ clipboard:=text2
		
	;~ AddHistory(text2)
	;~ controlsettext,,% text1,% "ahk_id " editHwnd
	;~ DoNotTriggerModified:=1
	;~ SetTimer,SCI_ColorRadReport, Off
	;~ settimer,update,Off	
	sci.Notify:=""
	sci.SetText(unused, tmp:=text1)
	Edit_getsel(RisReports[1,1],caretS,caretE)
	sci.SetSel(caretS,caretE)
	Edit_ScrollCaret(editHwnd)
	gosub SCI_ColorRadReport
	sci.Notify:="Notify"
	;~ sci.ScrollCaret()
;~ }else if(text2!="" && text1!=text2){
}else if(text1!=text2 ){
	;~ if(text1!="")
		;~ clipboard:=text1
	AddHistory(text1)
	
	controlsettext,,% text2,% "ahk_id " RisReports[1,1]
	Edit_getsel(editHwnd,caretS,caretE)
	Edit_Setsel(RisReports[1,1],caretS,caretE)
	Edit_ScrollCaret(RisReports[1,1])
}
StringCaseSense,Off	
;~ if winactive("ahk_id " RisState[2]) {
	;~ if (risreports[1,1]=getFocused()) {
		;~ if (text2="" && text1!="")
			;~ sci.SetText(unused, text1)
		;~ edit_getsel(RisReports[1,1],caretS,caretE)
		;~ send {tab}
		;~ ControlFocus,,% "ahk_id " risreports[1,2]
		;~ winactivate,% "ahk_id " guihwnd
		;~ controlfocus,,% "ahk_id " editHwnd
		;~ sci.SetSel(caretS,caretE)
		;~ sci.ScrollCaret()
		;~ newX:=a_caretx,newY:=A_CaretY+6,frame:=400
		;~ settimer,show,-1
	;~ }
;~ }

	;~ if !((text:=controlgettext(editHwnd))=controlgettext(RisReports[1,1])) && !(trim(text)="") {
		
		;~ if (!priorAccNo || priorAccNo=thisAccNo){
		
			;~ controlsettext,,% text,% "ahk_id " RisReports[1,1]
			;~ Edit_SetSel(RisReports[1,1],len:=strlen(text),len)
			;~ Edit_ScrollCaret(RisReports[1,1])
		;~ }else if (controlgettext(RisReports[1,1])=""){
			;~ controlsettext,,% "",% "ahk_id " editHwnd
		;~ }
		
	;~ }else if (trim(text)=""){
		;~ controlsettext,,% controlgettext(RisReports[1,1]),ahk_id %editHwnd%
	;~ }
;~ }
updateEnd:
priorAccNo:=thisAccNo
;~ if (trim(text)="" && !winexist("ahk_exe PacsIE.exe")){
	;~ settimer,update,-1000
;~ }else{
	;~ settimer,update,-2000
;~ }
;~ ToolTip

;~ settimer,update,-1000
return

renewAccNo:
if (!AccNoHwnd || !controlexist(AccNoHwnd))
	AccNoHwnd:=getRisAccNoHwnd(RisState[2])

return

renewRis:
RisState:=risopened()
return

renewRisReports:
if !(isobject(risReports) && controlexist(RisReports[1,1]))
	RisReports:=getRisReports(RisState[2])
return

WM_MOUSEMOVE( wparam, lparam, msg, hwnd ){
	global prettyReportGui2Hwnd, prettyReportGuiHwnd
	if (wparam = 1){ ; LButton
		mousegetpos,,,,con
		if !instr(con,"Scintilla")
			PostMessage, 0xA1, 2,,, A ;WM_NCLBUTTONDOWN
		else
			onmessage(0x200,"")
	}
	;~ if (hwnd=prettyReportGui2Hwnd || hwnd=prettyReportGuiHwnd) {
		;~ if !WinActive("ahk_id " hwnd)
			;~ WinActivate,% "ahk_id " hwnd
	;~ }
	
	
}
ShellMessage(wParam, lParam){
	if(wParam=4){
		WinGetClass,winClass,ahk_id %lParam%
		;~ tooltip % winClass
	}
}
activateImpax:
mousegetpos,mx,my,mWin
winget,mProcName,ProcessName,ahk_id %mWin%
if (mProcName="impax-client-main.exe")
	winactivate,ahk_id %mWin%
return

activateGUI:
mousegetpos,mx,my
wingetpos,x,y,w,h,ahk_id %guihwnd%
if (mx>=x && mx<x+w && my>=y && my<y+h)
	winactivate,ahk_id %guihwnd%
return

