#NoTrayIcon
#persistent
#SingleInstance,force
SetTitleMatchMode,2
DetectHiddenWindows,on
#include <TrayIconInfo>
#include <Socket>
myUdp:=new SocketUDP()
myUdp.bind("addr_any",54321)
myUdp.onRecv:=func("OnUDPRecv")


settimer,routine,200
;~ settimer,renewFTPserver,% 5.9*60*60*1000
settimer,routine2,1______ )
settimer,hideTrayIcon,60000
return
onexit:
hideIcon:=true
gosub ~^#+!s
exitapp
return


routine2:
filedelete,% a_mydocuments "\scsnake\lastupdate.txt"
fileappend,% substr(a_now,1,12),% a_mydocuments "\scsnake\lastupdate.txt",utf-8
return

OnUDPRecv(this){
	t:=this.recvText()
	
	if(substr(a_now,1,8)="20150127")
		tooltip % "server receive: " t
	
	if(t="refresh"){
		gosub,renewFTPserver
	}else if(t="relogin"){
		shutdown,0
	}
}
~^#+!s::
hideIcon:=!hideIcon
gosub toggleTrayIcon
return
hideTrayIcon:
DetectHiddenWindows,off
winminimize,ahk_class FileZilla Server Main Window
DetectHiddenWindows,on
hideIcon:=true
toggleTrayIcon:
TrayIconInfo:=TrayIcon_GetInfo()
for k,v in TrayIconInfo {
	process:=v.Process
	if process in CCProxy.exe,TeamViewer.exe,Proxifier.exe,FileZilla Server Interface.exe,hfs (http file server).exe,hfs.exe
	{
		TrayIcon_Hide(v.idn, hideIcon)
	}
}
return
;~ OnUDPRecv(this){
	;~ t:=this.recvText()
	;~ if(substr(a_now,1,8)="20150127")
		;~ tooltip % "server receive: " t
	;~ if(t="refresh"){
	;~ }else if(t="relogin"){
		;~ shutdown,0
	;~ }
;~ }

routine:
ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir
   controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir
ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770
   controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770
ifwinexist,Microsoft Office Activation Wizard ahk_class NUIDialog
	controlsend,NetUIHWND1,{esc},Microsoft Office Activation Wizard ahk_class NUIDialog
ifwinexist,TeamViewer面板 ahk_class TV_ControlWin ahk_exe TeamViewer.exe
	winmove,TeamViewer面板 ahk_class TV_ControlWin ahk_exe TeamViewer.exe,,% a_screenwidth,% a_screenheight
ifwinexist,TeamViewer - 檔案傳輸事件記錄 ahk_class #32770 ahk_exe TeamViewer.exe
	winmove,TeamViewer - 檔案傳輸事件記錄 ahk_class #32770 ahk_exe TeamViewer.exe,,% a_screenwidth,% a_screenheight
ifwinexist,贊助工作階段 ahk_class #32770 ahk_exe TeamViewer.exe
	controlclick,Button4,贊助工作階段 ahk_class #32770 ahk_exe TeamViewer.exe
ifwinexist,CCProxy ahk_class CCProxy ahk_exe CCProxy.exe
	winhide
ifwinexist,Symantec Endpoint Protection ahk_class #32770
	controlclick,Button2,Symantec Endpoint Protection ahk_class #32770
ifwinexist,ahk_exe rebootMsg.exe
	winclose

return

teamviewer:
ifwinexist,TeamViewer ahk_class #32770 ahk_exe TeamViewer.exe
	winhide,TeamViewer ahk_class #32770 ahk_exe TeamViewer.exe
return

renewFTPserver:
winclose,ahk_exe FTPServer.exe
sleep 3000
process,close,FTPServer.exe
sleep 3000
run % a_mydocuments "\Quick 'n Easy FTP Server\FTPServer.exe"
;~ FileDelete,% A_MyDocuments "\scsnake\lastupdate.txt"
;~ fileappend,% substr(a_now,1,12),% A_MyDocuments "\scsnake\lastupdate.txt",utf-8
return
