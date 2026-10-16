﻿#include <checkUpdate>
scs_sync()
FileEncoding,utf-8
#include <socket>
#include <RISIMPAX>
;~ #include <Crypt_AES>
;~ #include <Hex2Bin>
#include <crypt>
#include <CharWordPos>
#include <scrollable GUI>
#include <winvisible>
#include <settimerf>
#include <jxon>
#include <acc>
DetectHiddenWindows,on
SetTitleMatchMode,2
CoordMode,mouse,screen
SetBatchLines,-1
#SingleInstance,force
#InstallKeybdHook
#InstallMouseHook
onexit,OnExit
ComObjError(false)

serverIp:="10.0.1.100"
tcpPort:=35367

gosub checkImpax
gosub loadCSV
gosub impaxRefresh
gosub main
return

main:
if(impaxUserId=""){
	settimer,main,-10000
	return
}
gosub log
;~ impaxUserAbbr:="YCH"
;~ gosub tcp


dialogInd:=0
;~ sendQueue:={}
UserIpPair:=[]
;~ settimer,queueSend,-500
;~ gosub test
;~ showHxGui()
;~ gosub testSend
menu,tray,add,
menu,tray,add,Online User,queryOnline
menu,tray,add,Recent,showRecent
menu,tray,add,Search,searchHx
menu,tray,add,Send Message,sendMsg
;~ gosub sendMsg
settimer,autoSave,3______
settimerf("socketPoolDisconnect",10000)
Crypt:=new Crypt, AES_pw:="%TGB6yhn"
;~ settimer,checkTcp,60000
return

socketPoolDisconnect(){
	global socketPool
	for k,v in socketPool {
		if(v.2.socket=-1){
			socketPool.Delete(k)
		}else if(A_TickCount-v.1>10000){
			v.2.disconnect()
		}
	}
	
}



testSend:
outtcp.sendText(a_now "|CNL|YCH|T__________|1______|" A_IPAddress1 "," A_ComputerName)
return

showRecent:
showHxGui()
return

searchHx:
searchKeyWord:=""
inputbox,searchKeyWord,Search,% "Search for chart No or key words",,300,200
if errorlevel || (searchKeyWord="")
	return
if (msgLog="")
		fileread,msgLog,% msgLogPath
searchResult:=[]
loop,parse,msgLog,`n,`r
	if (a_loopfield!="" ) &&  instr(a_loopfield,searchResult)
		searchResult.push(parseMsg(a_loopfield))
showSearchResultGui(searchKeyWord)
return

broadcast:
broadcastMsg:=""
inputbox,broadcastMsg,Broadcast,Broadcast to All Users,,300,200
if errorlevel || (broadcastMsg="")
	return
gosub impaxRefresh
outtcp("addr_broadcast", tcpPort, jxon_dump({ip: A_IPAddress1, title: "broadcast", body: a_now "|" impaxUserAbbr "||||" msgStrip1(broadcastMsg)}))
return

outtcp(ip, port, msg){
	msg:=enc(msg)
	global socketPool
	{
		socketPool.push([A_TickCount, newTcp:=new SocketTCP()])
		newTcp.onRecv:=Func("onTcpRecv")
		r:=newTcp.connect(ip, port)
		newTcp.sendText(msg)
		;~ newTcp.disconnect()
	}
}

checkImpax:
if (impaxOpened()[1]!=2) {
	MsgBox, 4144, ,	% "Please login IMPAX !"
}
return
impaxRefresh:
impaxState:=impaxOpened()
if(pImpaxState[1]=impaxState[1] && (pImpaxState[2,2]|pImpaxState[2,3])!=(impaxState[2,2]|impaxState[2,3])){
	settimer,impaxRefresh,-5000
	return
}
pImpaxState:=impaxState.clone()
impaxInfo:=getImpaxInfo(impaxState,infoItems:=["chartNo", "UserId", "AccNo"])
for k,v in infoItems
	impax%v%:=impaxInfo[v]
impaxUserAbbr:=impaxUserAbbr(impaxUserId)
;~ impaxUserId:=getImpaxUserId(impaxState),impaxUserAbbr:=impaxUserAbbr(impaxUserId)
;~ ,impaxAccNo:=getImpaxAccNo(impaxState),impaxChartNo:=getImpaxChartNo(impaxState)
if(impaxUserAbbr="" && impaxUserId=""){
	myTCP.disconnect()
	hasLoginServer:=false
	settimer,impaxRefresh,-5000
	return
}
if(impaxUserAbbr="")
	impaxUserAbbr:=impaxUserId
if(pimpaxUserAbbr!=impaxUserAbbr && pimpaxUserAbbr!="") || !hasLoginServer
	gosub tcp

pimpaxUserAbbr:=impaxUserAbbr
settimer,impaxRefresh,-60000
return

sendMsg:	
gosub impaxRefresh
gui,send:destroy
gui,send:default
gui,font,s10,Verdana
gui,+hwndguiSendHwnd +alwaysontop +toolwindow
GroupAdd,sendMsg,ahk_id %guiSendHwnd%
gui,add,text,section,% "Sender: "
gui,add,edit,vsender xp+100 yp w100,% impaxUserAbbr
gui,add,text,xs,% "Receiver:"
;~ gui,add,edit,vsendto xp+100 yp w100,% (impaxUserAbbr="YCH"?"WGL":"YCH")
gui,add,edit,vsendto xp+100 yp w100,
gui,add,text,xs,% "Access No:"
gui,add,edit,vaccNo xp+100 yp w100,% impaxAccNo
gui,add,text,xs,% "Chart No:"
gui,add,edit,vchartNo xp+100 yp,% impaxChartNo
gui,add,text,x+0 yp+5,% "(Optional)"
gui,add,text,xs y+5,% "Message: "
gui,add,edit,xs y+5 vsendTxt r3 w250,

gui,add,button,xs y+5 gsending,Send

guicontrol,focus,% impaxUserAbbr?"sendTo":"sender"
gui,show,autosize,Send Message
return

#IfWinActive,ahk_group sendMsg
~NumpadEnter::
~Enter::
if(A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<500)
	ControlClick,Send,A
return
#IfWinActive

impaxUserAbbr(impaxUserId){
	global contacts
	for k,v in contacts
		if (v.7=impaxUserId){
			;~ matched:=1
			return abbr:=v.3
			break
		}
}

sending:
gosub impaxRefresh
gui,send:submit,NoHide
matched:=0
sender:=trim(sender)
,sendto:=trim(sendto)
,accNo:=trim(accNo)
,chartNo:=trim(chartNo)
if !(impaxAccNo){
	impaxAccNo:=getImpaxAccNo(impaxState)
}
if !(impaxChartNo){
	impaxChartNo:=getImpaxChartNo(impaxState)
}
for k,v in contacts
	if (v.3=sendto || v.7=sendto){
		matched:=1
		sendTo:=v.3
		break
	}
if (!matched){
	msgbox % "Receiver " sendto " not found in contacts.csv!"
	return
}
matched:=0
for k,v in contacts
	if (v.3=impaxUserId || v.7=impaxUserId){
		matched:=1
		sender:=v.3
		break
	}
if (!matched){
	msgbox % "Sender " impaxUserId " (current IMPAX user) not found in contacts.csv!"
	return
}
gui,send:destroy

sender:=impaxUserAbbr

;~ outtcp.sendtext((nowTime:=a_now) "|" sender "|" sendto "|" (impaxAccNo) "|" (impaxChartNo) "|" msgStrip1(sendTxt))
nowTime:=a_now
;~ sendQueue[nowTime "/00"]:={ip: (targetIp:=UserIpPair[sendto]?UserIpPair[sendto]:"addr_broadcast"), body: (nowTime) "|" sender "|" sendto "|" (impaxAccNo) "|" (impaxChartNo) "|" msgStrip1(sendTxt)}
if(myTCP=-1 || myTCP.sendText("keepConnection")=0)
	gosub tcp
myTCP.sendText(lastSent:=jxon_dump({ip: A_IPAddress1, target: sendto, from: sender, body: (nowTime) "|" sender "|" sendto "|" (impaxAccNo) "|" (impaxChartNo) "|" enc(msgStrip1(sendTxt))}))
line:=sendLog(nowTime,sender,sendto,impaxAccNo,impaxChartNo,msgStrip1(sendTxt))
showGUI(nowTime,sender,sendto,impaxAccNo,impaxChartNo,parseMsg(line))
;~ settimer,closeInfo,-2000
return
fill0(str,n=2){
	while strlen(str)<n
		str:="0" str
	return str
}
ToolTip:
ToolTip
return

queueSend:
if queueLock
	settimer,queueSend,-500
queueSend()
settimer,queueSend,-500
return

queueSend(){
	global sendQueue,tcpPort,queueLock,TCPsockets
	queueLock:=1
	sendQueueClone:=sendQueue.clone()
	for timeTry,toBeSentMsg in sendQueueClone {
		time:=substr(timeTry,1,-3)
		try:=substr(timeTry,-1,2)
		if(try="00"){
			outtcp(toBeSentMsg.ip, tcpPort, jxon_dump({ip: A_IPAddress1, body: toBeSentMsg.body}))
			,sendQueue.Delete("" timeTry)
			if (toBeSentMsg.ip!="addr_broadcast")
				sendQueue[a_now "/01"]:=toBeSentMsg.clone()
		}else if (try<5){
			now:=A_Now
			now-=time,s
			if(now>3){
				outtcp(toBeSentMsg.ip, tcpPort, jxon_dump({ip: A_IPAddress1, body: toBeSentMsg.body}))
				,sendQueue.Delete("" timeTry)
				,sendQueue[a_now "/" fill0(try+1)]:=toBeSentMsg.clone()
			}
		}else{
			MsgBox, 8240, ,% "Can't send message to " toBeSentMsg.ip ": `n" toBeSentMsg.body 
			sendQueue.Delete("" timeTry)
		}
	}
	queueLock:=0
	;~ settimerf("queueSend",-500)
}
return

tcp:
if(myTCP!=-1)
	myTCP.disconnect()
myTCP:=new SocketTCP()
;~ myTCP.bind("addr_any",tcpPort)
;~ myTCP.onAccept:=Func("OnTCPAccept")

myTCP.onRecv:=Func("OnTCPRecv")
if (myTCP.connect(serverIp,tcpPort)!=1){
	MsgBox % "Cannot connect to server. Please contact YCH(scsnake@gmail.com)."
	ExitApp
}
myTCP.sendText("ImpaxUserAbbr: " impaxUserAbbr)
hasLoginServer:=true
;~ myTCP.listen()
settimer,checkTcp,60000
return

checkTcp:
if(myTCP=-1 || myTCP.sendText("keepConnection")=0)
	gosub tcp
return




;~ j::
test:
;~ return
impaxUserId:=loginId
testInd:=(!testInd)?1:(testInd+1)
test:=new test(a_now "|CSY|YCH|T__________|1______|test" testInd)
ontcprecv(test)?
return

;~ k::
test2:
;~ return
impaxUserId:=loginId
testInd:=(!testInd)?1:(testInd+1)
test:=new test(a_now "|CNL|YCH|T__________|1______|test" testInd)
ontcprecv(test)
return

class test {
	__New(text){
		this.text:=text
	}
	recvText(){
		return this.text
	}
}



dateFormat(i){
	str:=substr(i,1,4) "/" substr(i,5,2) "/" substr(i,7,2) " " substr(i,9,2) ":" substr(i,11,2)
	if substr(i,1,4)=a_yyyy
		str:=(substr(i,5,4)=(a_mm a_dd))?substr(str,12):substr(str,6)
	i-=a_now,Days
	if (i*1<(-365)*3)
		str:=substr(str,1,4)
	else if (i<-7)
		str:=substr(str,1,-6)
	
	return "[" str "]"
	
}

showSearchResultGui(searchKeyWord){
	global
	total:=searchResult.MaxIndex()
	gui,search:Default
	gui,destroy
	gui,font,s10,Verdana
	gui,+hwndguiSearchHwnd +alwaysontop +toolwindow
	groupadd,MyGui,ahk_id %guiHxHwnd%
	OnMessage(0x115, "OnScroll") ; WM_VSCROLL
	OnMessage(0x114, "OnScroll") ; WM_HSCROLL
	loop % total {
		dialog:=searchResult[textInd:=total-a_index+1]
		talks:=[]
		for k,v in dialog.6
			if isobject(v)
				for i,j in v
					if instr(j, searchKeyWord)
						talks.push([i, j])
		talksCount:=talks.maxIndex()
		recentTalks:=""
		if talksCount>1
			recentTalks:="`n" talks[talksCount-1,2] "`n" talks[talksCount,2]
		else if talksCount>0
			recentTalks:="`n" talks[talksCount,2]
		else 
			recentTalks:="`n" dialog.4 " " dialog.5
		gui,add,text,border w200 y+3 gopenDialog vsr%textInd%,% dateFormat(talks[talks.maxindex(),1]) " " (checkReceiver(dialog.2,getImpaxUserId(impaxOpened()))?dialog.3:dialog.2) recentTalks
	}
	gui,show,% "y" a_screenheight " w250 noactivate",% "Search Result"
	wingetpos,,,w,h,ahk_id %guiSearchHwnd%
	winmove,ahk_id %guiSearchHwnd%,,% a_screenwidth-w-5,% a_screenheight-h-35,% w+5,% h+5
}

showHxGui(whichGui="",datetime=30,user="",keyword=""){
	global 
	hx:=filterHx(datetime,user,keyword)
	total:=hx.maxIndex()
	;~ gui,1:hide
	gui,hx:default
	gui,Destroy
	gui,font,s10,Verdana
	gui,+hwndguiHxHwnd +alwaysontop +toolwindow
	groupadd,MyGui,ahk_id %guiHxHwnd%
	OnMessage(0x115, "OnScroll") ; WM_VSCROLL
	OnMessage(0x114, "OnScroll") ; WM_HSCROLL
	loop % total {
		dialog:=hx[textInd:=total-a_index+1]
		talks:=[]
		for k,v in dialog.6
			if isobject(v)
				for i,j in v
					talks.push([i, j])
		talksCount:=talks.maxIndex()
		recentTalks:=""
		if talksCount>1
			recentTalks:="`n" talks[talksCount-1,2] "`n" talks[talksCount,2]
		else if talksCount>0
			recentTalks:="`n" talks[talksCount,2]
		gui,add,text,border w200 y+3 gopenDialog vhx%textInd%,% dateFormat(talks[talks.maxindex(),1]) " " (checkReceiver(dialog.2,getImpaxUserId(impaxOpened()))?dialog.3:dialog.2) recentTalks
	}
	gui,show,% "y" a_screenheight " w250 noactivate",% "Message history"
	wingetpos,,,w,h,ahk_id %guiHxHwnd%
	winmove,ahk_id %guiHxHwnd%,,% a_screenwidth-w-5,% a_screenheight-h-35,% w+5,% h+5
}
openDialog:
if(instr(A_GuiControl,"hx"))
	clickHx:=hx[substr(a_guicontrol,3)+0].clone()
else if instr(a_guicontrol,"sr")
	clickHx:=searchResult[substr(a_guicontrol,3)+0].clone()
showGUI(clickHx.1,clickHx.2,clickHx.3,clickHx.4,clickHx.5,clickHx)
return
showGUI(datetime, sender, receiver, accNo, chartNo, msgHx){
	global 
	local oldSelS, oldSelE, oldEditText, dialogNo, editstr, dialogExisted, thisGuiHwnd
	currentInfo:=msgHx.clone()
	
	if !isobject(dialogInfo)
		dialogInfo:=[]
	
	if !dialogNo:=dialogInfo[(sender=impaxUserAbbr?receiver:sender) accNo,"index"]
		dialogInfo[(sender=impaxUserAbbr?receiver:sender) accNo,"index"]:=dialogNo:=++dialogInd
		,dialogInfo[(sender=impaxUserAbbr?receiver:sender) accNo,"currentInfo"]:=currentInfo.clone()
	else if thisGuiHwnd:=WinExist("ahk_id " dialogInfo[(sender=impaxUserAbbr?receiver:sender) accNo,"hwnd"])
		dialogExisted:=true
	;~ else
		;~ guicontrolget,dl%dialogInd%: prvDialogText,,
	
	;~ loop 9
		;~ recentInfo[10-a_index+1]:=recentInfo[10-a_index].clone()
	;~ recentInfo[1]:=[datetime, sender, receiver, accNo, chartNo]
	;~ gui,hx:hide
	;~ gui,search:hide
	
	gui,dl%dialogNo%:default
	
	if(!dialogExisted){
	
		gui,destroy
		gui,font,s10,Verdana
		gui,+hwndguiHwnd%dialogNo% +alwaysontop +toolwindow
		groupadd,MyGui,% "ahk_id " guiHwnd%dialogNo%
		GroupAdd,MsgGUI,% "ahk_id " guiHwnd%dialogNo%
		dialogInfo[(sender=impaxUserAbbr?receiver:sender) accNo,"hwnd"]:=guiHwnd%dialogNo%
		OnMessage(0x115, "OnScroll") ; WM_VSCROLL
		OnMessage(0x114, "OnScroll") ; WM_HSCROLL
		guiWidth:=250
		textWidth:=200
		spacing:=guiWidth-textWidth
		;~ padd:=!checkReceiver(sender,impaxUserId:=getImpaxUserId(impaxOpened()))
		padd:=!(currentInfo.2=impaxUserAbbr)
		guiTextLine:=0
		for k,v in msgHx.6 
			for in,j in v
				++guiTextLine
		
		guiTextLineLimit:=(guiTextLine>15)?(guiTextLine-15):0
		
		gui,Add,edit,ReadOnly,% accNo
		gui,Add,edit,xm y+0 ReadOnly,% chartNo
	}
	
	editStr:=""
	for k,v in msgHx.6 {
		;~ gui,font,% "c" mod(k+padd,2)?"gray":"black"
			for i,j in v
				if substr(i,1,8)=substr(a_now,1,8) && (--guiTextLineLimit<0) {
					;~ gui,add,text,% "gcopytext w" textWidth " x" (mod(k+padd,2)?5:55) " y+" (a_index=1?5:0),% breakLine(dateFormat(i) " " j)
					editStr.=(mod(k+padd,2)?"":"     ") RegExReplace(breakLine(dateFormat(i) " " j), "\n", "`r`n" (mod(k+padd,2)?"":"     ")) "`r`n"
				}
	}
	
	if(!dialogExisted){
		lastFromOther:=!mod(k+padd,2)
		gui,Add,edit,% "r15 veditDlg" dialogNo " w230 x5 y+5 hwndeditDlgHwnd" dialogNo " readonly",% editStr 
		gui,add,edit,% "r3 vedit" dialogNo " w230 x5 y+10 hwndedithwnd" dialogNo,
		gui,add,button,greply y+0,Reply
		gui,add,button,gshowRecentButton x+30 yp,Recent
		gui,add,button,gshowImage x+30 yp,Image
		gui,show,% "y" a_screenheight " w250 noactivate",% checkReceiver(sender,impaxUserId)?sender " <-> " receiver:receiver " <-> " sender
		guiPos((sender=impaxUserAbbr?receiver:sender) accNo)
	}else{
		guicontrol,,% "editDlg" dialogNo,% editStr
	}
	
}

#IfWinActive,ahk_group MsgGUI
Enter::
ControlClick,Reply,A
return
~^c::
Sleep 200
clipboard:=RegExReplace(clipboard, "  +", "")
return
#IfWinActive

copytext:
MouseGetPos,,,,con,2
clipboard:=ControlGetText(con)
ToolTip % "Text copied to clipboard!"
settimer, ToolTip, -2000
return

breakLine(txt){
	s:="", start:=0, len:=0, lim:=20, StrLen:=StrLen(txt)
	Loop,Parse,txt
	{
		if(A_LoopField="`n" || len>=lim){
			s.="`n" A_LoopField, len:=0
			continue
		}
		len+=Asc(A_LoopField)<123?1:2
		,s.=A_LoopField
		 
	}
	return s
}

guiPos(info){
	global dialogInfo
	
	existWin:=[]
	
	for k,v in dialogInfo {
		if (k=info)
			continue
		if Winvisible(v.hwnd)
			existWin.push(v.hwnd)
	}
	wingetpos,,,w,h,% "ahk_id " dialogInfo[info,"hwnd"]
	x:=a_screenwidth-w-1,y:=a_screenheight-h-30
	winmove,% "ahk_id " dialogInfo[info,"hwnd"],,% x,% y
	for k,v in existWin {
		wingetpos,,,w,h,% "ahk_id " v
		if (y-=h)<0
			y:=a_screenheight-h-30,x-=w
		winmove,% "ahk_id " v,,% x,% y
	}
	winactivate,% "ahk_id " dialogInfo[info,"hwnd"]
	controlfocus,Edit1
	
}


1guiclose:
;~ gui,1: destroy
return
showRecentButton:
;~ if winexist("ahk_id " guiHxHwnd) {
	;~ gui,hx: show
	;~ gui,1: hide
;~ }else{
	showHxGui(a_gui)
;~ }
return
reply:
gui,%a_gui%: submit, NoHide
thisGui:=A_Gui
guicontrol,%thisGui%:,% "edit" SubStr(thisGui,3),% ""

for k,v in dialogInfo 
	if (v.index=substr(thisGui,3)){
		thisInfo:=v.currentInfo
		,thisInd:=v.index
		break
	}

if !(edit%thisInd%:=trim(edit%thisInd%))
	return

if(thisInfo.3=impaxUserAbbr)
	s:=thisInfo.3,r:=thisInfo.2
else
	s:=thisInfo.2,r:=thisInfo.3

;~ outtcp.sendtext((nowTime:=a_now) "|" s "|" r "|" thisInfo.4 "|" thisInfo.5 "|" msgStrip1(edit%thisInd%))
nowTime:=a_now
;~ sendQueue[nowTime "/00"]:={ip: (targetIp:=(UserIpPair[r]!=""?UserIpPair[r]:"addr_broadcast")), body: ((nowTime) "|" s "|" r "|" thisInfo.4 "|" thisInfo.5 "|" msgStrip1(edit%thisInd%))}
if(myTCP=-1 || myTCP.sendText("keepConnection")=0)
	gosub tcp
myTCP.sendText(jxon_dump({ip: A_IPAddress1, target: r, from: s, body: (nowTime) "|" s "|" r "|" thisInfo.4 "|" thisInfo.5 "|" enc(msgStrip1(edit%thisInd%))}))

line:=sendLog(nowTime,s,r,thisInfo.4,thisInfo.5,msgStrip1(edit%thisInd%))
;~ if lastFromOther
	;~ tmparr:=[],tmpArr["" nowTime]:=edit%thisInd%,thisInfo.6.push(tmpArr)
;~ else
	;~ thisInfo[6, thisInfo.6.maxIndex(), "" nowTime]:=edit%thisInd%
showGUI(nowTime,s,r,thisInfo.4,thisInfo.5,parseMsg(line))
;~ settimer,closeInfo,-2000
return

^i::
showImage:
thisGui:=A_Gui
for k,v in dialogInfo 
	if (v.index=substr(a_gui,3)){
		thisInfo:=v.currentInfo
		break
	}
gosub openImpaxContextServer
cmdContextServer("ADD_TO_DISPLAY_LIST || " currentInfo.4 " || SYNC_DISPLAY || " thisInfo.4 " ||",impaxContextServerHwnd)
return

openImpaxContextServer:
if(impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")){
	return
}else{
	impaxContextServerPath:=getImpaxContextServerPath()
	if(path=""){
		MsgBox % "ImpaxContextServer not found!"
		return
	}
	run % impaxContextServerPath
	winwait,ahk_exe ImpaxContextServer.exe,,2
	impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")
	impaxContextServerOpened:=true
}
return

closeInfo:
mousegetpos,,,mouseonWin
if (mouseOnWin=guiHwnd)
	settimer,closeInfo,-2000
else
	gui,destroy
return
hxGuiSize:
1GuiSize:
    UpdateScrollBars(A_Gui, A_GuiWidth, A_GuiHeight)
return
#IfWinActive ahk_group MyGui
WheelUp::
WheelDown::
+WheelUp::
+WheelDown::
    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
    OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, GetKeyState("Shift") ? 0x114 : 0x115, WinExist())
return
#IfWinActive


filterHx(datetime=30,user="",keyword=""){
	global msgLog,msgLogPath
	if (msgLog="")
		fileread,msgLog,% msgLogPath
	arr:=[]
	loop,parse,msgLog,`n
	{
		if !trim(a_loopfield)
			continue
		d:=substr(a_loopfield,1,14)
		d-=a_now,Days
		if (d<(-1)*dateTime)
			continue
		if (user && !instr(substr(a_loopfield,16,7),user))
			continue
		if (keyword && !instr(a_loopfield,keyword))
			continue
		arr.push(parseMsg(a_loopfield))
		
	}
	return arr
}

OnTCPAccept(this){
	global TCPclients
	TCPclients.push(newTcp:=this.accept())
	newTcp.onRecv:=Func("OnTCPRecv")
}


/* storage
DATETIME,asker,answerer,單號,[病歷號],"asker message","DATETIME answerer message[|DATETIME consequent message if any]"
*/

/* packet
DATETIME|sender|receiver|單號|[病歷號]|message
*/
;~ o::

;~ MsgBox,,,test,1

;~ return


queryOnline:
if(myTCP=-1 || myTCP.sendText("keepConnection")=0)
	gosub tcp
myTCP.sendText("GetOnlineUser")
return

OntcpRecv(this){
	global ImpaxState,impaxUserId,UserIpPair,tcpPort,TCPclients
	
	if !RegExMatch(t:=this.recvText(), "is)^!plain!(.*)$", match)
		isJson:=true
	else
		t:=match1, isJson:=false
	;~ msgbox,,, % t "," A_TickCount,1
	if !impaxState
		impaxState:=ImpaxOpened()
	if !impaxUserId
		impaxUserId:=getImpaxUserId(impaxOpened())
	
	if(isJson){
		try {
			msg:=jxon_load(t)
		}catch e {
		}
		if isobject(e)
			return
		
		t:=msg.body
		ip:=msg.ip
		title:=msg.title
	}
	
	if (ip=a_ipaddress1)
		return
	
	;~ if regexmatch(t,"is)(\d{14})\|(\w+)\|(\w+)\|(\w+)\|(\w+)?\|(.+?)") && impaxState[1]=2 && checkReceiver(match3,impaxUserId) {
	if (title="received") {
		for k,v in sendQueue 
			if (md5(v.body)=t){
				sendQueue.Delete("" k)
				;~ msgbox % test.body
				break
			}
		;~ this.disconnect()
	}else if(title="broadcast") && regexmatch(t,"is)^(\d{14})\|(\w+)\|\|\|\|(.*)",match) {
		msgbox,,% "Message from " match1,% dateformat(match1) ":`n" msgUnStrip(dec(match3))
	}else if regexmatch(t,"is)^(\d{14})\|(\w+)\|(\w+)\|(\w+)\|(\w+)?\|(.*)$",match)  {
		
	
		if(checkReceiver(match3,impaxUserId)){
			UserIpPair[match2]:=ip
			line:=parseInfo(match1,match2,match3,match4,match5,msgUnStrip(dec(match6)))
			showGUI(match1,match2,match3,match4,match5,parseMsg(line))
			;~ settimer,testGui,-1
			;~ this.sendText(jxon_dump({title: "received", ip: A_IPAddress1, body: md5(t)}))
			;~ outtcp(ip, tcpPort, jxon_dump({title: "received", ip: A_IPAddress1, body: md5(t)}))
		}
	}else if RegExMatch(t, "is)^(\w+) is (on|off)line\.", match){
		TrayTip,, % match,2
		settimer,TrayTip,-2000
	}else if RegExMatch(t, "is)^Online user: (.*)$", match){
		MsgBox,,Online User,% match1
	}else if (t="You've got some offline messages!"){
		MsgBox,,Offline Message,% t
	}
	;~ Crypt_AES(&pData, 128, pwGenerator(), 256, false)
	;~ txt:=StrGet(&pData, 128, "UTF-8")
	;~ tooltip % "server receive: " t
	
	
}

TrayTip:
traytip
return

testGui:
gui,test:Default
gui,Destroy
gui,Add,button,gtestb,test
gui,show,
return
testb:
MsgBox test
return

parseMsg(logLine){
	global impaxUserId:=getImpaxUserId(impaxOpened())
	arr:=[]
	loop,parse,logLine,CSV
		arr.push(a_loopfield)
	msg:=[]
	;~ if checkReceiver(arr.3,impaxUserId)
		;~ msg.push("")
	loop % arr.maxindex()-5 {
		txt:=arr[a_index+5]
		arr2:=[]
		loop,parse,txt,|
		{
			RegExMatch(a_loopfield,"i)(\d{14})?(.+)",match)
			arr2["" (match1?match1:arr.1)]:=msgUnstrip(match2)
		}
		msg.push(arr2)
	}
	return [arr.1,arr.2,arr.3,arr.4,arr.5,msg]
}
parseInfo(datetime, sender, receiver, accNo, chartNo, msg){
	log:=getLog(datetime, sender, receiver, accNo, chartNo)
	global msgLog
	i:=log.3,match1:=log.2,match:=log.1
	
	if (i) {
		loop,parse,match,CSV
			if trim(a_loopfield)
				colNo:=a_index
		
		if (instr(match1,sender)=1 && mod(colNo,2)=0) || (instr(match1,receiver)=1 && mod(colNo,2)=1)
			msgLog:=substr(msgLog,1,i-1<0?0:i-1) (newLine:=substr(match,1,-1) "|" datetime msgStrip1(msg) """") substr(msgLog,i+strlen(match))
		else
			msgLog:=substr(msgLog,1,i-1<0?0:i-1) (newLine:=match ",""" datetime msgStrip1(msg) """") substr(msgLog,i+strlen(match))
			
	}else {
		msgLog.=newLine:=datetime "," sender "," receiver "," accNo "," chartNo ",""" msgStrip1(msg) """`n"
	}
	return newLine
}
sendLog(datetime, sender, receiver, accNo, chartNo, msg){
	log:=getLog(datetime, sender, receiver, accNo, chartNo)
	global msgLog
	i:=log.3,match1:=log.2,match:=log.1
	
	if (i) {
		loop,parse,match,CSV
			if trim(a_loopfield)
				colNo:=a_index
		
		if (instr(match1,sender)=1 && mod(colNo,2)=0) || (instr(match1,receiver)=1 && mod(colNo,2)=1)
			msgLog:=substr(msgLog,1,i-1<0?0:i-1) (newLine:=substr(match,1,-1) "|" datetime msgStrip1(msg) """") substr(msgLog,i+strlen(match))
		else 
			msgLog:=substr(msgLog,1,i-1<0?0:i-1) (newLine:=match ",""" datetime msgStrip1(msg) """") substr(msgLog,i+strlen(match))
			
	}else {
		msgLog.=newLine:=datetime "," sender "," receiver "," accNo "," chartNo ",""" msgStrip1(msg) """`n"
	}
	return newLine
}
getLog(datetime, sender, receiver, accNo, chartNo){
	global msgLogPath,msgLog
	if (msgLog="")
		fileread,msgLog,% msgLogPath
	
	i:=RegExMatch(msgLog,needle:="mi)\d{14},(" sender "," receiver "|" receiver "," sender ")," accNo "[^\r\n]+",match) 
	return [match,match1,i]
}
msgStrip1(str){
	StringReplace,str,str,`",\`',all
	StringReplace,str,str,|,\``,all
	return str
}
msgUnStrip(str){
	StringReplace,str,str,\``,|,All
	StringReplace,str,str,\`',`",all
	return str
}
upperCase(str){
	stringupper,str,str
	return str
}
checkReceiver(abbr,impaxUserId){
	global contacts
	for k,v in contacts
		if (v.3=abbr || v.7=abbr) 
			return (v.7=impaxUserId)
}
pwGenerator(){
	pwChr:="LuhVvb96oGX53x7g37y5w1qDr9mMTxMs5yPFuWe4FwvDpI03ViDVikNoalgHCaLuRis1HGaPv29bbDif3KZeKIwng1Y9L0kiqelx8BkKq7pn5PYOb1bfmMx5v6HG6xuC"
	,pwLen:=strlen(pwChr)
	str:=a_year a_mm A_DD a_yday a_wday substr(A_YWeek,5),str+=0,str:=str**2*(pwLen-1),shift:=7
	pw:=""
	count:=1,strln:=strlen(str)
	loop % strln {
		len:=strln-a_index+1
		loop % strln-len+1 {
			pw.=substr(pwChr,mod(substr(str,a_index,len),pwLen)+1,1)
			if ++count>pwLen
				break 2
		}
		pwChr:=substr(pwChr,shift+1) substr(pwChr,1,shift)
	}
	if strlen(pw)<pwLen
		pw.=substr(pwChr,1,pwLen-strlen(pw))
	return pw
}

log:
if !fileexist(msgLogPath:=a_scriptdir "\messageLog.txt")
	fileappend,,% msgLogPath,utf-8
;~ msgLog:=FileOpen(msgLogPath,"rw","UTF-8")
return

loadCSV:
if !FileExist(contactsFile:=A_ScriptDir "\contacts.csv") && !FileExist(contactsFile:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\contacts.csv") {
	MsgBox % "contacts.csv not found."
	ExitApp
}
fileread,csv,*P65001 %contactsFile%
contacts:=[]
;name, phone, 3: abbreviation, title, group, ,7: id
loop,parse,csv,`n
{
	if regexmatch(a_loopfield,"^;")
		continue
	i:=a_index,arr:=[]
	loop,parse,a_loopfield,csv
		arr.push(regexreplace(trim(a_loopfield),"(^[\n\s\t]+)|([\n\s\t]+$)"))
	if (arr.maxIndex())
		contacts.push(arr)
}
return
cmdContextServer(str,hwnd=""){
	DetectHiddenWindows,on
	if !hwnd && !hwnd:=winexist("ahk_exe ImpaxContextServer.exe")
		return 1
	loop,parse,str
	{
		PostMessage,0______,,% asc(a_loopfield),,ahk_id %hwnd%
		sleep 20
	}
	PostMessage,0______,,0x0,,ahk_id %hwnd%
	
}
autosave:
critical
if (msgLog!=""){
	filedelete,% msgLogPath
	fileappend,% msgLog,% msgLogPath,utf-8
}
return

;~ esc::exitapp
onexit:
;~ msgLog.Close()
gosub autosave
if(impaxContextServerOpened)
	winclose,ahk_exe ImpaxContextServer.exe
myTCP.disconnect()
ExitApp
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

enc(txt){
	global Crypt, AES_pw
	return RegExReplace(Crypt.Encrypt.StrEncrypt(txt,AES_pw,7, 1), "\r?\n?$", "")

}
dec(txt){	
	global Crypt, AES_pw
	return Crypt.Encrypt.StrDecrypt(txt,AES_pw,7, 1)
}