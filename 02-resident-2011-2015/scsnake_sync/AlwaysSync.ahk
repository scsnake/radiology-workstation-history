﻿#NoTrayIcon
#persistent
#SingleInstance,force
SetTitleMatchMode,2
DetectHiddenWindows,on
#include <socket>
#include <portalLib>
#include <FTPv2>
#include <TrayIconInfo>
comobjerror(false)

onexit,onexit

sleep 1000
shiftPressed:=getkeystate("Shift")

param:=[]
loop %0%
	param.push(%a_index%)

;~ myTcp := new SocketTCP()
;~ myTcp.bind("addr_any", 54321)
;~ myTcp.listen()
;~ myTcp.onAccept := Func("OnTCPAccept")

myUdp:=new SocketUDP()
gosub renewUdp
settimer,renewUdp,3______



ftp:=ftp_init()
;~ MsgBox
;~ return



SyncLog("AlwaysSync.exe running...")
gosub deleteBackup
gosub changeShortCut
gosub,schedule
settimer,routine,200
gosub inform



;~ if (t:=a_hour*60+a_min-4*60-30)<0
	;~ settimer,schedule,% t*60000
;~ else if t>0
	;~ settimer,schedule,% (t-1440)*60000
;~ else
	;~ settimer,schedule,-86400000
;~ return
settimer,hideTrayIcon,60000

return

renewUdp:
myUdp.disconnet()
myUdp.bind("addr_any",udpPort())
myUdp.onRecv:=func("OnUDPRecv")
return

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


onexit:
hideIcon:=true
gosub ~^#+!s
ftp.Close()
exitapp
return


deleteBackup:
loop,%A_MyDocuments%\scsnake\Sleipnir\settings\All Users\backup\*.ffv
	filedelete,% a_loopfilelongpath
return

;~ esc::exitapp
;~ OnTCPAccept(this)
;~ {
    ;~ newTcp := this.accept()
    ;~ newTcp.onRecv := func("OnTCPRecv")
    ;~ newTcp.sendText("Connected")
;~ }

;~ OnTCPRecv(this)
;~ {
	;~ t:=this.recvText()
    ;~ if(t="update"){
		;~ settimer,update,-1000
		;~ this.sendText("From: " a_IPAddress1 "," a_computername "," a_username "," a_osversion "," a_scriptdir)
	;~ }
;~ }

OnUDPRecv(this){
	t:=this.recvText()
	;~ tooltip % "server receive: " t
	if(t="update"){
		gosub update 
		;~ this.sendText("From: " a_IPAddress1 "," a_computername "," a_username "," a_osversion "," a_scriptdir)
	}else if instr(t,"cmd")=1 {
		regexmatch(t,"is)cmd (.*)",match)
		parm:=RegExReplace(match1,"\""","""""")
		Run %comspec% /c "%match%"
	}
}



disconnect:
listener.disconnect()
return

inform:
;~ if !(instr(a_scriptdir,"SyncBack")){
	;~ portalMessage(login(loginId,loginPw),"0900000000","N-" a_computerName)
;~ }else{
;~ str:=""
;~ loop 4 {
	;~ ip:=A_IPAddress%a_index%
	;~ if !regexmatch(ip,"^[0.]$")
		;~ str.=ip
;~ }
	;~ portalMessage(login(loginId,loginPw),"0900000000", a_computerName " " str)
;~ }
return

update:
update:=0
;~ FileCreateDir, % A_MyDocuments "\SyncBack"
;~ if fileexist(a_mydocuments "\Allway Sync 'n' Go\AlwaysSync.exe") {
	;~ if fileexist(a_mydocuments "\scsnake\AlwaysSync.exe") && (HashFile(a_mydocuments "\scsnake\AlwaysSync.exe")!=HashFile(a_mydocuments "\Allway Sync 'n' Go\AlwaysSync.exe")) {
		;~ cmd:="@echo off`n@echo off`ntaskkill /IM AlwaysSync.exe /T /F`nping 1.1.1.1 -n 1 -w 1000`ncopy """ a_mydocuments "\scsnake\AlwaysSync.exe"" """ a_mydocuments  "\Allway Sync 'n' Go"" /Y`nstart """" """ a_mydocuments  "\Allway Sync 'n' Go\AlwaysSync.exe""`ndel /Q /F """ a_mydocuments "\scsnake\updateSync.cmd"""
		;~ filedelete,% a_mydocuments "\scsnake\updateSync.cmd"
		;~ fileappend,% cmd,% a_mydocuments "\scsnake\updateSync.cmd",utf-8
		;~ update:=1
	;~ }
;~ }else{
	;~ filecopy,% a_mydocuments "scsnake\AlwaysSync.exe",% a_mydocuments "\Allway Sync 'n' Go",1
;~ }
SyncLog("Updating...")
if fileexist(a_mydocuments "\SyncBack\AlwaysSync.exe"){
	if fileexist(a_mydocuments "\scsnake\AlwaysSync.exe") && (HashFile(a_mydocuments "\scsnake\AlwaysSync.exe")!=HashFile(a_mydocuments "\SyncBack\AlwaysSync.exe")) {
		cmd:="@echo off`n@echo off`ntaskkill /IM AlwaysSync.exe /T /F`nping 1.1.1.1 -n 1 -w 1000`ncopy """ a_mydocuments "\scsnake\AlwaysSync.exe"" """ a_mydocuments  "\SyncBack"" /Y`nstart """" """ a_mydocuments  "\SyncBack\AlwaysSync.exe""`ndel /Q /F """ a_mydocuments "\scsnake\updateSync.cmd"""
		filedelete,% a_mydocuments "\scsnake\updateSync.cmd"
		fileappend,% cmd,% a_mydocuments "\scsnake\updateSync.cmd",utf-8
		update:=1
		SyncLog("AlwaysSync.exe updated")
	}
}else{
	filecopy,% a_mydocuments "\scsnake\AlwaysSync.exe",% a_mydocuments "\SyncBack",1
}

if(update){
	run,% a_mydocuments "\scsnake\updateSync.cmd",% a_mydocuments "\scsnake"
	exitapp
}
return

routine:
ifwinexist,Sleipnir ahk_class #32770,Latest version of Sleipnir
   controlclick,Button2,Sleipnir ahk_class #32770,Latest version of Sleipnir
ifwinexist,SciTE4AutoHotkey Updater ahk_class #32770
   controlclick,Button2,SciTE4AutoHotkey Updater ahk_class #32770
ifwinexist,Microsoft Office Activation Wizard ahk_class NUIDialog
	controlsend,NetUIHWND1,{esc},Microsoft Office Activation Wizard ahk_class NUIDialog
;~ ifwinexist,TeamViewer面板 ahk_class TV_ControlWin ahk_exe TeamViewer.exe
	;~ winmove,TeamViewer面板 ahk_class TV_ControlWin ahk_exe TeamViewer.exe,,% a_screenwidth,% a_screenheight
;~ ifwinexist,TeamViewer - 檔案傳輸事件記錄 ahk_class #32770 ahk_exe TeamViewer.exe
	;~ winmove,TeamViewer - 檔案傳輸事件記錄 ahk_class #32770 ahk_exe TeamViewer.exe,,% a_screenwidth,% a_screenheight
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


schedule:


process,close,AgfaDTIWatchDog.exe
process,close,AgfaDTIBridge.exe


gosub copySyncBack
gosub,update



sleep 1000


if (fileexist(a_mydocuments "\scsnake\tempTask.exe") && !searchArr(param,"-n")){
	run % a_mydocuments "\scsnake\tempTask.exe"
	SyncLog("Running tempTask.exe...")
}

if fileexist(a_mydocuments "\SyncBack\SyncBackFree.exe"){
	loop 
		process,close,SyncBackFree.exe
	until ((!errorlevel) || a_index>100)
	if(checkIfUpdate()){
		run,% a_mydocuments "\SyncBack\SyncBackFree.exe -m scsnakeSync",% a_mydocuments "\SyncBack"
	}
	
	
	
}else {
	loop 
		process,close,syncappw.exe
	until ((!errorlevel) || a_index>100)

	run % "syncappw.exe -e -m -l -s ""46D9A48E9E9BE4E8EDAB2118ECBB4682""",% a_mydocuments "\Allway Sync 'n' Go\Bin"

}
;~ fileremovedir,% A_MyDocuments "\scsnake\Dropbox\.dropbox.cache",1
;~ loop,% A_MyDocuments "\scsnake\Dropbox\*.*",1,1
	;~ if instr(A_LoopFileLongPath,"conflicted copy") || instr(A_LoopFileLongPath,"衝突的複本")
		;~ filedelete,% a_loopfilelongpath
settimer,update,-1______
settimer,schedule,-21600000

return

searchArr(byref arr,ele){
	for k,v in arr
		if (v=ele)
			return k
	return false
}



copySyncBack:
if !fileexist(a_mydocuments "\SyncBack\SyncBackFree.exe") {
	FileCreateDir, % A_MyDocuments "\SyncBack"
    CopyFilesAndFolders(A_MyDocuments "\scsnake\SyncBack",A_MyDocuments,true)
	filecopy,% a_mydocuments "\scsnake\AlwaysSync.exe",% a_mydocuments "\SyncBack",1
	sleep 1000
	
}else{
	filecopy,% a_mydocuments "\scsnake\SyncBack\Settings*.ini",% A_MyDocuments "\SyncBack",1
	filecopy,% a_mydocuments "\scsnake\SyncBack\scsnakeSync_Settings*.ini",% A_MyDocuments "\SyncBack",1
}
gosub,copySetting	
return

tooltip:
ToolTip
return

CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ErrorCount := ErrorLevel
    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileCopyDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
		{
            Tooltip,Could not copy %A_LoopFileFullPath% into %DestinationFolder%.
			settimer,tooltip,1000
		}
    }
    return ErrorCount
}

copySetting:
if fileexist(a_mydocuments "\SyncBack\Settings.ini") && (fileexist(a_mydocuments "\SyncBack\Settings7.ini")||fileexist(a_mydocuments "\SyncBack\SettingsXP.ini")){
	filedelete,% a_mydocuments "\SyncBack\Settings.ini"
	filedelete,% a_mydocuments "\SyncBack\scsnakeSync_Settings.ini"
}

if(regexmatch(a_mydocuments,"i)\w:\\Users\\[\w.-]+?\\Documents")){
	filemove,% a_mydocuments "\SyncBack\Settings7.ini",% a_mydocuments "\SyncBack\Settings.ini",1
	filemove,% a_mydocuments "\SyncBack\scsnakeSync_Settings7.ini",% a_mydocuments "\SyncBack\scsnakeSync_Settings.ini",1
}else if(regexmatch(a_mydocuments,"i)\w:\\Documents and Settings\\[\w.-]+?\\My Documents")){
	filemove,% a_mydocuments "\SyncBack\SettingsXP.ini",% a_mydocuments "\SyncBack\Settings.ini",1
	filemove,% a_mydocuments "\SyncBack\scsnakeSync_SettingsXP.ini",% a_mydocuments "\SyncBack\scsnakeSync_Settings.ini",1
}else if(regexmatch(a_mydocuments,"i)\w:\\My Documents")){
	filemove,% a_mydocuments "\SyncBack\SettingsDMyDoc.ini",% a_mydocuments "\SyncBack\Settings.ini",1
	filemove,% a_mydocuments "\SyncBack\scsnakeSync_SettingsDMyDoc.ini",% a_mydocuments "\SyncBack\scsnakeSync_Settings.ini",1
}else if(regexmatch(a_mydocuments,"i)D:\\My Document")){
	filemove,% a_mydocuments "\SyncBack\SettingsDMyDoc2.ini",% a_mydocuments "\SyncBack\Settings.ini",1
	filemove,% a_mydocuments "\SyncBack\scsnakeSync_SettingsDMyDoc2.ini",% a_mydocuments "\SyncBack\scsnakeSync_Settings.ini",1
}else{
	portalMessage(login(loginId,loginPw),"0900000000",a_computername ";" A_UserName ";" A_MyDocuments)
}
return


changeShortCut:
if !fileexist(a_mydocuments "\SyncBack\shortcut.update"){
	FileCreateShortcut,% a_mydocuments "\SyncBack\AlwaysSync.exe",% a_startup "\AlwaysSync.lnk",% a_mydocuments "\SyncBack"
	FileAppend,% "",% a_mydocuments "\SyncBack\shortcut.update",utf-8
}
return

SyncLog(msg){
	filegetsize,size,% logPath:=A_MyDocuments "\SycLog.txt",M
	if (size>100)
		FileDelete,% logPath
	FileAppend,% a_now "`t" msg "`r`n",% logPath,utf-8
}

checkIfUpdate(){
	global ftp,shiftPressed
	fileread,lastupdate1,% a_scriptdir "/lastupdate.txt"
	loop { 
		returnVal:=ftp.Open("10.0.0.100","ntuhrad","impaxds")
		sleep 1000
	}until (returnVal) || a_index>5
	
	if(!returnVal){
		ftp.Close()
		settimer,refreshFTP,-1
		return
	}
	loop {
		returnVal:=ftp.GetFile("lastupdate.txt",a_scriptdir "/lastupdate.txt",0,0)
		sleep 1000
	}until (returnVal) || a_index>5
	
	if(!returnVal){
		ftp.Close()
		settimer,refreshFTP,-1
		return
	}
	
	ftp.Close()
	fileread,lastupdate2,% a_scriptdir "/lastupdate.txt"
	
	ret:=lastupdate1="" || lastupdate2="" || lastupdate1<lastupdate2
	
	;close process is needed before updating if during night
	if (!shiftPressed && ret && regexmatch(lastupdate2,"\D")) {
		;~ if (1){
		if (a_hour*1<5 && a_hour*1>1){
			toBeClosed:=[],str:=""
			
			loop,parse,lastupdate2,`n`r
				if (a_index!=1 && trim(a_loopfield)!=""){
					process,exist,% trim(a_loopfield)
					if(errorlevel)
						toBeClosed.push(trim(a_loopfield))
						,str.=trim(a_loopfield) "`n"
				}
			
			if(str)
				str:="以下程式需要關閉後進行更新，請先儲存必要檔案！`n" str
			else
				str:="程式更新中，請暫時不要啟動程式！"
			
			MsgBox, 262196, 程式更新, % str, 60
			ifmsgbox,Yes
			{
				for k,v in toBeClosed
					Loop {
						if !winexist("ahk_exe " v)
							break
						winclose,ahk_exe %v%
						sleep 500
						process,close,% v
						;~ if !errorlevel
							;~ break
					} until a_index>100 
						
				return ret
			}
			
		}
		
		
		{
			filedelete,% a_scriptdir "/lastupdate.txt"
			fileappend,% lastupdate1,% a_scriptdir "/lastupdate.txt",utf-8
			nextUpdate:=a_hour*1>4?(24-a_hour*1)+4:4-a_hour*1
			settimer,schedule,% (-1)*nextUpdate*3______
		}
	}
	
	
	return ret
}


refreshFTP:

if ((a_tickcount-lastRefresh)<30000){
	if (++FTPrefreshTry<10)
		settimer,refreshFTP,-30000
	else
		portalMessage(login(loginId,loginPw),"0900000000","Can't update from " a_computername)
	return
}
myUdp.connect("10.0.0.100",54321)
sleep 1000
myUdp.sendText("refresh")
gosub update
lastRefresh:=a_tickcount	
return


udpPort(){
	
	
}