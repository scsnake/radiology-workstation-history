﻿#SingleInstance,ignore
#NoEnv
#include ../portalLib/portalLib.ahk

coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetBatchLines, -1
SetWorkingDir, %a_scriptdir%
SetTitleMatchMode,2
SendMode Input
SetControlDelay,-1

askForPortalIdPw()
;~ iniRead,loginId,% RegExReplace(a_scriptname,"s)\..+?$",".ini"),portal,id
;~ iniRead,loginPw,% RegExReplace(a_scriptname,"s)\..+?$",".ini"),portal,pw
;~ while !checkSid(sid:=Login(loginId,loginPw)) {
	;~ if a_index>50
		;~ exitapp
	;~ inputbox,loginId,Enter portal login ID,,,,,,,,,% (loginId="ERROR")?"":loginId
	;~ if errorlevel
		;~ exitapp
	;~ inputbox,loginPw,Enter portal login password,,Hide
	;~ if errorlevel
		;~ exitapp
	;~ sleep 200
;~ }
;~ iniwrite,% loginId,% RegExReplace(a_scriptname,"s)\..+?$",".ini"),portal,id
;~ iniwrite,% loginPw,% RegExReplace(a_scriptname,"s)\..+?$",".ini"),portal,pw



firstColWidth=120
colWidth=40
rowHeight=20



labs:=[]
fileread,settings,% RegExReplace(a_scriptname,"s)\..+?$",".ini")
labCount:=0
loop,parse,settings,`n
{
	if(regexmatch(a_loopfield,"s)^\[(.+)\]",match)){
		if(match1="settings")
			section=1
		else if(match1="labOrderCode")
			section=2
		else
			section=0
	}else if(regexmatch(a_loopfield,"s)^(.+)=([^\n]+?)(?:\,([^\n]+?))?$",match)){
		if(section=1&&match1="defaultWard")
			defaultWard:=RegExReplace(trim(match2),"\W")
		else if(section=2)
			labCount++,labs[labCount,"name"]:="" trim(match1),labs[labCount,"code"]:="" trim(match2),labs[labCount,"code2"]:="" trim(match3)
	}
}

if(!labCount){
	Msgbox Please configure settings in orderBatch.ini first!
	exitapp
}

portalURL:="http://testenv.hospital-n.local/General/Login.aspx"
wardURL:="http://tihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx"

;~ ;test
;~ gosub guicheckbox
;~ return

gosub login

;~ portalURL:="http://portal.hospital-n.local/General/Login.aspx"



;~ onexit,on_exit
setTimer,closePop,200




return

ChooseAnother:
secondChoice=1
main:
gui,destroy
gosub getWards
gui,+lastfound +resize
winget,guiHwnd,id
gui,font,s10,Verdana
gui,add,DropDownList,vward gonWardChange,% toStr(wards)
gui,show

if(defaultWard&&!secondChoice){
	;~ guicontrol,ChooseString,ward,% defaultWard
	for k,v in wards
		if(RegExReplace(v,"^0+|\W")=defaultWard){
			guicontrol,choose,ward,% "|" k
			break
		}
	
	;~ gosub onWardChange
}
return

onWardChange:
guicontrolget,ward,,ward
if(!trim(ward))
	return
#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").value:=ward
#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").onchange()
if !waitLoaded(pwb,func("fn2")){
	msgbox Can not find bed in %ward% ward
	return
}
sleep 1000
beds:=[]
loop % #(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList").getElementsByTagName("TR").length-1 {
	ind:=fill0(a_index+1)
	beds[a_index,"room"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_RoomLabel").innerText
	beds[a_index,"bed"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_BedLabel").innerText
	beds[a_index,"name"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_LinkPatientName").innerText
	beds[a_index,"chartNo"]:=#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_PatChartNo").innerText
	beds[a_index,"link"]:=RegExReplace(RegExReplace(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" ind "_LinkTreatOrder").outerHTML,"is).+window\.open\(\'([^\']+)\'.+","$1"),"&amp;","&")
}
if(!beds.maxIndex())
	return
gosub guiCheckBox
return

guiCheckBox:
gui,destroy
while winexist("ahk_id "guihwnd)
	sleep 200

orderDate:=a_now
if !substr(orderDate,9,2)<8
	orderDate+=1,days
orderDate:=substr(orderDate,1,8) "080000"

gui,+lastfound +resize
winget,guihwnd,id
gui,font,s8,Verdana
gui,add,datetime,2 vorderDate w200 Choose%orderDate%,yyyy/MM/dd HH
gui,font,s10 w700,Verdana
gui,add,text,xs y+5,% RegExReplace(ward,"^0+|\W")
gui,font,s8 w400,Verdana
for k,v in labs {
	if(a_index=1)
		gui,add,text,% "xp+" firstColWidth " yp vLab" a_index,% v.name "  "
	else
		gui,add,text,% "xp+" colWidth " yp vLab" a_index,%  v.name "  "
}
Loop % labs.maxIndex() {
	if(a_index=1)
		gui,add,checkbox,% "xs+" firstColWidth " yp+" rowHeight " vC0_" a_index " gcheckAll"
	else
		gui,add,checkbox,% "xp+" colWidth " yp vC0_" a_index " gcheckAll"
}
for k,v in beds {
	gui,add,text,% "xs yp+" rowHeight " vBed" k " gbedInfo",% v.room "-" v.bed "  "
	gui,add,checkbox,% "xp+" firstColWidth-colWidth " yp gcheckAll vC" k "_0"
	Loop % labs.maxIndex() {
		if(a_index=1)
			gui,add,checkbox,% "xp+" colWidth " yp vC" k "_" a_index
		else
			gui,add,checkbox,% "xp+" colWidth " yp vC" k "_" a_index
	}
}
gui,add,button,% "xs y+5 gGo",GO!
gui,add,button,% "xp+100 yp gReset",Reset
gui,add,button,% "xp+150 yp gChooseAnother",Choose another ward
gui,show
OnMessage(0x200, "WM_MOUSEMOVE")
return

Go:
gui,hide
guicontrolget,orderDate,,orderDate
FormatTime,weekDay,% orderDate,WDay
holiday:=(weekDay=1||weedDay=6)
FormatTime,orderDate,% orderDate,yyyy/MM/dd HH
orders:=[]
loop % beds.maxIndex() {
	i:=a_index
	any:=0
	loop % labs.maxIndex() {
		guicontrolget,v,,% "C" i "_" a_index
		any|=v
		orders[i,a_index]:=v
	}
	orders[i,0]:=any
}
if !checkSid(sid)
	sid:=login(loginId,loginPw)
for k,v in orders {
	if !(v.0)
		continue
	orderCount:=0
	pwb.Navigate(beds[k,"link"])
	if !waitLoaded(pwb,func("fn3")) {
		msgbox % "Can not connect to " beds[k,"link"]
		gosub end
	}
	if !instr(#(pwb,"NWeb1_OrderEntryCommonSelection1_PatientAbstractBasicInfo1_LabelAbstractInfo").innerText,beds[k,"chartNo"]) {
		lg("Patient " beds[k,"name"] " (" beds[k,"chartNo"] ") is not at " ward beds[k,"room"] "-" beds[k,"bed"] " !")
		continue
	}
	for m,n in v {
		if !n || !m || (holiday && !labs[m,"code2"]) || (!holiday && !labs[m,"code"])
			continue
		
		
		#(pwb,"NWeb1_OrderEntryCommonSelection1_txbKeywordInput").value:=holiday?labs[m,"code2"]:labs[m,"code"]
		#(pwb,"NWeb1_OrderEntryCommonSelection1_btnKeywordQuery").click()
		if !waitLoaded(pwb,func("fn4")) {
			msgbox % "Can not find " labs[m,"name"] " (" holiday?labs[m,"code2"]:labs[m,"code"] ")"
			gosub end
		}
		#(pwb,"NWeb1_OrderSearch1_dlsOrders_ctl00_lbnName").click()
		if !waitLoaded(pwb,func("fn5")) {
			msgbox % "Can not add " labs[m,"name"] " (" holiday?labs[m,"code2"]:labs[m,"code"] ")"
			gosub end
		}
		orderCount++
	}
	
	if !orderCount
		continue
	loop % orderCount
		#(pwb,"NWeb1_EditTempOrders1_LabTempOrders1_lvwOrders_ctrl" a_index-1 "_txbPlanExecuteDateTime").value:=orderDate
	#(pwb,"NWeb1_EditTempOrders1_btnConfirm").click()
	if !waitLoaded(pwb,func("fn6")) {
		msgbox Can not confirm temporary orders !
		gosub end
	}
	if (!pwb2||pwb2.busy) {
		pwb2:=ComObjCreate("InternetExplorer.Application")
		pwb2.visible:=true
	}
	pwb2.Navigate(RegExReplace(beds[k,"link"],"DoctorEnterOrder.aspx\?","OrderConfirm.aspx?ManagerKey=__PageOrderConfirm&") "&PIN=")
	if !waitLoaded(pwb2,func("fn7")) {
		msgbox Can not connect to order confirm page !
		gosub end
	}
	userName:=#(pwb2,"vertical").innerText
	loop % #(pwb2,"NWeb1_grvOrders").getElementsByTagName("TR").length-1 {
		if (#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_lblCreateEmpName").innerText=userName)
			#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_ckbSelect").checked:=1
		else
			#(pwb2,"NWeb1_grvOrders_ctl" fill0(a_index+1) "_ckbSelect").checked:=0
	}
	#(pwb2,"NWeb1_btnConfirm").click()
}

end:
gui,show
return

Restart:
reload
return

Reset:
loop % beds.maxindex()+1 {
	i:=a_index
	loop % labs.maxindex()+1
		guicontrol,,% "C" i-1 "_" a_index-1,0
}
return

lg(msg){
	FormatTime,logTime,% a_now,yyyy/MM/dd HH:mm:ss
	FileAppend,% logTime "`t" msg "`n",% regexreplace(a_scriptname,"s)\..+?$",".log"),utf-8
}

checkAll:
if !RegExMatch(a_guicontrol,"C0_(\d+)|C(\d+)_0",match)
	return
guicontrolget,checkState,,% a_guicontrol
if match1
	loop % beds.maxIndex()
		guicontrol,,% "C" a_index "_" match1,% checkState
else if match2
	loop % labs.maxIndex()
		guicontrol,,% "C" match2 "_" a_index,% checkState
return

bedInfo:
if !RegExMatch(a_guicontrol,"Bed(\d+)",match)
	return
traytip,,% beds[match1,"name"] "`n" beds[match1,"chartNo"]
setTimer,traytip,-2000
return

traytip:
TrayTip
return

getWards:
ComObjError(false)
if(!pwb){
	pwb:=ComObjCreate("InternetExplorer.Application")
	pwb.visible:=true
}
pwb.Navigate(wardURL "?SESSION=" sid)
if !waitLoaded(pwb,func("ready")){
	msgbox Can not connect to ward page!
	return
}
if(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").selectedIndex!=1){
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").selectedIndex:=1
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListHosp").onchange()
	if !waitLoaded(pwb,func("fn1"))
		return
}
sleep 500
wards:=[]
loop % #(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options.length
	wards.push(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options[a_index-1].value)
if(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").checked!=-1)
	#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").click()
return

login:
while !checkSid(sid:=login(loginId,loginPw)){
	while !loginId
		inputbox,loginId,Enter portal ID,,,300,120
	while !loginPw
		inputbox,loginPw,Enter portal password,,HIDE,300,120
}
gosub main
return


closePop:
ifwinexist,網頁訊息 ahk_class #32770
	WinClose,網頁訊息 ahk_class #32770
ifwinexist,ahk_class #32770,您正在檢視的網頁嘗試要關閉視窗
	controlclick,Button1,ahk_class #32770,您正在檢視的網頁嘗試要關閉視窗
return

ready(byref pwb){
	return !pwb.busy
}
ready2(byref pwb){
	return (#(pwb,"NWeb1_UpdateProgress1").style.display="none")
}
fn1(byref pwb){
	return (#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DropListWard").options.length=117)
}
fn2(byref pwb){
	global ward
	return (instr(#(pwb,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_WardLabel").innerText,ward))?1:0
}
fn3(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_OrderEntryCommonSelection1_txbKeywordInput").id)
}
fn4(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_OrderSearch1_dlsOrders_ctl00_lbnName").innerText)
}
fn5(byref pwb){
	global orderCount
	return ready(pwb)&&ready2(pwb)&&(#(pwb,"NWeb1_EditTempOrders1_LabTempOrders1_lvwOrders_ctrl" orderCount "_lblOrderName").innerText)
}
fn6(byref pwb){
	return ready(pwb)&&ready2(pwb)&&(!#(pwb,"NWeb1_EditTempOrders1_LabTempOrders1_lvwOrders_ctrl0_lblOrderName").innerText)
}
fn7(byref pwb){
	return ready(pwb)&&(#(pwb,"NWeb1_grvOrders").innerText)
}

toStr(byref arr,output=0){
	str:=""
	if (!output){
		for k,v in arr
			str.=v "|"
		return regexreplace(str,"\|$")
	}
}
fill0(str,pan=2){
	while strlen(str)<pan
		str:="0" str
	return str
}
WM_MOUSEMOVE(){    
	static CurrControl, PrevControl 
	CurrControl:=a_guicontrol
    If (CurrControl <> PrevControl)
    {
		if(regexmatch(PrevControl,"C(\d+)_(\d+)",match)){
			guicontrol,font,% "bed" match1
			guicontrol,font,% "lab" match2
		}else if(regexmatch(PrevControl,"Bed(\d+)",match)){
			guicontrol,font,% "bed" match1
		}
		;~ else if(regexmatch(PrevControl,"Lab(\d+)",match)){
			;~ guicontrol,font,% "lab" match1
		;~ }
		
		gui,font,W700 underline
		if(regexmatch(CurrControl,"C(\d+)_(\d+)",match)){
			guicontrol,font,% "bed" match1
			guicontrol,font,% "lab" match2
		}else if(regexmatch(CurrControl,"Bed(\d+)",match)){
			guicontrol,font,% "bed" match1
		}
		;~ else if(regexmatch(CurrControl,"Lab(\d+)",match)){
			;~ guicontrol,font,% "lab" match1
		;~ }
		gui,font,norm
    }
	PrevControl := CurrControl
    return
}
GuiClose:
~esc::
exitapp
return