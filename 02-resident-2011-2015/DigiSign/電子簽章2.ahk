﻿#include <portalLib>


FileEncoding, UTF-8
comobjerror(false)
onexit,onexit
zeromsg := "0筆 "
gosub loadList
menu,tray,add, 立刻電子簽章, signOnce
winkill,ahk_class #32770簽章完成：共產生
Gui, Add, Text,,使用者:
Gui, Add, DropDownList,vpname ys w100, %name%
Gui, Add, Text,xm section,Portal密碼:
Gui, Add, Edit,+password vppw ys w72,
Gui, Add, Text,xm section,PIN碼:
Gui, Add, Edit,+password vcardpin ys w48
Gui, Add, Button,ys default,開始
Gui, Show,autosize,電子簽章
Return
signOnce:
SetTimer,DigiSign,off
gosub DigiSign
SetTimer,DigiSign,10800000
return
loadList:
datacount=0
Loop, read, %A_ScriptDir%\List.ini
{
datacount += 1
StringLeft, data%datacount%_1, A_LoopReadLine, 6
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
Gui, Submit
StringLeft, pid, pname, 6
if %cardpin%
Gosub, DigiSign
SetTimer,DigiSign,10800000
return
updateSid:
checkSid(sessionid)
return
DigiSign:
if !sessionid:=Login(loginId:=pid,loginPw:MOCK_PASSWORD,substr(name,1,1)="H"?"4":"0")
return
gosub loadList
url:="http://ihisaw.hospital-n.local/WebApplication/DigitalSignature/DSQuery.aspx?SESSION=" . sessionid
settimer,updateSid,300000
pwbArr:=[]
zero:=0
pwbArr.push(pwb:=comobjcreate("InternetExplorer.Application"))
pwb.Navigate(url)
loop,parse,id,`,
{
if instr(queryDigiSign(sessionid,a_loopfield),zeromsg) {
traytip,,% nameArr[a_index] ": " zeromsg,3
continue
}
loop
sleep 200
until !pwb.busy || a_index>100
pwb.document.getElementById("NWeb1_txbEmpNO").value := A_loopfield
pwb.document.getElementById("NWeb1_btnRefresh").click()
winget,activeWin,id,A
pwb.visible:=true
winactivate,ahk_id %activeWin%
loop
sleep 300
until (!pwb.busy && pwb.document.getElementById("NWeb1_lblEmpName").innerText=nameArr[a_index]) || a_index>100
record := pwb.document.getElementById("NWeb1_lblUnDsCnts").innerText
js=javascript:document.getElementById("NWeb1_txbPinCode").value="%cardpin%";void 0;
pwb.Navigate(js)
Sleep, 10
finish=0
winkill,ahk_class #32770,簽章完成：共產生
settimer,routine,300
winget,activeWin,id,A
settimer,activeWin,200
pwb.document.getElementById("NWeb1_btnDoSignatureByPCSC").click()
regexmatch(record,"\d+",match)
loop
sleep 1000
until ((a_index>(30+match*2)) || finish)
settimer,routine,off
settimer,activeWin,off
loop
Sleep, 200
until !pwb.busy || a_index>100
}
msgbox,,,簽章完成,5
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
routine:
ifwinexist,ahk_class #32770,簽章完成：共產生
{
ControlClick,Button1,ahk_class #32770,簽章完成：共產生
winkill,ahk_class #32770,簽章完成：共產生
finish=1
}
ifwinexist,ahk_class #32770,查無待簽
{
	ControlClick,Button1,ahk_class #32770,查無待簽
	winkill,ahk_class #32770,查無待簽
}
ifwinexist,ahk_class #32770,PIN碼驗證失敗，請確認讀卡機功能是否正常
{
	winactivate,ahk_class #32770,PIN碼驗證失敗，請確認讀卡機功能是否正常
	msgbox % "PIN碼錯誤或讀卡機異常，自動簽章中斷！"
	exitapp
}
return
closeAllPwb:
for k,v in pwbArr
v.quit()
return
GuiClose:
onexit:
gosub closeAllPwb
ExitApp