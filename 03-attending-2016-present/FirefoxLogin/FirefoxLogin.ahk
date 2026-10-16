#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
#persistent
#include <RisImpax>
#include <WM_COPYDATA>
#include <SetTimerF>
onexit,onexit

gui,main:default
gui,+hwndGuihwnd +ToolWindow -Caption
;~ WinSetTitle,ahk_id %guihwnd%,,FirefoxLogin_main
gui,Show,x-1 y-1 w1 h1,FirefoxLogin_main

;~ #include <CheckUpdate>
;~ SetTimerF("scs_sync", -1)
OnMessage(0x4a, "On_WM_COPYDATA")
;~ ,OnMessage(0x8000, "RisStateChange")
;~ ,OnMessage(0x1124, "ImpaxStateChange")
RISImpaxRegister([  {app: "Ris", type: "State", hwnd: guiHwnd, msg: {msg: 0x8000}, Func: "RisStateChange", initStart: 1}
	, {app: "Impax", type: "State", hwnd: guiHwnd, msg: {msg: 0x1124}, Func: "ImpaxStateChange", initStart: 1}])
WinClose,ahk_exe FirefoxLoginApp.exe
;~ filecopy,% A_ScriptDir "\FirefoxLoginApp\FirefoxLoginApp\bin\Release\FirefoxLoginApp.exe",% A_ScriptDir "\FirefoxLoginApp",1
GroupAdd,pacs,ahk_exe impax-client-main.exe
GroupAdd,pacs,ahk_exe WEBVIE~1.exe
GroupAdd,pacs,ahk_exe WebViewerComSrvEC.exe
;~ return
gosub sethotkey
settimer,sethotkey,5000
SetTimer,AddAppReg,-1
SetTimer,setDesktopShortcut,-1
gosub findFirefox
;~ settimer,RisImpaxRoutine,500
;~ SetTimer,checkOpenInIE,1500
SetTimer,checkCloseIE,500
;~ settimer,debug,500
return

debug:
ToolTip % exploreobj(impaxstate)
return

RisStateChange(){
	global 
	RisState:=RisOpened()
}

ImpaxStateChange(){
	global 
	ImpaxState:=ImpaxOpened()
}

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	global AccNoCol, examDateCol, examNameCol, ChartNoCol, statusCol
	;~ static lastTick
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	
	if(dwData=3){
		;~ ToolTip % lpData
		try
			j:=jxon_load(lpData)
		catch e {
			;~ ToolTip % exploreobj(e)
			return
		}

		if(j.URL)
			SetTimerF("openInIE", -1, [j.URL])
	}
	
}

AddAppReg:
process,Close,FirefoxLoginApp.exe
try
	RegWrite,REG_SZ,% "HKEY_CURRENT_USER\SOFTWARE\Mozilla\NativeMessagingHosts\FirefoxLoginApp",,% A_ScriptDir "\FirefoxLoginApp\manifest.json"
catch e {
	MsgBox % "Edit registry error!"
}
return


findFirefox:
if !WinExist("ahk_class MozillaWindowClass"){
	DefaultFirefox:=A_ScriptDir "\firefox\firefox.exe"
	if !FileExist(DefaultFirefox){
		DefaultFirefox:=""
		SetWorkingDir,% A_ScriptDir
		Loop,*.exe,0,1
		{
			if (A_LoopFileName="firefox.exe" || A_LoopFileName="FirefoxPortable.exe"){
				DefaultFirefox:=A_LoopFileLongPath
				break
			}
		}
		
		if(DefaultFirefox=""){
			MsgBox % "Can't find firefox.exe"
			return
		}
	}
	run % DefaultFirefox
	winwait,ahk_class MozillaWindowClass,,
	SetTimer,waitApp,-1000
}
SetTimer,autoClose,1000
return

waitApp:
;~ if (appHwnd:=WinExist("ahk_exe FirefoxLoginApp.exe")) && (pAppHwnd!=appHwnd) {
	;~ Send_WM_COPYDATA(WinExist("ahk_exe FirefoxLoginApp.exe"),1,guihwnd+0)
	;~ ,pAppHwnd:=appHwnd
;~ }
winget,appList,list,ahk_exe FirefoxLoginApp.exe
Loop % appList 
	Send_WM_COPYDATA(appList%a_index%,1,guihwnd+0)
SetTimer,,-5000
return

autoClose:
if !WinExist("ahk_class MozillaWindowClass")
	ExitApp
return

setDesktopShortcut:
SplitPath,A_ScriptFullPath,,dir,,scriptName
found:=0
Loop,% a_desktop "\*.lnk"
{
	FileGetShortcut,% A_LoopFileLongPath,target
	if(target=A_ScriptFullPath){
		;~ SplitPath,A_ScriptFullPath,,,,scriptName
		if (found)
			FileDelete,% A_LoopFileLongPath
		else {
			if(A_LoopFileName != scriptName){
				filemove,% A_LoopFileLongPath,% A_LoopFileDir "\" scriptName ".lnk", 1
			}
			found:=1
		}
	}else if InStr(target, "FirefoxLogin") && !FileExist(target)
		FileDelete,% A_LoopFileLongPath
}
FileCreateShortcut,% A_ScriptFullPath,% a_desktop "\FirefoxLogin.lnk"
return

openInIE(url){
	run % clipboard:="iexplore.exe """ url """"
}

checkOpenInIE:
if !hwnd:=WinExist("Opening in IE ... ahk_class MozillaWindowClass")
	return
WinGetTitle,title,ahk_id %hwnd%
RegExMatch(title, "Opening in IE \.\.\. (.+)$", match)
if !InStr(url:=match1, "SESSION="){
	SetTimer,checkOpenInIE,500
}else{
	WinActivate,ahk_id %hwnd%
	WinWaitActive,ahk_id %hwnd%,,1
	send ^w
	run % "iexplore.exe """ url """"
	SetTimer,checkOpenInIE,1500
}
return





;~ esc::
;~ OnExit:
;~ ExitApp


sethotkey:
HotkeyState:=!WinExist("Enter command ... ahk_class AutoHotkeyGUI")?"on":"off"
	Hotkey,IfWinExist
	Hotkey,IfWinActive
	for k,v in ["!#tab"]
		;~ try
			Hotkey,% v,% "_" v,% hotkeyState
	Hotkey,ifwinexist,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	for k,v in ["^!tab"]
		;~ try
			Hotkey,% v,% "_" v,% hotkeyState
	Hotkey,IfWinExist
	Hotkey,ifwinactive,ahk_exe impax-client-main.exe
	;~ try
		Hotkey,``,__toggle,% hotkeyState
		Hotkey,MButton,__MButton,% hotkeyState
		Hotkey,MButton up,__Mbutton_up,% hotkeyState
	for k,v in ["tab","~rbutton", "f1"]
		;~ try
			Hotkey,% v,% "_" v,% hotkeyState
	Hotkey,ifwinactive,放射線資訊管理系統(Radiology Information System)
	for k,v in ["^enter","^numpadenter"]
		;~ try
			Hotkey,% v,% "_" v,% hotkeyState
	;~ try 
		Hotkey,~RButton,__~RButton,% hotkeyState
	Hotkey,IfWinExist
	Hotkey,IfWinActive

return


_!#tab:
if !WinExist("ahk_exe FirefoxLoginApp.exe"){
	MsgBox % "Can't find FirefoxLoginApp.exe. Please restart FirefoxLogin"
	return 
}

keywait,alt,1
if errorlevel
   return
keywait,tab,1
if errorlevel
   return
keywait,lwin,1
if errorlevel
   return
sleep 100
clipboard=
send ^c
clipwait,1

if (!regexmatch(clipboard,"\b\w{6}\d\b",match) && winactive("放射線資訊管理系統(Radiology Information System)")) {
	clipboard:=(chartNo:=getRisChartNo(RisOpened()[2]))
}

!#tab1:
if !regexmatch(clipboard,"\b\w{6}\d\b",match) {
	return
}
chartNo:=match
,Send_WM_COPYDATA(WinExist("ahk_exe FirefoxLoginApp.exe"), 0, jxon_dump({"searchChartNo": chartNo}))
;~ SendToStdin(WinExist("ahk_exe FirefoxLoginApp.exe"), jxon_dump({"searchChartNo": chartNo}) )
;~ winactivate,- Mozilla Firefox ahk_class MozillaWindowClass
winactivate,ahk_exe firefox.exe
return


SendToStdin(hwnd, str, encoding="UTF-8"){
	winget,PID,PID,ahk_id %hwnd%
	DllCall("AttachConsole", "Int", PID)
	;~ or
	;~ DllCall("AttachConsole", "Int", -1) ; attach to parent's console
	,hStdIn := DllCall("GetStdHandle", "Int", -10) ; STD_INPUT_HANDLE = -10
	,Text:=""
	,len:=StrPut(str, encoding)
	,StrPut(str, Text, encoding)
	,DllCall("WriteFile"
			, "UInt", hStdIn ; hFile
			, "Ptr", &Text ; lpBuffer
			, "UInt", len ; nNumberOfCharsToWrite
			, "PtrP", bytesWritten ; lpNumberOfCharsWritten
			, "UInt", 0) ; lpOverlapped
	
}


#ifwinexist,ahk_class WindowsForms10.Window.8.app.0.2bf8098
_^!tab:
if (Impax:=ImpaxState)[1]!=2
	return
ifwinactive,UniReport ahk_class TMainForm
{	
	wingettitle,str,UniReport ahk_class TMainForm
	clipboard:=str
}else{
	keywait,alt,1
	keywait,tab,1
	keywait,ctrl,1
	if errorlevel
		return
	sleep 100
	clipboard=
	send ^c
	clipwait,1
}
^!tab1:
if !regexmatch(clipboard,"\b\w{6}\d\b",match)
	return
chartNo:=match
winactivate,% "ahk_id " id2:=Impax[2,2]|Impax[2,3]
bar:=ImpaxBar(id2)
wingetpos,,,,h,ahk_id %id2%
if !(bar.h>h-37)
	controlclick,,% "ahk_id " bar.hwnd
gosub selectChartNo
acc_objectfromwindow(impaxChartnoControl).accValue:=chartNo
controlsend,,{enter},% "ahk_id " impaxChartnoControl
return
#ifwinexist


selectChartNo:
;~ for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){
    ;~ if k<2
        ;~ continue
    ;~ if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" && impaxControls[k+2].text="檢查之日期") || (impaxControls[k-1].text="Patient ID" && impaxControls[k+2].text="Study Date")) {
        ;~ controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd
        ;~ controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl
        ;~ if !selectedText
			;~ ControlClick,,% "ahk_id " impaxChartnoControl,,l,1
        ;~ break
   ;~ }
;~ }
for k,v in (impaxControls:=getcontrols(id2:=Impax[2,2]|Impax[2,3])){
	if k<2
		continue
	if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" ) || (impaxControls[k-1].text="Patient ID")) {
		controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd
		controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl
		if !selectedText
			ControlClick,,% "ahk_id " impaxChartnoControl,,l,1
		break
	}
}

return





#ifwinactive,ahk_exe impax-client-main.exe

mouseGesture:
if (abs(gestureY2-gestureY1)+abs(gestureX2-gestureX1)<20) {
	gestureValue:=0
	return
}
if (gestureX2=gestureX1) {
	gestureValue:=(gestureY2>gestureY1)?4:8
}else if (gestureX2>gestureX1){
	if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414
		gestureValue:=4
	else if slope>0.414
	gestureValue:=3
	else if slope>-0.414
	gestureValue:=2
	else if slope>-2.414
	gestureValue:=1
	else
	gestureValue:=8
}else if (gestureX2<gestureX1){
	if (slope:=(gestureY2-gestureY1)/(gestureX2-gestureX1))>2.414
		gestureValue:=8
	else if slope>0.414
	gestureValue:=7
	else if slope>-0.414
	gestureValue:=6
	else if slope>-2.414
	gestureValue:=5
	else
	gestureValue:=4
}

if gesturevalue=2
	send {right}
else if gesturevalue=6
send {left}
else if gesturevalue=8
send %modifier%{up}
else if gesturevalue=4
send %modifier%{down}
return
__mbutton:
mousegetpos,gestureX1,gestureY1,mouseWin
WinGetClass,mouseWinClass,ahk_id %mouseWin%
winactivate,ahk_id %mouseWin%
whichMonitor:=whichMonitor()
modifier:=whichMonitor[1]=3?"^":""
return
__mbutton_up:
mousegetpos,gestureX2,gestureY2
gosub mouseGesture
if (Impax:=ImpaxState)[1]!=2
	return
if (!gestureValue){
	cursorModeToggle:=!cursorModeToggle
	for k,v in impaxControls:=getControls(Impax[2,1])
		if (v.text="BMP_CURSOR_MODE_NEW" && instr(v.classNN,"WindowsForms10.BUTTON.app")){
			controlclick,,% "ahk_id " impaxCursorModeHwnd:=v.hwnd
			break
		}
	;~ msgbox % acc_objectfromwindow(impaxCursorModeHwnd).accState
	if (cursorModeToggle)
		settimer,cursorModeToggle,-100
}
gestureValue:=0
return

cursorModeToggle:
if(winactive("ahk_group pacs") && !getkeystate("Lbutton") && !getkeystate("mbutton") && !getkeystate("rbutton")){
	mousegetpos,mx,my
	if (mx-gestureX1)**2+(my-gestureY1)**2>2500 {
		controlclick,,% "ahk_id " impaxCursorModeHwnd
		cursorModeToggle:=!cursorModeToggle
		return
	}
}
settimer,cursorModeToggle,-100
return

checkCloseIE:
;~ risState:=risOpened(),impaxState:=impaxOpened()
IfWinExist,ahk_class #32770,簽章完成
	ControlClick,Button1
IfWinExist,ahk_class #32770,試圖關閉索引標籤
	ControlClick,Button1
IfWinExist,ahk_class #32770,查無待簽章電子病歷資料。
	WinClose
IfWinExist,ahk_class #32770,您正在檢視的網頁嘗試要關閉視窗。
	ControlClick,Button1
return
;press ` toggle text and image
__toggle:
toggleImageText:
if (Impax:=ImpaxState)[1]!=2
   return
if(Impax[2,5]=2){
	if(Impax[2,4]=1){
		for k,v in (impaxControls:=getcontrols(Impax[2,1])){
			if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
				controlclick,,% "ahk_id " v.hwnd
				return
			}
		}
	}else if(Impax[2,4]=3){
		winactivate,% "ahk_id " Impax[2,1]
	}
	
}else if(Impax[2,5]=1){
	for k,v in (impaxControls:=getcontrols(Impax[2,1])){
		if (v.text="文字" || v.text="Text" || v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
			controlclick,,% "ahk_id " v.hwnd
			return
		}
	}
}
   

    
    
return

;press tab to toggle image series window
_tab:
if (Impax:=ImpaxState)[1]!=2 && Impax[2,4]!=1
	return
for k,v in (impaxControls:=getcontrols(Impax[2,1])){
	if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
		controlclick,,% "ahk_id " v.hwnd
	}
}
winactivate,% "ahk_id " ImpaxState[2,1]
return

_~rbutton:
if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {
	return 
}
sleep 100
mousemove,10,10,0,r
mousegetpos,,,menuHwnd
controlgetpos,,,w,h,,ahk_id %menuHwnd%
mouseclick,l,% w/2-10,% (h/9)*3,1,0,,R
return

_f1:
if (Impax:=ImpaxState)[1]!=2
   return
bar:=ImpaxBar(id2:=Impax[2,2]|Impax[2,3])
if(Impax[2,5]=2){
	if(Impax[2,4]=1){
		winactivate,ahk_id %id2%
		wingetpos,,,,h,ahk_id %id2%
		if !(bar.h>h-37)
			controlclick,,% "ahk_id " bar.hwnd
	}else if(Impax[2,4]=3){
		wingetpos,,,,h,ahk_id %id2%
		if !(bar.h>h-37)
			controlclick,,% "ahk_id " bar.hwnd
	}else if(Impax[2,4]=2){
		;~ WinMinimize,% "ahk_id " id2 
		winactivate,% "ahk_id " Impax[2,1]
	}
	
}else if(Impax[2,5]=1){
	if(Impax[2,4]=2){
		controlclick,,% "ahk_id " bar.hwnd,,,,% "x" a_screenwidth/2 " y5"
		loop {
			sleep 200
 			if(ImpaxState[2,4]=1){
				break
			}else if(ImpaxState[2,4]=3){
				for k,v in (impaxControls:=getcontrols(ImpaxState[2,2]|ImpaxState[2,3])){
					if (v.text="影像" || v.text="Image") && instr(v.ClassNN,"WindowsForms10.BUTTON") {
						controlclick,,% "ahk_id " v.hwnd
						break
					}
				} 
			}
			
		}
	}else if(Impax[2,4]=1||Impax[2,4]=3){
		controlclick,,% "ahk_id " bar.hwnd
	}
}
if (Impax[2,4]!=2) {
	gosub selectChartNo
}




return


#ifwinactive


#ifwinactive,放射線資訊管理系統(Radiology Information System)
_^numpadenter:
_^Enter:
;~ for k,v in RISarr:=getControls(RisState[2])
   ;~ if (k>3 && RISarr[k-3].text="改派原因" && instr(v.classNN,"WindowsForms10.BUTTON.app.")) {
      ;~ ControlClick,,% "ahk_id " v.hwnd
      ;~ break
   ;~ }
   controlclick,,% "ahk_id " getNetControl2(RisState[2],"","cmdSearch","","WindowsForms10.BUTTON.app","","","",0)[1]

return
#ifwinactive


__~rbutton:
if !(a_thishotkey=a_priorhotkey && A_TimeSincePriorHotkey<300 && GetKeyState("RButton","P")) {
	return 
}
;~ wingettitle,activeWin,,A
mousemove,-1,-1,0,R
mousegetpos,,,activeWin
wingetTitle,activeWinTitle,% "ahk_id " activeWin
keywait,rbutton
if (instr(activeWinTitle,"放射線資訊管理系統(Radiology Information System)") || instr(activeWinTitle,"DisplayMenuForm")) {
	mouseclick,l,-2,-2,1,0,,r
	mouseclick,r,2,2,1,0,,r
	sleep 100
	mouseclick,l,5,5,1,0,,r
	;~ send {click 5,5 relative}
}
return

OnExit:
WinClose,ahk_exe FirefoxLoginApp.exe
ExitApp