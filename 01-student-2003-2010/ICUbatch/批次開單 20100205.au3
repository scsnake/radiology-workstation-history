#include <IE.au3>
#include <GuiConstantsEx.au3>
#include <date.au3>
;~ #include <WindowsConstants.au3>
;~ #include <EditConstants.au3>
;~ #include <string.au3>
;~ #include <ButtonConstants.au3>
#include <Array.au3>


Opt("WinTitleMatchMode",2)
Opt ("ExpandEnvStrings", 1)
AutoItSetOption("MustDeclareVars",0)


global $this_gui = GUICreate("6PE ICU 批次開單",720,400)
GUISetFont(10,400,0,"Verdana")

global $room[16] = ["01","02","03","05","06","07","08","09","10","11","12","13","15","16","17","18"]
global $pt[16]
For $i=0 to 15 step 1
	$pt[$i] = GUICtrlCreateLabel($room[$i],0,40+20*$i)
Next

global $item_txt[15]
$item_txt[0] = GUICtrlCreateLabel("CXR",40,0)
$item_txt[1] = GUICtrlCreateLabel("BUN",80,0)
$item_txt[2] = GUICtrlCreateLabel("Cr",120,0)
$item_txt[3] = GUICtrlCreateLabel("T-Bil",160,0)
$item_txt[4] = GUICtrlCreateLabel("D-Bil",200,0)
$item_txt[5] = GUICtrlCreateLabel("AST",240,0)
$item_txt[6] = GUICtrlCreateLabel("ALT",280,0)
$item_txt[7] = GUICtrlCreateLabel("Mg",320,0)
$item_txt[8] = GUICtrlCreateLabel("CBC",360,0)
$item_txt[9] = GUICtrlCreateLabel("DC",400,0)
$item_txt[10] = GUICtrlCreateLabel("PT",440,0)
$item_txt[11] = GUICtrlCreateLabel("PTT",480,0)
$item_txt[12] = GUICtrlCreateLabel("CRP",520,0)
$item_txt[13] = GUICtrlCreateLabel("Alb",560,0)
$item_txt[14] = GUICtrlCreateLabel("others",600,0)



global $chk_all[14]
For $i=0 to 13 step 1
	$chk_all[$i] = GUICtrlCreateCheckbox("",40*$i+40,20,18,18)
Next

global $if_chkall[14]
For $i=0 to 13 step 1
	$if_chkall[$i] = 0
Next

global $inputbox[16]
For $i=0 to 15 step 1
	$inputbox[$i] = GUICtrlCreateInput("",600,20*$i+40,100,18)
Next

global $chkbox[16][14]
For $i=0 to 15 step 1
	for $j=0 to 13 step 1
		$chkbox[$i][$j] = GUICtrlCreateCheckbox("",40*$j+40,20*$i+40,18,18)
	Next
Next

global $button[2]
$button[0] = GUICtrlCreateButton("開工",640,360)
$button[1] = GUICtrlCreateButton("清空",560,360)


GUISetState(@SW_SHOW)





Func gogogo()
	Global $chk[16][14]
	For $i=0 to 15 step 1
		For $j=0 to 13 step 1
			If GUICtrlRead($chkbox[$i][$j])=1 Then
				$chk[$i][$j] = 1
			Else
				$chk[$i][$j] = 0
			EndIf
		Next
	Next
	
;	_ArrayDisplay($chk)
	
	Local $sum[16]
	For $i=0 to 15 step 1
		Local $temp = 0
		For $j=0 to 13 step 1
			$temp = $temp + $chk[$i][$j]
		Next
		$sum[$i] = $temp
	Next
	GUISetState(@SW_MINIMIZE,$this_gui)
	if_debug()
	
	Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
	Global $n
	For $n=0 to 15 step 1
		Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
		$pt_table = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList")
		$pt_arr = _IETableWriteToArray($pt_table)
		$pts = Ubound($pt_arr,2)-1
		Global $pt_room[$pts]
		For $i=0 to $pts-1 step 1
			$pt_room[$i] = Int($pt_arr[1][$i+1])
		Next
		Global $m = _ArraySearch($pt_room,Int($room[$n]),0,0,0,1,1)                ;病床->病房中的序號
		If ( $sum[$n]>0 and $m>=0 ) Then                ;有勾選項目的病床
;~			Local $date_changed=0
			Local $temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			If @error=0 Then $temp.quit
			$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
			If @error=0 then $temp.quit
			Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
			If $m<=7 Then 
				$TreatOrder = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl0" & ($m+2) & "_LinkTreatOrder");診療醫令
			Else
				$TreatOrder = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" & ($m+2) & "_LinkTreatOrder")
			EndIf
			$TreatOrder.click
			While 1
				sleep(500)
				$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")         ;診療醫令視窗
				If @error=0 Then
					Global $oIE2 = $temp
					ExitLoop
				EndIf
			WEnd
			sleep(500)
			_IELoadWait($oIE2,0,60000)
			load_wait()
			If $sum[$n]-$chk[$n][0]>0 Then  ;檢驗
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$lab_radio = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_rblOrderType_1")  ;點選檢驗
				If Not $lab_radio.checked Then
					_IEAction($lab_radio,"click")
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$lab1_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlMainCategory") ;點選緊急檢查室
				If Not ($lab1_select.value=17) Then
					_IEFormElementSetValue($lab1_select,17)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$lab2_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlSubCategory") ;最常用項目
				If Not ($lab2_select.value=1) Then
					_IEFormElementSetValue($lab2_select,1)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$date_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlPlanDate")   ;選明天的日期
				$sNewDate = _DateAdd('d',1, _NowCalcDate())
				If Not ($date_select.value=$sNewDate) Then
					_IEFormElementSetValue($date_select,$sNewDate)
					load_wait()
				EndIf	
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				check_lab($chk,$n)      ;勾選檢驗單
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$submit1 = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_btnSelect2")   ;暫存勾選醫令
				$submit1.click
				load_wait()
			EndIf
			If $chk[$n][0]>0 Then   ;影醫
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR_radio = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_rblOrderType_3")   ;點選影醫
				If Not $XR_radio.checked Then
					$XR_radio.click
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR1_radio = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_rblRadSubTypes_0")   ;None
				If Not $XR1_radio.checked Then
					$XR1_radio.click
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR2_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlMainCategory")   ;Plain Film
				If Not ($XR2_select.value=1) Then
					_IEFormElementSetValue($XR2_select,1)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR3_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlSubCategory")   ;Chest
				If Not ($XR3_select.value=2) Then
					_IEFormElementSetValue($XR2_select,2)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$date_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlPlanDate")   ;選明天的日期
				$sNewDate = _DateAdd( 'd',1, _NowCalcDate())
				If Not ($date_select.value=$sNewDate) Then
					_IEFormElementSetValue($date_select,$sNewDate)
					load_wait()
				EndIf	
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				check_XR($chk,$n)		;勾選X光單
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$submit1 = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_btnSelect2")   ;暫存勾選醫令
				$submit1.click
				load_wait()
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$bedside_chk = _IEGetObjById($oIE2,"NWeb1_EditTempOrders1_RadTempOrders1_lvwOrders_ctrl0_cbxIsBedSide")  ;勾portable
				$bedside_chk.click
			EndIf
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			$submit2 = _IEGetObjById($oIE2,"NWeb1_EditTempOrders1_btnConfirm")    ;確定帶入勾選醫令
			$submit2.click
			load_wait()
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			$back_main = _IEGetObjById($oIE2,"NWeb1_OrderEntryCommonSelection1_BackToOrigin")   ;回主畫面
            $back_main.click			
			While 1
				sleep(500)
				$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")        ;病人主畫面
				If @error=0 Then
					Global $oIE2 = $temp
					ExitLoop
				EndIf
			WEnd
			sleep(500)
			
			$oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL")     ;重整病房首頁
			$ward_search = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_QueryAccountNoByWardInput")
			$ward_search.click
			
			_IELoadWait($oIE2,0,60000)
;~ 			msgbox(0,"","")
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
			$Dr_confirm = _IEGetObjById($oIE2,"NWeb1_PageLinkAndPrintControl1_DRVSConfirm")   ;醫師確認
			$Dr_confirm.click
			While 1
				sleep(500)
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
				$temp = _IEGetObjById($oIE2,"NWeb1_PageLinkAndPrintControl1_DRVSConfirm")   ;處理中...
				If @error=0 Then
					If StringInStr(_IEBodyReadText($oIE2),"無法作醫師確認") then MsgBox(0,"","無法作醫師確認!!!")
					ExitLoop
				EndIf
			WEnd
			_IELoadWait($oIE2,0,60000)
		EndIf
	Next
	MsgBox(0,"批次開單","完工!!")
	WinSetState("6PE 批次開單","",@SW_RESTORE)
EndFunc


Func if_debug()
	if not ProcessExists("closeJS.exe") Then
		ShellExecute("closeJS.exe")
	EndIf
EndFunc

Func load_wait()
	sleep(1000)
	While 1
		$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
		Local $loading = _IEGetObjById($oIE2,"NWeb1_UpdateProgress1")
		If $loading.style.display = "none" Then
			ExitLoop
		EndIf
		sleep(200)
	WEnd
	sleep(200)
EndFunc

Func toggle_all($t)
	If $if_chkall[$t] = 0 Then
		For $i=0 to 15 step 1
			GUICtrlSetState($chkbox[$i][$t],$GUI_CHECKED)
		Next
		$if_chkall[$t] = 1
	Else
		For $i=0 to 15 step 1
			GUICtrlSetState($chkbox[$i][$t],$GUI_UNCHECKED)
		Next
		$if_chkall[$t] = 0
	EndIf
EndFunc	

Func clear_all()
	For $i=0 to 15 step 1
		For $j=0 to 13 step 1
			GUICtrlSetState($chkbox[$i][$j],$GUI_UNCHECKED)
		Next
	Next
	For $i=0 to 13 step 1
		GUICtrlSetState($chk_all[$i],$GUI_UNCHECKED)
	Next
EndFunc

Func check_lab($chk,$n)
	If $chk[$n][1]=1 Then
		$BUN = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl08_cbxIsSelect")
		$BUN.click    ;
	EndIf
	If $chk[$n][2]=1 Then
		$Cr = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl09_cbxIsSelect")
		$Cr.click    ;
	EndIf
	If $chk[$n][3]=1 Then
		$TBil = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl06_cbxIsSelect")
		$TBil.click    ;
	EndIf
	If $chk[$n][4]=1 Then
		$DBil = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl07_cbxIsSelect")
		$DBil.click    ;
	EndIf
	If $chk[$n][5]=1 Then
		$AST = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl04_cbxIsSelect")
		$AST.click    ;
	EndIf
	If $chk[$n][6]=1 Then
		$ALT = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl05_cbxIsSelect")
		$ALT.click    ;
	EndIf
	If $chk[$n][7]=1 Then
		$Mg = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl16_cbxIsSelect")
		$Mg.click    ;
	EndIf
	If $chk[$n][8]=1 Then
		$CBC = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl01_cbxIsSelect")
		$CBC.click    ;
	EndIf
	If $chk[$n][9]=1 Then
		$DC = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl02_cbxIsSelect")
		$DC.click    ;
	EndIf
	If $chk[$n][10]=1 Then
		$PT = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl21_cbxIsSelect")
		$PT.click    ;
	EndIf
	If $chk[$n][11]=1 Then
		$PTT = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl22_cbxIsSelect")
		$PTT.click    ;
	EndIf
	If $chk[$n][12]=1 Then
		$CRP = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl25_cbxIsSelect")
		$CRP.click    ;
	EndIf
	If $chk[$n][13]=1 Then
		$Alb = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl03_cbxIsSelect")
		$Alb.click    ;
	EndIf
	
EndFunc

Func check_XR($chk,$n)
	If $chk[$n][0]=1 Then
		$CXR2 = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_dlsOrders_ctl01_cbxIsSelect")
		$CXR2.click    ;
	EndIf
EndFunc

while 1
	$msg = GUIGetMsg()
	Select
		case $msg = $GUI_EVENT_CLOSE
			Exit
		case $msg = $button[0]
			gogogo()
		case $msg = $button[1]
			clear_all()
		case $msg = $chk_all[0]
			toggle_all(0)
		case $msg = $chk_all[1]
			toggle_all(1)
		case $msg = $chk_all[2]
			toggle_all(2)
		case $msg = $chk_all[3]
			toggle_all(3)
		case $msg = $chk_all[4]
			toggle_all(4)
		case $msg = $chk_all[5]
			toggle_all(5)
		case $msg = $chk_all[6]
			toggle_all(6)
		case $msg = $chk_all[7]
			toggle_all(7)
		case $msg = $chk_all[8]
			toggle_all(8)
		case $msg = $chk_all[9]
			toggle_all(9)
		case $msg = $chk_all[10]
			toggle_all(10)
		case $msg = $chk_all[11]
			toggle_all(11)
		case $msg = $chk_all[12]
			toggle_all(12)
		case $msg = $chk_all[13]
			toggle_all(13)
		
	EndSelect
WEnd
