﻿/*
20140426
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
#include <Class_CTLCOLORS>


askForPortalIdPw()




labTip:=[]
Lab4Arr:=[]
queryProgress:=[]
onexit,exitsub
settimer,checkLab4Pwb,500

colWidth:=[80,90,90,50,40,50,40,40,40,40,40,40,40,40,50,50,60]
rowHeight:=25

gui,color,% windowColor:="ECE9D8"
gui,font,s8,Verdana
gui,+lastfound 
winget,guiHwnd,id
colName:=["Chart No","Ward","Name","Age","Hb","WBC","INR","Plt","BUN","Cr","AST","ALT","T-bil","D-bil","Preg","BW","Thyroid"]
totalCol:=colName.maxIndex()
birthDayArr:=[]
gui,add,text,% "w" colWidth[1] ,% colName[1]
loop % totalCol-1
	gui,add,text,% "w" colWidth[a_index+1]  " yp xp+" colWidth[a_index],% colName[a_index+1]
gui,add,text,% "w50 yp xp+" colWidth[totalCol],4th Lab
rowNo:=1

;~ gui,add,button,xs gExcel HwndButtonId,Convert to Excel
;~ gui,add,button,x+50 yp gRestart HwndButtonId2,Restart
gui,add,button,xs gRestart HwndButtonId2,Restart
gui,show,,Search Lab

addRow()




OnMessage(0x1001,"enterChartNo")
return

Restart:
;~ gosub quitPwb
reload
return

Excel:
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

return

excel2:
if !fileexist("angioSchedule.xls")
	return
run,angioSchedule.xls

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
	str.=formula "`t"
	
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


winwait,angioSchedule ahk_class XLMAIN,,30
if errorlevel
	return
controlfocus,XLDESK1
controlsend,XLDESK1,^{home}
controlsend,XLDESK1,% nextDate
controlsend,XLDESK1,{down}
clipboard:=str
sleep 100
controlsend,XLDESK1,{ctrl down}v{ctrl up}
sleep 500
controlsend,MsoCommandBar1,{alt down}fa{alt up}
winwait,另存新檔 ahk_class bosa_sdm_XL9
controlsettext,RichEdit20W2,% a_desktop 
controlsend,RichEdit20W2,{enter}
controlsettext,RichEdit20W2,% RegExReplace(nextDate,"\/") ".xls"
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
		gui,add,edit,% "readonly w" colWidth[a_index+1]  " yp xp+" colWidth[a_index] " vt" rowNo "_" a_index " hwndEdit" rowNo "_" a_index+1,.
	
	gui,add,button,% "glinkLab4 w50 yp xp+" colWidth[totalCol] " vb" rowNo,L
	
	controlgetpos,,editY,,,,% "ahk_id " editId%rowNo%
	guicontrol,movedraw,%buttonId%,% "y" editY
	guicontrol,movedraw,%buttonId2%,% "y" editY
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
sleep 100
gosub pressEnter
return
;chartNo

#ifwinactive,Search Lab
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
	priorRow:= whichRow=1 ? 1 : (whichRow-2)*totalCol+1
	;~ controlgetText,chartNoPrev,% "Edit" priorRow
	priorRow:= whichRow=1?1:(whichRow-1)
	guicontrolget,chartNoPrev,,% "chartNo" priorRow
	if (chartNo && chartNoPrev) && guiH<a_screenheight-rowHeight*2
		addRow()
}
else{
	controlfocus,% "edit" whichRow+1,ahk_id %guiHwnd%
}
setTimerF("queryLab",-1,object(1,whichRow,2,chartNo))
return

~LButton::
if (A_TimeSincePriorHotkey<300 && a_priorhotkey=a_thishotkey) {
	gosub dLButton
	return
}
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

dLButton:
guicontrolget,nowFocus,focus
guicontrolget,focusEditValue,,% nowFocus
clipboard:=focusEditValue
traytip,,Text copied!
tooltip,Text copied!
settimer,traytip,1000
settimer,tooltip,1000

return

LButton & Rbutton::
guicontrolget,nowFocus,focus
;~ guicontrolget,focusEditValue,,% nowFocus
RegExMatch(nowFocus,"\d+",whichEdit)
whichRow:=round((whichEdit-1)/totalCol+1)
whichCol:=mod(whichEdit,totalCol)-1
clipboard:=labTip[whichRow,whichCol]
traytip,,Text copied!
tooltip,Text copied!
settimer,traytip,1000
settimer,tooltip,1000
return


^v::
data:=clipboard
if !found:=regexmatch(data,"(\w)\w{5}\d",matchChartNo)
	return
;~ loop {
	guicontrol,,% "chartNo" rowNo-1,% matchChartNo
	guicontrol,focus,% "chartNo" rowNo-1
	gosub pressEnter
	;~ sleep 5000
;~ } until !found:=regexmatch(data,"(\w)\w{5}\d",matchChartNo,found+7)
	;~ ;chartNo,chartNo
return
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
	
	ptInfo:=patientBasicInfo(chartNo,sid)
	
	,RegExMatch(ptInfo.age,"(\d+)y(\d+)m",match)
	,str:=round(match1 + match2/12) ptInfo.gender
	,birthDayArr[whichRow]:=ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay
	guicontrol,,% "t" whichRow "_" 1,% ptInfo.ward
	guicontrol,,% "t" whichRow "_" 2,% ptInfo.name
	guicontrol,,% "t" whichRow "_" 3,% str
	labTip[whichRow,2]:=ptInfo.personId
	,labTip[whichRow,3]:=birthDayArr[whichRow]
	
	ptBWBH:=patientBWBH(chartNo,sid,ptInfo.personId)
	guicontrol,,% "t" whichRow "_" 15,% ptBWBH.BW
	regexmatch(ptBWBH.BW,"[\d.]+",BW)
	,labTip[whichRow,15]:=ptBWBH.UpdateDate (BW?"`n1.3→ " round(BW*1.3) "ml`n1.5→ " round(BW*1.5) "ml" :"") 
	
	
	arr:=array("HB","WBC",array("INR","PT INR"),"PLT",array("UN","BUN"),"CRE","AST","ALT","T-BIL","D-BIL","Urine Pregnancy Test")
	
	ptLab2:=getLab2(chartNo,sid,1)
	for k,item in arr
		fillLab3(ptLab2,item,whichRow,a_index+3,0)
	 
	
	ptLab2:=0
	for k,item in arr {
		controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		if (trim(v) || a_index=12)
			continue
		if !isobject(ptLab2)
			ptLab2:=getLab2(chartNo,sid,14,1)
		fillLab3(ptLab2,item,whichRow,a_index+3,1)
	}
	
	ptLab2:=0
	for k,item in arr {
		controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		if (trim(v) || a_index=12)
			continue
		if !isobject(ptLab2)
			ptLab2:=getLab2(chartNo,sid,90,14)
		fillLab3(ptLab2,item,whichRow,a_index+3,1)
	}

	
	screenLab(whichRow)
	,screenCre(whichRow)
	,screenDate(whichRow)
	setTimerF("thyroidFunc",-1,object(1,whichRow,2,ptInfo.personId,3,sid))
}


fillLab3(byref ptLab,byref labName,whichRow,whichCol,pass=0){
	global labTip,guiHwnd,totalCol
	;~ if(isobject(labName)&&pass=0){
		;~ for k,v in labName
			;~ fillLab3(ptLab,v,whichRow,a_index+3,1)
		;~ return
	;~ }
	result:=getLabValue(ptLab,labName)
	
	if(result.maxIndex()<1&&pass>0)
		return
	
	value:=result[1].value
	
	
	if(labName="WBC"){
		controlsetText,% "Edit" n:=(whichRow-1)*totalCol+whichCol+1,% text:=trim((x:=round(1000*value))?x:0),ahk_id %guiHwnd%
		;~ guicontrol,,% "t" whichRow "_" whichCol+1,% trim((x:=round(1000*value))?x:0)
	}else{
		controlsetText,% "Edit" (whichRow-1)*totalCol+whichCol+1,% trim(value),ahk_id %guiHwnd%
		;~ guicontrol,,% "t" whichRow "_" whichCol+1,% trim(value)
	}
	labTip[whichRow,whichCol]:=RegExReplace(result[1].LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
	
}

thyroidFunc(whichRow,personId,sid){
	global guiHwnd,totalCol,labTip,tt
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
	str:=""
	,labHx:=patientLabHistory("",sid,personId)
	
	abnormal:=0
	l:="Free T4"
	if(isobject(labHx.lab[l]))
		for k,v in labHx.lab[l]
			for i,j in v
				if j.1<0.6 || j>1.75
					str.=k " " l "`t" j.1 "`n",abnormal++
				else
					str.=k " " l "`tWNL`n" 
	
	l:="TSH"
	if(isobject(labHx.lab[l]))
		for k,v in labHx.lab[l]
			for i,j in v
				if j.1<0.1 || j>4.5
					str.=k " " l "`t" j.1 "`n",abnormal++
				else
					str.=k " " l "`tWNL`n" 

	l:="RIA:T3"
	if(isobject(labHx.lab[l]))
		for k,v in labHx.lab[l]
			for i,j in v
				if j.1<78 || j.1>182
					str.=k " " l "`t" j.1 "`n",abnormal++
				else
					str.=k " " l "`tWNL`n" 
				
				
	if(str){
		labTip[whichRow,16]:=RegExReplace(str,"\n$","")
		guicontrol,,% "t" whichRow "_" 16,% abnormal?"!!!!!!":"details"
	}else{
		labTip[whichRow,16]:=""
		guicontrol,,% "t" whichRow "_" 16,no data
	}
	SendMessage,0x30,% abnormal?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+17,ahk_id %guiHwnd%

	
}

screenCre(whichRow){
	global guiHwnd,totalCol,labTip
	
	;~ static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
	controlgetText,Cr,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	if Cr is not number
		return
	controlgetText,BW,% "Edit" (whichRow-1)*totalCol+16,ahk_id %guiHwnd%
	controlgetText,Age,% "Edit" (whichRow-1)*totalCol+4,ahk_id %guiHwnd%
	RegExMatch(Age,"is)(.+)([MF])$",match)
	,age:=match1
	,gender:=match2
	,factor1:=(gender="M")?1:0.85
	,factor2:=(gender="M")?1:0.742
	
	if bw is number
		if (bw>0 && (Ccr:=(140-age)*BW*factor1/72/Cr)<=45)
			SendMessage,0x30,hFont2,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	if((mdrd:=186*(Cr**(-1.154))*(age**(-0.203))*factor2)&&mdrd<=45)
		SendMessage,0x30,hFont2,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	labTip[whichRow,9].="`nCcr = " round(Ccr,1) "`neGFR = " round(mdrd,1)
	;~ SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
}

screenLab(whichRow){
	global
	
	static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	,static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
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
	
	controlgetText,v,% "Edit" (whichRow-1)*totalCol+15,ahk_id %guiHwnd%
	SendMessage,0x30,% v!="Negative"?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+15,ahk_id %guiHwnd%
	
}

screenDate(whichRow){
	global
	
	loop % totalCol-6 {
		col:=a_index+4
		;~ controlget,editHWND,hwnd,,% "Edit" (whichRow-1)*totalCol+col,ahk_id %guiHwnd%
		editHWND:="Edit" whichRow "_" col
		regexmatch(LabTip[whichRow,col-1],"\d{4}\/\d\d\/\d\d",editDate)
		editTextColor:=date2color(editDate)
		if(CtlColors.IsAttached(%editHwnd%)){
			CtlColors.Change(%editHWND%,windowColor,editTextColor)
		}else{
			CtlColors.Attach(%editHwnd%,windowColor,editTextColor)
		}
	}
}

date2color(date1,refDate=""){
	if(!refDate)
		refDate:=a_now
	
	if(date1=""){
		return % "000000"
	}
	
	if instr(date1,"/")
		StringReplace,date1,date1,/,,A
	
	loop % 14-strlen(date1)
		date1.="0"
	
	EnvSub,refDate,% date1,days
	if refDate<=1
		color:="008000"
	else if refDate<=3
		color:="20B2AA"
	else if refDate<=7
		color:="FF5611"
	else if refDate is number
		color:="777777"
	else
		color:="000000"
	
	return color
}

fillLab(byref ptLab,labName,whichRow,whichCol,pass=0){
	global labTip
	if(isobject(labName)&&!pass){
		for k,v in labName
			fillLab(ptLab,v,whichRow,a_index+3,1)
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

fillLab2(byref ptLab,labName,whichRow,whichCol,pass=0){
	global labTip
	if(isobject(labName)&&!pass){
		for k,v in labName
			fillLab2(ptLab,v,whichRow,a_index+3,1)
		return
	}
	
	result:=ptLab.getValue(labName)
	,d:=result.maxIndex()
	,value:=result[d].value
	if(labName="WBC"){
		guicontrol,,% "t" whichRow "_" whichCol,% trim((x:=round(1000*value))?x:0)
	}else{
		guicontrol,,% "t" whichRow "_" whichCol,% trim(value)
	}
	labTip[whichRow,whichCol]:=RegExReplace(d,"(\d{4})(\d{2})(\d{2})","$1/$2/$3")
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