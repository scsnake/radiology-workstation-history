﻿/*
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
#notrayicon
#InstallKeybdHook
#include <portalLib>
#include <Class_CTLCOLORS>
#include <Monster>
#include <Showtooltip>
#include <HasVal>

OnExit,OnExit

try
	Menu,tray,icon,% A_ScriptDir "\searchLab.ico"

InitWorkerThread()
updateDate=2020/2/13
gosub mainGUI
return

mainGUI:

askForPortalIdPw()



workerPool:=[]
labTip:=[]
Lab4Arr:=[]
queryProgress:=[],queryQueue:=""
onexit,exitsub
settimer,checkLab4Pwb,500

colWidth:=[80,90,90,50,40,50,40,40,40,40,40,40,40,40,70,50,70]
rowHeight:=25

gui,color,% windowColor:="ECE9D8"
gui,font,s8,Verdana
gui,+lastfound 
winget,guiHwnd,id
colName:=["Chart No","Ward","Name","Age","Hb","WBC","INR","Plt","BUN","Cr","AST","ALT","T-bil","D-bil","Preg","BW","Thyroid"]
LabItemArr:=array(["HB", "//i)\bhb\b", "血紅素"]
	,["//W\.?B\.?C", "//白血球"]
	,["INR","PT INR", "//\bINR\b"]
	,["PLT", "//i)\bplt\b", "//i)血小板|platelet"]
	,["UN","BUN", "//\bBUN\b","血中尿素氮"]
	,["CRE","//i)\bCreatinine\b", "//肌酸酐"]
	,"//^AST"
	,"//^ALT"
	,"//i)^T-BIL"
	,"//i)^D-BIL"
	,"Urine Pregnancy Test")
totalCol:=colName.maxIndex()
birthDayArr:=[]
gui,add,text,% "w" colWidth[1] ,% colName[1]
loop % totalCol-1
	gui,add,text,% "w" colWidth[a_index+1]  " yp xp+" colWidth[a_index],% colName[a_index+1]
gui,add,text,% "w50 yp xp+" colWidth[totalCol],Lab
rowNo:=1

;~ gui,add,button,xs gExcel HwndButtonId,Convert to Excel
;~ gui,add,button,x+50 yp gRestart HwndButtonId2,Restart
gui,add,button,xs gClipboard HwndButtonId3,Copy Data
gui,add,button,x+50 yp gRestart HwndButtonId2,Restart
gui,add,button,x+300 yp ghelpFile HwndHelpButton,% "?"
gui,show,,Search Lab

addRow()


hotstrings("i)(\w)","enterChartNo")

OnMessage(0x1001,"enterChartNo")
;~ gosub debug
return

debug:
ControlSetText,,M001017,% "ahk_id " editId1
gosub pressEnter
return

helpFile:
help=
(
1. 選取病歷號按 Ctrl+C+C：查詢lab data。

2. 滑鼠左鍵點姓名、年齡、lab data，顯示附加資訊(身份證字號、生日、lab data日期)。

3. 滑鼠左鍵雙擊：複製一格資料

4. 滑鼠左鍵+右鍵：複製附加資訊。

5. Lab data顏色代表data新舊，最新為綠色，然後是藍色、橘色、灰色。

scsnake@gmail.com 
%updateDate%
)
gui,2: add,edit,w300,% help
gui,2: show,,Help File
return


Restart:
;~ gosub quitPwb
MsgBox, 49, Restart searchLab, Are you sure? All data will be gone!
IfMsgBox,OK
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
	oWb.Sheets(2).Delete()
oSh:=oWb.sheets(1)

,oSh.Cells.NumberFormat := "@"
,oSh.Columns(9).NumberFormat:=ComObj(8,"General") ;op method in "H" column!!
,oSh.Cells.VerticalAlignment := -4108 ;xlCenter
,oSh.Cells.Font.Size := 10
,oSh.Cells.Font.Name := "Arial"


,oSh.PageSetup.Orientation:=2 ;Horizontal
,oSh.PageSetup.PaperSize:=9 ;A4
,oSh.PageSetup.BottomMargin:=oExcel.CentimetersToPoints(1)
,oSh.PageSetup.TopMargin:=oExcel.CentimetersToPoints(1)
,oSh.PageSetup.LeftMargin:=oExcel.CentimetersToPoints(1)
,oSh.PageSetup.RightMargin:=oExcel.CentimetersToPoints(1)
,oSh.PageSetup.CenterHorizontally:=ComObj(0xB,-1) ;true
,oSh.PageSetup.Zoom:=ComObj(0xB,0) ;false
,oSh.PageSetup.FitToPagesTall:=1
,oSh.PageSetup.FitToPagesWide:=1


,oSh.cells(1,1):=nextDate

,excelCols:=["床號","姓名","年齡","病歷號","生日","檢查/術式","TAE","Hb","WBC","INR","Plt","BUN/Cr","AST/ALT","T/D-bil"]
loop % excelCols.maxindex() 
{
	oSh.cells(1,2+a_index).value:=excelCols[a_index]
	,oSh.cells(1,2+a_index).font.name:="標楷體"
	,oSh.cells(1,2+a_index).font.name:="Arial"
	,oSh.cells(1,2+a_index).HorizontalAlignment:=-4108
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
	guicontrol,movedraw,%buttonId3%,% "y" editY
	guicontrol,movedraw,%HelpButton%,% "y" editY
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
Showtooltip("Data copied to clipboard!", 2000)
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
	StringUpper,chartNo,chartNo
	pwb:=ComObjCreate("InternetExplorer.Application")
	;~ ,pwb.Navigate("http://portal.hospital-n.local/General/Login.aspx")
	
	
	
	;~ if (errorlevel) {
		;~ msgbox 無法開啟首頁
		;~ return
	;~ }
	,pwb.Toolbar:=pwb.Menubar:=false
	;~ WinSet, Style, -0xC00000, % "ahk_id " pwb.hwnd
	WinSet, Style, -0x40000, % "ahk_id " pwb.hwnd
	pwb.Visible:=true
	
	;~ pwb:=IEGet2("正式環境(Portal)介面",3)
	pwb.Navigate("http://ihisaw.hospital-n.local/WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx?SESSION=" sid "&PatClass=I&WardCode=12PW&ChartNo=" chartNo "&HospitalCode=T0&Seed=" A_now "&IntervalDay=-9")
	
	Loop 
		Sleep 100
	until (A_Index>100 || !pwb.busy)
	
	
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
StringUpper,chartNo,chartNo
guicontrol,,% "chartNo" whichRow,% chartNo

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
	controlfocus,% "edit" (whichRow)*totalCol+1,ahk_id %guiHwnd%
}
setTimerF("queryLab",-1,object(1,whichRow,2,chartNo))
settimer,clearWorkers,-300000
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

tip:=labTip[x:=(mod(match1,totalCol)?((match1//totalCol)+1):(match1//totalCol)),y:=match1-totalCol*(x-1)-1]
,tipTime:=StrLen(tip)*(-80)
ToolTip % tip

	;~ , tipTime:=(y<4||y>14)?-5000:-2000)
;~ traytip,,% tip
;~ settimer,tooltip,% tipTime:=(y<4||y>14)?-5000:-2000
;~ settimer,traytip,% tipTime:=(y<4||y>14)?-5000:-2000
if tip!=
	settimer,ToolTip,% tipTime
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
chartNoParse:=0
while chartNoParse:=regexmatch(data,"(\w)\w{5}\d",matchChartNo,chartNoParse+1) {
	guicontrol,,% "chartNo" rowNo-1,% matchChartNo
	guicontrol,focus,% "chartNo" rowNo-1
	gosub pressEnter
	sleep 2000
}
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


queryPatientBasicInfo(workerThread,whichRow,chartNo,sid){
	ptInfo:=patientBasicInfo("" chartNo,sid)
	,ptBWBH:=patientBWBH(chartNo,sid,ptInfo.personId)
	,RegExMatch(ptInfo.age,"(\d+)y(\d+)m",match)
	,str:=round(match1 + match2/12) ptInfo.gender
	return [whichRow,ptInfo.ward,ptInfo.name,str,ptInfo.personId,ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay,ptInfo,ptBWBH]
}

queryPatientBasicInfo_onFinish(workerThread,result){
	global guiHwnd,birthDayArr,totalCol,ptInfo,labTip,sid,workerPool
	ptInfo:=result[7]
	loop 3
		ControlSetText,% "Edit" (result[1]-1)*totalCol+1+a_index,% result[a_index+1],ahk_id %guiHwnd%
	
	labTip[result[1],2]:=result[5]
	,labTip[result[1],3]:=birthDayArr[whichRow]:=result[6]
	
	,ptBWBH:=result[8]
	ControlSetText,% "Edit" (result[1]-1)*totalCol+16,% RegExReplace(trim(ptBWBH.BW),"is)(^[^\.]+$)|^(.+?)(0*)$","$1$2"),ahk_id %guiHwnd%
	regexmatch(ptBWBH.BW,"[\d.]+",BW)
	
	,regexmatch(ptBWBH.BMI,"[\d.]+",BMI)
	SetFormat,Float,0.1
	BMI:=BMI+0
	,BW13:=BW*1.3
	,BW15:=BW*1.5
	,labTip[result[1],15]:=ptBWBH.UpdateDate (BMI?"`nBMI = " BMI:"") (BW?"`n1.3→ " (BW13) "ml`n1.5→ " (BW15) "ml" :"")	
	
	if instr(a_scriptname,"searchLab") {
		WorkerThread5:=new CWorkerThread("thyroidFunc", 0, 0, 1)
		,WorkerThread5.OnFinish.Handler := "thyroidFunc_onFinish"
		,WorkerThread5.Start(result[1],result[5],sid)
		,workerPool.push(WorkerThread5)
		;~ setTimerF("thyroidFunc",-1,object(1,whichRow,2,ptInfo.personId,3,sid))
	}
	
}

queryLab1(workerThread,whichRow,chartNo,sid,guiHwnd,LabItemArr,totalCol){
	return [whichRow,ptLab2:=getLab2(chartNo,sid,1),chartNo,sid,guiHwnd,LabItemArr,totalCol]
}
queryLab1_onFinish(workerThread,result){
	global guiHwnd,birthDayArr,totalCol,labItemArr,workerPool
	for k,item in labItemArr
		fillLab3(result[2],item,result[1],a_index+3,0)
	
	WorkerThread3:=new CWorkerThread("queryLab2", 0, 0, 1)
	WorkerThread3.OnFinish.Handler := "queryLab2_onFinish"
	WorkerThread3.Start(result[1],result[3],result[4],result[5],result[6],result[7],14,1)
	,workerPool.push(WorkerThread3)
}
queryLab2(workerThread,whichRow,chartNo,sid,guiHwnd,labItemArr,totalCol,day1,day2){
	returnArr:=[],ptLab2:=0
	returnArr.push(whichRow)
	for k,item in labItemArr {
		controlgetText,v,% "Edit" (whichRow-1)*totalCol+4+a_index,ahk_id %guiHwnd%
		if (trim(v) || a_index=12)
			continue
		if !isobject(ptLab2) {
			returnArr.push(ptLab2:=getLab2(chartNo,sid,day1,day2))
		}
		returnArr.push(array(item,a_index+3))
	}
	return [returnArr,chartNo,sid,guiHwnd,labItemArr,totalCol,day1,day2]
}
queryLab2_onFinish(workerThread,result){
	global CtlColors,queryProgress,workerPool
	whichRow:=result[1,1]
	loop % result[1].maxIndex()-2
		fillLab3(result[1,2],result[1,a_index+2,1],whichRow,result[1,a_index+2,2],1)
	
	if result[7]=14 {
		WorkerThread4:=new CWorkerThread("queryLab2", 0, 0, 1)
		WorkerThread4.OnFinish.Handler := "queryLab2_onFinish"
		WorkerThread4.Start(whichRow,result[2],result[3],result[4],result[5],result[6],90,14)
		,workerPool.push(WorkerThread4)
	}else if result[7]=90 {
		screenLab(whichRow)
		,screenCre(whichRow)
		;~ ,screenDate(whichRow)
		queryProgress[whichRow]:=queryProgress[whichRow]+1
		,queryLabAllChartNos(whichRow, result[2])
		
	}
}
;6______ 

queryLabAllChartNos(whichRow, chartNo){
	global sid,guiHwnd,LabItemArr,totalCol,workerPool,labTip
	
	WorkerThread6:=new CWorkerThread("queryLabAllChartNosWorker", 0, 0, 1)
	WorkerThread6.OnFinish.Handler := "queryLabAllChartNosWorker_onFinish"
	WorkerThread6.Start(whichRow, chartNo,sid,guiHwnd,LabItemArr,totalCol)
	,workerPool.push(WorkerThread6)
}

queryLabAllChartNosWorker(workerThread, whichRow, chartNo, sid, guiHwnd, LabItemArr, totalCol){
	results:=[]
	for k,otherChartNo in getAllChartNos(sid, chartNo) {
		results[otherChartNo]:=result:=getLab2(otherChartNo, sid, 90, 0)
	}
	return [whichRow, results]
}

queryLabAllChartNosWorker_onFinish(workerThread,result){
	global CtlColors,queryProgress,workerPool,labItemArr,labTip
	
	moreFilled:=false
	whichRow:=result[1]
	AllChartNos:=""
	for otherChartNo, ptLab in result[2] {
		AllChartNos.=otherChartNo "`n"
	
		if ptLab.length()
			for k,item in labItemArr 
				;~ if InStr(item, "AST")
					;~ clipboard:=exploreobj(ptLab)
					moreFilled |= fillLab3(ptLab,item,whichRow,a_index+3,1,true)
	}
	labTip[whichRow, 1]:=Trim(AllChartNos)	
	
	if moreFilled
		screenLab(whichRow)
		,screenCre(whichRow)
		;~ ,screenDate(whichRow)
	queryProgress[whichRow]:=queryProgress[whichRow]+1
}

queryLab(whichRow,chartNo){
	global sid,loginId,loginPw,birthDayArr,labTip,guiHwnd,totalCol,labItemArr,ptInfo,CtlColors,queryProgress,queryQueue,workerPool,Lab4Arr
	
	
	labTip[whichRow]:=[]
	Loop 16
		ControlSetText,% "Edit" (whichRow-1)*totalCol+A_Index+1,% "", ahk_id %guiHwnd%
	Lab4Arr[whichRow]:=""
	
	queryProgress[whichRow]:=0
	if(CtlColors.IsAttached(EditId%whichRow%)){
		CtlColors.Change(EditId%whichRow%,"FFFFFF","000000")
	}else{
		CtlColors.Attach(EditId%whichRow%,"FFFFFF","000000")
	}
	
	
	if !checkSID(sid)
		sid:=Login(loginId,loginPw)
	
	WorkerThread:=new CWorkerThread("queryPatientBasicInfo", 0, 0, 1)
	WorkerThread.OnFinish.Handler := "queryPatientBasicInfo_onFinish"
	WorkerThread.Start(whichRow,chartNo,sid)
	,workerPool.push(WorkerThread)

	WorkerThread2:=new CWorkerThread("queryLab1", 0, 0, 1)
	WorkerThread2.OnFinish.Handler := "queryLab1_onFinish"
	WorkerThread2.Start(whichRow,chartNo,sid,guiHwnd,LabItemArr,totalCol)
	,workerPool.push(WorkerThread2)
	
	queryQueue.="" whichRow ","
	settimer,queryFinish,300
	
	;~ screenLab(whichRow)
	;~ ,screenCre(whichRow)
	;~ ,screenDate(whichRow)
	
	;~ return whichRow
	
}
	;~ setTimerF("thyroidFunc",-1,object(1,whichRow,2,ptInfo.personId,3,sid))

queryFinish:
if (queryQueue="")
	return
tempQueue:=""
loop,parse,queryQueue,`,
{
	if(a_loopfield="")
		continue
	if (queryProgress[a_loopfield]>=2){
		if queryProgress[a_loopfield]=2
			tempQueue.="" a_loopfield ","
		ProgressColor:=queryProgress[a_loopfield]=2?"f1ff87":"9aff4d"
		if(CtlColors.IsAttached(EditId%a_loopfield%)){
			CtlColors.Change(EditId%a_loopfield%,ProgressColor,"000000")
		}else{
			CtlColors.Attach(EditId%a_loopfield%,ProgressColor,"000000")
		}
	}else{
		tempQueue.="" a_loopfield ","
	}
}
if (tempQueue="")
	settimer,queryFinish,off
else
	queryQueue:=tempQueue
return

queryFinish(whichRow){
	global queryProgress,CtlColors
	;~ tooltip,% queryProgress[1] "," queryProgress[2]
	if queryProgress[whichRow]>=2 {
		if queryProgress[whichRow]==3
			setTimerF("queryFinish",0)
		ProgressColor:=queryProgress[whichRow]=2?"f1ff87":"9aff4d"
		if(CtlColors.IsAttached(EditId%whichRow%)){
			CtlColors.Change(EditId%whichRow%,ProgressColor,"000000")
		}else{
			CtlColors.Attach(EditId%whichRow%,ProgressColor,"000000")
		}
	}else{
		;~ settimerF("queryFinish",-300,object(1,whichRow))
	}
}


fillLab3(byref ptLab,byref labName,whichRow,whichCol,pass=0,updateMode=false){
	global labTip,guiHwnd,totalCol
	;~ if(isobject(labName)&&pass=0){
		;~ for k,v in labName
			;~ fillLab3(ptLab,v,whichRow,a_index+3,1)
		;~ return
	;~ }
	if (labName="Urine Pregnancy Test")
		result:=getLabValue(ptLab,labName,"RANDOM URINE")
	else
		result:=getLabValue(ptLab,labName)
	
	if(!result.maxIndex()&&pass>0)
		return false
	
	
	
	
	
	
	updated:=false
	str:=labTip[whichRow, whichCol]
	while (r:=result[a_index]) && a_index<6 {
		value:=r.value
	
		if(labName="WBC"){
			value:=trim((x:=round(1000*value))?x:0)
		}else{
			value:=RegExReplace(trim(value),"is)(^[^\.]+$)|(^.+\.0)0*$|^(.+?)(0*)$","$1$2$3")
		}
		
		thisLabDate:=RegExReplace(r.LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
		if (a_index=1){
			if compareLabDates(labTip[whichRow, whichCol],thisLabDate) {
				controlsetText,% "Edit" n:=(whichRow-1)*totalCol+whichCol+1,% value,ahk_id %guiHwnd%
				updated:=true
			}
		}
		
		str.=thisLabDate "  " value "`n"
	}
	
	if ((IsObject(labName) && HasVal(labName, "CRE")) || (!IsObject(labName) && InStr(labName, "CRE"))) && (GFR:=getLabValue(ptLab, "//GFR|腎絲球濾過率")).length()
		while (r:=GFR[A_Index]) && A_Index<3 {
			value:=r.value
			,thisLabDate:=RegExReplace(r.LogDateTime,"is)(\d{4})-(\d{2})-(\d{2}).*","$1/$2/$3")
			,str.=thisLabDate " GFR " Round(value,1) "`n"
		}
	
	
	if !isobject(result[1]) && !updateMode
		controlsetText,% "Edit" (whichRow-1)*totalCol+whichCol+1,% "",ahk_id %guiHwnd%
	
	
	labTip[whichRow,whichCol]:=sortLabTipDates(str)
	return updated
}
compareLabDates(labTipDates, thisLabDate){
	if Trim(labTipDates)=""
		return true
	
	thisLabDate:=RegExReplace(thisLabDate, "\D", "")
	newest:=true
	
	Loop,Parse,labTipDates,`n
	{
		if !RegExMatch(A_LoopField, "^\d+\/\d+\/\d+", d)
			continue
		d:=RegExReplace(d, "\D", "")
		newest &= (thisLabDate>d)
	}
	
	return newest
}

sortLabTipDates(str){
	if (Trim(str)="")
		return ""
	tmp:=[]
	Loop,Parse,str,`n
		if RegExMatch(A_LoopField, "is)^(\d+\/\d+\/\d+)(.+)$", m)
			tmp[(99999999-RegExReplace(m1, "\D", "")) " " A_Index]:=Trim(m2)
	str:=""
	for k,v in tmp
		if (k:=99999999-SubStr(k,1,8)) && !InStr(str, newTxt:=SubStr(k,1,4) "/" SubStr(k,5,2) "/" SubStr(k,7,2) " " v)
			str.=newTxt "`n"
	return RTrim(str)
}

thyroidFunc_onFinish(workerThread,result){
	global guiHwnd,labTip,totalCol,queryProgress
	
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	whichRow:=result[1],abnormal:=result[3],str:=result[2]
	if(str){
		labTip[whichRow,16]:=RegExReplace(str,"\n$","")
		controlsettext,% "Edit" (whichRow-1)*totalCol+17,% abnormal?"!!!!!!":"details",ahk_id %guiHwnd%
	}else{
		labTip[whichRow,16]:=""
		controlsettext,% "Edit" (whichRow-1)*totalCol+17,no data,ahk_id %guiHwnd%
	}
	SendMessage,0x30,% abnormal?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+17,ahk_id %guiHwnd%
	queryProgress[whichRow]:=queryProgress[whichRow]+1

}
thyroidFunc(workerThread,whichRow,personId,sid){
	global guiHwnd,totalCol,labTip,tt
	
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
	

	return [whichRow,str,abnormal]
				
	
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
	global totalCol,labtip,guiHwnd,CtlColors,windowColor
	
	static hFont1   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  400,   "Uint", 0,   "Uint", 0,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	static hFont2   := DllCall("CreateFont", "int",  13, "int",  0, "int",  0, "int", 0 ,"int",  700,   "Uint", 0,   "Uint", 1,"Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", "Verdana")
	
	static conditions:=["<8",">9999", ">1.29", "<80", ">30", ">1.49", ">100", ">100", ">1.49", ">0.99"]
	static abnormalBgColor:="ffc3bf"
	
	loop % totalCol-6 {
		col:=a_index+4
		;~ controlget,editHWND,hwnd,,% "Edit" (whichRow-1)*totalCol+col,ahk_id %guiHwnd%
		editHWND:="Edit" whichRow "_" col
		regexmatch(LabTip[whichRow,col-1],"\d{4}\/\d\d\/\d\d",editDate)
		
		controlgetText,v,% "Edit" (whichRow-1)*totalCol+col,ahk_id %guiHwnd%
		
		if A_Index<=10
			condition:=conditions[A_Index]
			,abnormal:=Trim(v)=""?false:!!eval(v condition)
		else
			abnormal:=Trim(v)=""?false:(v!="Negative")
		
		editTextColor:=date2color(editDate)
		
		if(CtlColors.IsAttached(%editHwnd%)){
			CtlColors.Change(%editHWND%,abnormal?abnormalBgColor:windowColor,editTextColor)
		}else{
			CtlColors.Attach(%editHwnd%,abnormal?abnormalBgColor:windowColor,editTextColor)
		}
		SendMessage,0x30,% abnormal?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+col,ahk_id %guiHwnd%
	}
	
	
	
	;~ SendMessage,0x30,% v<8?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+5,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+6,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>9999?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+6,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+7,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>1.29?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+7,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+8,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v<80?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+8,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+9,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>30?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+9,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+10,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+11,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>100?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+11,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+12,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>100?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+12,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+13,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>1.49?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+13,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+14,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v>0.99?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+14,ahk_id %guiHwnd%
	
	;~ controlgetText,v,% "Edit" (whichRow-1)*totalCol+15,ahk_id %guiHwnd%
	;~ SendMessage,0x30,% v!="Negative"?hFont2:hFont1,true,% "Edit" (whichRow-1)*totalCol+15,ahk_id %guiHwnd%
	
}

screenDate(whichRow){
	global
	
	
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

enterChartNo:
guicontrolget,focused,focus
regexmatch(focused,"Edit(\d+)",match)
if mod(match1-1,totalCol)=0
	return
guicontrolget,tmp,,% "Edit" (rowNo-2)*totalCol+1
if (tmp="") {
	guicontrol,focus,% "Edit" (rowNo-2)*totalCol+1
}
return

hotstrings(k, a = "")
{
	static z, m = "*~$", s, t, w = 2000, sd, d = "Left,Right,Up,Down,Home,End,RButton,LButton"
	global $
	If z = ; init
	{
		RegRead, sd, HKCU, Control Panel\International, sDecimal
		Loop, 94
		{
			c := Chr(A_Index + 32)
			If A_Index not between 33 and 58
				Hotkey, %m%%c%, __hs
		}
		e = 0,1,2,3,4,5,6,7,8,9,Dot,Div,Mult,Add,Sub,Enter
		Loop, Parse, e, `,
			Hotkey, %m%Numpad%A_LoopField%, __hs
		e = BS,Space,Enter,Return,Tab,%d%
		Loop, Parse, e, `,
			Hotkey, %m%%A_LoopField%, __hs
		z = 1
	}
	If (a == "" and k == "") ; poll
	{
		StringTrimLeft, q, A_ThisHotkey, StrLen(m)
		If q = BS
		{
			If (SubStr(s, 0) != "}")
				StringTrimRight, s, s, 1
		}
		Else If q in %d%
			s =
		Else
		{
			If q = Space
				q := " "
			Else If q = Tab
				q := "`t"
			Else If q in Enter,Return,NumpadEnter
				q := "`n"
			Else If (RegExMatch(q, "Numpad(.+)", n))
			{
				q := n1 == "Div" ? "/" : n1 == "Mult" ? "*" : n1 == "Add" ? "+" : n1 == 

"Sub" ? "-" : n1 == "Dot" ? sd : ""
				If n1 is digit
					q = %n1%
			}
			Else If (StrLen(q) != 1)
				q = {%q%}
			Else If (GetKeyState("Shift") ^ GetKeyState("CapsLock", "T"))
				StringUpper, q, q
			s .= q
		}
		Loop, Parse, t, `n ; check
		{
			StringSplit, x, A_LoopField, `r
			If (RegExMatch(s, x1 . "$", $)) ; match
			{
				StringLen, l, $
				StringTrimRight, s, s, l
				;SendInput, {BS %l%} <-------------------------------------------
				If (IsLabel(x2))
					Gosub, %x2%
				Else
				{
					Transform, x0, Deref, %x2%
					SendInput, %x0%
				}
			}
		}
		If (StrLen(s) > w)
			StringTrimLeft, s, s, w // 2
	}
	Else ; assert
	{
		StringReplace, k, k, `n, \n, All ; normalize
		StringReplace, k, k, `r, \r, All
		Loop, Parse, t, `n
		{
			l = %A_LoopField%
			If (SubStr(l, 1, InStr(l, "`r") - 1) == k)
				StringReplace, t, t, `n%l%
		}
		If a !=
			t = %t%`n%k%`r%a%
	}
	Return
	__hs: ; event
	hotstrings("", "")
	Return
}


clearWorkers(){
	global workerPool
	for k,v in workerPool
		v.Stop(), v.Finish()
	workerPool:=[]
}

OnExit:
;~ MsgBox % workerPool.length()
clearWorkers()
ExitApp

#include <WorkerThread>

