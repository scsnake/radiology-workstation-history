#MaxMem 4095
#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen
#NoTrayIcon
ComObjError(false)
onexit,onexit
SendMode,input
#Persistent
SetTimer,HideWidget,500
return


HideWidget:
if !WinVisible("ahk_class Shell_TrayWnd")
	WinShow,ahk_class Shell_TrayWnd

if (!WinExist("WatchDOGWidget") || !Winvisible("WatchDOGWidget") ){
	winget,list,list,ahk_exe BackgroundScreen.exe
	Loop % List {
		bg:=list%a_index%
		WinGetPos,x,,,,ahk_id %bg%
		if (x=0){
			WinMove,ahk_id %bg%,,-1,-1,1,1
		}
	}
}
return

~LButton up::

MouseGetPos,,,win
hwnd:=WinExist("SecurView Login ahk_class QWidget ahk_exe SCRLogin.exe")
;~ ToolTip % win "," hwnd "," win-hwnd
if (win && hwnd && win==hwnd){
	if (A_ThisHotkey =A_PriorHotkey && A_TimeSincePriorHotkey<400){
		send {Home}+{End}secur{tab}secur{Enter}
		;~ ControlSend,QWidget5,secur,SecurView Login ahk_class QWidget ahk_exe SCRLogin.exe
		;~ ControlSend,QWidget6,secur,SecurView Login ahk_class QWidget ahk_exe SCRLogin.exe
		;~ ControlClick,QWidget4,SecurView Login ahk_class QWidget ahk_exe SCRLogin.exe
	}else{
		ShowToolTip("User name: secur`nPassword: secur", 3000)
	}
	

}
return



OnMessage(0x200, "WM_MOUSEMOVE")

gui,-Caption +hwndguiHwnd -Resize +ToolWindow +0x400000
gui,Font,s25 bold,Calibri
gui,Add,button,gRIS w150 h80 x10 y10,% "RIS"
gui,Add,button,x+0 w150 h80 gIMPAX,% "IMPAX"
gui,Add,button,x+0 w200 h80 gWS,% "Hologic WS"
gui,Add,button,x+0 w150 h80 gdesktop,% "Desktop"
gui,Show,x0 y0 w670 h100

SetTimer,keepOnTop,500
SetTimer,checkMouseOver,-1500
return

keepOnTop:
winset,AlwaysOnTop,,ahk_id %guihwnd%
return

RIS:
run % "C:\Users\SCR\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\陽明資訊\放射線資訊管理系統(Radiology Information System).appref-ms"
return

IMPAX:
run % "C:\Program Files (x86)\Agfa\IMPAX Client\AppStart.exe"
return

WS:
run,% "E:\SecurView\Watchdog.exe", % "E:\SecurView"
return

desktop:

return

~^!q::
;~ esc::
OnExit:
ExitApp

WM_MOUSEMOVE(wparam,lparam,msg,hwnd){
	if (wparam=1)
		PostMessage,0xA1,2,,,A
	SetTimer,checkMouseOver,-100
}

checkMouseOver:
MouseGetPos,,,win,con,2
if (win!=guihwnd)
	winset,Transparent,100,ahk_id %guihwnd%
else
	winset,Transparent,Off,ahk_id %guihwnd%
return
