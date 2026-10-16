#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,force
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
setformat,float,0.2
SetControlDelay,-1
#SingleInstance,force
#include <RisImpax>
DetectHiddenWindows,on
onexit,onexit

for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name = 'Autohotkey.exe' and not CommandLine like '%" A_ScriptName "%' ")
	PostMessage,0x10102,,,,% "ahk_pid " process.ProcessId
;~ OnMessage(0x10102,"Exit")



;~ #Hotstring EndChars -()[]{}:;"\,.?!`n `t

hotstring("i)([.\W])?(\d+)\.\.(\d+)(\W)","specifyImage",3)
,hotstring("i)([apsiml]{2,3})(q?)(9)$","aspect",3)
,hotstring("i)\b(\d{8}|\d{6})(r?)(\/|\.|\-)","date",3)

;~ lineTubes:={t: "endotracheal tube", k: "tracheostomy tube", g: "nasogastric tube", v: "central venous catheter(s)", d: "double lumen catheter", sg: "Swan-Ganz catheter", a: "port-A catheter", p: "cardiac pacemaker", ct: "chest tube(s)", pc: "PICC", ia: "IABP", ec: "ECMO vascular cannula", dn: "drainage tube(s)", pi: "pigtail catheter(s)", vs: "VP shunt", cs: "coronary stent(s)", as: "aortic stent", bs: "biliary stent", es: "esophageal stent"}
;~ hotstring("i)\b(p|3t|2t|3tr|2tr)([a-z]+)=","lineTubes",3)
;~ hotstring("i)\b([blr])(\w+?)(s?)//","combineHotstring",3)
,NoTrayOrphans()
;~ menu, tray, icon,% a_scriptdir "\CXR.ico",1,0

,ini:=a_scriptdir "/RisHelper.ini"

iniread,firstOpen,% ini,Setting,first,1
if(firstOpen){
	gosub firstSetting
}

iniread,sendReport,% ini,Hotkey,發送,F3
iniread,tempReport,% ini,Hotkey,暫存,F4
iniread,addExam,% ini,Hotkey,加檢查名稱,F5
iniread,sendMode,% ini,Setting,Mode,1
iniread,previewMode,% ini,Setting,Preview,1
iniread,noIdle,% ini,Setting,noIdle,1

if sendMode!=0
	sendMode:=1

try {
hotkey,ifwinactive,放射線資訊管理系統(Radiology Information System)
hotkey,%sendReport%,F3
hotkey,%tempReport%,F4
hotkey,%addExam%,F5
hotkey,ifwinactive
}

iniread,textHotkeySetting,% ini,PlugIn,textHotkey,0
iniread,AutoNumSetting,% ini,PlugIn,AutoNum,0
if (textHotkeySetting) 
	if fileexist(p:=a_scriptdir "\textHotkey.exe")
		|| fileexist(p:=a_scriptdir "\..\textHotkey.exe")
		|| fileexist(p:=a_scriptdir "\..\textHotkey\textHotkey.exe")
	run % p
if (AutoNumSetting)
	if fileexist(p:=a_scriptdir "\AutoNum.exe")
		|| fileexist(p:=a_scriptdir "\..\AutoNum.exe")
		|| fileexist(p:=a_scriptdir "\..\AutoNum\AutoNum.exe")
	run % a_scriptdir "\AutoNum.exe"

menu,tray,add,錯誤回報,reportBug
menu,tray,add,重新載入,reload
menu,tray,add,Plain Film Mode,togglePlainFilmMode
menu,tray,check,Plain Film Mode

FileGetTime,iniLastModify,% ini
settimer,monitorIni,2000
settimer,monitorUser,10000
if(noIdle){
	settimer,noidle,540000
	
}
return 

reportBug:
filedelete,% reportBugFile:=a_scriptdir "\risControlList.csv"
fileappend,% ListControls(risopened()[2]),% reportBugFile,utf-8
run % a_scriptdir
msgbox,4096,, % "請將risControlList.csv寄給scsnake@gmail.com，並描述遇到的錯誤"

return

reload:
reload
return


firstSetting:
MsgBox, 8225, ,% "第一次執行，是否開啟設定檔？"
ifmsgbox,OK
	run % "notepad.exe """ a_scriptdir "\RisHelper.ini"""
iniwrite,0,% ini,Setting,first
winwait,RisHelper ahk_class Notepad,,3
winactivate,RisHelper ahk_class Notepad
return

monitorIni:
filegettime,iniModify,% ini
if(iniModify>iniLastModify){
	MsgBox, 68, Reload?, 設定檔已修改，是否重新載入RisHelper？, 30
	ifmsgbox,Yes
		Reload
	
}
iniLastModify:=iniModify
return

togglePlainFilmMode:

menu,tray,% (bypassPlainFilm:=!bypassPlainFilm)?"uncheck":"check",% bypassPlainFilm?"Plain Film Mode":"(Disabled)"
menu,tray,rename,% bypassPlainFilm?"Plain Film Mode":"(Disabled)",% bypassPlainFilm?"(Disabled)":"Plain Film Mode"
return

Exit(){
	Exitapp
}


monitorUser:
wingettitle,RisTitle,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe
regexmatch(RisTitle,"^[^\-]",userName)
if(initUser && pUserName!=userName){
	MsgBox, 4164, ,%  "RIS使用者已" (userName=""?"登出":"變更") "，是否關閉RisHelper？", 30
	ifmsgbox,yes
		exitapp
	ifmsgbox,timeout
		exitapp
}
pUserName:=userName
if(!initUser && userName)
	initUser:=userName
return


aspect:
;~ loop % strlen($1)+strlen($2)+1
	;~ send {bs}

a:=$.value(1),last:=""
loop,parse,a
{
	if a_loopfield=a
		send antero-
	else if a_loopfield=p
		send postero-
	else if a_loopfield=s
		send supero-
	else if a_loopfield=i
		send infero-
	else if a_loopfield=m
		send medio-
	else if a_loopfield=l
		send latero-
	last:=a_loopfield
}
if last in m,l
	send {bs 2}al
else
	send {bs 2}ior
if strlen($.value(2))
	send % " aspect of"
return

date:
s:=$.value(1)
if ($.value(2))
	s:=substr(s,5,strlen(s)-4) substr(s,1,4)


if strlen(s)=6
	if substr(s,1,2)<80
		s:="20" s
	else
		s:="19" s
if (substr(s,5,2)>12 || substr(s,7,2)>31) {
	send % $.value(0)
	return
}


send % substr(s,1,4) $.value(3) substr(s,5,2) $.value(3) substr(s,7,2)
return

specifyImage:
;~ bs:=strlen($1)+strlen($2)+strlen($3)+strlen($4)
;~ loop % bs+2
	;~ send {bs}
if $.value(1)="."
	send % "(SE" $.value(2) " IM" $.value(3) ")" $.value(4)
else
	send % $.value(1) "SE" $.value(2) " IM" $.value(3) $.value(4)
return
/*
t: endotracheal tube
k: tracheostomy 
g: nasogastric tube
v: central venous catheter(s)
d: doublelumen catheter
s: Swan-Ganz catheter
a: port-A catheter
ct: chest tube(s)
pi: PICC
ia: IABP
ec: ECMO vascular cannula


*/
lineTubes:
result:="placement of "
str:=$.value(2)
if ($.value(1)="3t")
	str:="tgv" str
else if($.value(1)="2t")
	str:="tg" str
else if($.value(1)="3tr")
	str:="kgv" str
else if($.value(1)="2tr")
	str:="kg" str

ind:=1,max:=strlen(str)
loop {
	key1:=substr(str,ind,2)
	key2:=substr(str,ind,1)
	if v:=lineTubes[key1]
		result.=v ", ",ind+=2
	else if v:=lineTubes[key2]
		result.=v ", ",ind+=1	
	else 
		++ind
}until ind>max 
send % RegExReplace(result,"\, $",".")
return





#ifwinactive,放射線資訊管理系統(Radiology Information System)

F3:
gosub checkReport
if (hold || incomplete)
	return
if sendMode=0
	;~ controlclick,,% "ahk_id " getNetControl2(RisOpened()[2],"存檔發送","cmdRunVerifySend","存檔發送","WindowsForms10.BUTTON.app","","","",0)[1]
	risSendReport(Risopened()[2], 3)
else
	send % "{" sendReport "}"
return
F4:
gosub checkReport
if (hold || incomplete)
	return
if sendMode=0
	;~ controlclick,,% "ahk_id " getNetControl2(RisOpened()[2],"暫存","cmdRunSave","暫存","WindowsForms10.BUTTON.app","","","",0)[1]
	risSendReport(Risopened()[2], 1)
else
	send % "{" tempReport "}"
return
#ifwinactive

checkReport:

risReport:=getRisReports(RisHwnd:=RisOpened()[2])[1,1]
text:=controlgettext(risReport)
incomplete:=hold:=0

if (trim(text)=""){
	msgbox,,,% "報告內容空白！",3
	hold:=1
	return
}

if (bypassPlainFilm)
	return

Exam:=trim(parseRisExamItems(getRisExamItems(RisHwnd))[1,1])
if (regexmatch(Exam,"CT") || regexmatch(exam,"MRI")) {
	msgbox,4,, % "這個檢查是" (regexmatch(Exam,"CT")?"CT":"MRI") "，關閉plain film模式？"
	
	ifmsgbox,Yes
	{
		goto togglePlainFilmMode
		;~ return 
	}
		
}


;~ text:=RegExReplace(text,"\.+",".")
text:=RegExReplace(text,"\ {2,}(?!(-+ |\d+\W ))"," ")
;~ text:=RegExReplace(text," {2}"," ")
text:=RegExReplace(text,"\.{2,}",".")
text:=RegExReplace(text,",{2,}",",")
text:=RegExReplace(text,"\.\,",",")
text:=RegExReplace(text,"\,\.",".")
text:=RegExReplace(text,"\ ([,.;])","$1")
text:=RegExReplace(text,"i)([a-z])\. ([a-z])","$1.$2")
text:=RegExReplace(text,"([,;])(\w)","$1 $2")
text:=RegExReplace(text,".\ {2,}(\r?\n)",". $1")
text:=RegExReplace(text,"(^(\r?\n)+)|((\r?\n)+$)","")
;~ text:=RegExReplace(text,"(\.)  +(\w)",". $2")
newText:=""
incomplete:=0,hold:=0
loop,parse,text,`.
	if regexmatch(a_loopfield,"\w"){
		if strlen(line:=trim(a_loopfield))<5 && regexmatch(line,"^[a-zA-Z][a-z]+$")
			incomplete:=1
		newText.=stringupper(substr(line,1,1)) substr(line,2) ". "
	}else{
		newText.=trim(a_loopfield) ". "
	}
newText:=RegExReplace(newText,"(\d). (\d)","$1.$2")
newText:=RegExReplace(newText,"[\.\ ]+$",".")
newText:=addTitle(newText)
if(previewMode){
	MsgBox, 1, Preview,% newText
	ifmsgbox,Cancel
	{
		hold:=1
		return
	}
}
controlsettext,,% newText,% "ahk_id " risReport
if incomplete
	goto incomplete
return

F5:
risReport:=getRisReports(RisOpened()[2])[1,1]
text:=controlgettext(risReport)
if (trim(text)=""){
	msgbox,,,% "報告內容空白！",3
	return
}
controlsettext,,% newText:=addTitle(text),% "ahk_id " risReport
Edit_SetSel(risreport,strlen(newText),-1)
return

addTitle(newText){
	if instr(newText,"EXAMINATION:")
		return newText
	if (m:=regexmatch(newText,"\bshow(s|ed)\b",match)){
		if(regexmatch(substr(newText,m+strlen(match)),"\bshow(s|ed)\b")){
			MsgBox, 4148, , % "這個檢查是plain film嗎？"
			ifmsgbox,no
				return newText
			
		}
		;~ newText:=RegExReplace(newText,"is)^.+shows\s*","")
		newText:=regexreplace(substr(newText,m+strlen(match)),"^\W+","")
		,newText:=stringupper(substr(newText,1,1)) substr(newText,2)
	}
	indication:=getIndication(RisHwnd:=RisOpened()[2])
	indication:=RegExReplace(indication,"is)(有.*)$","")
	indication:=RegExReplace(indication,"[^\s]*顱內動脈瘤血管[^\s]*","")
	indication:=RegExReplace(indication,"[^\s]*心律調整器\(CEID\)[^\s]*","")
	indication:=RegExReplace(indication,"[^\s]*是[^\s]*","")
	indication:=RegExReplace(indication,"[^\s]*否[^\s]*","")
	indication:=RegExReplace(indication,"\(please specify location\)","")
	indication:=RegExReplace(indication,"緊急通報:","")
	indication:=trim(indication)
	
	risExamItemHwnd:=getRisExamItems(RisHwnd)
	risExamItem:=parseRisExamItems(risExamItemHwnd)
	
	
	exam:=[],with:=0,without:=0,ctmr:=""
	if !(regexmatch(risExamItem[1,1],"i)^CT|^MRI",match)=1){			
		for k,v in risExamItem[2]
			exam.push(trim(v))
		
		exam:=join(exam,"; ","")
	}else{
		ctmr:=match
		for k,v in risExamItem[1] {
			RegExMatch(v,"is)(with)?\/?(without)?\sContrast-+([\w\s]+)",match)
			if match=
				continue
			with|=!!match1,without|=!!match2
			if instr(match3,"neck")
				match3:="neck"
			else if regexmatch(match3,"i)(\w) spine",match)
				match3:=match1 " spine"
			else
				stringlower,match3,match3
			exam.push(match3)
		}
		exam:=ctmr " of " join(exam) " " (with&without?"without/with":with?"with":"without") " contrast enhancement"
	}
	
	RegExMatch(clinicalHx:=getClinicalInfo(RisState[2]),"【SPECIAL MEDICAL】\r?\n小部位:([^\r\n\[]+)",match)
	if !regexmatch(match1:=trim(match1),"\w")
		match1:=""
		
	return (indication=""?"":"INDICATION: " trim(indication) "`r`n") "EXAMINATION: " exam (match1=""?"":" (" match1 ")") ".`r`nFINDINGS:`r`n" RegExReplace(newText,"(^(\r?\n)+)|((\r?\n)+$)","")
}

incomplete:
msgbox % "Check the report for AHK error!"
return


newFilm:
mousegetpos,x,y
ExamItems:=parseRisExamItems(getRisExamItems(RisHwnd:=RisOpened()[2]))
,risReports:=getRisReports(risHwnd)
if RegExMatch(ExamItem:=ExamItems[1,1],"is)Chest.*(AP|PA)") || chestLat:=!!regexmatch(ExamItem,"is)Chest.*Lateral") {
	boneKeywords:=["rib","fracture","bone","bony","\bsclero","lytic"]
	,lungKeyWords:=["(lung|pulmonary) (nodule|mass|tumor|lesion|metasta)"]
	,cancerKeywords:=["cancer","malignant","malignancy","lymphoma","leukemia","tumor"]
	
	,CXRind:=0,CTind:=0,keyWord:=""
	
	for k,v in rows:=acc_children(acc_ObjectFromWindow(getRisHistoryId(RisHwnd))) {
		if regexmatch(priorExamItem:=acc_children(v)[4].accValue,"is)Chest.*(AP|PA)") && (++CXRind<11) {
			v.accSelect(ComObj(3,3),0)
			if (CXRind=1)
				first:=v
			if (CXRind=1 && priorExamItem!=ExamItem){
				sleep 100
				loc:=Acc_Location(v)
				mouseclick,r,% loc.x+50,% loc.y+5,1,0
				sleep 100
				mouseclick,l,10,10,1,0,,R
			}
			keyWord.=matchText(controlgettext(risReports[2,1]),boneKeyWords)
		}else if regexmatch(priorExamItem,"is)CT.*Chest") && (++CTind<2) {
			v.accSelect(ComObj(3,3),0)
			keyWord.=matchText(controlgettext(risReports[2,2]),lungKeyWords)
		}
		
		if (CXRind>10 && CTind>1)
			break
	}
	
	first.accSelect(ComObj(3,3),0)
	
	if breakLineControl:=getNetControl2(RisHwnd,"","txtALL","","WindowsForms10.EDIT","","","",0)[1] 
		keyword.=matchText(controlgettext(breakLineControl),cancerKeywords)
	
	if (keyword!=""){
		monitorInfo:=monitorInfo()
		gui,destroy
		gui,+alwaysontop +hwndguiHwnd +toolwindow -Caption
		gui,font,s14,Verdana
		gui,add,text,,% keyword:=filterDuplicate(keyword)
		gui,show,% "x" monitorInfo.2.l " y" monitorInfo.2.b-200 " autosize"
		settimer,killGui,% -1000+(-1)*strlen(keyword)*50
		winactivate,ahk_id %risHwnd%
	}
	
}
winactivate,ahk_id %risHwnd%
controlfocus,,% "ahk_id " RisReports[1,1]
mousemove,% x,% y,0
return

killGui:
gui,destroy
return

matchText(byref str,byref arrOfKeyWords){
	ret:=""
	for k,v in arrOfKeyWords {
		ret.=(s:=RXMS(str,"is)[^\.;\r\n]*" v "[^\.;\r\n]*([\.;\r\n]|$)","r"))=""?"":s "`n"
	}
	return ret
}

filterDuplicate(str,del="`n"){
	arr:=[]
	loop,parse,str,%del%
		if (trim(a_loopfield)!="")
			arr["" trim(a_loopfield)]:=""
	str:=""
	for k,v in arr
		str.=k "`n"
	
	return substr(str,1,-1)
}


stringupper(t){
	StringUpper,t,t
	return t
}


noIdle:
if  Risopened()[1]!=2
	return
mousegetpos,,,win
if (win=Risopened()[2])
{
	mousemove,1,0,0,R
	mousemove,-1,0,0,R
}else {
	for k,v in risControls:=GetControls(Risopened()[2])
		if instr(v.ClassNN,"WindowsForms10.SysTreeView32") {
			controlsend,,{space},% "ahk_id " v.Hwnd
			break
		}
}
return

^!q::
exitapp
return

onexit:
;~ winclose,ahk_exe AutoNum.exe
;~ winclose,ahk_exe textHotkey.exe
SendMessage,0x10102,,,,ahk_exe AutoNum.exe
SendMessage,0x10102,,,,ahk_exe textHotkey.exe
exitapp
return

join(arr,del=", ",lastDel="and"){
	str:="",ind:=arr.maxindex()
	for k,v in arr
		str.=v del
	
	if (lastDel="" || k=1)
		return substr(str,1,strlen(str)-strlen(del))
	else 
		return substr(str,1,strlen(str)-strlen(del)*2-strlen(v)) " " lastDel " " v
	
}