﻿#include <portalLib>
#include <ParseArg>

#SingleInstance,force
DetectHiddenWindows,On
DetectHiddenText,On
FileEncoding, UTF-8
comobjerror(false)

onexit,onexit
zeromsg := "0筆 "

,SaveFile:=A_ScriptDir "\info.ini"
,args:=ParseArg()
,unsignedHistory:=[]
,loginPortalError:=0
,signPageError:=0
,queryPageError:=0
;~ Loop %0%
	;~ args.push(%a_index%)

gosub loadList
menu,tray,add, 立刻電子簽章, signOnce
Menu,tray,Default,立刻電子簽章
winkill,ahk_class #32770簽章完成：共產生

try
	menu, tray, icon,% a_scriptdir "\DigiSign.ico",1,0

;~ MsgBox % exploreobj(args)
logFile:=A_ScriptDir "\log.txt"

if (sid:=login(args[1], args[2])){
	pname:=args[1]
	,ppw:=args[2]
	,cardpin:=args[3]
	,Type:=args[4]
	;~ MsgBox % pname "," ppw "," cardpin "," Type
	gosub directStart
	
}else{
	gui,+hwndGuihwnd
	Gui, Add, Text,,使用者:
	Gui, Add, DropDownList,vpname ys w100, %name%
	Gui, Add, Text,xm section,Portal密碼:
	Gui, Add, Edit,+password vppw ys w72,
	Gui, Add, Text,xm section,PIN碼:
	Gui, Add, Edit,+password vcardpin ys w48,
	Gui, Add, Text,xm section,簽章問題傳簡訊:
	Gui, Add, Edit,vmessagePhone xm w100,
	Gui, Add, Button,xm default,開始
	gui,add,radio,vtype xs checked,Dr
	gui,add,radio,x+0,N
	gui,Add,Checkbox,xm gsave vsaveinfo checked,Save info?
	gui,Add,button,x+30 gstartOS,開機執行
	Gui, Show,autosize,電子簽章
	GroupAdd,self,ahk_id %guihwnd%
	
	
	SetTimer,LoadInfo,-2000
}

;~ run % a_scriptdir "\closePop.exe"

Return

startOs:
Loop,% a_startup "\*.lnk"
{
	FileGetShortcut,% A_LoopFileLongPath,target
	if (target = A_ScriptFullPath){
		MsgBox,,, % "Already done!",5
		return
	}
}
FileCreateShortcut,% A_ScriptFullPath,% A_Startup "\DigiSign.lnk",% A_ScriptDir
MsgBox,,, % "Done!",5
return

#IfWinActive,ahk_group self
~LButton::
~esc::
~tab::
~Left::
~Right::
~up::
~Down::
stopLoad:=true
return

#IfWinActive

Save:
gui,Submit,NoHide
if(SaveInfo){
	SaveInfo()
}else{
	FileDelete,% SaveFile
}
return

SaveInfo(){
	static AES_pw:="scsnakeDigiSign"
	global guihwnd, pname, ppw, cardpin, SaveFile, messagephone
	gui,%guihwnd%:Submit,NoHide
	if pname!=
		IniWrite,% RegExReplace(pname, "s)^([^ ]+) .+$", "$1"),% SaveFile,info,id
	if ppw!=
	{
		;~ enc_dec:=ppw "0123456789abcdef"
		;~ size:=Crypt_AES(&enc_dec, strlen(enc_dec), AES_pw, 256, 1)
		;~ encPw:=Bin_Hex(enc_dec,size,32,"")
		encPw:=Crypt.Encrypt.StrEncrypt(ppw,AES_pw,7,6)
		IniWrite,% encPw,% SaveFile,info,pw
	}
	if cardpin!=
	{
		;~ enc_dec:=cardpin "0123456789abcdef"
		;~ size:=Crypt_AES(&enc_dec, strlen(enc_dec), AES_pw, 256, 1)
		;~ encCardPin:=Bin_Hex(enc_dec,size,32,"")
		encCardPin:=Crypt.Encrypt.StrEncrypt(cardpin,AES_pw,7,6)
		IniWrite,% encCardPin,% SaveFile,info,pin
	}
	if messagephone!=
		IniWrite,% encCardPin,% messagephone,info,phone
}

LoadInfo(){
	static AES_pw:="scsnakeDigiSign"
	global guihwnd, SaveFile, stopLoad
	
	if stopLoad || !FileExist(SaveFile) {
		guicontrol,%guihwnd%:choose,pname,1
		return
	}
		
	;~ gui,%guihwnd%:Submit,NoHide
	IniRead,pname,% SaveFile,info,id
	IniRead,ppw,% SaveFile,info,pw
	IniRead,cardpin,% SaveFile,info,pin
	IniRead,messagephone,% SaveFile,info,phone
	
		
	if ppw!=
	{
		;~ Hex_Bin(enc_dec,ppw)
		;~ size:=Crypt_AES(&enc_dec, floor(strlen(ppw)/2), AES_pw, 256, 0)
		;~ ppw:=substr(substr(enc_dec,1,size),1,size-16)
		ppw:=Crypt.Encrypt.StrDecrypt(ppw,AES_pw,7,6)
		guicontrol,%guihwnd%:,ppw,% ppw
		w:=true
	}
	if cardpin!=
	{
		;~ Hex_Bin(enc_dec,cardpin)
		;~ size:=Crypt_AES(&enc_dec, floor(strlen(cardpin)/2), AES_pw, 256, 0)
		;~ cardpin:=substr(substr(enc_dec,1,size),1,size-16)
		cardpin:=Crypt.Encrypt.StrDecrypt(cardpin,AES_pw,7,6)
		guicontrol,%guihwnd%:,cardpin,% cardpin
		p:=true
	}
	
	if pname!=
	{
		guicontrol,%guihwnd%:ChooseString,pname,% pname
		n:=true
	}
	
	if messagephone!=
		guicontrol,%guihwnd%:,messagephone,% messagephone
	
	if w&&p&&n
		gosub start
	else 
		guicontrol,%guihwnd%:choose,pname,1
}

signOnce:
gosub DigiSignReopen
;~ SetTimer,DigiSign,off
;~ gosub,DigiSign
;~ SetTimer,DigiSign,1432
return

logMsg(msg){
	global
	FileAppend,% msg "`n",% logFile,UTF-8
}

loadList:
datacount=0
Loop, read, %A_ScriptDir%\List.ini
{
datacount += 1
StringLeft, data%datacount%_1, A_LoopReadLine, 6
;~ id:=data%datacount%_1
StringUpper,data%datacount%_1,data%datacount%_1
data%datacount%_2 := A_LoopReadLine
}
nameArr:=[]
Loop,%datacount%
{
if A_index = 1
{
id := data1_1
name:=data1_2
nameArr.push(regexreplace(data1_2,"\s*\w+\s+"))
}
if A_index > 1
{
id := id . "," . data%A_index%_1
nameArr.push(regexreplace(data%A_index%_2,"\s*\w+\s+"))
name.= "|" data%A_index%_2
}
}
return
Button開始:
gosub save
start:
Gui, Submit
directStart:
StringLeft, pid, pname, 6
loginId:=pid, loginPw:MOCK_PASSWORD
if (trim(cardpin)!=""){
	settimer,DigiSign,-1
}

return


DigiSignReopen:
goto digisign
return
if A_IsCompiled
	run % """" A_ScriptFullPath """ " loginId " " loginPw " " cardpin " " Type
else
	run % """" RegExReplace(A_ScriptFullPath,"i).ahk$", ".exe") """ """ A_ScriptFullPath """ " loginId " " loginPw " " cardpin " " Type
ExitApp
return


signingFinished(thisId, Type){
	static pass
	global sid, lastTick
	if (pass){
		--pass
		return
	}
	if (Type=1){
		query:=queryDigiSign(sid,thisId)
		,dom:=ComObjCreate("HtmlFile")
		,dom.write(query)
		,Count:=Trim(dom.getElementById("NWeb1_lblUnDsCnts").innerText)
		,RegExMatch(Count, "\d+", bool)	
	}else if(Type=2){
		query:=queryDigiSignN(sid,thisId)
		,dom:=ComObjCreate("HtmlFile")
		,dom.write(query)
		try
			bool:=dom.getElementById("NWeb1_dgrEmrRecord").rows.length-1
		catch
			return true
	}
	
	if !bool
		return true
	else
		pass:=Floor(bool/20)
}

updateSid:
checkSid(sid)
return
DigiSign:
SetTimer,DigiSignReopen,-10800000
;~ SetTimer,DigiSignReopen,-5000
sid:=login(loginId, loginPw)
,totalUnsigned:=0
if !checkSid(sid)	{
	MsgBox,,,% "Can't login portal!",10
	if(++loginPortalError>4)
		msgError("Can't login portal")
	return
}
loginPortalError:=0

gosub loadList

;~ GroupAdd,dialog,ahk_class #32770
;~ WinKill,ahk_group dialog
gosub routine

if type=1
	url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" . sid
else if type=2
	url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DrugGivenDS.aspx?SESSION=" sid
settimer,updateSid,300000
pwbArr:=[]
,zero:=0
,zerocount:=0
loop,parse,id,`,
{
	if (!pwb || !WinExist("ahk_id " pwb.hwnd)){
		pwbArr.push(pwb:=comobjcreate("InternetExplorer.Application"))
		,pwb.Navigate(url)
		,pwb.visible:=true
		
		;~ pwb:=new PwbClass(pwb.hwnd)
		
		Loop
			Sleep 100
		until !pwb.busy || A_Index>300
		
		;~ MsgBox % pwb.LocationUrl
	}
	
	ind:=a_index
	,thisId:=A_LoopField
	,pageError:=false
	if (type=1){
		query:=queryDigiSign(sid,thisId)
		,dom:=ComObjCreate("HtmlFile")
		,dom.write(query)
		if(!dom.getElementById("NWeb1_lblUnDsCnts").id){
			pageError:=true
		}else{
			Count:=Trim(dom.getElementById("NWeb1_lblUnDsCnts").innerText)
			,RegExMatch(Count, "\d+", bool)
			,totalUnsigned+=(bool?bool:0)
			,bool:=!bool
		}	
		
		;~ FileAppend,% a_now "------------------------`n" query "`n`n`n",queryLog.txt,UTF-8
	}else if (type=2){
		bool:=!regexmatch(queryDigiSignN(sid,thisId),"is)id\W+NWeb1_dgrEmrRecord\W")
	}
		
	if(pageError){
		MsgBox,,,% "Page error!",10
		pwb.Visible:=true
		
		if (++signPageError>2)
			msgError("Can't load sign page")
		
		return
	}else
		signPageError:=0
	
	if (bool) {
		;~ if instr(queryDigiSign(sid,thisId),zeromsg) {
		;~ logMsg(a_now ": " thisId " " nameArr[ind] " " zeromsg)
		zerocount++
		traytip,,% thisId " " nameArr[ind] ": " zeromsg,3
		Sleep 1000
		continue	
	}

loop
	sleep 200
until !pwb.busy && (pwb.document.getElementById("NWeb1_lblEmpName").innerText!="") || a_index>100
Sleep 500
if (type=1){
	pwb.document.getElementById("NWeb1_txbEmpNO").value := thisId
	,pwb.document.getElementById("NWeb1_btnRefresh").click()
}else if(type=2){
	pwb.document.getElementById("NWeb1_txbEmpNO").value := thisId
	,pwb.document.getElementById("NWeb1_BtnGetEmgPatientListByDoctor").click()
}
winget,activeWin,id,A
;~ pwb.visible:=true
winactivate,ahk_id %activeWin%
Sleep 1000
loop
	sleep 300
until (!pwb.busy && pwb.document.getElementById("NWeb1_lblEmpName").innerText=nameArr[ind]) || a_index>100
Sleep 500
if (type=1){
	record := pwb.document.getElementById("NWeb1_lblUnDsCnts").innerText
	if !InStr(record, "筆"){
		pwb.Visible:=true
		MsgBox,,,% "網頁錯誤！",10
		
		if (++queryPageError>2)
			msgError("Can't query sign records")
		
		return
	}else
		queryPageError:=0
	traytip,,% thisId " " nameArr[ind] ": " record,3
}
js=javascript:document.getElementById("NWeb1_txbPinCode").value="%cardpin%";void 0;
loop {
	pwb.Navigate(js)
	,pwb.document.getElementById("NWeb1_txbPinCode").value:=cardpin
	sleep 200
} until (pwb.document.getElementById("NWeb1_txbPinCode").value!="") || a_index=50
Sleep, 10
finish=0

winkill,ahk_class #32770,簽章完成
;~ settimer,routine,300
winget,activeWin,id,A
settimer,activeWin,200
if type=1
	regexmatch(record,"\d+",match)
else if type=2
	match:=pwb.document.getElementById("NWeb1_dgrEmrRecord").rows.length-1
;~ Sleep 1000
if (type=1){
	pwb.document.getElementById("NWeb1_btnDoSignatureByPCSC").click()
	;~ js=javascript:document.getElementById("NWeb1_btnDoSignatureByPCSC").click();void 0;
	;~ pwb.Navigate(js)
}else
	pwb.document.getElementById("NWeb1_btnSignTS").click()

;~ SetTimer,fillReason,500

regexmatch(record,"\d+",match)
,logMsg(a_now ": " thisId " " nameArr[ind] " " match "筆")
,startSign:=false
,err:=""
lastTick=0
loop {
	gosub fillReason
	gosub routine
	if Mod(A_Index,10)=0
		if signingFinished(thisId, Type)
			continue,2
	Sleep 300
} until (finish || startSign || A_Index>50+match*10)

if (startSign){
	loop {
		gosub routine
		if Mod(A_Index,10)=0
			if signingFinished(thisId, Type)
				continue,2
		Sleep 300
	} until (finish || A_Index>50+match*10)
}
if (err!=""){
	Loop,Parse,err,`n
		logMsg(a_now ": " thisId " " nameArr[ind] " " A_LoopField)
	MsgBox,,,% err, 10
}
Sleep 500
settimer,activeWin,off
SetTimer,fillReason,Off
loop
	Sleep, 200
until !pwb.busy || a_index>100
Sleep 1000
}
unsignedHistory.push(totalUnsigned)
,checkUnsignedHistory()
gosub routine
if (zerocount!=ind){
	msgbox,,,% "簽章完成，共" totalUnsigned "筆",3
	if totalUnsigned>100
		SetTimer,DigiSignReopen,-300000
	else
		SetTimer,DigiSignReopen,-600000
	totalUnsigned:=0
}
	

gosub closeAllPwb
traytip
return
activeWin:
winget,activeWin2,id,A
if (activeWin!=activeWin2) {
winactivate,ahk_id %activeWin%
settimer,activeWin,off
}
return


checkUnsignedHistory(){
	global unsignedHistory
	i:=unsignedHistory.length()
	if i<5 || !unsignedHistory[i]
		return
	Loop 4
		if (unsignedHistory[i] != unsignedHistory[i-A_Index])
			return
	;;; five unsigned history same -> probably not signed 
	msgError("unknwon error, not signed!")
}


msgError(msg=""){
	global messagephone, sid, loginId, loginPw
	static lastSend
	
	if (lastSend && A_TickCount-lastSend<300000)
		return
	
	messagephone:=Trim(messagephone)
	if messagephone=
		return
	if StrLen(messagephone)=5
		messagephone:="09726" messagephone
	
	if !checkSid(renewSid(sid, loginId, loginPw)){
		sid:=""
		for k,v in fetchIEsids()
			if checkSid(v){
				sid:=v
				break
			}
		
		if sid=
			return
	}

	lastSend:=A_TickCount
	,portalMessage(sid,messagephone,"DigiSign: " msg)
	
}

fillReason:
if !pwb.busy && InStr(pwb.document.documentElement.innerHTML, "臨床業務繁忙"){
	b:=pwb.document.getElementsByTagName("BUTTON")
	Loop % b.length
		if(b[A_Index-1].innerText="確定"){
			b[A_Index-1].Click()
			startSign:=true
			SetTimer,,Off
			return
		}
}
return

routine:
ifwinexist,ahk_class #32770,簽章完成
{
ControlClick,Button1,ahk_class #32770,簽章完成
winkill,ahk_class #32770,簽章完成：共產生
finish=1
}
ifwinexist,ahk_class #32770,查無待簽章
{
ControlClick,Button1,ahk_class #32770,查無待簽章
winkill,ahk_class #32770,查無待簽章
finish=1
}
ifwinexist,ahk_class #32770,PIN碼驗證失敗，請確認讀卡機功能是否正常
{
	if (thisId~="i)000000|H00000|Y00000")
		portalMessage(sid, "0900000000", "PIN碼驗證失敗，請確認讀卡機功能是否正常")
winactivate,ahk_class #32770,PIN碼驗證失敗，請確認讀卡機功能是否正常
msgbox % "PIN碼錯誤或讀卡機異常，自動簽章中斷！"
exitapp
}
ifwinexist,網頁訊息 ahk_class #32770
{
    controlclick,Button1,網頁訊息 ahk_class #32770
}
IfWinExist,批次電子簽章 ahk_class IEFrame
{
	For pwb1 in ComObjCreate( "Shell.Application" ).Windows
		If ( InStr(pwb1.LocationName,"批次電子簽章" ) && InStr( pwb1.FullName, "iexplore.exe" ) && pwb1.document.getElementById("dsInfo").id){
			txt:=pwb1.document.getElementById("dsInfo").innerText
			;~ txt:=pwb1.document.documentElement.innerText
			;~ clipboard:=txt
			;~ ToolTip % txt
			;~ SetTimer,ToolTip,-2000
			RegExMatch(txt, "應簽[^\d]*(\d+)", total)
			,RegExMatch(txt, "已簽[^\d]*(\d+)", signed)
			if (total1!=signed1)
				err.="應簽" total1 "筆，未簽" (total1-signed1) "筆`n"
			if InStr(txt, "簽章完成。") || (total1 && (total1=signed1))
				finish:=1
				,pwb1.quit()
			break
		}
}
return

ToolTip:
ToolTip
return

closeAllPwb:
for k,v in pwbArr
	try
		v.quit()
return
;~ esc::
GuiClose:
onexit:
gosub closeAllPwb
;~ process,close,closePop.exe
ExitApp

