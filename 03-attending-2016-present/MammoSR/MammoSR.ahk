FileEncoding,utf-8
OnExit,OnExit
#include <XML>
#include <Edit>
#include <portalLib>
#include <RisImpax>
#include <CheckUpdate>
#include <class_CTLCOLORS>
#include <WM_COPYDATA>
#UseHook

;~ SetTimerF("scs_sync", -1)
#SingleInstance,force
askForPortalIdPw()

,thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
;~ ,OnMessage(0x8000, "AccNoChange")
,RISImpaxRegister([  {app: "Ris", type: "State", hwnd: thisHwnd, msg: {msg: 0x8000}, Func: "AccNoChange", initStart:1}
	,{app: "Ris", type: "AccNo", hwnd: thisHwnd, msg: {msg: 0x8000}, Func: "AccNoChange"}])

;~ gosub serverInfo
FirstOpened:=true
gosub setting
gosub serverInfo
gosub parseTemplate
;~ gosub routine
SetTimer,routine,500
;~ AccNoChange()
SetTimer,saveNewHtml,-500
;~ SetTimer,checkHtmlSaveHint,500
;~ SetTimer,runOther,-3000
try
	menu, tray, icon,% a_scriptdir "\MammoSR.ico",1,0

GroupAdd,HotkeyGroup,ahk_exe impax-client-main.exe
GroupAdd,HotkeyGroup,ahk_exe Menu.exe
GroupAdd,HotkeyGroup,simple RIS ahk_class AutoHotkeyGUI

Hotkey,IfWinActive,ahk_group HotkeyGroup
Hotkey,^2,b2FastSend
Hotkey,+^2,b2FastSend
Hotkey,^1,b1FastSend
Hotkey,+^1,b1FastSend
Hotkey,IfWinActive

return

runOther:
runOther("MammoSRPrintServer.exe")
return

runOther(exeName){
	if !(exeName~="i).exe$")
		exeName.=".exe"
	if !WinExist("ahk_exe " exeName) {
		if !FileExist(A_ScriptDir "\" exeName){
			MsgBox % exeName " NOT FOUND!!!"
			return 
		}
		run % A_ScriptDir "\" exeName
		winwait,ahk_exe %exeName%,,20
		if (ErrorLevel){
			MsgBox % "Can't run " exeName "!!!"
			return
		}
	}
}
parseTemplate:
B1template:=B2template:=""
Loop,read,MammoSR.ini
{
	line:=Trim(A_LoopReadLine)
	if(line="[Template]")
		template:=true
	else if(template && line="B1=")
		nextB1:=true, nextB2:=false
	else if(template && line="B2=")
		nextB2:=true, nextB1:=false
	else if(nextB1)
		B1template.=line "`r`n"
	else if(nextB2)
		B2template.=line "`r`n"
}
if (B1template="")
	B1template=
	(LTrim
	- There are no definite mass, no suspicious microcalcifications, and no architectural distortion in this study.
	- No definite axillary lymphadenopathy. 
	)
if (B2template="")
	B2template=
	(LTrim
	- There are benign calcification(s).
	- There are no definite mass and no architectural distortion in this study.
	- No definite axillary lymphadenopathy. 
	)
return
serverInfo:
IniRead,serverIp,% iniPath:=A_ScriptDir "\MammoSR.ini",server,ip,localhost
IniRead,serverPort,% iniPath,server,port,54321
return

^tab::
WinActivate,ahk_id %guihwnd%
return

AccNoChange(){
	global 
	if AccNoChangeUpdating
		return
	AccNoChangeUpdating:=true
	,RisState:=RisOpened()
	,thisAccNo:=getRisAccNo(RisState[2])
	if(priorAccNo!="" && xmlSaveStateInd>0 && FirstOpened){
		saveNoExport:=true
		gosub Save
	}
	if !InStr(parseRisExamItems(getRisExamItems(RisState[2]))[1,1], "預防保健")
		return AccNoChangeUpdating:=false
	gosub gui
	FirstOpened:=false
	GuiControlGet,isAutoOpen,,autoOpen
	if isAutoOpen
		SetTimer,OpenStudy,-1
	AccNoChangeUpdating:=false
}

routine:
if RegExMatch(findingsText:=ControlGetText(EditHwnd), "(?<!\r)\n"){
	Edit_SetText(EditHwnd, findingsText:=RegExReplace(findingsText, "(?<!\r)\n", "`r`n"))
	Edit_SetSel(EditHwnd, StrLen(findingsText), StrLen(findingsText))
}
return

setting:
bullet:="- "
FileCreateDir,% ReportDir:=A_ScriptDir "\MammoReportSaved\"
return

#IfWinActive,ahk_group MyGUI
F5::
gosub OpenStudy
return
^s::
gosub savesend
return
;~ ^d::
;~ gosub Send
;~ return
;~ ^p::
;~ gosub printAll
;~ return
#IfWinActive


gui:
if WinExist("ahk_id " guihwnd){
	WinGetPos,x,y,,,ahk_id %guihwnd%
	GuiControlGet,autoOpen,,autoOpen
}else{
	autoOpen:=true
}
gui,Destroy
gui,+hwndguiHwnd
GroupAdd,MyGUI,ahk_id %guiHwnd%
gui,Font,s10,Verdana
gui,add,button,gopenStudy vopenStudyButton,Open Study
gui,add,Checkbox,% "yp+10 x+30 vautoOpen " (!autoOpen?"":"checked"),Auto-open
gui,add,DropDownList,vmodality xm w150,CR|DR||Tomo

gui,Add,Text,xs y+20,Indication
gui,Add,ComboBox,vindication w600,% "1) screening mammogram||2) follow up|3) breast cancer status post left mastectomy|4) breast cancer status post right mastectomy|5) breast cancer status post bilateral mastectomy|6) status post operation with benign result|7) status post biopsy with benign result|8) family history of breast cancer ()"

gui,Add,Text,y+20,Comparison
gui,Add,ComboBox,vcomparison w600,% "1) Yes||2) No, 第一次篩檢|3) No, 無法取得舊片|4) No, 無法獲知是否有舊片"

gui,Add,Text,y+20,Breast Composition
gui,Add,DropDownList,vcomposition w600,% "1) The breasts are almost entirely fatty. (breast composition a) |2) There are scattered areas of fibroglandular density. (breast composition b)|3) The breasts are heterogeneously dense, which may obscure small masses. (breast composition c)||4) The breasts are extremely dense, which lowers the sensitivity of mammography. (breast composition d)"

gui,Add,Text,y+20,Findings
gui,Add,button,gfindingsButton,OP
gui,Add,button,gfindingsButton x+10,Calcification
gui,Add,button,gfindingsButton x+10,Mass
gui,Add,button,gfindingsButton x+10,Asymmetry
gui,Add,button,gfindingsButton x+10,Architectural distortion
gui,Add,button,gfindingsButton x+10,Other
gui,Add,button,gtemplateText xm,B1
gui,Add,button,gtemplateText x+10,B2
gui,Add,Edit,xs vfindings hwndeditHwnd w600 h200
gui,add,button,gdeleteLast xp+500 y+0,Delete Last

gui,Add,Text,xs y+0,Assessment
gui,Add,DropDownList,vassessment w600,% "0u) BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest breast ultrasound correlation.|0m) BI-RADS 0, indeterminate mammographic finding (need additional imaging evaluation), suggest spot magnified view correlation.|1) BI-RADS 1, negative finding, suggest annual mammogram follow up or at the recommendation of the patient's physician. (If there is clinical relevant finding, ultrasound is suggested.)|2) BI-RADS 2, benign finding, suggest annual mammogram follow up or at the recommendation of the patient's physician. (If there is clinical relevant finding, ultrasound is suggested.)||3) BI-RADS 3, probably benign finding, suggest 6-month mammogram follow up. (If there is clinical relevant finding, ultrasound is suggested.)|4) BI-RADS 4, suspicious malignant lesion. Suggest tissue proof.|4a) BI-RADS 4A, low suspicion for malignancy. Suggest tissue proof.|4b) BI-RADS 4B, moderate suspicion for malignancy. Suggest tissue proof.|4c) BI-RADS 4C, high suspicion for malignancy. Suggest tissue proof.|5) BI-RADS 5, highly suggestive of malignancy. Suggest tissue proof.|6) BI-RADS 6, known biopsy-proven malignancy."

gui,add,button,gsave xm y+20,Save
gui,Add,button,gsend x+20 yp,Send
gui,Add,button,gsavesend x+20 yp,% "Save&&Send"
gui,add,button,greset yp x+30,Reset All
;~ gui,add,button,glistRemote yp x+100,List Remote
;~ gui,add,button,gprintAll yp x+50,Print All

gui,add,Text,xm y+10,Name
gui,add,edit,vptNameEdit hwndptNameHwnd x+5 yp-5,% "　　　　"
guicontrol,,ptNameEdit,% ""
gui,add,Text,x+10 yp+5,Age
gui,add,edit,vptAgeEdit hwndptAgeHwnd x+5 yp-5,00
guicontrol,,ptAgeEdit,% ""
gui,add,Text,xm,Chart No
gui,add,edit,vchartNoEdit hwndchartNoHwnd x+5 yp-5,1______
guicontrol,,chartNoEdit,% ""
gui,add,Text,x+10 yp+5,Acc No
gui,add,edit,vAccNoEdit hwndAccNoHwnd x+5 yp-5,T__________
guicontrol,,AccNoEdit,% ""
gui,add,Text,x+10 yp+5,Exam Date
gui,add,edit,vExamDateEdit hwndExamDateHwnd x+5 yp-5,2016/01/01 00:00:00
guicontrol,,ExamDateEdit,% ""
gui,add,Text,xm,Radiologist
gui,add,edit,vradiologistEdit hwndradiologistHwnd x+5 yp-5,% "　　　"
guicontrol,,radiologistEdit,% ""
gui,add,Text,x+10 yp+5,Technician
gui,add,edit,vtechnicianEdit hwndtechnicianHwnd x+5 yp-5,% "　　　"
guicontrol,,technicianEdit,% ""

infoEditHwndArr:=[]
for k,v in ["ptName", "ptAge", "chartNo", "AccNo", "ExamDate", "radiologist", "technician"] 
	varName:=v "hwnd"
	, infoEditHwndArr.push(%varName%)
	, CTLColors.attach(%varName%, "white")


gui,Show,% "AutoSize " (x?"x" x " y" y:""),Mammography Structured Report
;~ winset,AlwaysOnTop,on,ahk_id %guihwnd%
guicontrol,Focus,OpenStudyButton

gosub xmlInit
oldStudyList:=""
return

templateText:
oldText:=RegExReplace(ControlGetText(EditHwnd), "(\r?\n)*$", "")
if(oldText!="")
	oldText.="`n"
if(genB1 || a_guicontrol="B1"){
	str:=B1template
	GuiControlChooseSubString("Assessment", "BI-RADS 1")
}else if(genB2 || a_guicontrol="B2"){
	str:=B2template
	GuiControlChooseSubString("Assessment", "BI-RADS 2")
}
Edit_SetText(EditHwnd, oldText:=RegExReplace(oldText str, "(?<!\r)\n", "`r`n"))
,Edit_SetSel(EditHwnd, StrLen(oldText), StrLen(oldText))
,genB2:=genB1:=false
return

+^2::
^2::
b2FastSend:
genB2:=true
if InStr(A_ThisHotkey,"+")
	gosub noOldFilm
gosub templateText
gosub savesend
return

+^1::
^1::
b1FastSend:
genB1:=true
if InStr(A_ThisHotkey,"+")
	gosub noOldFilm
gosub templateText
gosub savesend
return

!1::
!2::
!3::
!4::
guicontrol,choose,Composition,% SubStr(A_ThisHotkey,2,1)
Showtooltip("Breast density changed to: " SubStr(A_ThisHotkey,2,1), 1500)
return

noOldFilm:
guicontrol,choose,Comparison,2
return

getExamInfo:
if !WinExist(RisState[2]) && !(RisState:=RisOpened())[2]
	return
;yyyy/MM/dd hh:mm:ss
SRxml.setText("/MammoSR/StudyDateTime", examDate:=getRisExamDate(RisState[2]))
,SRxml.setText("/MammoSR/ChartNo", chartNo:=getRisChartNo(RisState[2]))
,SRxml.setText("/MammoSR/AccNo", accNo:=thisAccNo)
,SRxml.setText("/MammoSR/ReportVS", radiologist:=getRisLoginName(RisState[2]))
,SRxml.setText("/MammoSR/Technician", technician:=getRisTechName(RisState[2]))
,SRxml.setText("/MammoSR/Patient/Name", ptName:=getRisPtName(RisState[2]))
,SRxml.setText("/MammoSR/Patient/Gender", ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","性別","WindowsForms10.EDIT")[1]))
,SRxml.setText("/MammoSR/Patient/Age", ptAge:=ControlGetText(getNetControl2(RisState[2],"","FID_TEXT","年齡","WindowsForms10.EDIT")[1]))

for k,v in ["examDate", "chartNo", "radiologist", "technician", "ptAge", "ptName", "accNo"]
	guicontrol,,% v "Edit",% %v%

if FileExist(savedXML:=ReportDir chartNo " " accNo ".xml")
	SetTimer,loadSavedXML,-1

if !checksid(sid)
	return
ptInfo:=patientBasicInfo(chartNo,sid)
,SRxml.setText("/MammoSR/Patient/PersonId", ptInfo.personId)
;yyyy/MM/dd
,SRxml.setText("/MammoSR/Patient/Birthday", ptInfo.birthYear "/" ptInfo.birthMonth "/" ptInfo.birthDay)
settimer,alarmBlankInfo,-1
return

alarmBlankInfo:
blankInfoPresent:=false
for k,v in infoEditHwndArr {
	if (ControlGetText(v)="")
		CTLColors.change(v, "red"), blankInfoPresent|=true
	else
		CTLColors.change(v, "white")
}
if(blankInfoPresent)
	settimer,alarmBlankInfo,-3000
else
	settimer,alarmBlankInfo,Off
return

loadSavedXML:
fileread,oldXML,% savedXML
SRxml:=new xml(oldXML)
GuiControlChooseSubString("Indication", SRxml.getText("/MammoSR/Report/Indication"), true)
GuiControlChooseSubString("Comparison", SRxml.getText("/MammoSR/Report/Comparison"))
GuiControlChooseSubString("Composition", SRxml.getText("/MammoSR/Report/Density"))
GuiControlChooseSubString("Assessment", SRxml.getText("/MammoSR/Report/Assessment"))
;~ GuiControlChooseSubString("findings", SRxml.getText("/MammoSR/Report/FullText"))
;~ guicontrol,ChooseString,Indication,% SRxml.getText("/MammoSR/Report/Indication")
;~ guicontrol,ChooseString,Comparison,% SRxml.getText("/MammoSR/Report/Comparison")
;~ guicontrol,ChooseString,Composition,% SRxml.getText("/MammoSR/Report/Density")
;~ guicontrol,ChooseString,Assessment,% SRxml.getText("/MammoSR/Report/Assessment")
guicontrol,,findings,% SRxml.getText("/MammoSR/Report/FullText")
return

GuiControlChooseSubString(var, Text, ComboBox=false){
	global 
	local oHwnd,oList,pos
	GuiControlGet,oHwnd,hwnd,%var%
	controlget,oList,list,,,% "ahk_id " oHwnd
	Loop,Parse,oList,`n
	{
		if (A_LoopField=Text){
			guicontrol,ChooseString,% var,% Text
			return
		}
	}
	Loop,Parse,oList,`n
	{
		if (pos:=InStr(A_LoopField,Text) && RegExMatch(SubStr(A_LoopField,1,pos-1),"\d+\) ")){
			guicontrol,ChooseString,% var,% A_LoopField
			return
		}
	}
	Loop,Parse,oList,`n
	{
		if InStr(A_LoopField,Text) {
			guicontrol,ChooseString,% var,% A_LoopField
			return
		}
	}
	if(ComboBox)
		guicontrol,Text,% var,% Text
	else
		guicontrol,,% var,% Text
}

save:
gui,1:Submit,NoHide
SRxml.setText("/MammoSR/Report/Indication", Indication:=removeNumbering(Indication))
,SRxml.setText("/MammoSR/Report/Comparison", Comparison:=removeNumbering(Comparison))
,SRxml.setText("/MammoSR/Report/Density", Density:=removeNumbering(Composition))
,SRxml.setText("/MammoSR/Report/Assessment", Assessment:=removeNumbering(Assessment))
,SRxml.setText("/MammoSR/Report/FullText", findings:=removeNumbering(findings))
,SRxml.setText("/MammoSR/Report/Modality", modality:=removeNumbering(modality))
,SRxml.setText("/MammoSR/Report/ReportDate", A_YYYY "/" A_MM "/" A_DD)
if !(saveNoExport){
	gosub exportReport
}
gosub saveXML
saveNoExport:=false
;~ gosub xmlInit
return

exportReport:
str:="Indication: " Indication 
,str.=(SubStr(Trim(str),0,1)="."?"":".") "`n"
,str.="Comparison: " (oldStudyList=""?Comparison:oldStudyList) (InStr(Comparison,"無法取得舊片")?" (本院無舊片，亦無可取得的外院片)":"")
,str.=(SubStr(Trim(str),0,1)="."?"":".") "`n`n"
,str.="Breast composition: `n" Density
,str.=(SubStr(Trim(str),0,1)="."?"":".") "`n`n"
,str.="Findings: `n" findings
,str.="`n`n"
,str:=RegExReplace(str, "is)\r?\n?(- +(\r?\n?))*(\r?\n)*$", "")
,str:=RegExReplace(str, "\r?\n", "`r`n")
,setReportText(str, Assessment, RisReports, true)
if(simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI")){
	controlget,SciEditHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
	SendMessage,0x2023,1000,1,,simple RIS ahk_class AutoHotkeyGUI
	Edit_SetText(SciEditHwnd, str)
}
;~ RisReports:=getRisReports(RisOpened()[2])
;~ oldReport:=ControlGetText(RisReports[1,1])
;~ if start:=InStr(oldReport, str) {
	;~ setReportText(SubStr(oldReport, 1, start-1), Assessment, RisReports, true)
;~ }else {
	;~ setReportText(str, Assessment, RisReports)
;~ }
return

reset:
MsgBox,4,, % "Reset data of this exam?"
IfMsgBox,No
	return
FileDelete,% ReportDir chartNo " " accNo ".xml"
gosub gui
return

saveXML:
SRxml.transformXml()
if(SRxml.getText("/MammoSR/ChartNo")="" || SRxml.getText("/MammoSR/AccNo")=""){
	gosub getExamInfo
}
if(SRxml.getText("/MammoSR/ChartNo")="" || SRxml.getText("/MammoSR/AccNo")=""){
	MsgBox % "Can't get chart/accession number. Please re-open the RIS!"
	return
}
savedXML:=SRxml.getText("/MammoSR/ChartNo") " " SRxml.getText("/MammoSR/AccNo") 
SRxml.save(xmlPath:=ReportDir savedXML ".xml")

if (saveNoExport){
	return
}

;~ run % """" A_ScriptDir "\MammoSRprint.exe"" """ xmlPath """"
run %  runAhkExe("MammoSRprint.exe") commands(xmlPath)
htmlFileName:=RegExReplace(SubStr(SRxml.getText("/MammoSR/StudyDateTime"),1,10),"\W","") " " SRxml.getText("/MammoSR/ChartNo") ".html"
Loop {
	Sleep 100
}until FileExist(ReportDir htmlFileName) || A_Index>50
if FileExist(ReportDir htmlFileName) && !saveNoOpend {
	if ChromePath:=getChromePath() {
		;~ run % """" A_ScriptDir "\GoogleChromePortable\App\Chrome-bin\chrome.exe"" """ ReportDir htmlFileName """"
		;~ run, %  commands(A_ScriptDir "\GoogleChromePortable\App\Chrome-bin\chrome.exe", ReportDir htmlFileName),,UseErrorLevel 
		run, %  commands(ChromePath, ReportDir htmlFileName),,UseErrorLevel 
		if (!ErrorLevel)
			WinWaitActive,ahk_exe chrome.exe,,5
	}else{
		MsgBox % "Can't find Google Chrome. Preview with default browser."
		run % commands(ReportDir htmlFileName)
	}
}
return 

savesend:
GuiControlGet,currentAssessment,1:,Assessment
RegExMatch(currentAssessment, "is)^([^\)])[^\)]?", match)
if !(match=2 || match=1){
	MsgBox, 68, , % "Save without preview and send ?"
	IfMsgBox,No
		return
}
saveNoOpen:=1
gosub save
gosub send
saveNoOpen:=0
return

send:
if (saveNoOpen)
	goto doSend

MsgBox, 8516, Send,% "Send the HTML file to server?"
IfMsgBox,Yes
	gosub doSend
return

doSend:
{
	;~ htmlFileName:=RegExReplace(SubStr(SRxml.getText("/MammoSR/StudyDateTime"),1,10),"\W","") " " SRxml.getText("/MammoSR/ChartNo") ".html"
	;~ if FileExist(ReportDir htmlFileName)
		;~ run % """" A_ScriptDir "\MammoSRsend.exe"" """ ReportDir htmlFileName """"
	;~ else
		;~ MsgBox % "Not found: `n" ReportDir htmlFileName
	
	;~ winwait,ahk_exe MammoSRPrintClient.exe,Successfully sent,6
	;~ if (!ErrorLevel){
		winactivate,% "ahk_id " RisState[2]
		if (getRisStudyState(RisState[2])="已發報告"){
			MsgBox, 4148, 此報告已發送, 再次確認發送報告？, 10
			IfMsgBox,Yes
			{
				risSendReport(RisState[2], 3)
				gosub goReportList
			}
			

		}else{
			risSendReport(RisState[2], 3)
			gosub goReportList
		}
		winactivate,% "ahk_id " RisState[2]
		if(simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI")){
			controlget,SciEditHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
			SendMessage,0x2023,1000,1,,simple RIS ahk_class AutoHotkeyGUI
			Edit_SetText(SciEditHwnd, "")
		}

	;~ }
}

return

goReportList:
if (!ControlExist(tabsHwnd))
	tabsHwnd:=getNetControl2(RisOpened()[2],"","B_ACTIVE","","WindowsForms10.BUTTON")[2]
	,tabsAcc:=acc_ObjectFromWindow(tabsHwnd)
tabsAcc.accDoDefaultAction()
MouseMove,% Floor(A_ScreenWidth/2),% Floor(A_ScreenHeight/2),0
return

printAll:
savedHTML:=[], savedHTMLcount:=0
Loop,files,% ReportDir "*.html"
	savedHTML.push(A_LoopFileName)
	,savedHTMLcount++
MsgBox,4,Print All,% "Print " savedHTMLcount " reports?"
IfMsgBox,Yes
	run,% runAhkExe("..\MammoSRPrintClient.exe") commands(serverIp, serverPort, "print" radiologist, savedHTML), % ReportDir

;~ radiologist:=getRisLoginName(RisState[2])
;~ MsgBox, 8516, Print Report,% "Print all saved report by " radiologist "?"
;~ IfMsgBox,Yes
	;~ run % """" A_ScriptDir "\MammoSRPrintClient.exe"" " serverIp " " serverPort " ""print" radiologist """"
return
listRemote:
radiologist:=getRisLoginName(RisState[2])
;~ run % """" A_ScriptDir "\MammoSRPrintClient.exe"" " serverIp " " serverPort " ""list" radiologist """"
run % runAhkExe("MammoSRPrintClient.exe") commands(serverIp, serverPort, "list" radiologist)
return

xmlInit:
try
	SRxml:=new xml("<MammoSR/>")
catch err
	MsgBox,16,Parse Error,% err.what

SRxml.AddElement("Patient", "/MammoSR", "")
SRxml.AddElement("Name", "/MammoSR/Patient", "")
SRxml.AddElement("Gender", "/MammoSR/Patient", "")
SRxml.AddElement("Age", "/MammoSR/Patient", "")
SRxml.AddElement("PersonId", "/MammoSR/Patient", "")
SRxml.AddElement("Birthday", "/MammoSR/Patient", "")

SRxml.AddElement("ReportVS", "/MammoSR", "")
SRxml.AddElement("Technician", "/MammoSR", "")

SRxml.AddElement("ChartNo", "/MammoSR", "")
SRxml.AddElement("AccNo", "/MammoSR", "")
SRxml.AddElement("StudyDateTime", "/MammoSR", "")
SRxml.AddElement("Report", "/MammoSR")
SRxml.AddElement("Findings", "/MammoSR/Report")
SRxml.AddElement("Modality", "/MammoSR/Report", "")

;~ SRxml.AddElement("Masses", "/MammoSR/Report/Findings")
;~ SRxml.AddElement("Calcifications", "/MammoSR/Report/Findings")
;~ SRxml.AddElement("Asymmetries", "/MammoSR/Report/Findings")
;~ SRxml.AddElement("ArchitecturalDistortions", "/MammoSR/Report/Findings")
SRxml.AddElement("Indication", "/MammoSR/Report", "")
SRxml.AddElement("Comparison", "/MammoSR/Report", "")
SRxml.AddElement("Density", "/MammoSR/Report", "")
SRxml.AddElement("Assessment", "/MammoSR/Report", "")
SRxml.AddElement("ReportDate", "/MammoSR/Report", "")
SRxml.AddElement("FullText", "/MammoSR/Report", "")
;~ SRxml.transformXml()
;~ SRxml.viewXml()
xmlSaveState:=[]
,xmlSaveStateInd:=-1
,xmlSaveState()
SetTimer, getExamInfo,-1
return

deleteLast:
if (xmlSaveStateInd<1){
	MsgBox % "Can't delete last finding!"
	return
}else{
	SRxml:=new XML(xmlSaveState[--xmlSaveStateInd])
}
ControlSetText,,% RegExReplace(ControlGetText(EditHwnd), "\" bullet "[^\r\n]+\r?\n?$", ""),% "ahk_id " EditHwnd
return

xmlSaveState(){
	global xmlSaveState, xmlSaveStateInd, SRxml, ReportDir
	SRxml.save(xmlFile:=ReportDir A_TickCount "_temp.xml")
	fileread,tmp,% xmlFile
	xmlSaveState[++xmlSaveStateInd]:=tmp
	FileDelete,% xmlFile
}


findingsButton:
gosub alertNoAccNo
WinGetPos,x2,y2,,,ahk_id %guihwnd2%
gui,2:Destroy
gui,2:+Owner1 +OwnDialogs +hwndguiHwnd2
gui,2:Default
gui,Font,s10,Verdana
gosub % RegExReplace(a_guicontrol, " ", "")
return

Calcification:
gui,Add,Text,,Distribution
gui,Add,Checkbox,vdistribution1,Grouped
gui,Add,Checkbox,vdistribution2 x+10,Regional
gui,Add,Checkbox,vdistribution3 x+10,Segmental
gui,Add,Checkbox,vdistribution4 x+10,Diffuse

gui,Add,Text,xs,Morphology
gui,Add,Checkbox,vmorphology1,Amorphous
gui,Add,Checkbox,vmorphology2 x+10,Coarse heterogeneous
gui,Add,Checkbox,vmorphology3 x+10,Fine pleomorphic
gui,Add,Checkbox,vmorphology4 x+10,Fine linear
gui,Add,Checkbox,vmorphology5 x+10,Fine linear branching

gui,add,ComboBox,vcaltype xm,% "microcalcifications||calcifications"

gosub templateLocationOther

gui,Add,button,gsaveCal xs Default,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,% "AutoSize " (x2?"x" x2 " y" y2:""),% findingType:=RegExReplace(A_ThisLabel," ","")
return

saveCal:
gui,2:Submit
str:=
SRxml.AddElement(saveType:="Calcification", "/MammoSR/Report/Findings")
SRxml.AddElement("Distribution", "/MammoSR/Report/Findings/" saveType "[last()]", d:=getCheckboxValues("Distribution"))
if(d!="")
	Loop,Parse,d,`,
		if !(A_LoopField="")
			str.=Lowercase(A_LoopField) "/"
if(str!="")
	str:=SubStr(str,1,-1) " "
SRxml.AddElement("Morphology", "/MammoSR/Report/Findings/" saveType "[last()]", d:=getCheckboxValues("Morphology"))
if(d!="")
	Loop,Parse,d,`,
		if !(A_LoopField="")
			str.=Lowercase(A_LoopField) "/"
if(str!="")
	str:=SubStr(str,1,-1) " " 
	
;~ InStr(str,"coarse")?"calcifications[last()]":"microcalcifications") " "
SRxml.AddElement("CalDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(caltype))
str.=Trim(caltype) " "

SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
str.="at " getLocationText() ". "

SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
suggestionUpdate(suggestion)
xmlSaveState()
return




Mass:
gui,Add,Text,,Size
gui,Add,Edit,vsize r1 w50,
gui,Add,Text,x+5,cm

gui,add,ComboBox,vmass x+10,% "mass||nodule"

gui,Add,Text,xs,Shape
gui,Add,Checkbox,vshape1,Oval
gui,Add,Checkbox,vshape2 x+10,Round
gui,Add,Checkbox,vshape3 x+10,Irregular
gui,Add,Checkbox,vshape4 x+10,Lobular

gui,Add,Text,xs,Margin
gui,Add,Checkbox,vmargin1,Circumscribed
gui,Add,Checkbox,vmargin2 x+10,Obscured
gui,Add,Checkbox,vmargin3 x+10,Microlobulated
gui,Add,Checkbox,vmargin4 x+10,Indistinct
gui,Add,Checkbox,vmargin5 x+10,Spiculated

gui,Add,Text,xs,Density
gui,Add,Checkbox,vdensity1,High
gui,Add,Checkbox,vdensity2 x+10,Iso
gui,Add,Checkbox,vdensity3 x+10,Low
gui,Add,Checkbox,vdensity4 x+10,Fat

gosub templateLocationOther

gui,Add,button,gsaveMass xs,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,AutoSize,% findingType:=A_ThisLabel
return


templateLocationOther:
gui,Add,Text,xs,Location
gui,Add,DropDownList,vlocation1 w100,Left|Right|Bilateral
gui,Add,DropDownList,vlocation2 w100 x+10,% "Upper||Lower|Central| "
gui,Add,DropDownList,vlocation3 w100 x+10,% "Outer||Inner|Central| "
gui,Add,Checkbox,vlocation4 x+10,Subareolar
gui,Add,Checkbox,vlocation5 x+10,Axillary tail

gui,add,Text,xs,Other Description
gui,add,Edit,vdescription w600 h100,

gui,add,Text,xs,Change
gui,add,ComboBox,vchange w200,% "Stable|Larger|Smaller"

gui,add,Text,xs,Suggestion
gui,add,ComboBox,vsuggestion w400,% "1) Suggest ultrasound correlation|2) Suggest spot magnified view correlation|3) Suggest tomosynthesis correlation|4) Suggest 6-month follow up|5) Suggest tissue proof|6) Highly suggestive of malignancy"


return

saveMass:
gui,2:Submit
str:=(Mass="masses"||Mass="nodes")?"There are ":"A "
SRxml.AddElement(saveType:="Mass", "/MammoSR/Report/Findings")
SRxml.AddElement("Size", "/MammoSR/Report/Findings/" saveType "[last()]", Size)
SRxml.AddElement("Shape", "/MammoSR/Report/Findings/" saveType "[last()]", d:=getCheckboxValues("Shape"))
if(Size!="")
	str.=Size "cm "
else if RegExMatch(d, "i)^[aeiou]") && !(Mass="masses"||Mass="nodes")
	str:="An "
if(d!=""){
	Loop,Parse,d,`,
		if !(A_LoopField="")
			str.=Lowercase(A_LoopField) "/"
	str:=SubStr(str,1,-1) " "
}
SRxml.AddElement("Density", "/MammoSR/Report/Findings/" saveType "[last()]", d:=getCheckboxValues("density"))
if(d!="")
	str.=Lowercase(RegExReplace(d,",","")) "-density "
SRxml.AddElement("Type", "/MammoSR/Report/Findings/" saveType "[last()]", Mass)
str.=(Trim(Mass)?Trim(Mass)" ":"mass ")
SRxml.AddElement("Margin", "/MammoSR/Report/Findings/" saveType "[last()]", d:=getCheckboxValues("Margin"))
if(d!=""){
	str.="with "
	Loop,Parse,d,`,
		if !(A_LoopField="")
			str.=Lowercase(A_LoopField) "/"
	str:=SubStr(str,1,-1) " margin "
}
SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
str.="at " getLocationText() ". "
SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
suggestionUpdate(suggestion)
xmlSaveState()
return

Asymmetry:
gui,Add,Text,,Type
gui,Add,DropDownList,vasymmetry,% "Asymmetry|Focal asymmetry||Global asymmetry|Developing asymmetry"

gosub templateLocationOther

gui,Add,button,gsaveAsy xs,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,AutoSize,% findingType:=A_ThisLabel
return

saveAsy:
gui,2:Submit
SRxml.AddElement(saveType:="Asymmetry", "/MammoSR/Report/Findings")
SRxml.AddElement("Type", "/MammoSR/Report/Findings/" saveType "[last()]", Asymmetry)
str:=Asymmetry " "
SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
str.="at " getLocationText() ". "
SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
suggestionUpdate(suggestion)
xmlSaveState()
return

ArchitecturalDistortion:
gui,add,Text,,
gosub templateLocationOther

gui,Add,button,gsaveAD xs,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,AutoSize,% findingType:=A_ThisLabel
return

saveAD:
gui,2:Submit
SRxml.AddElement(saveType:="ArchitecturalDistortion", "/MammoSR/Report/Findings")
str:="Architectural distortion "
SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
str.="at " getLocationText() ". "
SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
suggestionUpdate(suggestion)
xmlSaveState()
return

Other:
gui,Add,Text,,Other Findings
gui,add,ComboBox,vother w600,% "1) Enlarged axillary lymph node(s)|2) Nipple retraction|3) Skin thickening|4) Skin retraction|5) Dense axillary lymph node(s)|6) Dilated lactiferous ducts"

gosub templateLocationOther

;~ gui,Add,Checkbox,vnipple1,Thickening or retraction of the skin and/or nipple
;~ gui,Add,Checkbox,vaxillary1 y+10,Dense or enlarged axillary lymph nodes
;~ gui,Add,DropDownList,vaxillary2,Left|Right|Bilateral
;~ gui,Add,Checkbox,vduct1 y+10,Dilated lactiferous ducts
;~ gui,Add,DropDownList,vduct2,Left|Right|Bilateral
;~ gui,Add,Checkbox,vskin1,Diffuse thickening of the skin and increased density
;~ gui,Add,DropDownList,vskin2,Left|Right|Bilateral

gui,Add,button,gsaveOther xs,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,AutoSize,% findingType:=A_ThisLabel
return

saveOther:
gui,2:Submit
SRxml.AddElement(saveType:="Other", "/MammoSR/Report/Findings")
,SRxml.AddElement("Description", "/MammoSR/Report/Findings/" saveType "[last()]", d:=removeNumbering(Other))
,str:=d " "
,SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
,str.="at " getLocationText() ". "
,SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
,str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
,SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
,suggestionUpdate(suggestion)
,xmlSaveState()
return

OP:
gui,Add,Text,,Post-OP Change
gui,add,ComboBox,vopchange w600,% "Focal parenchymal loss, architectural distortion and skin retraction are noted at ___ under the wire, compatible with post-operative change.||"

gosub templateLocationOther

gui,Add,button,gsaveOp xs,Save
gui,Add,button,gcancel x+10,Cancel
gui,Show,AutoSize,% findingType:=A_ThisLabel
return

saveOp:
gui,2:Submit
SRxml.AddElement(saveType:="OP", "/MammoSR/Report/Findings")
,SRxml.AddElement("Description", "/MammoSR/Report/Findings/" saveType "[last()]", d:=removeNumbering(OPchange))
,str:=d " "
,SRxml.AddElement("Location", "/MammoSR/Report/Findings/" saveType "[last()]", getLocationValue())
,str:=RegExReplace(str, "i)at ___", "at " getLocationText())
,SRxml.AddElement("OtherDescription", "/MammoSR/Report/Findings/" saveType "[last()]", Trim(Description))
,str:=StringUpperFirst(str) StringUpperFirst(Trim(Description))
,SRxml.AddElement("Change", "/MammoSR/Report/Findings/" saveType "[last()]", Change)
if(Change!="")
	str.=StringUpperFirst(Change) ". "
SRxml.AddElement("Suggestion", "/MammoSR/Report/Findings/" saveType "[last()]", removeNumbering(suggestion))
if(suggestion!="")
	str.=StringUpperFirst(removeNumbering(suggestion)) ". "
ControlSetText,,% AllStr:=RegExReplace(ControlGetText(EditHwnd), "\r?\n" bullet "(\r?\n)|\r?\n" bullet "$", "`r`n") bullet str "`r`n",% "ahk_id " EditHwnd
Edit_SetSel(EditHwnd, -1, -1)
;~ SRxml.transformXml()
;~ SRxml.viewXml()
,suggestionUpdate(suggestion)
,xmlSaveState()
return

Cancel:
2guiclose:
gui,2:Destroy
return

;~ ControlGetText(hwnd){
	;~ ControlGetText,str,,ahk_id %hwnd%
	;~ return str
;~ }



GuiClose:
ExitApp
return

~^w::
;~ ExitApp
if WinActive("ahk_id " guihwnd2)
	gui,2:Destroy
return

varExist(ByRef v) { ; Requires 1.0.46+
   return &v = &n ? 0 : v = "" ? 2 : 1 
}

getCheckboxValue(var){
	global
	local s
	GuiControlGet,s,,%var%,Text
	return s
}

getCheckboxValues(prefix){
	global
	local str:="",s,var
	Loop {
		var:=prefix A_Index
		if !varExist(%var%)
			break
		if(%var%)=1
			str.=getCheckboxValue(var) ","
	}
	return RegExReplace(str,"\,+$","")
}
getLocationValue(){
	global 
	local s,str:=""
	
	str.=((s:=SubStr(Location1,1,1))?s:"") ","
	
	if(location4)
		str.="subareolar"
	else if(location5)
		str.="AT"
	else 
		str.=((s:=SubStr(Location2,1,1))?s:"") "," ((s:=SubStr(Location3,1,1))?s:"") 
	
	return str
}
getLocationText(){
	global 
	local s,str:=""
	str.=Lowercase(Location1) " "
	
	if(location4)
		str.="subareolar region"
	else if(location5)
		str.="axillary tail"
	else{ 
		if RegExMatch(Location2,"i)upper|lower") && RegExMatch(Location3,"i)outer|inner")
			str.=SubStr(Location2,1,1) SubStr(Location3,1,1) "Q breast"
		else {
			str.=Lowercase(Location2) " " Lowercase(Location3) " breast"
			str:=RegExReplace(str,"i)central central","central")
			str:=RegExReplace(str,"  +"," ")
		}
	}
	
	
	return str
}
removeNumbering(str){
	return RegExReplace(str, "^\d+[a-z]?\) ", "")
}
Lowercase(str){
	StringLower,str,str
	return str
}
StringUpperFirst(str){
	
	a:=SubStr(str,1,1)
	b:=SubStr(str,2)
	stringupper,a,a
	return a b
}

alertNoAccNo:
if(thisAccNo=""){
	MsgBox,
	(Ltrim
	無法取得檢查單號，請確定RIS已開啟報告撰打作業，並顯示以下欄位：照會單號、病歷號、姓名、性別、年齡
	或者重新開啟RIS
	)
}
return

OpenStudy:
RisHwnd:=RisState[2]
,risOpenStudyImpax(RisHwnd)
,RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(RisHwnd))
,priorDate:="",count:=0,prior:=""
,thisAccNo:=getRisAccNo(RisHwnd)
,ExamItems:=parseRisExamItems(getRisExamItems(RisHwnd))
if(thisAccNo="")
	goto alertNoAccNo

for k,exam in ExamItems[1]
	if InStr(exam, "Tomo") {
		guicontrol,,modality,Tomo
		break
	}

if !impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe") {
	if !(impaxContextServerPath:=getImpaxContextServerPath()) {
		MsgBox % "ImpaxContextServer.exe not found!"
	}else{
		impaxContextServerRunByMammoSR:=true
		run % impaxContextServerPath
		winwait,ahk_exe ImpaxContextServer.exe,,5
		Sleep 500
	}
}
	
    ;~ for k,v in rows:=acc_children(RisHistoryAcc) 
        ;~ if regexmatch(acc_children(v)[4].accValue,"is)Mammogra|乳房|LOCALIZATION- BREAST|Medio-lateral oblique|Mammotome|Stereotic|tomosynthesis") {
            ;~ priorDate.=acc_children(v)[2].accValue ", "
            ;~ if !prior
                ;~ prior:=v
            ;~ if (++count<=6) {
                ;~ v.accSelect(ComObj(3,3),0)
                ;~ sleep 200
                ;~ loc:=Acc_Location(v)
                ;~ mouseclick,r,% loc.x+50,% loc.y+5,1,0
                ;~ sleep 200
                ;~ mouseclick,l,10,10,1,0,,R
            ;~ }else{
                ;~ break
            ;~ }
        ;~ }
;~ }else{
sendStr:="",oldStudyList:=""
for k,v in rows:=acc_children(RisHistoryAcc) {
	;~ ToolTip % acc_children(v)[examNameColl].accValue 
	if(k=1){
		for x,y in cells:=acc_children(v) {
			if (y.accValue="照會單號"){
				AccNoCol:=x
			}
			if (y.accValue="檢查名稱"){
				examNameColl:=x
			}
			if (y.accValue="檢查日"){
				StudyDateCol:=x
			}
		}
	}else if regexmatch(acc_children(v)[examNameColl].accValue,"is)Mammogra|乳房|LOCALIZATION- BREAST|Medio-lateral oblique|Mammotome|Stereotic|tomosynthesis") {
		if (++Count>6)
			break
		thisDate:=acc_children(v)[StudyDateCol].accValue
		if RegExReplace(thisDate,"\D","")<SubStr(a_now,1,8)-70000 && Count>1
			break
		
		oldStudyList.=thisDate
			
		if instr(examName,"LOCALIZATION- BREAST")
			oldStudyList.= " (needle localization)"
		else if instr(examName,"Mammotome") || instr(examName,"Stereotic")
			oldStudyList.= " (stereotactic biopsy)"
		else if instr(examName,"tomosynthesis")
			oldStudyList.= " (tomosynthesis)"
		else if instr(examName,"Medio-lateral oblique")
			oldStudyList.= " (MLO)"
		oldStudyList.=", "
		
		sendStr.="ADD_TO_DISPLAY_LIST || " Trim(acc_children(v)[AccNoCol].accValue) " || "
		
		if (!prior){
			prior:=v
			prior.accSelect(ComObj(3,3),0)
			Sleep 500
			lastImp:=ControlGetText(getRisReports(RisHwnd)[2,2])
			if(lastImp ~= "i)BI\W?RADS *(Category)? *[12]")
				break
		}
		
	}
}

oldStudyList:=SubStr(oldStudyList,1,-2)
sendStr.="SYNC_DISPLAY || " thisAccNo " || "
if(Count=0)
	sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " thisAccNo " || "
Sleep 1000
cmdContextServer(sendStr, impaxContextServerHwnd)

;~ }
    
if(prior){
	;~ prior.accSelect(ComObj(3,3),0)
	oldReportText:=ControlGetText(getRisReports(RisHwnd)[2,1])
	if RegExMatch(oldReportText, "i)family history of breast cancer *\([\w ]+\)", m)
		guicontrol,Text,Indication,% m
	else if InStr(oldReportText,"mastectomy"){
		Loop,parse,oldReportText,`n,`r
		{
			firstLine:=A_LoopField
			break
		}
		if InStr(firstLine, "bilateral")
			guicontrol,Text,Indication,% "breast cancer status post bilateral mastectomy"
		else if InStr(firstLine, "right")
			guicontrol,Text,Indication,% "breast cancer status post right mastectomy"
		else if InStr(firstLine, "left")
			guicontrol,Text,Indication,% "breast cancer status post left mastectomy"
	}
	
}else{
	guicontrol,choose,Comparison,3
}
settimer,updateSimpleRISoldHx,-500
;~ if (simpleRis:=WinExist("simple RIS ahk_class AutoHotkeyGUI")){
    ;~ winactivate,% "ahk_id " simpleRis
    ;~ ControlFocus,Scintilla1,ahk_id %simpleRIS%
;~ }else{
    ;~ send {f6}
;~ }
winactivate,ahk_id %guiHwnd%
return

updateSimpleRISoldHx:
PostMessage,0x1124,1,0,,simple RIS ahk_class AutoHotkeyGUI
return

cmdContextServer(str,hwnd=""){
	DetectHiddenWindows,on
	if !hwnd && !hwnd:=winexist("ahk_exe ImpaxContextServer.exe")
		return 1
	Send_WM_COPYDATA(hwnd, 0, str)
}

OnExit:
SRxml:=xmlSaveState:=""
Loop % ReportDir "*_temp.xml"
	FileDelete,% A_LoopFileFullPath
if (impaxContextServerRunByMammoSR)
	WinClose,ahk_exe ImpaxContextServer.exe
;~ for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where name like 'MammoSR%.exe'")
	;~ if (process.ProcessId!=DllCall("GetCurrentProcessId"))
		;~ WinClose,% "ahk_pid " process.ProcessId
ExitApp
return


createNewPage(ByRef dom, lesionInd){

	suffix:="_" lesionInd
	newLesion:=dom.createElement("DIV")
	,newLesion.id:="positiveFindingPage" suffix
	
	innerHTML:=dom.getElementById("positiveFindingPage").innerHTML
	newHTML:="", i:=0, ind:=1
	while i:=RegExMatch(innerHTML,"i)\bname=(""?)([^ "">]+)(""?)", match, ind) {
		if RegExMatch(match2, "i)^(chartno|ptname|f?id|brth|examDate|resultcb|resultsubcb|hospital|radiologist)")
			newHTML.=SubStr(innerHTML, ind, i-ind) match
		else
			newHTML.=SubStr(innerHTML, ind, i-ind) "name=" match1 match2 suffix match3
		ind:=i+StrLen(match)
	}
	newHTML.=SubStr(innerHTML,ind)
	newLesion.innerHTML:=newHTML
	
	dom.getElementById("positiveFindingPage").parentNode.insertBefore(newLesion, dom.getElementById("saveHint"))
	
	
}

saveNewHtml:
if WinActive("ahk_exe chrome.exe") && RegExMatch(activeUrl:=GetActiveBrowserURL(), "is)^(file:\/\/\/)?(.+?\d{8}(?: |\%20)\w{6}\d\.html)\?(.+)$", activeHtmlMatch) {
	activeBrowserHwnd:=WinExist("A")
	MsgBox, 8260, Save Report, Save changes to the form?, 10
	IfMsgBox, Yes 
	{
		fileread,beforeHtml,% activeHtmlPath:=RegExReplace(activeHtmlMatch2, "\%20", " ")
		tmpDom:=ComObjCreate("HtmlFile")
		,tmpDom.write(beforeHtml)
		
		if RegExMatch(activeUrl, "lesionCount=([^&]+)", match) {
			;~ MsgBox % match1
			lesionInd:=0
			Loop {
				if (++lesionInd)>match1
					break
				if tmpDom.getElementById("positiveFindingPage_" lesionInd).id
					continue
				createNewPage(tmpDom, lesionInd)
			}
		}
		
		Loop % (cb:=tmpDom.getElementsByTagName("input")).length 
			if ((ele:=cb[A_Index-1]).Type="checkbox")
				ele.checked:=""
		
		Loop,Parse,activeHtmlMatch3,&
		{
			RegExMatch(A_LoopField, "is)^([^\=]+)\=(.+?)$", cbkvpair)
			Loop % (cb:=tmpDom.getElementsByTagName("input")).length 
				if ((ele:=cb[A_Index-1]).Type="checkbox" && ele.Name=cbkvpair1 && cbkvpair2="1")
					ele.checked:="checked"
		}
		FileDelete,% activeHtmlPath
		FileAppend,% tmpDom.documentElement.innerHTML,% activeHtmlPath, utf-8
		winactivate,% "ahk_id " activeBrowserHwnd
		send !d
		clipboard:="file:///" activeHtmlPath
		Sleep 200
		send ^v
		send {Enter}
	}
}
SetTimer,saveNewHtml,-500
return

updateAssessment(birads){
	global
	if (birads="1")
		return
	local currentAssessment, match
	
	birads1:=SubStr(birads,1,1)+0
	
	GuiControlGet,currentAssessment,1:,Assessment
	RegExMatch(currentAssessment, "is)^([^\)])[^\)]?", match)
	match+=0
	if (birads1=2 && match=1)
		guicontrol,1:choose,Assessment,4
	else if (birads1=3) && (match=1 || match=2)
		guicontrol,1:choose,Assessment,5
	else if (birads1=0) && (match<=3)
		guicontrol,1:choose,Assessment,% birads="0u"?1:2
	else if (birads1>3 && match<birads1)
		guicontrol,1:choose,Assessment,% birads="4"?6:birads="4a"?7:birads="4b"?8:birads="4c"?9:(birads1+5)
}


suggestionUpdate(suggestion){
	if(suggestion="")
		return
	RegExMatch(suggestion, "^\d+", match)
	static arr:=["0u", "0m", "0m", "3", "4", "5"]
	updateAssessment(arr[match])
}

getChromePath(){
	RegRead,r,HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe,Path
	if FileExist(path:=r "\chrome.exe")
		return path 
	
	if FileExist(path:=A_ProgramFiles "\Google\Chrome\Application\chrome.exe")
		return path
	
	Loop % a_desktop "\*.lnk" {
		if InStr(A_LoopFileName, "chrome"){
			FileGetShortcut,% A_LoopFileFullPath,target
			if InStr(target,".exe")
				return target
		}
	}
	
	Loop, % A_MyDocuments "\*",2 
	{
		if InStr(A_LoopFileName, "chrome"){
			Loop,% A_LoopFileFullPath "\*",1,1
				if InStr(A_LoopFileName,"chrome") && InStr(A_LoopFileName,".exe")
					return A_LoopFileFullPath
		}
	}
	
	Loop, % A_ScriptDir "\*",2 
	{
		if InStr(A_LoopFileName, "chrome"){
			Loop,% A_LoopFileFullPath "\*",1,1
				if InStr(A_LoopFileName,"chrome") && InStr(A_LoopFileName,".exe")
					return A_LoopFileFullPath
		}
	}
	return ""
}