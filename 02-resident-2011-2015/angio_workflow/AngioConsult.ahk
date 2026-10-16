﻿/*
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
SetFormat, float, 2.1
comobjerror(false)
onexit,onexit
#include <portalLib>
#include <LV_Color>
#include <sleipnir>


askForPortalIdPw()



schedule:=[]

gosub readVSinfo
width:=a_screenwidth-24

gui,+lastfound 
guiHwnd:=winexist()
gui,font,s8,Verdana
gui,add,button,gManualUpdate,Renew
gui,add,button,yp x+20 gOutput,Copy
gui,add,button,yp x+20 geditVS,Edit VS
gui,add,listview,xs vLV hwndLVid AltSubmit gLVevent w%width% r30,編號|開單單位|病歷號|姓名|照會時間|類別|申請者|主旨|被照會主治|被照會住院|回覆醫師|績效主治|狀態|LT 



gui,show,,Angioroom Consult List
LV_ColorInitiate()

settimer,manualupdate,% 1000*30*60
gosub manualupdate
;~ lv_add("",1,2,3,4,5,6,7)


return

editVS:
run,% a_scriptdir "\angioVS.txt"
return

output:
output:=""
rowCount:=lv_getcount(),colCount:=lv_getcount("Col")
loop % rowCount+1 {
	i:=a_index-1
	loop % colCount {
		j:=a_index
		lv_getText(tmp,i,j)
		output.=tmp "`t"
	}
	output.="`n"
}
clipboard:=regexreplace(RegExReplace(output,"\t\n","`n"),"\n$","")
traytip,,Copied!,2
return

LVevent:
hit:=LV_SubItemHitTest(LVid),row:=hit.x,col:=hit.y
LV_GetText(selected,hit.x,1)
selectedConsult:=schedule[order[selected]]
if (a_guievent="Normal"){
	if !row || !col
	return
	
	
	
	LV_GetText(getText,row,col)
	
	if (col=2){
		getText.="`n" selectedConsult["departmentPhone"]
	}else if(col=6){
		getText:=selectedConsult["type2"]
	}else if(col=7){
		getText.="`n" selectedConsult["consulterPhone"]
	}
		
	
	tooltip,% getText
	settimer,tooltip,-2000
}else if(a_guievent="RightClick" or a_guievent="R"){
	if !row || !col
	return

	if(col=3){
		LV_GetText(getText,row,col)
		clipboard:=getText
		tooltip,Chart No copied !
		settimer,tooltip,-2000
		;~ tooltip,% a_guievent
		if(a_guievent="R"){
			;~ searchLab(chartNo)
			if !hwnd:=winexist("Search Lab ahk_class AutoHotkeyGUI")
				if !hwnd:=winexist("Angioroom scheduler ahk_class AutoHotkeyGUI")
					return
				
			PostMessage,0x1001,% encodeChartNo(getText),,,% "ahk_id " hwnd
			;~ tooltip,% errorlevel
		}
		;~ }else if(a_guievent="RightClick"){
			;~ tooltip,Chart No copied !
			;~ settimer,tooltip,-2000
		;~ }
	}
	;~ tooltip % a_guievent
	
}else if(a_guievent="DoubleClick"){
	if !row || !col
	return

	if !checksid(sid)
		sid:=login(loginid,loginpw)
	
	
	
	url:=testConsultUrl(url:="http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/NotifyOtherDoctor.aspx?SESSION=" sid "&AccountIDSE=" selectedConsult.account "&NotifyIDSE=" selectedConsult.notifyId "&PatClass=I&Reply=Y&Seed=" (a_hour<12?"上":"下") "午 " a_hour ":" a_min ":" a_sec)
	
	;~ run % "iexplore.exe " url
	
	if !slpId:=winexist("ahk_class SleipnirMainWindow ahk_exe Sleipnir.exe"){
		if !consultPwb || consultPwb.locationURL
		consultPwb:=comobjcreate("InternetExplorer.Application")
		
		consultPwb.Navigate(url)
		consultPwb.visible:=true
		
		consultPwb:=comobjcreate("InternetExplorer.Application")
		consultPwb.Navigate(portalUrl)
	}else{
		winactivate,ahk_id %slpId%
		;~ winwaitactive,ahk_id %slpId%,,2
		controlfocus,,ahk_id %slpId%
		controlsend,,{lctrl down}t{lctrl up},ahk_id %slpId%
		
		loop {
			sleep 300
			slpWb:=getSlpWb()
			for k,v in slpWb
				if (v.LocationURL="about:blank"){
					v.Navigate(url)
					
					breakLoop:=1
					break 2
				}
			
			
		}until a_index>33
	
	}
	
	
}
	;~ !!schedule[order[A_EventInfo]]
return

tooltip:
ToolTip
return


ManualUpdate:
gosub updateConsult
gosub sorting
LV_Delete()
ind:=0
GuiControl, -Redraw,LV
lv_colorchange("","0x000000","0xFFFFFF")
loop % (total:=order.maxindex()) {
	consult:=schedule[order[a_index]]

	formattime,formatedTime,% consult.time,MM/dd HH:mm
	
	
	LV_add("",++ind,consult.department,consult.chartNo,consult.Name " " RegExReplace(consult.age,"is)y.+") consult.gender ,formatedTime,consult.type,consult.consulter,consult.purpose,consult.VS,consult.R,consult.replyBy,consult.GCA,consult.status,consult.leftTime)
	
	
	if (consult.GCA=dutyVS) || (strlen(consult.GCA)<2 && consult.VS=dutyVS)
		BackColor:="0x00FC7C"
	else
		BackColor:="0xFFFFFF"
		
	
	if instr(consult.type2,"急")
		TextColor:="0x0000FF"
	else 
		TextColor:="0x000000"
	
	lv_colorchange(ind,TextColor,BackColor) 
	
}
LV_ModifyCol()
LV_ModifyCol(8,250)
GuiControl, +Redraw,LV
LV_ModifyCol(1,"Integer")
return

readVSinfo:
if !checksid(sid)
	sid:=login(loginId,loginPw)
vs:=[],vs2:=[]
formattime,weekDay,% a_now,WDay
weekDay-=1
shiftTime:=(a_hour<12)?"am":"pm"
loop,read,AngioVS.txt
{
	if RegExMatch(a_loopreadline,"^;")
		continue
	
	if RegExMatch(a_loopreadline,"(\d),(\w+),(\w+)",m) {
		vs2["" m3]:=1
		if(m1=weekDay && m2=shiftTime)
			dutyVS:=getUserName(m3,sid)
	}
}

for k,v in vs2
	vs.push("" k)

if !vs.maxindex() {
	msgbox,Please edit "AngioVS.txt" first !
	exitapp
}

settimer,readVSinfo,% (a_hour<12?12-a_hour:24-a_hour)*60*60*(-1000)
return


updateConsult:
if !checksid(sid)
	sid:=login(loginid,loginpw)
traytip,,Updating...
updateMsg:=""
schedule:=[]
updatedVScount:=0
;~ for k,v in vs {
	;~ SetTimerF("updatingConsults",-1,object(1,v))
;~ }
;~ sleep 1000
;~ while (updatedVScount<vs.maxIndex())
	;~ sleep 1000
for k,v in vs {
	VSname:=getUserName(v,sid)
	traytip,,% "Updating consults of " VSname " ...",60
	params:={userId:v}
	result:=consultInfo(sid,"",params)
	schedule:=unionSchedule(schedule,result)
}
traytip
return


updatingConsults(v){
	global updateMsg,schedule,sid,updatedVScount
	VSname:=getUserName(v,sid)
	updateMsg.=(updateMsg?",":"") VSname
	traytip,,% "Updating consults of " updateMsg " ...",60
	params:={userId:v}
	result:=consultInfo(sid,"",params)
	++updatedVScount
	schedule:=unionSchedule(schedule,result)
	if trim(updateMsg:=regexreplace(updateMsg,VSname ",?"))
		traytip,,% "Updating consults of " updateMsg " ...",60
	else 
		traytip
}

/* settimer analog for function
Function: function name
Period: repeated interval; execute once if period < 0
ParmObject: array object of parameter passed to function, eg. object(1,param1,2,param2,3,param3)
Priority:
*/
SetTimerF( Function, Period=0, ParmObject=0, Priority=0 ) { 
 Static current,tmrs:=Object() ;current will hold timer that is currently running
 If IsFunc( Function ) {
    if IsObject(tmr:=tmrs[Function]) ;destroy timer before creating a new one
       ret := DllCall( "KillTimer", UInt,0, UInt, tmr.tmr)
       , DllCall("GlobalFree", UInt, tmr.CBA)
       , tmrs.Delete(Function) 
    if (Period = 0 || Period ? "off")
       return ret ;Return as we want to turn off timer
	 ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched
    tmr:=tmrs[Function]:=Object("func",Function,"Period",Period="on" ? 250 : Period,"Priority",Priority
								,"OneTime",(Period<0),"params",IsObject(ParmObject)?ParmObject:Object()
								,"Tick",A_TickCount)
    tmr.CBA := RegisterCallback(A_ThisFunc,"F",4,&tmr)
    return !!(tmr.tmr  := DllCall("SetTimer", UInt,0, UInt,0, UInt
								, (Period && Period!="On") ? Abs(Period) : (Period := 250)
								, UInt,tmr.CBA)) ;Create Timer and return true if a timer was created
				, tmr.Tick:=A_TickCount
 }
 tmr := Object(A_EventInfo) ;A_Event holds object which contains timer information
 if IsObject(tmr) {
	 DllCall("KillTimer", UInt,0, UInt,tmr.tmr) ;deactivate timer so it does not run again while we are processing the function
	 If (!tmr.active && tmr.Priority<(current.priority ? current.priority : 0)) ;Timer with higher priority is already current so return
		 Return (tmr.tmr:=DllCall("SetTimer", UInt,0, UInt,0, UInt, 100, UInt,tmr.CBA)) ;call timer again asap
	 current:=tmr
	 tmr.tick:=ErrorLevel :=Priority ;update tick to launch function on time
	 tmr.func(tmr.params*) ;call function
	 current= ;reset timer
    if (tmr.OneTime) ;One time timer, deactivate and delete it
       return DllCall("GlobalFree", UInt,tmr.CBA)
				 ,tmrs.Delete(tmr.func)
	 tmr.tmr:= DllCall("SetTimer", UInt,0, UInt,0, UInt ;reset timer
				,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), UInt,tmr.CBA)
 }
}



sorting:
order:=[]
sorting:=[]
for a,b in schedule {
	if (b.GCA=dutyVS) || (strlen(b.GCA)<2 && b.VS=dutyVS)
		sorting["9" b.time b.consulter b.account]:=a
	else
		sorting["0" b.time b.consulter b.account]:=a
	;~ if !trim(b.time)
		;~ msgbox
}
num:=schedule.maxIndex()
for a,b in sorting
	order[num-a_index+1]:=b
;~ reverse:=[]
;~ loop % num {
	;~ for k,v in order
;~ }
return


unionSchedule(byref a,byref b){
	if !a.maxIndex()
		return b.clone()
	
	x:=a.clone()
	
	str:=""
	for k,v in x {
		str.= fill0(k,5) "|" v.department "|" v.chartNo "|" v.name "|" v.gender "|" v.age "|" v.time "|" v.type "|" v.consulter "|" v.purpose "|" v.consulted "|" v.VS "|" v.R "|/"
		;~ for m,n in v
			;~ str.= v "|"
		;~ str.= "\"
	}
	for k,v in b {
		;~ if !instr(v.consulted,"血管攝影")
			;~ continue

		temp:=v.department "|" v.chartNo "|" v.name "|" v.gender "|" v.age "|" v.time "|" v.type "|" v.consulter "|" v.purpose "|" v.consulted "|" v.VS "|" v.R "|"
		if !(i:=instr(str,temp)) {
			x.push(v)
		}else if(k:=0+substr(str,i-6,5)){
			x[k,"replyBy"]:=v.replyBy
			x[k,"GCA"]:=v.GCA
			x[k,"status"]:=v.status
			x[k,"leftTime"]:=v.leftTime
		}
	}
	
	return x
}

LV_SubitemHitTest(HLV) {
   ; To run this with AHK_Basic change all DllCall types "Ptr" to "UInt", please.
   ; HLV - ListView's HWND
   Static LVM_SUBITEMHITTEST := 0x1039
   VarSetCapacity(POINT, 8, 0)
   ; Get the current cursor position in screen coordinates
   DllCall("User32.dll\GetCursorPos", "Ptr", &POINT)
   ; Convert them to client coordinates related to the ListView
   DllCall("User32.dll\ScreenToClient", "Ptr", HLV, "Ptr", &POINT)
   ; Create a LVHITTESTINFO structure (see below)
   VarSetCapacity(LVHITTESTINFO, 24, 0)
   ; Store the relative mouse coordinates
   NumPut(NumGet(POINT, 0, "Int"), LVHITTESTINFO, 0, "Int")
   NumPut(NumGet(POINT, 4, "Int"), LVHITTESTINFO, 4, "Int")
   ; Send a LVM_SUBITEMHITTEST to the ListView
   SendMessage, LVM_SUBITEMHITTEST, 0, &LVHITTESTINFO, , ahk_id %HLV%
   ; If no item was found on this position, the return value is -1
   If (ErrorLevel = -1)
      Return 0
   ; Get the corresponding subitem (column)
   Subitem := NumGet(LVHITTESTINFO, 16, "Int") + 1
   
   item:=NumGet(LVHITTESTINFO, 12, "Int") + 1
   
   Return {x:item,y:Subitem}
}
/*
typedef struct _LVHITTESTINFO {
  POINT pt;
  UINT  flags;
  int   iItem;
  int   iSubItem;
  int   iGroup;
} LVHITTESTINFO, *LPLVHITTESTINFO;
*/


testConsultUrl(url){
	httprequest(url,post:="",header:="","charset: utf-8`n+NO_COOKIES")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	
	if trim($(dom,"NWeb1_PatBasicInfoLabel").innerText) 
		return url
	
	
	httprequest(url:=RegExReplace(url,"PatClass=I","PatClass=E"),post:="",header:="","charset: utf-8`n+NO_COOKIES")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	
	if trim($(dom,"NWeb1_PatBasicInfoLabel").innerText) 
		return url
		
	
	httprequest(url:=RegExReplace(url,"PatClass=E","PatClass=O"),post:="",header:="","charset: utf-8`n+NO_COOKIES")
	
	dom:=ComObjCreate("HtmlFile")
	dom.write(post)
	
	if trim($(dom,"NWeb1_PatBasicInfoLabel").innerText) 
		return url
	
	
}


searchLab(chartNo){
	if !hwnd:=winexist("Search Lab ahk_class AutoHotkeyGUI")
		if !hwnd:=winexist("Angioroom scheduler ahk_class AutoHotkeyGUI")
			return
		
	winget,controlList,controllist,ahk_id %hwnd%
	
	m:=0
	loop,parse,controlList,`n
	{
		if !RegExMatch(a_loopfield,"Edit(\d+)",match)
			continue
		controlget,style,style,,% a_loopfield,ahk_id %hwnd%
		if (style=0x50010080 && match1+0>m)
			m:=match1
	}
	
	ControlSetText,% "Edit" m,% chartNo,ahk_id %hwnd%
	controlsend,% "Edit" m,{Enter},ahk_id %hwnd%
	
}


encodeChartNo(chartNo){
	if !regexmatch(chartNo,"[^\d]",match)
		return chartNo+0
	
	return (asc(match) "0" substr(chartNo,2)) + 0
	
}



guiclose:
;~ ~esc::
msgbox,4,Exit?
ifmsgbox,yes
	exitapp
return

onexit:
consultPwb.quit()
ExitApp
return
