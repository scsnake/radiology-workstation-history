﻿/*
20130504
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


#include <portalLib>

askForPortalIdPw()


labTip:=[]
Lab4Arr:=[]
onexit,exitsub
settimer,checkLab4Pwb,500

colWidth:=[100,100,100,60,60,60,60,60,60,60,60,60,60,60]
rowHeight:=25
toExcel=0

gui,font,s8,Verdana
gui,+lastfound 
winget,guiHwnd,id
colName:=["Chart No","Ward","Name","Age","Hb","WBC","INR","Plt","BUN","Cr","AST","ALT","T-bil","D-bil"]
totalCol:=colName.maxIndex()
birthDayArr:=[]
gui,add,text,% "w" colWidth[1] ,% colName[1]
loop % totalCol-1
	gui,add,text,% "w" colWidth[a_index+1]  " yp xp+" colWidth[a_index],% colName[a_index+1]
gui,add,text,% "w50 yp xp+" colWidth[totalCol],4th Lab
rowNo:=1

gui,add,button,xs gExcel HwndButtonId,Convert to Excel
gui,add,button,x+50 yp gClipboard HwndButtonId3,Copy Data
gui,add,button,x+50 yp gRestart HwndButtonId2,Restart
gui,show,,Angioroom scheduler

addRow()
OnMessage(0x1001,"enterChartNo")

return

Restart:
;~ gosub quitPwb
reload
return

Excel:
toExcel=1
;~ if 1
	;~ return
gui,submit,nohide
ComObjError(false)
oExcel:=ComObjCreate("Excel.Application")

nowDate:=a_now
formattime,weekDay,% nowDate,Wday
if weekDay=6
	nowDate+=3,days
else if weekDay=7
	nowDate+=2,days
else
	nowDate+=1,days
formattime,nextDate,% nowDate,yyyy/MM/dd
if (!oExcel){
	gosub excel2
}
oExcel.visible:=true
oWb:=oExcel.Workbooks.Add
loop % oWb.sheets.count-1
	oWb.Sheets(2).Delete
oSh:=oWb.sheets(1)

oSh.Cells.NumberFormat := "@"
oSh.Columns(9).NumberFormat:=ComObj(8,"General") ;op method in "H" column!!
oSh.Cells.VerticalAlignment := -4108 ;xlCenter
oSh.Cells.Font.Size := 10
oSh.Cells.Font.Name := "Arial"


oSh.PageSetup.Orientation:=2 ;Horizontal
oSh.PageSetup.PaperSize:=9 ;A4
oSh.PageSetup.BottomMargin:=oExcel.CentimetersToPoints(1)
oSh.PageSetup.TopMargin:=oExcel.CentimetersToPoints(1)
oSh.PageSetup.LeftMargin:=oExcel.CentimetersToPoints(1)
oSh.PageSetup.RightMargin:=oExcel.CentimetersToPoints(1)
oSh.PageSetup.CenterHorizontally:=ComObj(0xB,-1) ;true
oSh.PageSetup.Zoom:=ComObj(0xB,0) ;false
oSh.PageSetup.FitToPagesTall:=1
oSh.PageSetup.FitToPagesWide:=1


oSh.cells(1,1):=nextDate

excelCols:=["床號","姓名","年齡","病歷號","生日","檢查/術式","TAE","Hb","WBC","INR","Plt","BUN/Cr","AST/ALT","T/D-bil"]
loop % excelCols.maxindex() 
{
	oSh.cells(1,2+a_index).value:=excelCols[a_index]
	oSh.cells(1,2+a_index).font.name:="標楷體"
	oSh.cells(1,2+a_index).font.name:="Arial"
	oSh.cells(1,2+a_index).HorizontalAlignment:=-4108
}
oSh.rows(1).autofit

loop % rowNo-1 {
	i:=a_index,j:=i+1
	if !(chartNo%i%)
		continue
	
	oSh.Cells(i+1,6).value:=chartNo%i%
	oSh.Cells(i+1,7).value:=birthDayArr[i]
	loop % 3 {
		guicontrolget,txt,,% "t" i "_" a_index
		oSh.cells(i+1,2+a_index):=txt
	}
	loop % 4 {
		guicontrolget,txt,,% "t" i "_" a_index+3
		oSh.cells(i+1,9+a_index):=txt
	}
	loop % 3 {
		guicontrolget,txt,,% "t" i "_" a_index*2+6
		guicontrolget,txt2,,% "t" i "_" a_index*2+7
		oSh.cells(i+1,13+a_index):=txt "/" txt2
	}
	oSh.rows(i+1).height:=30
	formula==IF(H%j%="","",IF(ISNUMBER(SEARCH("TACE",H%j%)),"v",""))
	oSh.cells(i+1,9).formula:=formula ;op method in "H" column !!
}

oExcel.activewindow.view:=2 ;xlPageBreakPreview
oSh.columns.autofit
;~ oSh2:=oSh.Copy(oSh)
;~ oSh2.Name:="Angioroom"

;~ oSh
toExcel=0
return

Clipboard:
if !toExcel
	gui,submit,nohide
str:=""
loop % rowNo-1 {
	i:=a_index
	j:=i+1
	if !(chartNo%i%)
		continue
	str.="`t`t"
	loop % 3 {
		guicontrolget,txt,,% "t" i "_" a_index
		str.=txt "`t"
	}
	str.=chartNo%i% "`t" birthDayArr[i] "`t`t"
	formula==IF(H%j%="","",IF(ISNUMBER(SEARCH("TACE",H%j%)),"v",""))
	if toExcel
		str.=formula "`t"
	else
		str.="`t"
	
	loop % 4 {
		guicontrolget,txt,,% "t" i "_" a_index+3
		str.=txt "`t"
	}
	loop % 3 {
		guicontrolget,txt,,% "t" i "_" a_index*2+6
		guicontrolget,txt2,,% "t" i "_" a_index*2+7
		str.=txt "/" txt2 "`t"
	}
	
	str.="`n"
}
str:=RegExReplace(str,"\n+$","")
clipboard:=str

return

excel2:
if !fileexist("angioSchedule.xls")
	return
run,angioSchedule.xls

gosub clipboard
winwait,angioSchedule ahk_class XLMAIN,,30
if errorlevel
	return
controlfocus,XLDESK1
controlsend,XLDESK1,^{home}
controlsend,XLDESK1,% nextDate
controlsend,XLDESK1,{down}
sleep 100
controlsend,XLDESK1,{ctrl down}v{ctrl up}
sleep 1000
controlsend,MsoCommandBar1,{alt down}fa{alt up}
winwait,另存新檔 ahk_class bosa_sdm_XL9,,10
controlsettext,RichEdit20W2,% a_desktop 
controlsend,RichEdit20W2,{enter}
controlsettext,RichEdit20W2,% RegExReplace(nextDate,"\/") ".xls"
toExcel=0
return


addRow(x="",y=""){
	global
	
	str:=""
	if !x
		x:="s"
	if !y
		y:=rowNo*rowHeight
	
	if x
		str.="x" x " "
	if y
		str.="y" y
	
	gui,add,edit,% "limit7 w" colWidth[1]  " vchartNo" rowNo " " str " HwndeditId" rowNo
	loop % totalCol-1
		gui,add,edit,% "readonly w" colWidth[a_index+1]  " yp xp+" colWidth[a_index] " vt" rowNo "_" a_index,.

	gui,add,button,% "glinkLab4 w50 yp xp+" colWidth[totalCol] " vb" rowNo,L


	controlgetpos,,editY,,,,% "ahk_id " editId%rowNo%
	guicontrol,movedraw,%buttonId%,% "y" editY
	guicontrol,movedraw,%buttonId2%,% "y" editY
	guicontrol,movedraw,%buttonId3%,% "y" editY
	gui,show,% "h" editY+30
	controlfocus,% "edit" (rowNo-1)*totalCol+1,ahk_id %guiHwnd%
	rowNo++
}

linkLab4:
RegExMatch(A_GuiControl,"b(\d+)",match)
if !(selectedLab4Pwb:=Lab4Arr[match1]) || !selectedLab4Pwb.LocationURL
	selectedLab4Pwb:=linkLab4(match1)
else
	selectedLab4Pwb.visible:=!selectedLab4Pwb.visible
return


checkLab4Pwb:
for k,v in Lab4Arr {
	if (v && instr(v.LocationURL,"http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx")!=1 && !RegExMatch(v.LocationURL,"^http:\/\/portal(.hospital-n.local)?\/General\/Login.aspx$")) {
		v.quit(),Lab4Arr[k]:=0
	}
}
if instr(clipboard,sid)
	clipboard:=""
return

linkLab4(row){

	global guihwnd,totalCol,sid,Lab4Arr
	ControlGetText,chartNo,% "edit" (row-1)*totalCol+1,ahk_id %guihwnd%
	if !RegExMatch(chartNo,"(\w)\w{5}\d")
		return
	

	run % "iexplore.exe http://portal.hospital-n.local/General/Login.aspx"
	winwait,正式環境(Portal)介面 ahk_class IEFrame,,10
	if (errorlevel) {
		msgbox 無法開啟首頁
		return
	}
	
	pwb:=IEGet2("正式環境(Portal)介面",3)
	pwb.Navigate("http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid "&PatClass=I&WardCode=12PW&ChartNo=" chartNo "&HospitalCode=T0&Seed=" A_now "&IntervalDay=-9")
	
	
	;~ pwb:=ComObjCreate("InternetExplorer.Application")
	;~ pwb.Navigate("http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid "&PatClass=I&WardCode=12PW&ChartNo=" chartNo "&HospitalCode=T0&Seed=" A_now "&IntervalDay=-9")
	Lab4Arr[row]:=pwb
	return pwb
}



~^c::
if !(a_timesincepriorhotkey<500 && a_priorhotkey=a_thishotkey && RegExMatch(clipboard,"(\w)\w{5}\d",match))
	return
winactivate,% "ahk_id " guiHwnd
winwaitactive,% "ahk_id " guiHwnd
guicontrol,,% "chartNo" rowNo-1,% match
guicontrol,focus,% "chartNo" rowNo-1
gosub pressEnter
return
;chartNo

#ifwinactive,Angioroom scheduler
~numpadenter::
~enter::
pressEnter:
critical
controlgetfocus,nowFocus,ahk_id %guiHwnd%
;~ if !instr(nowFocus,"Edit")
	;~ return
;~ gui,submit,nohide
RegExMatch(nowFocus,"\d+",whichEdit)
if mod(whichEdit-1,totalCol)>0
	return
whichRow:=round((whichEdit-1)/totalCol+1)
;~ controlgettext,chartNo,% "Edit" whichEdit
guicontrolget,chartNo,,% "chartNo" whichRow

if !RegExMatch(chartNo,"(\w)\w{5}\d")
	return



if(whichRow=rowNo-1){
	
	WinGetPos,,,,guiH,ahk_id %guiHwnd%
	;~ priorRow:= whichRow=1 ? 1 : (whichRow-2)*totalCol+1
	priorRow:= whichRow=1?1:(whichRow-1)
	;~ controlgetText,chartNoPrev,% "Edit" priorRow
	guicontrolget,chartNoPrev,,% "chartNo" priorRow
	if (chartNo && chartNoPrev) && guiH<a_screenheight-rowHeight*2
		addRow()
}
else{
	controlfocus,% "edit" whichRow+1,ahk_id %guiHwnd%
}
setTimerF("queryLab",-1,object(1,whichRow,2,chartNo),0)
return

~LButton::
if(A_TimeSincePriorHotkey>-1 && A_TimeSincePriorHotkey<500)
	return
MouseGetPos,,,,currControl
regexmatch(currControl,"Edit(\d+)",match)
if(!match1){
	TrayTip
	return
}
;~ traytip,,% labTip[x:=(mod(match,totalCol)?((match//totalCol)+1):(match//totalCol)),y:=match-totalCol*(x-1)-1],5
;~ settimer,traytip,% (y<4)?-5000:-2000

tooltip,% tip:=labTip[x:=(mod(match1,totalCol)?((match1//totalCol)+1):(match1//totalCol)),y:=match1-totalCol*(x-1)-1]
traytip,,% tip
settimer,tooltip,% tipTime:=(y<4||y>14)?-5000:-2000
settimer,traytip,% tipTime:=(y<4||y>14)?-5000:-2000

;~ guicontrolget,hEdit,hwnd,% currControl
;~ SendMessage, 0xB1, 0, -1, , ahk_id %hEdit%  ; EM_SETSEL
;~ traytip,,% match,1
return

;~ ^v::
;~ data:=clipboard
;~ if !found:=regexmatch(data,"(\w)\w{5}\d",matchChartNo)
	;~ return
;~ loop {
	;~ guicontrol,,% "chartNo" rowNo-1,% matchChartNo
	;~ guicontrol,focus,% "chartNo" rowNo-1
	;~ gosub pressEnter
	;~ sleep 5000
;~ } until !found:=regexmatch(data,"(\w)\w{5}\d",matchChartNo,found+7)
	;~ ;chartNo,chartNo
;~ return
#ifwinactive
queryLab:
queryLab(whichRow,chartNo)
return

traytip:
traytip
return

tooltip:
ToolTip
return

queryLab(whichRow,chartNo){
	global sid,loginId,loginPw,birthDayArr,labTip,guiHwnd,totalCol
	if !checkSID(sid)
		sid:=Login(loginId,loginPw)
	
	
	ptInfo:=patientBasicInfo("" chartNo,sid)
	
	RegExMatch(ptInfo.age,"(\d+)y(\d+)m",match)
	str:=round(match1 + match2/12) ptInfo.gender
	birthDayArr[whichRow]:=ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay
	guicontrol,,% "t" whichRow "_" 1,% ptInfo.ward
	guicontrol,,% "t" whichRow "_" 2,% ptInfo.name
	guicontrol,,% "t" whichRow "_" 3,% str
	labTip[whichRow,2]:=ptInfo.personId
	labTip[whichRow,3]:=birthDayArr[whichRow]
	
	arr:=array("HB","WBC","PT INR","PLT","UN","CRE","AST","ALT","T-BIL","D-BIL")
	,ptLab:=getLab4New(chartNo,sid)
	fillLab4(ptLab,arr,whichRow,0)
	loop % totalCol-4 {
		controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		if (trim(v) || a_index=12)
			continue
		if !isobject(ptLab)
			ptLab:=getLab2(chartNo,sid,90,14)
		fillLab2(ptLab,arr[a_index],whichRow,a_index+3)
	}


	;~ ptLab3:=getLab2(chartNo,sid,1)
	;~ fillLab3(ptLab2,arr,whichRow,0)
	
	
	;~ loop % totalCol-4 {
		;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		;~ if (trim(v) || a_index=12)
			;~ continue
		;~ if !isobject(ptLab2)
			;~ ptLab2:=LabIn10Days(chartNo,sid,ptInfo.personId)
		;~ fillLab2(ptLab2,arr[a_index],whichRow,a_index+3)
	;~ }
	
	
	;~ loop % totalCol-4 {
		;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		;~ if (trim(v) || a_index=12)
			;~ continue
		;~ if !isobject(ptLab)
			;~ ptLab:=patientLabDataRecent(ptInfo.personId,sid)
		;~ fillLab(ptLab,arr[a_index],whichRow,a_index+3)
	;~ }
	
	
	;~ ptLab:=patientLabDataRecent(ptInfo.personId,sid)
	;~ fillLab(ptLab,arr,whichRow,0)
	
	;~ value:=ptLab.getValue("HB").pop()
	;~ guicontrol,,% "t" whichRow "_" 4,% value.2
	;~ labTip[whichRow,1]:=value.1
	;~ guicontrol,,% "t" whichRow "_" 5,% round(1000*ptLab.getValue("WBC").pop()).2
	;~ guicontrol,,% "t" whichRow "_" 6,% ptLab.getValue("PT INR").pop().2
	;~ guicontrol,,% "t" whichRow "_" 7,% ptLab.getValue("PLT").pop().2
	;~ guicontrol,,% "t" whichRow "_" 8,% ptLab.getValue("UN").pop().2
	;~ guicontrol,,% "t" whichRow "_" 9,% ptLab.getValue("CRE").pop().2
	;~ guicontrol,,% "t" whichRow "_" 10,% ptLab.getValue("AST").pop().2
	;~ guicontrol,,% "t" whichRow "_" 11,% ptLab.getValue("ALT").pop().2
	;~ guicontrol,,% "t" whichRow "_" 12,% ptLab.getValue("T-BIL").pop().2
	;~ guicontrol,,% "t" whichRow "_" 13,% ptLab.getValue("D-BIL").pop().2
	
	screenLab(whichRow)
	,screenCre(whichRow)
	
}

screenCre(whichRow){
	global guiHwnd,totalCol,labTip
	
	;~ static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
	controlgetText,Cr,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	if Cr is not number
		return
	;~ controlgetText,BW,% "Edit" (whichRow-1)*totalCol+16,ahk_id %guiHwnd%
	controlgetText,Age,% "Edit" (whichRow-1)*totalCol+4,ahk_id %guiHwnd%
	RegExMatch(Age,"is)(.+)([MF])$",match)
	age:=match1
	gender:=match2
	factor1:=(gender="M")?1:0.85
	factor2:=(gender="M")?1:0.742
	
	;~ if bw is number
		;~ if (Ccr:=(140-age)*BW*factor1/72/Cr)<=45
			;~ SendMessage,0x30,hFont2,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	if((mdrd:=186*(Cr**(-1.154))*(age**(-0.203))*factor2)&&mdrd<=45)
		SendMessage,0x30,hFont2,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	;~ labTip[whichRow,9].="`nCcr = " round(Ccr,1) "`neGFR = " round(mdrd,1)
	labTip[whichRow,9].="`neGFR = " round(mdrd,1)
	;~ SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
}

screenLab(whichRow){
	global
	
	static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+5,ahk_id %guiHwnd%
	SendMessage,0x30,% v<8?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+5,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+6,ahk_id %guiHwnd%
	SendMessage,0x30,% v>9999?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+6,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+7,ahk_id %guiHwnd%
	SendMessage,0x30,% v>1.29?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+7,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+8,ahk_id %guiHwnd%
	SendMessage,0x30,% v<80?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+8,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+9,ahk_id %guiHwnd%
	SendMessage,0x30,% v>30?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+9,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+11,ahk_id %guiHwnd%
	SendMessage,0x30,% v>100?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+11,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+12,ahk_id %guiHwnd%
	SendMessage,0x30,% v>100?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+12,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+13,ahk_id %guiHwnd%
	SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+13,ahk_id %guiHwnd%
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+14,ahk_id %guiHwnd%
	SendMessage,0x30,% v>0.99?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+14,ahk_id %guiHwnd%
	
	
}


fillLab(byref ptLab,byref labName,whichRow,whichCol){
	global labTip
	if(isobject(labName)){
		for k,v in labName
			fillLab(ptLab,v,whichRow,a_index+3)
		return
	}
	
	value:=ptLab.getValue(labName).pop()
	if(labName="WBC"){
		guicontrol,,% "t" whichRow "_" whichCol,% trim((x:=round(1000*value.2))?x:0)
	}else{
		guicontrol,,% "t" whichRow "_" whichCol,% trim(value.2)
	}
	labTip[whichRow,whichCol]:=RegExReplace(value.1,"(\d{2})(\d{2})","$1/$2")
}

;~ fillLab2(byref ptLab,byref labName,whichRow,whichCol){
	;~ global labTip
	;~ if(isobject(labName)){
		;~ for k,v in labName
			;~ fillLab2(ptLab,v,whichRow,a_index+3)
		;~ return
	;~ }
	
	;~ result:=ptLab.getValue(labName)
	;~ d:=result.maxIndex()
	;~ value:=result[d].value
	;~ if(labName="WBC"){
		;~ guicontrol,,% "t" whichRow "_" whichCol,% (x:=round(1000*value))?x:0
	;~ }else{
		;~ guicontrol,,% "t" whichRow "_" whichCol,% value
	;~ }
	;~ labTip[whichRow,whichCol]:=RegExReplace(d,"(\d{4})(\d{2})(\d{2})","$1/$2/$3")
;~ }


fillLab2(byref ptLab,labName,whichRow,whichCol){
	global labTip
	if(isobject(labName)){
		for k,v in labName
			fillLab2(ptLab,v,whichRow,a_index+3)
		return
	}
	
	result:=getLabValue(ptLab,labName)
	,value:=result[1].value
	if(labName="WBC"){
		guicontrol,,% "t" whichRow "_" whichCol,% trim((x:=round(1000*value))?x:0)
	}else{
		guicontrol,,% "t" whichRow "_" whichCol,% trim(value)
	}
	labTip[whichRow,whichCol]:=RegExReplace(result[1].LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
}




fillLab3(byref ptLab,labName,whichRow,whichCol){
	global labTip
	if(isobject(labName)){
		for k,v in labName
			fillLab3(ptLab,v,whichRow,a_index+3)
		return
	}
	
	result:=getLabValue(ptLab,labName)
	,value:=result[1].value
	if(labName="WBC"){
		guicontrol,,% "t" whichRow "_" whichCol,% (x:=round(1000*value))?x:0
	}else{
		guicontrol,,% "t" whichRow "_" whichCol,% value
	}
	labTip[whichRow,whichCol]:=RegExReplace(result[1].LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
}


fillLab4(byref ptLab,labName,whichRow,whichCol){
	global labTip
	if(isobject(labName)){
		for k,v in labName
			fillLab4(ptLab,v,whichRow,a_index+3)
		return
	}
	
	result:=getLabValue(ptLab,labName)
	,value:=result[1].value
	if(labName="WBC"){
		guicontrol,,% "t" whichRow "_" whichCol,% (x:=round(1000*value))?x:0
	}else{
		guicontrol,,% "t" whichRow "_" whichCol,% value
	}
	labTip[whichRow,whichCol]:=RegExReplace(result[1].LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
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

enterChartNo(wParam, lParam){
	global
	if strlen(wParam)<8
		chartNo:=fill0(wParam,7)
	else
		chartNo:= chr(substr(wParam,1,2)) substr(wParam,4)
	
	guicontrol,,% "Edit" 1+(rowNo-2)*colName.maxIndex(),% chartNo
	guicontrol,focus,% "Edit" 1+(rowNo-2)*colName.maxIndex()
	gosub pressEnter
}

guiclose:
;~ ~esc::
;~ msgbox,1,,Exit?
;~ ifmsgbox,OK
	exitapp
return

exitsub:
gosub quitPwb
logout(sid,portalAspId)
exitapp
return

quitPwb:
for k,v in Lab4Arr
	v.quit()
return