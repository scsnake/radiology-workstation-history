;Server
FileEncoding,utf-8
DetectHiddenWindows,on

#include <Socket>
#include <DoublyLinkedList>
#include <WM_COPYDATA>
#include <SetTimerFn>
#SingleInstance,Off
#NoTrayIcon
;~ #include <Hash>

OnMessage(0x4A, "On_WM_COPYDATA")

;~ FileCreateDir,% printedDir:=A_ScriptDir "\MammoReports_printed\"
SetTimer,closeMsg,500
param:=[]
if %0%
{
	Loop %0%
	{
		arg:=%a_index%
		param.push(arg)
	}
	goto localPrintMode
}

thisProcessId:=DllCall("GetCurrentProcessId"), CloseOther:=false
for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'MammoSRPrintServer.exe'") {
	if(process.ProcessId!=thisProcessId){
		MsgBox, 8260, Duplicated process, % "Duplicated MammoSRPrintServer.exe, close other processes?", 10
		IfMsgBox, Yes
			CloseOther:=true
		if(CloseOther)
			process,close,% process.ProcessId
	}
}


printBusy:=false, connectBusy:=false, connectTimeoutList:=[]
queue:=new Queue
gosub loadQueue
SetTimer,printNewReport,-1
;~ FileCreateDir,% dir:=A_ScriptDir "\MammoReports\"
if ((ChromePath:=getChromePath())="") {
	;~ MsgBox,,, % "Can't find path of chrome.exe!`nThis program will exit.",10
	;~ ExitApp
}
;~ SetTimer,keepTcp,-1000
;~ SetTimer,watchFtpUpload,-1000
ftpUploading:=[]
return

watchFtpUpload:
if (ftpUploading.maxIndex()) {
	for k,filePath in ftpUploading {
		fileread,html,% filePath
		dom:=ComObjCreate("HtmlFile")
		dom.write(html)

		span:=dom.getElementsByTagName("span")
		Loop % span.length {
			if (span[A_Index-1].getAttribute("name")="radiologist"){
				Radiologist:=span[A_Index-1].innerText
				break
			}
		}
		if(Radiologist="")
			Radiologist:="unknown"
		SplitPath,filePath,fileName
		filemove,% filePath,% A_ScriptDir "\" Radiologist "\" fileName,1
	}
	ftpUploading:=[]
}
Loop % A_ScriptDir "\upload\*.html"
	ftpUploading.push(A_LoopFileLongPath)
if(ftpUploading.maxIndex()){
	SetTimer,watchFtpUpload,-5000
	return
}

SetTimer,watchFtpUpload,-1000
return

keepTcp:
if(myTCP="" || !IsObject(myTCP) || myTCP.socket=-1 || myTCP.socket=""){
	;~ ToolTip % A_TickCount
	gosub tcp
}
SetTimer,keepTcp,-1000
return

tcp:
TCPclients:=[]
port:=54345

myTCP:=new SocketTCP()
;~ if myTCP.bind("addr_any",port)>1 {
	;~ MsgBox % "Failed to bind to " ip
	;~ ExitApp
;~ }
myTCP.bind("addr_any",port)
myTCP.onAccept:=Func("OnTCPAccept")
myTCP.onRecv:=Func("OnTCPRecv")
myTCP.listen()
SetTimer,connectTimeout,1000
return

OnTCPAccept(this){
	global TCPclients
	TCPclients[newTcp:=this.accept()]:=[]
	;~ global newTcp
	;~ newTcp:=this.accept()
	;~ newTcp.sendText("Connected")
	newTcp.onRecv:=Func("OnTCPRecv")
}

;~ esc::ExitApp
On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	
	,t:=lpData
	;~ MsgBox % lpData
	global queue
	
	 if RegExMatch(t, "is)^([^\|]+)\|printReport\|(.+)$", match) {
		ToolTip % "Prepare to print: " match2
		SetTimer,ToolTip,-2000
		queue.enqueue(match2)
		
		SetTimerFn("Send_WM_COPYDATA", -1, [WinExist("ahk_exe MammoSRPrintClient.exe"), 0, "Printing"])
	}else if RegExMatch(t, "is)^([^\|]+)\|listReport\|(.+)$", match) {
		listReport:=[]
		Loop % A_ScriptDir "\" match2 "\*.html"
			listReport.push(A_LoopFileFullPath)
		listReport:=sortFileListByTime(listReport)
		str:=""
		for k,v in listReport
			str.=RegExReplace(v, "is).+\\([^\\]+\.html)", "$1") "`n"
		SetTimerFn("Send_WM_COPYDATA", -1, [WinExist("ahk_exe MammoSRPrintClient.exe"), 0, "Remote Files:`n" str])
	}
}


OnTCPRecv(this){
	global queue, TCPclients, printBusy, connectBusy, connectTimeoutList
	t:=this.recvText()
	;~ tooltip % "server receive: " t
	;~ clipboard:=t
	
	;~ MsgBox % t
	/*
	; ip|tryTimes|radiologist|htmlFileName|htmlStrLen|whichPart|allPart|htmlChunk
	if RegExMatch(t, "is)^([^\|]+)\|(\d+)\|([^\|]+)\|([^\|]+)\|([^\|]+)\|([^\|]+)\|([^\|]+)\|(.+)$", match){
		connectBusy:=true
		if !(buffer.hasKey(match4)){
			buffer[match4]:=[]
		}
		buffer[match4,match6]:=match8
		
		complete:=true
		Loop % match7
			complete&= buffer[match4].hasKey(A_Index)
		
		if (!complete)
			return
		;~ if (StrLen(match6)!=match5){
			;~ outUdp.connect(match1, port+1)
			;~ outUdp.sendText("fail|" ++match2)
			;~ outUdp.disconnect()
			;~ return
		;~ }
		html:=""
		for k,v in buffer[match4]
			html.=v
		
		if StrLen(html)!=match5 {
			ToolTip % "Receive file " match4 ": incomplete!"
			SetTimer,ToolTip,-2000
			
			this.sendText("fail|" (++failTimes[match4]) "|" match4)
			buffer[match4]:=[]
			return
		}
		
		FileCreateDir,% dir:=A_ScriptDir "\" match3
		FileDelete,% path:=dir "\" match4
		printJS=<script type="text/javascript">window.onload=function(){window.print();}</script>
		FileAppend,% html printJS,% path,utf-8
		;~ MsgBox % html
		buffer.Delete(match4), failTimes.Delete(match4)
		connectBusy:=false
		;~ ToolTip % match6
		;~ outUdp.connect(match1, port+1)
		;~ outUdp.sendText("success|" match4)
		;~ outUdp.disconnect()
		ToolTip % "Receive file: " match4 
		SetTimer,ToolTip,-2000
		this.sendText("success|" match4)
	*/
	; ip|tryTimes|radiologist|htmlFileName|htmlStrLen|md5
	if RegExMatch(t, "is)^([^\|]+)\|(\d+)\|([^\|]+)\|([^\|]+)\|(\d+)(?:\|(\w+))$", match) && TCPclients[this].connectBusy {
		TCPclients[this].expectedLen:=match5
		,TCPclients[this].ip:=match1
		,TCPclients[this].tryTimes:=match2
		,TCPclients[this].Radiologist:=match3
		,TCPclients[this].htmlFileName:=match4
		,TCPclients[this].startRecv:=A_TickCount
		,TCPclients[this].md5:=match6
		ToolTip % "Start receiving: " match4
		SetTimer,ToolTip,-2000
		this.sendText("sendHTML")
		;~ clipboard:=""
	}else if (TCPclients[this].connectBusy && TCPclients[this].expectedLen>0) {
		;~ clipboard.=t "-------------------------------"
		
		thisLen:=StrLen(t)
		if(TCPclients[this].receivedLen+thisLen<=TCPclients[this].expectedLen)
			TCPclients[this].buffer.=t, TCPclients[this].receivedLen+=thisLen
		else
			TCPclients[this].buffer.=SubStr(t,1,TCPclients[this].expectedLen-TCPclients[this].receivedLen), TCPclients[this].receivedLen:=TCPclients[this].expectedLen
		
		
		bufferMd5:=md5(TCPclients[this].buffer)
		if (TCPclients[this].receivedLen!=TCPclients[this].expectedLen) || (TCPclients[this].md5!="" && TCPclients[this].md5!=bufferMd5)
			return
		else if (TCPclients[this].receivedLen=TCPclients[this].expectedLen) && (TCPclients[this].md5!="" && TCPclients[this].md5!=bufferMd5){
			;~ MsgBox,,,% TCPclients[this].receivedLen "," TCPclients[this].expectedLen "," TCPclients[this].md5 "," bufferMd5
		
			this.sendText("fail|" (TCPclients[this].tryTimes) "|" TCPclients[this].htmlFileName)
			resetTransferBuffer(this)
			return
		}
		
		SetTimer,connectTimeout,Off
		FileCreateDir,% dir:=A_ScriptDir "\" TCPclients[this].Radiologist
		FileDelete,% path:=dir "\" TCPclients[this].htmlFileName
		printJS=<script type="text/javascript">window.onload=function(){window.print();}</script>
		FileAppend,% TCPclients[this].buffer printJS,% path,utf-8
		resetTransferBuffer(this)
		;~ ToolTip % match6
		;~ outUdp.connect(match1, port+1)
		;~ outUdp.sendText("success|" match4)
		;~ outUdp.disconnect()
		ToolTip % "Receive file: " TCPclients[this].htmlFileName 
		SetTimer,ToolTip,-2000
		this.sendText("success|" TCPclients[this].htmlFileName)
		
	}else if RegExMatch(t, "is)^([^\|]+)\|printReport\|(.+)$", match) {
		ToolTip % "Prepare to print: " match2
		SetTimer,ToolTip,-2000
		queue.enqueue(match2)
		this.sendText("Printing")
	}else if RegExMatch(t, "is)^([^\|]+)\|listReport\|(.+)$", match) {
		listReport:=[]
		Loop % A_ScriptDir "\" match2 "\*.html"
			listReport.push(A_LoopFileFullPath)
		listReport:=sortFileListByTime(listReport)
		str:=""
		for k,v in listReport
			str.=RegExReplace(v, "is).+\\([^\\]+\.html)", "$1") "`n"
		this.sendText("Remote Files:`n" str)
	}else if RegExMatch(t, "is)^([^\|]+)\|queryStatus", match){
		;~ msgbox % "query"
		if (TCPclients[this].connectBusy) {
			this.sendText("Status: wait")
		}else{
			this.sendText("Status: OK")
			resetTransferBuffer(this)
			TCPclients[this].connectBusy:=true
		}
		;~ (outUdp:=new SocketUDP()).connect(match1, port+1)
		;~ outUdp.sendText("Status: OK")
		;~ outUdp.disconnect()
	}else if (t="abortTransfer"){
		resetTransferBuffer(socket)
	}
}

resetTransferBuffer(socket){
	global TCPclients
	TCPclients[socket, "buffer"]:=""
	,TCPclients[socket, "connectBusy"]:=false
	,TCPclients[socket, "expectedLen"]:=0
	,TCPclients[socket, "receivedLen"]:=0
	,TCPclients[socket, "startRecv"]:=0
	,TCPclients[socket, "md5"]:=""
}

connectTimeout:
for socket,client in TCPclients {
	if(client.connectBusy && (client.startRecv-A_TickCount)>5000){
		socket.sendText("fail|" client.tryTimes "|" client.htmlFileName)
		resetTransferBuffer(socket)
	}
}

ToolTip:
ToolTip
return

loadQueue:
fileread,queueText,% queueFile:=A_ScriptDir "\queue.txt"
loop,Parse,queueText,`,
	if(Trim(A_LoopField)!="")
		queue.enqueue(Trim(A_LoopField))
FileDelete, % queueFile
return

saveQueue:
FileDelete,% queueFile
while % (item:=queue.dequeue())
	FileAppend,% item ",",% queueFile,utf-8
return

getChromePath(){
	if FileExist(path:=A_ProgramFiles "\Google\Chrome\Application\chrome.exe")
		return path
	
	Loop % a_desktop "\*.lnk" {
		if InStr(A_LoopFileName, "chrome"){
			FileGetShortcut,% A_LoopFileFullPath,target
			if InStr(target,".exe")
				return target
		}
	}
	
	Loop, % A_MyDocuments "\*",2 
	{
		if InStr(A_LoopFileName, "chrome"){
			Loop,% A_LoopFileFullPath "\*",1,1
				if InStr(A_LoopFileName,"chrome") && InStr(A_LoopFileName,".exe")
					return A_LoopFileFullPath
		}
	}
	
	Loop, % A_ScriptDir "\*",2 
	{
		if InStr(A_LoopFileName, "chrome"){
			Loop,% A_LoopFileFullPath "\*",1,1
				if InStr(A_LoopFileName,"chrome") && InStr(A_LoopFileName,".exe")
					return A_LoopFileFullPath
		}
	}
	return ""
}


sortFileListByTime(dir, fileType="html", sortedBy="C"){
	if IsObject(dir){
		arr:=dir, sort:=[]
		for k,v in arr {
			FileGetTime, time, % v, % sortedBy
			sort[time fill0(k)]:=A_Index
		}
	}else{
		arr:=[], sort:=[]
		Loop % dir "\*." fileType {
			arr.push(A_LoopFileFullPath)
			FileGetTime, time, % A_LoopFileFullPath, % sortedBy
			sort[time fill0(A_Index)]:=A_Index
		}
	}
	ret:=[]
	for k,v in sort
		ret.push(arr[v])
	return ret
}

fill0(str, n=2){
	while StrLen(str)<n
		str:="0" str
	return str
}

printNewReport:
if queue.isEmpty()
	goto printNewReportEnd
thisReporter:=queue.dequeue()
if(thisReporter="")
	goto printNewReportEnd
printBusy:=true
printed:=[]
;~ Loop % A_ScriptDir "\" thisReporter "\*.html" {

/* print using chrome
for k,filePath in fileList:=sortFileListByTime(A_ScriptDir "\" thisReporter, "html"){
	ToolTip % "列印中，請稍候！"
	SetTimer,ToolTip,-3000
	gosub closeAllChrome
	
	fileread,toPrintHtml,% filePath
	if !InStr(toPrintHtml,"window.print()"){
		FileAppend,% "<script type=""text/javascript"">window.onload=function(){window.print();}</script>",% filePath,utf-8
	}
	run % """" filePath """"
	
	
	Loop {
		Sleep 500
		controlget,hwnd,hwnd,,Chrome_RenderWidgetHostHWND1,ahk_exe chrome.exe
	}until hwnd
	Sleep 4000
	winset,AlwaysOnTop,on,ahk_exe chrome.exe
	winactivate,ahk_exe chrome.exe
	WinMaximize,ahk_exe chrome.exe
	Sleep 1000
	ImageSearch,imX,imY,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\DoublePrint.png"
	if (!ErrorLevel){
		mouseclick,l,% imX+5,% imY+5,1,0
		Sleep 100
	}
	
	Loop {
		Sleep 200
		ImageSearch,imX,imY,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\chromePrint.png"
	}until !ErrorLevel || A_Index>50
	if(imX="" || imY="")
		send {Enter}
	else
		mouseclick,l,% imX,% imY,1,0
	
	printed.push(filePath)
	Sleep 5000
	filemove,% filePath,% printedDir,1
}
;~ for k,v in printed
	;~ filemove,% v,% printedDir,1
gosub closeAllChrome
*/
filelistStr:=""
for k,filePath in fileList:=sortFileListByTime(A_ScriptDir "\" thisReporter, "html")
	filelistStr.=" """ filePath """"
;~ Run % """" A_ScriptDir "\MammoSRSilentPrint.exe""" filelistStr
Run % runAhkExe("MammoSRSilentPrint.exe") commands(filelistStr)
printBusy:=false

printNewReportEnd:
ToolTip
SetTimer,printNewReport,-1000
return

closeAllChrome:

	Loop {
		Sleep 100
		process,Exist,chrome.exe
		if(!ErrorLevel || A_Index>10)
			return
		WinClose,ahk_exe chrome.exe
	}
return

localPrintMode:
toBePrint:=[], printed:=[], printBusy:=true
for k,filePath in param {
	fileType:=FileExist(filePath)
	SplitPath,filePath,,,extension
	if InStr(fileType,"D"){
		;~ for k,v in fileList:=sortFileListByTime(RegExReplace(filePath, "[\\\/]$", ""), "html")
			;~ toBePrint.push(v)
		Loop,% RegExReplace(filePath, "[\\\/]$", "") "\*.html"
			toBePrint.push()
	}else if (extension="html")
		toBePrint.push(filePath)
}

/* print using chrome
for k,htmlFile in sortFileListByTime(toBePrint) {
	ToolTip % "列印中，請稍候！"
	SetTimer,ToolTip,-3000
	gosub closeAllChrome
	
	
	fileread,toPrintHtml,% htmlFile
	if !InStr(toPrintHtml,"window.print()"){
		FileAppend,% "<script type=""text/javascript"">window.onload=function(){window.print();}</script>",% htmlFile,utf-8
	}
	
	;~ run % """" ChromePath " """ RegExReplace(A_LoopFileFullPath, " "," ") """"
	run % """" htmlFile """"
	Loop {
		Sleep 500
		controlget,hwnd,hwnd,,Chrome_RenderWidgetHostHWND1,ahk_exe chrome.exe
	}until hwnd
	Sleep 4000
	winset,AlwaysOnTop,on,ahk_exe chrome.exe
	winactivate,ahk_exe chrome.exe
	WinMaximize,ahk_exe chrome.exe
	Sleep 1000
	;~ winwait,ahk_exe chrome.exe,,5
	;~ Sleep 3000
	;~ WinActivate,ahk_exe chrome.exe
	;~ WinWaitActive,ahk_exe chrome.exe,,5
	;~ MsgBox % " {Enter}"
	ImageSearch,imX,imY,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\DoublePrint.png"
	if (!ErrorLevel){
		mouseclick,l,% imX,% imY,1,0
		Sleep 100
	}
	Loop {
		Sleep 200
		ImageSearch,imX,imY,0,0,% A_ScreenWidth,% A_ScreenHeight,% "*10 " A_ScriptDir "\image\chromePrint.png"
	}until !ErrorLevel || A_Index>50
	if(imX="" || imY="")
		send {Enter}
	else
		mouseclick,l,% imX,% imY,1,0
	
	printed.push(htmlFile)
	Sleep 5000
	filemove,% htmlFile,% printedDir,1
}	
printBusy:=false
;~ for k,v in printed
	;~ filemove,% v,% printedDir,1
gosub closeAllChrome
*/
filelistStr:=""
for k,htmlFile in sortFileListByTime(toBePrint) 
	filelistStr.=" """ htmlFile """"
;~ Run % """" A_ScriptDir "\MammoSRSilentPrint.exe""" filelistStr
Run % runAhkExe("MammoSRSilentPrint.exe") commands(filelistStr)
printBusy:=false
ToolTip
ExitApp
return


OnExit:
myTCP.disconnect()
for k,v in TCPclients
	k.disconnect()
gosub saveQueue
ExitApp


closemsg:
WinClose,ahk_exe rebootMsg.exe
return

MD5( V ) { ; www.autohotkey.com/forum/viewtopic.php?p=376840#376840
 VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, A_IsUnicode ? "AStr" : "Str",V
 , UInt,StrLen(V) ), DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
stringlower,MD5,md5
return md5
}