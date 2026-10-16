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

#include <risimpax>
#include <prettyReport>
#include <Class_RichEdit>
#include <winvisible>
#include <wingetatcoords>

;~ gosub setHotkey
history:=[]
historySize:=100
historyInd:=1
onmessage(0x2021,"update")
onmessage(0x2022,"noUpdateMode")
;~ OnMessage( 0x111, "focusMsg" )
mouseHooks:=[]
monitors:=monitorInfo()
settimer,loadRisText,-1
;~ gosub update
;~ settimer,update,-5000
;~ gosub hookMouse
gosub gui
;~ settimer,prettyReportGui,-1
settimer,autoActivate,300


;~ settimer,sizing,1000
;~ gosub windowHook
settimer,caretPos,-500
;~ settimer,updateRisAccNo,2000
settimer,setFocus,200

Loop, 4
{
	Gui, notify%A_Index%: -Caption +ToolWindow +AlwaysOnTOp
	Gui, notify%A_Index%: Color, white
}


return

setHotkey:
if fileexist(iniFile:=a_scriptdir "/simpleRIS.ini") {
	
}else if fileexist(iniFile:=a_scriptdir "/RisHelper.ini"){
	
}
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
gosub update
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
simpleRis:=winexist("simple RIS ahk_class AutoHotkeyGUI")
winactivate,ahk_id %simpleRis%
return

setFocus:
guicontrolget,focused,focus
if instr(focused,"button")
	guicontrol,focus,Edit1
return

noUpdateMode(wParam, lParam, msg, hwnd){
	global noUpdateMode:=lParam
	settimer,ReactivateUpdateMode,-120000
}
ReactivateUpdateMode:
noUpdateMode:=0
gosub update
return

#ifwinactive,ahk_exe simpleRIS.exe





F9::
F10::
insertBefore:=(a_thishotkey="F9")?1:0
Edit_getsel(editHwnd,sBeforeSearch,eBeforeSearch)
wingetpos,x,y,w,h,ahk_id %guiHwnd%
inputbox,searchWord,Jump...,% insertBefore?"before":"after",,300,200,% x+w/2-150,% y-200
if(searchWord="")
	return
searchResult:=searchText(searchWord, controlgettext(editHwnd))
if(!searchResult.maxIndex())
	return
resultInd:=findClosedResult(searchResult, searchWordLen:=strlen(searchWord), sBeforeSearch, eBeforeSearch)
if(resultInd="")
	return
Edit_Setsel(editHwnd, searchedPos:=(insertBefore?searchResult[resultInd]:searchResult[resultInd]+searchWordLen)-1, searchedPos)
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
Edit_Setsel(editHwnd, searchedPos:=(insertBefore?searchResult[resultInd]:searchResult[resultInd]+searchWordLen)-1, searchedPos)
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
controlsettext,,% controlgettext(risreports[1,2]) controlgettext(risReports[2,2]),% "ahk_id " risReports[1,2]
controlsettext,,% text:=controlgettext(risreports[1,1]) controlgettext(risReports[2,1]),% "ahk_id " editHwnd
controlsettext,,% text,% "ahk_id " risReports[1,1]

return
;~ #IfWinActive

prettyReportGui:
gui,pr:default
gui,+hwndprettyReportGuiHwnd
gui,+toolwindow -caption -border +AlwaysOnTop +lastfound
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
gui,+toolwindow -caption -border +AlwaysOnTop +lastfound
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
Groupadd,pr,% "ahk_id " prettyReportGuiHwnd2
Groupadd,MyGUI,% "ahk_id " prettyReportGuiHwnd2
settimer,updateHx,1000
return

updateHx:
if (noUpdateMode){
	gui,pr2:hide
	gui,pr:hide
	;~ winhide,ahk_id %prettyReportGui2Hwnd%
	goto updateHxEnd
	return
}
gosub renewRis
gosub renewRisReports
wingetpos,risX,risY,,,% "ahk_id " RisState[2]
controlgetpos,x,y,w,h,,% "ahk_id " oldReportHwnd:=risreports[2,1]
coordHwnd:=wingetatcoords(risX+x,risY+y,"ID")
oldReport:=controlgettext(oldReportHwnd)
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
	gosub pastHxGUIOnTop
	gui,pr:show,NoActivate
	gui,pr2:show,NoActivate
	
}
if((oldReport)=pOldReport)
	goto updateHxEnd

gosub pastHxGUIOnTop
RE.setText(pOldReport:=oldReport)
RE.setSel(0,strlen(pOldReport))
RE.setFont({"Name": "Verdana"})
controlgetpos,x,y,w,h,,% "ahk_id " RisReports[2,1]
try
	gui,pr:show,% "x" risX+x+1 " y" risY+y+1 " w" w " h" h " noactivate"
controlmove,,,,% w,% h,% "ahk_id " RE.hwnd


RE2.setText(txt:=controlgettext(risReports[2,2]))
RE2.setSel(0,strlen(txt))
RE2.setFont({"Name": "Verdana"})
controlgetpos,x,y,w,h,,% "ahk_id " RisReports[2,2]
try
	gui,pr2:show,% "x" risX+x+1 " y" risY+y+1 " w" w " h" h " noactivate"
controlmove,,,,% w,% h,% "ahk_id " RE2.hwnd

colorRadReport(RE)
colorRadReport(RE2)
updateHxEnd:
settimer,updateHx,1000
return

pastHxGUIonTop:
winset,alwaysontop,on,ahk_group pr
settimer,pastHxGUINotOnTop,-500
return
pastHxGUINotOnTop:
winset,alwaysontop,off,ahk_group pr
return


gui:
gui,1:default
gui,+hwndguiHwnd
groupadd,MyGui,ahk_id %guiHwnd%
gui,+toolwindow -caption
gui,color,,black
gui,font,s14 csilver,Georgia
gui,add,button,w0 h0 gnothing
gui,add,edit,xp yp vedit w1000 h300 hwndeditHwnd,
;~ gui,add,edit,vedit2 w1000 h0 hwndedit2Hwnd,

if monitors.maxindex()=1
	gui,show,% "autosize x" Floor(a_screenwidth/2)-500 " y" a_screenheight-320,simple RIS
else
	gui,show,% "autosize x" monitors.2.l+Floor(monitors.2.w/2)-500 " y" monitors.2.b-320,simple RIS

;~ if(monitors.maxindex()<3){
	;~ guicontrol,-redraw,% editHwnd
	;~ redraw:=0
	;~ settimer,editRedraw,500
;~ }
return

nothing:
return

editRedraw:
guicontrol,% ((redraw:=!redraw)?"+":"-") "redraw",% editHwnd
return

caretPos:
if(selectAll){
	selectAll:=0
	settimer,caretPos,-5000
	return
}else if ((editText:=controlgettext(editHwnd))!="") {
	Edit_GetSel(editHwnd,cStart,cEnd)
	if(cStart=0 && cEnd=strlen(editText) && pStart!="" && pEnd!="" && winactive("ahk_id " guiHwnd)){
		Edit_SetSel(editHwnd,pStart,pEnd)
	}else{
		pStart:=cStart,pEnd:=cEnd
	}
}
settimer,caretPos,-500
return

focusEdit:
if(winactive("ahk_id " guiHwnd)){
	guicontrolget,focused,Focus
	if (focused!="Edit1"){
		guicontrol,Focus,edit
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
	settimer,update,off
	sleep 500
	gosub renewRIs
	gosub renewRisReports
	controlsettext,,% controlgettext(RisReports[1,1]),% "ahk_id " editHwnd
	settimer,update,-5000
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
~lbutton::
;~ gosub unhookMouse
OnMessage( 0x200, "WM_MOUSEMOVE" ) 
return

~lbutton up::
OnMessage( 0x200, "" ) 
return

#IfWinActive

#ifwinactive,ahk_group MyGui
resetText:
;~ ^n::
gosub renewRis
gosub renewRisReports
;~ controlsettext,,,% "ahk_id " editHwnd
gosub resetEdit
controlsettext,,,% "ahk_id " RisReports[1,1]
return
updateText:
;~ ^b::
gosub loadRisText
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
controlsettext,,% "",ahk_id %editHwnd%
priorAccNo:=""
;~ settimer,update,-1500
settimer,updateHx,-2000
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
settimer,updateHx,-2000
return

~#up::
~#down::
historyInd:=mod(historyInd + (instr(a_thishotkey,"up")?(historySize-1):1), historySize)
controlsettext,,% history[mod(historyInd-1,historySize)+1],ahk_id %editHwnd%
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
text2:=controlgettext(editHwnd)
if(text2!="" && text2!=history[historyInd])
	history[mod((++historyInd)-1,historySize)+1]:=text2
controlsettext,,% "",ahk_id %editHwnd%
priorAccNo:=""
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
~F4::
~F2::
~F12::
~F11::
~F1::
settimer, resetEdit,-500
;~ settimer,update,-1500
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
	if(pMouseOverWin!=MouseOverWin){
		if(processName="simpleRIS.exe"){
			winget,lastActivateWin,id,A
			winactivate,ahk_id %MouseOverWin%
		}else if (lastActivateWin){
			winactivate,ahk_id %lastActivateWin%
			lastActivateWin:=0
		}
	}
	pMouseOverWin:=MouseOverWin
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
exitapp
return


loadRisText:
gosub renewRis
gosub renewRisReports

text2:=controlgettext(editHwnd)
if(text2!="" && text2!=history[historyInd])
	history[mod((++historyInd)-1,historySize)+1]:=text2

controlsettext,,% text:=controlgettext(RisReports[1,1]),% "ahk_id " editHwnd
Edit_SetSel(editHwnd,len:=strlen(text),len)
Edit_ScrollCaret(editHwnd)
return

updateRisAccNo:
thisAccNo:=controlgettext(AccNoHwnd)
if(priorAccNo && thisAccNo!=priorAccNo){
	controlsettext,,,% "ahk_id " editHwnd
}
priorAccNo:=thisAccNo
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
text2:=controlgettext(editHwnd)
;~ if winactive(RisState[2]){
	;~ if (text1!=text2) && !(trim(text2)=""){
		;~ controlsettext,,% text,% "ahk_id "editHwnd
		;~ Edit_SetSel(editHwnd,len:=strlen(text),len)
		;~ Edit_ScrollCaret(editHwnd)
	;~ }
;~ }else {

if(priorAccNo!=thisAccNo && text1!=text2){
	;~ if(text2!="")
		;~ clipboard:=text2
		
	if(text2!="" && text2!=history[historyInd])
		history[mod((++historyInd)-1,historySize)+1]:=text2
	controlsettext,,% text1,% "ahk_id " editHwnd
	Edit_getsel(RisReports[1,1],caretS,caretE)
	Edit_Setsel(editHwnd,caretS,caretE)
	Edit_ScrollCaret(editHwnd)
}else if(text2!="" && text1!=text2){
	;~ if(text1!="")
		;~ clipboard:=text1
	if(text1!="" && text1!=history[historyInd])
		history[mod((++historyInd)-1,historySize)+1]:=text1
		
	controlsettext,,% text2,% "ahk_id " RisReports[1,1]
	;~ Edit_getsel(editHwnd,caretS,caretE)
	;~ Edit_Setsel(RisReports[1,1],caretS,caretE)
	;~ Edit_ScrollCaret(RisReports[1,1])
}
	
;~ msgbox % winactive(RisState[2])
if winactive("ahk_id " RisState[2]) {
	;~ msgbox % getFocused() "," risreports[1,1]
	if (risreports[1,1]=getFocused()) {
		if (text2="" && text1!="")
			controlsettext,,% text1,% "ahk_id " editHwnd
		edit_getsel(RisReports[1,1],caretS,caretE)
		send {tab}
		ControlFocus,,% "ahk_id " risreports[1,2]
		winactivate,% "ahk_id " guihwnd
		controlfocus,,% "ahk_id " editHwnd
		Edit_Setsel(editHwnd,caretS,caretE)
		Edit_ScrollCaret(editHwnd)
		newX:=a_caretx,newY:=A_CaretY+6,frame:=400
		settimer,show,-1
	}
}

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
priorAccNo:=thisAccNo
;~ if (trim(text)="" && !winexist("ahk_exe PacsIE.exe")){
	;~ settimer,update,-3000
;~ }else{
	settimer,update,-5000
;~ }
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
	if (wparam = 1){ ; LButton
		mousegetpos,,,,con
		if !instr(con,"edit")
			PostMessage, 0xA1, 2,,, A ;WM_NCLBUTTONDOWN
		else
			onmessage(0x200,"")
	}
	if !winactive("ahk_id " hwnd)
		winactivate,ahk_id %hwnd%
	
	
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

