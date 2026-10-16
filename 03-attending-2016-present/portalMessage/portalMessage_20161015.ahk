/*
20141211
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
onexit,onexit
#include <portalLib>


askForPortalIdPw()


guiTitle:="Send Portal Message"


gosub loadCSV


gui,+lastfound
guiHwnd:=winexist()
gui,font,s10,Verdana
gui,add,text,,% "手機號碼：(以 , 分隔)(可省略開頭的09726)(可輸入縮寫)"
gui,add,text,yp x+150,% "加入群組："
gui,add,DropDownList,yp x+10 gaddGroup vgroup,% "reset||all|R|VS|VS1 |R1|R2|R3|R4|R5|neuro|chest|body|ortho|ped|yl"
gui,add,edit,xs r3 w800 vphoneNos
gui,add,text,xs,% "簡訊內容：                              "
gui,add,text,yp x+200,% "目前字數: "
gui,add,text,yp x+0 vwordCount,% "0    "
gui,add,edit,xs r4 w800 vmsg,
gui,add,radio,xs vmsgType,% "危急值通報(30分內回覆)"
gui,add,radio,yp x+80,% "異常值通報(24時內回覆)"
gui,add,radio,yp x+80 checked,% "一般通報(不需回覆) "
gui,add,button,xs gsend,% "發送簡訊"
gui,add,button,yp x+100 gmessageHx,% "簡訊記錄"
gui,add,text,yp x+100 gchangeUser,登入者：
gui,add,button,yp x+5 vchangeUser gchangeUser,% getUserName(loginId,sid) ""
gui,add,button,yp x+200 gHelpFile,% "?"



gui,show,,% guiTitle
settimer,wordCount,200

return

helpFile:
help=
(
1. 手機號碼填五碼簡碼，自動加上09726開頭。

2. 手機號碼可填字母代碼(設定於contact.csv)。

3. 群組、字母代碼、手機號碼設定於contact.csv。

4. 滑鼠左鍵點「登入者：XXX」可更改登入者。

scsnake@gmail.com 
Update: 2016/9/3
)
gui,2: add,edit,w300,% help
gui,2: show,,Help File
return

changeUser:
askForPortalIdPw(1)
guicontrol,,changeUser,% getUserName(loginId,sid)
return

wordCount:
guicontrolget,msg,,msg
if (strlen(priorMsg)!=strlen(msg))
	guicontrol,,wordCount,% strlen(msg)
priorMsg:=msg
return


;~ #ifwinactive,Send Portal Message
;~ ~lbutton::
;~ msgbox % A_GuiEvent
;~ return
;~ #IfWinActive

loadCSV:
if !FileExist(contactsFile:=A_ScriptDir "\contacts.csv")
	contactsFile:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\contacts.csv"
fileread,csv,*P65001 %contactsFile%
contacts:=[]
;name, phone, abbreviation, title, group
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


addGroup:
guicontrolget,phoneNos,,phoneNos
guicontrolget,group,,group
group:=trim(group)
str:=""
if(group="reset"){
	phoneNos:=""
}else if(group="all") {
	for k,v in contacts
		if trim(v.2)
			str.="," trim(v.3) v.1
}else if(group="R") {
	for k,v in contacts
		if (instr(v.5,"R"))
			str.="," trim(v.3) v.1 
}else if(regexmatch(group,"is)R\d+")) {
	for k,v in contacts
		if(v.5=group)
			str.="," trim(v.3) v.1
}else if(group="VS") {
	for k,v in contacts
		if(instr(v.5,"VS"))
			str.="," trim(v.3) v.1
}else if(regexmatch(group,"is)VS\d+")) {
	for k,v in contacts
		if(v.5=group)
			str.="," trim(v.3) v.1
}else {
	for k,v in contacts
		if (instr(v.6,group))
			str.="," trim(v.3) v.1
}
guicontrol,,phoneNos,% regexreplace(phoneNos str,"^\,","")

return


send:
gui,submit,nohide
if (phoneNos="" || msg="")
	return

guicontrol,disable,send
if !checksid(sid)
	sid:=login(loginId,loginPw)
phoneNoArr:=[]
loop,parse,phoneNos,`,
	if((phone:=trim(a_loopfield))!="") {
		if phone is number 
		{
			phoneNoArr["" (strlen(phone)=5?("09726" phone):phone)]:=1
		;~ }else if strlen(phone)=3 || strlen(phone)=2 {
		}else if RegExMatch(phone,"i)^([a-z]{2,3})", match) || RegExMatch(phone, "[^\w]+", name) {
			for k,v in contacts
				;~ if (instr(v.3,phone))
				if ((v.3=match1 && match1!="") || v.1=name)
					phoneNoArr["" v.2]:=1
		}
	}
phoneNos:=""
for k,v in phoneNoArr
	phoneNos.=k ","
;~ loop,parse,phoneNos,`,
	;~ if((phone:=trim(a_loopfield))!="") {
		;~ if phone is number 
		;~ {
			;~ phoneNoArr.push("" strlen(phone)=5?("09726" phone):phone)
		;~ }else if strlen(phone)=3 {
			;~ for k,v in contacts
				;~ if instr(v.3,phone)
					;~ phoneNoArr.push(v.2)
		;~ }
	;~ }
;~ phoneNos:=""
;~ for k,v in phoneNoArr
	;~ phoneNos.=v ","
phoneNos:=regexreplace(phoneNos,",$")
if portalMessage(sid,phoneNos,msg,msgType)
	msgbox % "簡訊發送成功!"
else
	msgbox % "簡訊發送失敗!"

guicontrol,enable,send

return

messageHx:
if !checksid(sid)
	sid:=login(loginId,loginPw)
url:="http://ihisaw.hospital-n.local/WebApplication/OtherIndependentProj/CriticalVentilator/ShowInfo.aspx?SESSION=" sid "&ST=" substr(a_now,1,8) "&ET=" substr(a_now,1,8) "&queryID=" loginId
run % "iexplore.exe " url

return

guiclose:
;~ ~esc::
exitapp
return

onexit:
exitapp
return
