/*
20130824
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
onexit,onexit

#include <portalLib>

;~ loginId:=loginId
;~ loginPw:=loginPw

askForPortalIdPw()


gui,+lastfound
guiHwnd:=winexist()
gui,font,s10,Verdana

gui,add,text,,% "填入日期與病歷號: (可由excel複製後貼上)"
gui,add,edit,vchartNos w800 r2 xs
gui,add,button,xs gGo,% "開始查詢"
gui,add,edit,yp x+100 w300 vupdating disabled,

gui,show,,% "Follow up liver function after TAE"

settimer,renewSid,300000

return

renewSid:
renewSid(sid,loginId,loginPw)
return


#IfWinActive,Follow up liver function after TAE ahk_class AutoHotkeyGUI
#IfWinActive

Go:
gui,submit,nohide

if !checkSid(sid)
	sid:=login(loginId,loginPw)
guicontrol,disable,Go

chartArr1:=[],chartArr2:=[]
sig:=0
loop,parse,chartNos,`,`n%A_Tab%
{
	if (sig:=!sig) {
		date:=DateParse(trim(a_loopfield))
		continue
	}
	
	if ! regexmatch(chartNo:=trim(a_loopfield),"^(\w)\w{5}\d$")
		continue
	if chartArr2.hasKey("" date chartNo)
		continue
	chartArr1["" date]:="" chartNo
	chartArr2["" date chartNo]:=0
	counts:=a_index
}	


LFT:=[]
for date,chartNo in chartArr1 
{
	guicontrol,,updating,% "(" a_index "/" counts ") Searching for: " chartNo
	FormatTime,startTime,% date,yyyy-MM-ddTHH:mm:ss
	date+=14,d
	FormatTime,endTime,% date,yyyy-MM-ddTHH:mm:ss
	lab:=getLab2(chartNo,sid,14,0,startTime,endTime)
	LFT.push(parseLFT(lab,chartNo))
	
}




guicontrol,,updating,% ""
guicontrol,enable,Go
return


parseLFT(byref lab,chartNo){
	arr:=[]
	
	arr.chartNo:=chartNo
	for k,v in lab
	{
		if (v.SpecimenName="BLOOD") {
			if v.ItemName in T-BIL,D-BIL,AST,ALT
			{
				
				arr[date:="" DateParse(regexreplace(v.LogDateTime,"T"," ")),"" v.ItemName]:=v.ItemName
				arr[date,"" v.Value]:=v.Value
				
			}
		}
			
	}
	return arr
	
}



nolimit:
gui,submit,nohide
guicontrol,disable%noLimit%,date
return


guiclose:
;~ ~esc::
exitapp
return

onexit:
exitapp
return