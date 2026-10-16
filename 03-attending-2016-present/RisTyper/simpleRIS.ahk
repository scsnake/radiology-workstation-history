#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
SetBatchLines, -1
coordMode,mouse,screen

DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
comobjerror(false)
onexit,onexit
#NoTrayIcon

#include <risimpax>

onmessage(0x2021,"update")
onmessage(0x2022,"noUpdateMode")
;~ OnMessage( 0x111, "focusMsg" )
mouseHooks:=[]
monitors:=monitorInfo()
settimer,loadRisText,-1
settimer,update,-3000
;~ gosub hookMouse
gosub gui
;~ settimer,sizing,1000
;~ gosub windowHook
settimer,caretPos,-500
;~ settimer,updateRisAccNo,2000
return


noUpdateMode(wParam, lParam, msg, hwnd){
	global noUpdateMode:=lParam
	settimer,ReactivateUpdateMode,-120000
}
ReactivateUpdateMode:
noUpdateMode:=0
gosub update
return

gui:
gui,+hwndguiHwnd
groupadd,MyGui,ahk_id %guiHwnd%
gui,+toolwindow -caption
gui,color,,black
gui,font,s14 csilver,Georgia
gui,add,edit,vedit w1000 h300 hwndeditHwnd,
;~ gui,add,edit,vedit2 w1000 h0 hwndedit2Hwnd,

gui,show,% "autosize x" monitors.2.l+200 " y" monitors.2.b-320,simple RIS


return

caretPos:
if(selectAll){
	selectAll:=0
	settimer,caretPos,-2000
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
	sleep 100
	gosub renewRIs
	gosub renewRisReports
	controlsettext,,% controlgettext(RisReports[1,1]),% "ahk_id " editHwnd
	settimer,update,-3000
}
return

#ifwinactive

#ifwinactive,ahk_group MyGui
^n::
gosub renewRis
gosub renewRisReports
controlsettext,,,% "ahk_id " editHwnd
controlsettext,,,% "ahk_id " RisReports[1,1]
return

^b::
gosub loadRisText
return
~lbutton::
;~ gosub unhookMouse
OnMessage( 0x200, "WM_MOUSEMOVE" ) 
return

~lbutton up::
OnMessage( 0x200, "" ) 
return


;~ ~rbutton::
;~ keywait, rbutton, t0.3
;~ if errorlevel = 1
;~ {
	;~ gosub loadRisText
;~ }

~^a::
selectAll:=1
return


focusImpression:
^space::
;~ if !(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<400)
	;~~ return
gosub renewRis
gosub renewRisReports
gosub update
controlfocus,,% "ahk_id " RisReports[1,2]
winactivate,% "ahk_id " RisState[2]
controlfocus,,% "ahk_id " RisReports[1,2]
return

F12::
gosub PacsIEnextStudy
return

F11::
gosub PacsIEnextStudy
return

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


#ifwinactive
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
OnMessage( 0x200, "" ) 
;~ mouseHooks.push(SetWindowsHookEx(WH_MOUSE_LL   := 14, RegisterCallback("MouseHook", "Fast")))
hooked:=1
return

unhookMouse:
;~ for k,v in mouseHooks
	;~ UnhookWindowsHookEx(v)
;~ mouseHooks:=[]
hooked:=0
return

onexit:
exitapp
return


loadRisText:
gosub renewRis
gosub renewRisReports
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



update:

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
	if(text2!="")
		clipboard:=text2
	controlsettext,,% text1,% "ahk_id " editHwnd
	Edit_getsel(RisReports[1,1],caretS,caretE)
	Edit_Setsel(editHwnd,caretS,caretE)
	Edit_ScrollCaret(editHwnd)
}else if(text2!="" && text1!=text2){
	;~ if(text1!="")
		;~ clipboard:=text1
	controlsettext,,% text2,% "ahk_id " RisReports[1,1]
	;~ Edit_getsel(editHwnd,caretS,caretE)
	;~ Edit_Setsel(RisReports[1,1],caretS,caretE)
	;~ Edit_ScrollCaret(RisReports[1,1])
}
	
;~ msgbox % winactive(RisState[2])
if winactive("ahk_id " RisState[2]) {
	;~ msgbox % getFocused() "," risreports[1,1]
	if (risreports[1,1]=getFocused()) {
		edit_getsel(RisReports[1,1],caretS,caretE)
		winactivate,% "ahk_id " guihwnd
		controlfocus,,% "ahk_id " editHwnd
		Edit_Setsel(editHwnd,caretS,caretE)
		Edit_ScrollCaret(editHwnd)
		
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
	settimer,update,-3000
;~ }
return

renewAccNo:
if (!AccNoHwnd || !controlexist(AccNoHwnd))
	AccNoHwnd:=getRisAccNoHwnd(RisState[2])

return

renewRis:
if !(isobject(RisState) && RisState[1]=2 && winexist(RisState[2])) 
	RisState:=risopened()
return

renewRisReports:
if !(isobject(risReports) && controlexist(RisReports[1,1]))
	RisReports:=getRisReports(RisState[2])
return

WM_MOUSEMOVE( wparam, lparam, msg, hwnd ){
	if (wparam = 1){ ; LButton
		PostMessage, 0xA1, 2,,, A ;WM_NCLBUTTONDOWN
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

