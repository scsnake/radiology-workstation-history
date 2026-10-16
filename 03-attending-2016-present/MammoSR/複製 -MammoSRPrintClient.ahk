﻿FileEncoding,utf-8
#include <Socket>
#include <Args>
;~ #NoTrayIcon
;~ argv:=Args( "", ( A_IsCompiled ? 1 : 2 ) )

ComObjError(false)
param:=[]
if %0%
	Loop %0%
	{
		arg:=%a_index%
		param.push(arg)
	}
else 
	ExitApp

;~ param[1]:="localhost" ;"10.0.0.100"
;~ param[2]:=54321
;~ param[3]:="F:\scripts\Radiology\MammoSR\MammoReportSaved\20160906 5______.html"
;~ param[3]:="print陳醫師"



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
if !FileExist(file) && !RegExMatch(file, "is)print(.+)", argPrint){
	MsgBox % "Please enter valid file path!"
	ExitApp
}


;~ MsgBox % ip "," port "," file

inUdp:=new SocketUDP()
inUdp.bind("addr_any",port+1)
inUdp.onRecv:=func("OnUDPRecv")

queryServerStatus:
ServerStatus:="", waitServerInd:=0
outUdp(ip, port, A_IPAddress1 "|queryStatus")
settimer,waitServerOK,-100
SetTimer,OnExit,-60000
return

waitServerOK:
if (ServerStatus!="") || (++waitServerInd)>30 {
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
	MsgBox % "Cannot connnect to server!"
	ExitApp
}
ToolTip % "Connect to server: OK"
;~ MsgBox % "OK"
;~ ExitApp




if FileExist(file)
	gosub sendFile
else if (argPrint1!="")
	gosub printReport
return

 
outUdp(ip, port, txt){
	global outUdp
	if !IsObject(this:=outUdp[ip ":" port]){
		outUdp[ip ":" port]:=this:=new SocketUDP()
		this.connect(ip, port)
	}
	return this.sendText(txt)
}
 
sendFile:
SplitPath,file,fileName
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


splitAndSend(html)
return

splitAndSend(html){
	global fileName, Radiologist, ip, port
	len:=StrLen(html)
	static SectionLen:=256
	parts:=Floor(len/SectionLen)+(Mod(len,SectionLen)?1:0)
	Loop % parts {
		chunk:=SubStr(html, (A_Index-1)*SectionLen+1, SectionLen)
		,outUdp(ip, port, A_IPAddress1 "|1|" Radiologist "|"  fileName "|" len "|" A_Index "|" parts "|" chunk)
		Sleep 100
	}
}
;~ myUdp.sendText("refresh")


return


printReport:
outUdp(ip, port, A_IPAddress1 "|printReport|" argPrint1)
ExitApp
return


OnUDPRecv(this){
	global html,fileName,len,ServerStatus
	global outUdp
	t:=this.recvText()
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
		if(match1>3){
			MsgBox % "Failed to sent " match2
			ExitApp
		}
			
			
		Sleep 10000
		splitAndSend(html)
	}else if RegExMatch(t, "is)success\|(.+)", match){
		MsgBox,,,% "Successfully sent: " match1,3
		ExitApp
	}else if RegExMatch(t, "is)Status: (.+)", match){
		ServerStatus:=match1
	}
}


OnExit:
inUdp.disconnect()
for k,v in outUdp
	v.disconnect()
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