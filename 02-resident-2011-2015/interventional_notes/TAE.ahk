﻿/*date not work !!
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

#include ../portalLib/portalLib.ahk

gui,font,s10,Verdana
gui,add,text,,Portal ID
gui,add,edit,xp+100 vloginId w100,006584
gui,add,text,xs,Portal PW
gui,add,edit,xp+100 vloginPw w100,pcliang3
gui,add,text,xs,Date
gui,add,datetime,xp+100 vorderDate w100
gui,add,text,xs,Chart No.
gui,add,edit,r3 xp+100 vchartNo w100,4______
gui,add,button,xs,GO


gui,show,,Doxorubicin Order

return

buttonGO:
gui,submit
if !checkSid(sid)
	if !sid:=login(loginId,loginPw){
		msgbox Error: can't login portal
		return
	}
if !RegExMatch(chartNo,"(\w)\w{5}\d"){
	msgbox Error: enter correct chart number
	return
}
gui,hide


errorMsg:=""
settimer,routine,200


chartNoArr:=[]
i=0
while i:=regexmatch(chartNo,"(\w)\w{5}\d",match,i+1)
	chartNoArr.push(match)

loop % chartNoArr.maxIndex() {
	chartNo:=chartNoArr[a_index]
	settimer,orderDoxo,-1
	sleep 200
}

gui,show
return


orderDoxo:
orderDoxo(sid,chartNo,orderDate)
return

logErr(str){
	FileAppend,% a_now "-" str,TAE.log,UTF-8
}

orderDoxo(sid,chartNo,orderDate){
	
	ComObjError(false)
	pwb:=ComObjCreate("InternetExplorer.Application")
	if !pwb{
		logErr(chartNo " Error: can't open IE")
		return
	}
	
	pwb.Navigate("http://ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx?SESSION=" sid) ;ward
	if !waitLoaded(pwb,func("func1")){
		logErr(chartNo " Time out: connect to ward")
		return
	}

	pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_tbxChartNoInput").value:=chartNo
	pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_QueryAccountByPatientInput").click()
	if !waitLoaded(pwb,func("func2"),30,1500){
		logErr(chartNo " Time out: search patient by chart no.")
		return
	}

	if ! pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").checked="checked"
		pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn").click()
	if !waitLoaded(pwb,func("func2"),30,1500){
		logErr(chartNo " Time out: show doctor column for ward page")
		return
	}

	if !pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList").innerText {
		logErr(chartNo " Error: patient not found")
		return
	}

	RegExMatch(pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkMedication").outerHTML,"i)window.open\('([^']+)",match)
	;~ RegExMatch(pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl02_LinkConfirmDiagnosisOrder").outerHTML,"i)window.open\('([^']+)",mainHref)
	pwb.Navigate(medHref:=RegExReplace(match1,"&amp;","&"))
	if !waitLoaded(pwb,func("func3")){
		logErr(chartNo " Time out: show medication order page")
		return
	}

	pwb.document.getElementById("NWeb1_OrderEntryCommonSelectionBox_lnbMedicationChem").click()
	if !waitLoaded(pwb,func("func4")){
		logErr(chartNo " Time out: show chemotherapy order page")
		return
	}



	pwb.document.getElementById("NWeb1_OrderEntryCommonSelectionBox_txbKeywordInput").value:="TAE-ADM"
	pwb.document.getElementById("NWeb1_OrderEntryCommonSelectionBox_btnKeywordQuery").click()
	if !waitLoaded(pwb,func("func4")){
		logErr(chartNo " Time out: search ""TAE-ADM"" in chemothearpy order page")
		return
	}
	;~ test:=medOrderList(pwb)
	if !(medOrderId:=medOrderList(pwb)["Doxorubicin HCl(TAE)"]["id"]){
		logErr(chartNo " Can not find ""Doxorubicin HCl(TAE)"" in chemothearpy order page")
		return
	}

	pwb.document.getElementById(medOrderId).click()
	if !waitLoaded(pwb,func("func5")){
		logErr(chartNo " Time out: click ""Doxorubicin HCl(TAE)"" in chemothearpy order page")
		return
	}


	pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_txbDose").value:=40
	pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_txbRepeatPattern").value:="ONCE"
	pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_txbRepeatPattern").onchange()
	if ! waitLoaded(pwb,func("func4")){
		return
	}
	
	stringleft,orderDate,orderDate,8
	pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_ddlStartDateChar").value:=orderDate
	pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_ddlStartDateChar").onchange()
	
	;編輯結束
	pwb.document.getElementById("NWeb1_ChemoEditorBox_btnStore").click()
	if !waitLoaded(pwb,func("func4")){
		;~ logErr(chartNo " Time out: search ""TAE-ADM"" in chemothearpy order page")
		return
	}

	pwb.Navigate(RegExReplace(medHref,"MedicationV2.aspx\?","OrderConfirm.aspx?ManagerKey=__PageOrderConfirm&") "&PIN=")
	if !waitLoaded(pwb,func("func6")){
		;~ logErr(chartNo " Time out: search ""TAE-ADM"" in chemothearpy order page")
		return
	}
	
	pwb.document.getElementById("NWeb1_btnConfirm").click()
	pwb.visible:=true
	sleep 2000
	pwb.close()
}

gui,show
return

routine:
;~ ifwinexist,網頁訊息 ahk_class #32770
	;~ winclose
return

guiclose:
~esc::
exitapp
return

func1(byref pwb){
	return !pwb.busy && pwb.document.getElementById("NWeb1_QueryInPatientPersonAccountControl1_IDInputTextBox").value
}
func2(byref pwb){
	return !pwb.busy
}
func3(byref pwb){
	global chartNo
	return !pwb.busy && pwb.document.getElementById("NWeb1_OrderEntryCommonSelectionBox_txbKeywordInput").id
}
func4(byref pwb){
	return !pwb.busy && (pwb.document.getElementById("NWeb1_UpdateProgress1").style.display="none")
}
func5(byref pwb){
	return !pwb.busy && pwb.document.getElementById("NWeb1_UpdateProgress1").style.display="none" && pwb.document.getElementById("NWeb1_ChemoEditorBox_EditorInjBox_dgrOrderPlan_ctl02_txbDose").id
}
func6(byref pwb){
	global chartNo
	return !pwb.busy && pwb.document.getElementById("NWeb1_btnConfirm").id
}
