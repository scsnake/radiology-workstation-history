/*
scsnake@gmail.com
*/
FileEncoding,utf-8
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
#include <Schtasks>
#include <Edit>

SchTxtFolder:=A_ScriptDir "\ScheduleMsg"

arg:=[]

Loop %0% 
	arg.push(%a_index%)

if(arg.maxIndex()>0)
	argMode:=true

askForPortalIdPw()


guiTitle:="Send Portal Message"


gosub loadCSV


gui,+lastfound
guiHwnd:=winexist()
gui,font,s10,Verdana
gui,add,text,,% "手機號碼：(以 , 分隔)(可省略開頭的09726)(可輸入縮寫)"
gui,add,text,yp x+150,% "加入群組："
gui,add,DropDownList,yp x+10 gaddGroup vgroup,% "reset||all|R|VS|VS1 |R1|R2|R3|R4|R5|neuro|chest|body|ortho|ped|hs|yl"
gui,add,edit,xs r3 w800 vphoneNos
gui,add,text,xs,% "簡訊內容：                              "
gui,add,text,yp x+200,% "目前字數: "
gui,add,text,yp x+0 vwordCount,% "0    "
gui,add,edit,xs r4 w800 vmsg,
gui,add,radio,xs vmsgType hwndmsgTypeHwnd1,% "危急值通報(30分內回覆)"
gui,add,radio,yp x+80 hwndmsgTypeHwnd2,% "異常值通報(24時內回覆)"
gui,add,radio,yp x+80 checked hwndmsgTypeHwnd3,% "一般通報(不需回覆) "
gui,add,button,xs gsend,% "發送簡訊"
gui,add,button,yp x+100 gmessageHx,% "簡訊記錄"
gui,add,text,yp x+100 gchangeUser,登入者：
gui,add,button,yp x+5 vchangeUser gchangeUser,% getUserName(loginId,sid) ""
;~ gui,add,button,yp x+120 gschGui,排程
gui,add,button,yp x+120 gHelpFile,% "?"


gui,show,,% guiTitle

	
if argMode
	gosub argParse


settimer,wordCount,200
;~ gosub schGui
return

schGui:
gui,sch:Default
gui,Destroy

gui,Font,s10,Verdana
;~ gui,add,Text,,Create New
gui,add,DateTime,vschStartDateTime w200,yyyy/MM/dd HH:mm:ss
;~ gui,add,Text,yp x+5,% " till "
;~ gui,add,DateTime,vschEndDateTime w200 yp x+5 choosenone,yyyy/MM/dd HH:mm:ss
;~ gui,add,Text,xm y+5,% "interval"
;~ gui,add,Edit,vschInterval yp x+5 w50
;~ gui,add,DropDownList,vschInterval2 yp x+5 w100,% "once||minute|hour|day|week|month"
gui,add,button,xm y+5 gcreateSch,Create New
gui,add,ListView,xm y+40 r5 w600,% "Text|Receiver|StartTime|TaskId"
gui,add,button,xm y+5 gdelSch,Delete Selected

LV_ModifyCol(1, 200)
,LV_ModifyCol(2, 200)
,LV_ModifyCol(3, 200)

gosub updateSch
gui,Show,,Schedule
return

updateSch:
LV_Delete()
LV_ModifyCol(4,0)
for k,v in querySch:=SchTasks_Query() {
	schName:=v["工作名稱"] v["TaskName"]
	if !InStr(schName, "portalMsg")
		continue
	RegExMatch(schName,"\d+", taskId)
	if !FileExist(schFile:=SchTxtFolder "\" taskId ".txt")
		continue
	fileread,schData,% schFile
	if !RegExMatch(schData, "is)(.+?)\|\r?\n(.+?)\|\r?\n(\d)", match)
		return
	LV_Add("", match2, match1, v["下次執行時間"], taskId)
}

return

delSch:
MsgBox, 8244, , Delete selected schedule?
IfMsgBox,No
	return
RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(taskId, RowNumber, 4)
    schResult:=SchTasks_Do("delete", {TN: "portalMsg" taskId, F: ""})
	if InStr(schResult,"成功") || InStr(schResult, "success"){
		ToolTip % "刪除排程成功",
		LV_Delete(RowNumber)
		FileDelete,% SchTxtFolder "\" taskId ".txt"
	}
}
SetTimer,ToolTip,-2000
;~ gosub updateSch
return

ToolTip:
ToolTip
return

CreateSch:
gui,sch:Default
gui,Submit,NoHide
gui,1:Submit,NoHide
schId:=a_now
EnvGet, Domain, USERDOMAIN

if(A_OSVersion="WIN_XP"){
	newTask:=[]
	,newTask["TN"]:="portalMsg" schId
	,newTask["TR"]:="""\""" RegExReplace(A_ScriptFullPath, ".ahk", ".exe") "\"" \""" SchId "\"""""
	;~ ,newTask["SC"]:=schInterval2="once"?"ONCE":(schInterval2="month"?"MONTHLY":schInterval2="day"?"DAILY":schInterval2="minute"?"MINUTE":(schInterval2 "LY"))
	,newTask["SC"]:="ONCE"
	,newTask["ST"]:=SubStr(schStartDateTime,9,2) ":" SubStr(schStartDateTime,11,2) ":" SubStr(schStartDateTime,13,2) 
	,newTask["SD"]:=SubStr(schStartDateTime,1,4) "/" SubStr(schStartDateTime,5,2) "/" SubStr(schStartDateTime,7,2)
	;~ if(schInterval2!="once"){
		;~ newTask["ET"]:=SubStr(schEndDateTime,9,2) ":" SubStr(schEndDateTime,11,2)
		;~ if(schEndDateTime!="")
			;~ newTask["ED"]:=SubStr(schEndDateTime,1,4) "/" SubStr(schStartDateTime,5,2) "/" SubStr(schStartDateTime,7,2)
	;~ }
	,schResult:=SchTasks_Do("create", newTask)
	,useXml:=false
}else{
	startBoundary:="<StartBoundary>" SubStr(schStartDateTime,1,4) "-" SubStr(schStartDateTime,5,2) "-" SubStr(schStartDateTime,7,2) "T" SubStr(schStartDateTime,9,2) ":" SubStr(schStartDateTime,11,2) ":" SubStr(schStartDateTime,13,2) "</StartBoundary>"
	,EndDateTime:=schStartDateTime
	EndDateTime+=30,Minutes
	endBoundary:="<EndBoundary>" SubStr(EndDateTime,1,4) "-" SubStr(EndDateTime,5,2) "-" SubStr(EndDateTime,7,2) "T" SubStr(EndDateTime,9,2) ":" SubStr(EndDateTime,11,2) ":" SubStr(EndDateTime,13,2) "</EndBoundary>"
	,command:="<Command>""" RegExReplace(A_ScriptFullPath, ".ahk", ".exe") """</Command>"
schXML=
(
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>%a_yyyy%-%a_MM%-%a_dd%T%A_Hour%:%a_min%:%a_sec%</Date>
    <Author>scsnake</Author>
  </RegistrationInfo>
  <Triggers>
    <TimeTrigger>
      %startBoundary%
      %endBoundary%
      <ExecutionTimeLimit>PT30M</ExecutionTimeLimit>
      <Enabled>true</Enabled>
      <RandomDelay>PT1M</RandomDelay>
    </TimeTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>%domain%\%a_username%</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT2H</ExecutionTimeLimit>
    <DeleteExpiredTaskAfter>P30D</DeleteExpiredTaskAfter>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      %command%
      <Arguments>"%schId%"</Arguments>
    </Exec>
  </Actions>
</Task>
)
	FileDelete,% schXMLFile:=SchTxtFolder "\" SchId ".xml"
	FileAppend,% schXML,% schXMLFile,utf-16
	schResult:=SchTasks_Do("create", {XML: """" schXMLFile """", TN: "portalMsg" SchId})
	,useXml:=true
}


if InStr(schResult, "執行身分密碼") {
	if((A_UserName="raduser") && (domain="NH")){
		schUsername:="raduser", schUserpwd:="MOCK_PASSWORD"
	}else{
		gui,schPwd:Default
		gui,Destroy
		gui,+hwndschPwdGuiHwnd 
		gui,Font,s10,Verdana
		gui,add,Text,,Username
		gui,add,Edit,yp x+15 vschUsername w200,% A_UserName
		gui,add,Text,xm,Password
		gui,add,Edit,yp x+15 vschUserpwd w200,
		gui,add,button,gschUserEnterPwd xm,Submit
		
		gui,Show,,Need Windows username/password
		
		WinWaitClose, ahk_id %schPwdGuiHwnd%
		
		
	}
	
	if(useXml){
	}else{
		newTask["RU"]:=domain "\" schUsername
		,newTask["RP"]:=schUserpwd
		,schResult:=SchTasks_Do("create", newTask)
	}
}

if InStr(schResult,"成功") || InStr(schResult,"success"){
	FileCreateDir,% SchTxtFolder
	FileDelete,% schFile:=SchTxtFolder "\" SchId ".txt"
	FileAppend,% phoneNos "|`n" msg "|`n" msgType ,% schFile,utf-8
	MsgBox,,,% "新增排程成功",3
}else 
	MsgBox % "新增排程錯誤: `n" schResult
FileDelete,% schXMLFile
gosub updateSch
return

schUserEnterPwd:
gui,schPwd:Default
gui,Submit
gui,Destroy
return

argParse:
SchId:=arg[1]
if !FileExist(schFile:=SchTxtFolder "\" SchId ".txt"){
	MsgBox,,,% "Schedule file not found!",10
	ExitApp
}
fileread,schData,% schFile
if !RegExMatch(schData, "is)(.+?)\|\r?\n(.+?)\|\r?\n(\d)", match)
	return
guicontrol,,phoneNos,% match1
guicontrol,,msg,% match2
TypeInd:=match3=1?1:match3=2?2:3
guicontrol,,% msgTypeHwnd%TypeInd%,1
gosub send
SetTimer,OnExit,-10000
return

sch:
gui,Submit,NoHide
d:=arg[4]
startTime:=SubStr(d,9,2) ":" SubStr(d,11,2) ":" SubStr(d,13,2)
startDate:=SubStr(d,1,4) "/" SubStr(d,5,2) "/" SubStr(d,7,2)
if RegExMatch(arg[5], "s)^(.+?)([mhdwM])$", intv)
	interval:=RegExMatch(intv,"M")?"MONTHLY":intv="m"?"MINUTE":intv="h"?"HOURLY":intv="d"?"DAILY":intv="w"?"WEEKLY":"ONCE"
	,Modifier:=(interval="ONCE"?"":(intv1+0))
else
	interval:="ONCE"
EndDate:=arg[6]
return

helpFile:
help=
(
1. 手機號碼填五碼簡碼，自動加上09726開頭。

2. 手機號碼可填字母代碼(設定於contact.csv)。

3. 群組、字母代碼、手機號碼設定於contact.csv。

4. 滑鼠左鍵點「登入者：XXX」可更改登入者。

scsnake@gmail.com 
Update: 2018/8/20
)
gui,2: add,edit,w300 ReadOnly hwndinfoEdit,% help
gui,2: show,,Help File
Edit_SetSel(infoEdit,0,0)
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
;~ if !FileExist(contactsFile:=A_ScriptDir "\contacts.csv")
	;~ contactsFile:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\contacts.csv"
;~ fileread,csv,*P65001 %contactsFile%

if FileExist(contactsFile:=A_ScriptDir "\contacts.csv")
    || FileExist(contactsFile:=A_ScriptDir "\..\contacts.csv")
    fileread,csv,%contactsFile%
else
    MsgBox % "Can't find contacts.csv!!"
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
FileDelete,% schFile
if portalMessage(sid,phoneNos,msg,msgType)
	msgbox,,, % "簡訊發送成功!"
else {
	msgbox % "簡訊發送失敗!"
	SetTimer,OnExit,Off
}


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
