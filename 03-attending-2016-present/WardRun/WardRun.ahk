﻿#SingleInstance,force
SetBatchLines,-1
OnExit,OnExit

#include <RisImpax>
#include <IEGet>
ComObjError(false)

gosub init
HiddenWB:=[]
SetTimer,HideToBeConfirmed,500

return

init:
arr:=[]
arr["主"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkConfirmDiagnosisOrder"
arr["入"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkAdmissionNote"
arr["程"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkProgressNote"
arr["出"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkDisCharge"
arr["處"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkMedication"
arr["診"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkTreatOrder"
arr["食"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkDietOrder"
arr["血"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkBloodOrder"
arr["囑"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkQueryOrders"
arr["術"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkOperationNote"
arr["報"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkForthMedicalReport"
arr["Pacs"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkShowPACS"
arr["證"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkCertificate"
arr["照"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkNotifyWork"
arr["准"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkPermitDischarge"
arr["約"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkOPDAdministration"
arr["生"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkVitalSign"
arr["藥"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkDrugGiven"
arr["EMR"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkElectronicMedicalRecord"
arr["指"]:="NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkDrHealthEducation"

;~ title:=[]
;~ title.push("主")
;~ title.push("入")
;~ title.push("程")
;~ title.push("出")
;~ title.push("處")
;~ title.push("診")
;~ title.push("食")
;~ title.push("血")
;~ title.push("囑")
;~ title.push("術")
;~ title.push("報")
;~ title.push("Pacs")
;~ title.push("證")
;~ title.push("照")
;~ title.push("准")
;~ title.push("約")
;~ title.push("生")
;~ title.push("藥")
;~ title.push("EMR")
;~ title.push("指")

ini:=A_ScriptDir "\WardRun.ini"

IniRead,hk,% ini,Settings,Hotkey,#c
try
	Hotkey,% hk,copyAndRun
catch {
	MsgBox % "Hotkey was set: Win + C"
	Hotkey,% hk:=#c,copyAndRun
}
return

HideToBeConfirmed:
while toBeHidden:=WinExist("醫師待確認清單 ahk_exe iexplore.exe") {
	
	HiddenWB.push(toBeHidden)
	WinHide,ahk_id %toBeHidden%
}
	
return

copyAndRun:
;~ ~^c::
;~ if !(A_ThisHotkey=A_PriorHotkey && A_TimeSincePriorHotkey<500)
	;~ return
Sleep 100
send ^c
Sleep 400
clip:=clipboard
if !RegExMatch(clip,"\b\w{6}\d\b",chartNo)
	return
gosub searchInIE
gosub impaxEnterChartNo
return

searchInIE:
wb:=IEGet("病房首頁選擇病人","WebApplication/InPatient/Ward/OpenWard.aspx")
if !wb.hwnd
	return

Loop {
	if InStr(wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_PatChartNo").innerText,chartNo)
		break
	wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_tbxChartNoInput").value:=chartNo
	wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_QueryAccountByPatientInput").Click()
	Sleep 500
}

for k,v in arr {
	IniRead,val,% ini,Settings,% k,0
	if !val
		continue
	wb.document.getElementById(v).Click()
}

IniRead,ClickPatho,% ini,Settings,病理,0
if(ClickPatho)
	SetTimer,openPatho,-500
	


;~ wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkAdmissionNote").Click()
;~ wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkForthMedicalReport").Click()
;~ wb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkOperationNote").Click()

return

openPatho:
Loop 
	Sleep 500
until A_Index>20 || IEGet("報告查詢","WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx").hwnd
Sleep 3000
IEGet("報告查詢","WebApplication/ElectronicMedicalReportViewer/MedicalReportContent.aspx").Navigate("javascript:$('.groupHeader[reportgroup=病理]').click().next().click();")
return

impaxEnterChartNo:
IniRead,ifImpax,% ini,Settings,IMPAX,1
if !ifImpax
	return

ImpaxState:=impaxOpened()
if ImpaxState[1]!=2
	return
winactivate,% "ahk_id " id2:=ImpaxState[2,2]|ImpaxState[2,3]
bar:=ImpaxBar(id2)
wingetpos,,,,h,ahk_id %id2%
if !(bar.h>h-37)
	controlclick,,% "ahk_id " bar.hwnd
gosub selectChartNo
acc_objectfromwindow(impaxChartnoControl).accValue:=chartNo
controlsend,,{enter},% "ahk_id " impaxChartnoControl
return

selectChartNo:
for k,v in (impaxControls:=getcontrols(id2:=ImpaxState[2,2]|ImpaxState[2,3])){
	if k<2
		continue
	if instr(v.classNN,"WindowsForms10.EDIT.app") && ((impaxControls[k-1].text="病歷號碼" ) || (impaxControls[k-1].text="Patient ID")) {
		controlfocus,,% "ahk_id " impaxChartnoControl:=v.hwnd
		controlget,selectedText,Selected,,,% "ahk_id " impaxChartnoControl
		if !selectedText
			ControlClick,,% "ahk_id " impaxChartnoControl,,l,1
		break
	}
}
return

~!q::
OnExit:
for k,v in HiddenWB
	WinShow,ahk_id %v%
ExitApp
return