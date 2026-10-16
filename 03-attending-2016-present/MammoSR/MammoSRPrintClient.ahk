﻿FileEncoding,utf-8
DetectHiddenWindows,on
#include <Socket>
#include <Args>
#include <FTPv2>
#include <WM_COPYDATA>
#SingleInstance,Off
#NoTrayIcon
;~ argv:=Args( "", ( A_IsCompiled ? 1 : 2 ) )


ComObjError(false)
OnMessage(0x4A, "On_WM_COPYDATA")
param:=[]

if %0%
	Loop %0%
	{
		arg:=%a_index%
		param.push(arg)
	}
else 
	ExitApp



;~ param[1]:="10.0.0.100" ;"10.0.0.100"
;~ param[2]:=54321
;~ param[3]:="F:\scripts\Radiology\MammoSR\MammoReportSaved\20170613 5______.html"
;~ param[3]:="list陳醫師"


printReportInd:=listReportInd:=0
ftpUser:="MammoSR"
ftpPw:="impaxdsmammosr"

;~ if (%0%<3){
	;~ MsgBox % "Usage:`nMammoSRPrintClient.exe ip port filePath"
	;~ ExitApp
;~ }

ip:=param[1]
;~ if !ValidIP(ip:=argv[1]){
	;~ MsgBox % "Please enter valid ip address!"
	;~ ExitApp
;~ }



port:=param[2]+0
if (port=0){
	MsgBox % "Please enter valid port number!"
	ExitApp
}

file:=param[3]
if !FileExist(file) && !RegExMatch(file, "is)print(.+)", argPrint) && !RegExMatch(file, "is)list(.+)", argList) {
	MsgBox % "Please enter valid file path!"
	ExitApp
}

SplitPath,file,fileName
if(argPrint1!="" || argList1!=""){
	if(A_IPAddress1=ip || ip="localhost")
		goto localSend
	else 
		goto sendByTCP
}

sendByFtp:
if ! ((ftp:=new FTP()) 
	&& (ftp.Open(ip, ftpUser, ftpPw))){
	MsgBox % "FTP error: " ftp.LastError
	goto sendByTCP
}

;~ if  ((FileExisted:=ftp.FindFirstFile(fileName)) 
	;~ && FileExisted ) {
	;~ ftpFile(fileName)
;~ }

if !(ftp.PutFile(file)){
	MsgBox % "FTP error: " ftp.LastError
	goto sendByTCP
}
MsgBox,,,% "Successfully sent: " fileName,3
ExitApp
return

localSend:
if !WinExist("ahk_exe MammoSRPrintServer.exe") {
	if !FileExist(A_ScriptDir "\MammoSRPrintServer.exe"){
		MsgBox % "MammoSRPrintServer.exe NOT FOUND!!!"
		ExitApp
	}
	run % MammoSRPrintServer.exe
	winwait,ahk_exe MammoSRPrintServer.exe,,20
	if (ErrorLevel){
		MsgBox % "Can't run MammoSRPrintServer.exe!!!"
		ExitApp
	}
}
if(argPrint1!="")
	Send_WM_COPYDATA(WinExist("ahk_exe MammoSRPrintServer.exe"), 0, "localhost|printReport|" argPrint1)
else if (argList1!="")
	Send_WM_COPYDATA(WinExist("ahk_exe MammoSRPrintServer.exe"), 0, "localhost|listReport|" argList1)
return


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
	;~ MsgBox % t
	if (t="Printing"){
		SetTimer,printReport,Off
		MsgBox,,,% "Printing...",3
		ExitApp
	}else if InStr(t,"Remote Files:"){
		MsgBox % (clipboard:=t) (t="Remote Files:`n"?"no html file found!":"")
		ExitApp
	}
}

sendByTCP:

;~ MsgBox % ip "," port "," file

myTCP:=new SocketTCP()
myTCP.onRecv:=Func("OnTCPRecv")
myTCP.connect(ip, port)


queryServerStatus:
ServerStatus:="", waitServerInd:=0
myTCP.sendText(A_IPAddress1 "|queryStatus")
settimer,waitServerOK,-500
SetTimer,OnExit,-60000
return

waitServerOK:
if (ServerStatus!="") || (++waitServerInd)>6 {
	;~ ToolTip % waitServerInd
	SetTimer,waitServerOK,Off
}else{
	settimer,waitServerOK,-100
	return
}
if(ServerStatus="wait"){
	SetTimer,OnExit,Off
	SetTimer,queryServerStatus,-20000
	return
}else if(ServerStatus!="OK"){
	MsgBox % "Cannot connnect to server! `n" file
	ExitApp
}
;~ ToolTip % "Connect to server: OK"
;~ MsgBox % "OK"
;~ ExitApp




if FileExist(file)
	gosub sendFile
else if (argPrint1!="")
	gosub printReport
else if (argList1!="")
	gosub listReport
return


sendFile:
fileread,html,% file
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

tryTimes:=1
myTCP.sendText(A_IPAddress1 "|" tryTimes "|" Radiologist "|"  fileName "|" (len:=StrLen(html)) "|" (md5:=md5(html)))

;~ splitAndSend(html)
SetTimer,ifFileSent,-5000
return

splitAndSend(html){
	global fileName, Radiologist, myTCP
	len:=StrLen(html)
	static SectionLen:=256
	parts:=Floor(len/SectionLen)+(Mod(len,SectionLen)?1:0)
	Loop % parts {
		chunk:=SubStr(html, (A_Index-1)*SectionLen+1, SectionLen)
		,myTCP.sendText(A_IPAddress1 "|1|" Radiologist "|"  fileName "|" len "|" A_Index "|" parts "|" chunk)
		Sleep 100
	}
}
;~ myUdp.sendText("refresh")


return

ifFileSent:
MsgBox % "Failed to sent " fileName
ExitApp
;~ if (++tryTimes)>3 {
	;~ MsgBox % "Failed to sent " fileName
	;~ ExitApp
;~ }
;~ myTCP.sendText(A_IPAddress1 "|" tryTimes "|" Radiologist "|"  fileName "|" len "|" md5)
;~ myTCP.sendText(html)
;~ SetTimer,ifFileSent,-5000
return


printReport:
myTCP.sendText(A_IPAddress1 "|printReport|" argPrint1)
if(++printReportInd<3)
	SetTimer,printReport,-5000
return

listReport:
myTCP.sendText(A_IPAddress1 "|listReport|" argList1)
if(++listReportInd<3)
	SetTimer,listReport,-5000
return


OnTCPRecv(this){
	global html,fileName,len,ServerStatus,Radiologist,len,tryTimes,md5
	;~ global myTCP
	t:=this.recvText()
	;~ ToolTip % t
	;~ if RegExMatch(t, "i)fail|(\d+)", match){
		;~ if(match1>=3){
			;~ MsgBox,4,Send Report to Server,% "Failed to send after " match1 " attemps. Retry?"
			;~ IfMsgBox,Yes
			;~ {
				;~ Sleep 3000
				;~ this.sendText(A_IPAddress1 "|" (++match1) "|" fileName "|" len "|" html)
			;~ }else
				;~ ExitApp
		;~ }else{
			;~ Sleep 3000
			;~ this.sendText(A_IPAddress1 "|" (++match1) "|" fileName "|" len "|" html)
		;~ }
	if RegExMatch(t, "is)fail\|(\d+)\|(.+)", match){
		if(match1>100){
			MsgBox % "Failed to sent " match2
			ExitApp
		}
			
			
		Sleep 500
		this.sendText(A_IPAddress1 "|" (tryTimes:=match1+1) "|" Radiologist "|"  fileName "|" len "|" md5)
		;~ this.sendText(html)
		
	}else if RegExMatch(t, "is)success\|(.+)", match){
		MsgBox,,,% "Successfully sent: " match1,3
		ExitApp
	}else if RegExMatch(t, "is)Status: (.+)", match){
		ServerStatus:=match1
	}else if (t="Printing"){
		SetTimer,printReport,Off
		MsgBox,,,% "Printing...",3
		
		ExitApp
	}else if InStr(t,"Remote Files:"){
		MsgBox % (clipboard:=t) (t="Remote Files:`n"?"no html file found!":"")
		ExitApp
	}else if (t="sendHTML"){
		this.sendText(html)
	}
}


OnExit:
myTCP.sendText("abortTransfer")
myTCP.disconnect()
ExitApp

ValidIP(ByRef IPAddress)
{
	if (StrLen(IPAddress) > 15)
		return 0

	IfInString, IPAddress, %A_Space%
		return 0

	StringSplit, Octets, IPAddress, .
	if (Octets0 <> 4)
		return 0
	else if (Octets1 < 1 || Octets1 > 255)
		return 0
	else if (Octets2 < 0 || Octets2 > 255)
		return 0
	else if (Octets3 < 0 || Octets3 > 255)
		return 0
	else if (Octets4 < 0 || Octets4 > 255)
		return 0
	else Valid=1

	Oct1:=Octets1*0
	Oct2:=Octets2*0
	Oct3:=Octets3*0
	Oct4:=Octets4*0

	if (Oct1 <> 0 || Oct2 <> 0 || Oct3 <> 0 || Oct4 <> 0)
		return 0

	return %Valid%
}

MD5( V ) { ; www.autohotkey.com/forum/viewtopic.php?p=376840#376840
 VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, A_IsUnicode ? "AStr" : "Str",V
 , UInt,StrLen(V) ), DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
stringlower,MD5,md5
return md5
}