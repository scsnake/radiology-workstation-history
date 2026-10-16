#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         何佾昌
 Script Function:Portal批次開單
 Email:			 scsnake@gmail.com
 
#ce ----------------------------------------------------------------------------



#include <IE.au3>
#include <GuiConstantsEx.au3>
#include <date.au3>
#include <Timers.au3>
;~ #include <WindowsConstants.au3>
;~ #include <EditConstants.au3>
;~ #include <string.au3>
;~ #include <ButtonConstants.au3>
#include <Array.au3>


Global $Paused
HotKeySet("{esc}", "TogglePause")
Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(200)
        TrayTip("暫停中...","ESC: 暫停/繼續"&@crlf&"Alt+Q: 結束程式",1)
    WEnd
    TrayTip("","",1)
EndFunc




Opt("WinTitleMatchMode",2)
Opt ("ExpandEnvStrings", 1)
AutoItSetOption("MustDeclareVars",0)


$this_gui = GUICreate("Portal批次開單",760,400)
GUISetFont(10,400,0,"Verdana")

$room_label = GUICtrlCreateLabel("Rooms:",0,60)
$room = GUICtrlCreateInput("01-1,02-3,05~07-1,etc.",60,60,500)



GUISetFont(8,400,0,"Verdana")

$item_label = GUICtrlCreateLabel("項目:",0,0)
Global $item_txt[16]                                 					   ;開單項目
$item_txt[0] = GUICtrlCreateLabel("CBC",40,0)
$item_txt[1] = GUICtrlCreateLabel("DC",80,0)
$item_txt[2] = GUICtrlCreateLabel("T-Bil",120,0)
$item_txt[3] = GUICtrlCreateLabel("D-Bil",160,0)
$item_txt[4] = GUICtrlCreateLabel("AST",200,0)
$item_txt[5] = GUICtrlCreateLabel("ALT",240,0)
$item_txt[6] = GUICtrlCreateLabel("BUN",280,0)
$item_txt[7] = GUICtrlCreateLabel("Cr",320,0)
$item_txt[8] = GUICtrlCreateLabel("Na",360,0)
$item_txt[9] = GUICtrlCreateLabel("K",400,0)
$item_txt[10] = GUICtrlCreateLabel("CRP",440,0)
$item_txt[11] = GUICtrlCreateLabel("Alb",480,0)
$item_txt[12] = GUICtrlCreateLabel("PT",520,0)
$item_txt[13] = GUICtrlCreateLabel("PTT",560,0)
$item_txt[14] = GUICtrlCreateLabel("CXR",600,0)
$item_txt[15] = GUICtrlCreateLabel("KUB",640,0)
global $item_chk[16]													
For $i=0 to 15 step 1
	$item_chk[$i] = GUICtrlCreateCheckbox("",40*$i+40,20,18,18)
Next

$chkall_txt = GUICtrlCreateLabel("全選",680,0)
$chkall = GUICtrlCreateCheckbox("",680,20,18,18)

$others_label = GUICtrlCreateLabel("Others:",0,40)
$others = GUICtrlCreateInput("",60,40,500)

;~ global $if_chkall[15]
;~ For $i=0 to 14 step 1
;~ 	$if_chkall[$i] = 0
;~ Next

;~ global $inputbox[16],$others[16]									; OTHERS
;~ For $i=0 to 15 step 1
;~ 	$inputbox[$i] = GUICtrlCreateInput("",600,20*$i+40,100,18)
;~ Next

;~ global $chkbox[16][15]                                                ;CHECKBOXES
;~ For $i=0 to 15 step 1
;~ 	For $j=0 to 13 step 1
;~ 		$chkbox[$i][$j] = GUICtrlCreateCheckbox("",40*$j+40,20*$i+40,18,18)
;~ 	Next
;~ Next
;~ For $i=0 to 15 step 1
;~ 	$chkbox[$i][14] = GUICtrlCreateCheckbox("",720,20*$i+40,18,18)
;~ Next

global $option[1],$test_mode
$option[0] = GUICtrlCreateCheckbox("測試模式",410,365)

GUISetFont(10)
global $button[4]													;按鈕
$button[0] = GUICtrlCreateButton("開工",640,360)
$button[1] = GUICtrlCreateButton("清空",560,360)
$button[2] = GUICtrlCreateButton("補摺",720,360)
$button[3] = GUICtrlCreateButton("說明",480,360)




GUISetState(@SW_SHOW)
msgbox(0,"","")




Func gogogo()
	ToolTip("批次開單中…",0,0,"","",1)
;~ 	Global $chk[16][14]
;~ 	For $i=0 to 15 step 1
;~ 		For $j=0 to 13 step 1
;~ 			If GUICtrlRead($chkbox[$i][$j])=1 Then
;~ 				$chk[$i][$j] = 1
;~ 			Else
;~ 				$chk[$i][$j] = 0
;~ 			EndIf
;~ 		Next
;~ 	Next
	
;	_ArrayDisplay($chk)
	
;~ 	global $sum[16]
;~ 	For $i=0 to 15 step 1
;~ 		Local $temp = 0
;~ 		For $j=0 to 13 step 1
;~ 			$temp = $temp + $chk[$i][$j]
;~ 		Next
;~ 		$sum[$i] = $temp
;~ 	Next
	GUISetState(@SW_MINIMIZE,$this_gui)
	if_debug()
	
	Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
	$DrMainColumn = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn")
	If Not IsObj($DrMainColumn) Then
		MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之IE視窗，操作中止")
		Return
	EndIf
	If Not $DrMainColumn.checked Then $DrMainColumn.click
	While 1
		sleep(500)
		$temptext = _IEBodyReadText($oIE)
		If StringInStr($temptext,"醫護專用") then ExitLoop
	WEnd
	
	sleep(500)
	
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
			If Not IsObj($TreatOrder) Then
				MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之""診療醫令""文字連結，操作中止")
				Return
			EndIf
			$TreatOrder.click
			TrayTip("Room No.: "& $room[$n],"診療醫令視窗開啟中...",30)
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
				If Not IsObj($lab_radio) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""檢驗""醫令，操作中止")
					Return
				EndIf
				If Not $lab_radio.checked Then
					_IEAction($lab_radio,"click")
					TrayTip("Room No.: "& $room[$n],"點選""檢驗""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$lab1_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlMainCategory") ;點選緊急檢查室
				If Not IsObj($lab1_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""檢驗醫令主類別""，操作中止")
					Return
				EndIf
				If Not ($lab1_select.value=17) Then
					_IEFormElementSetValue($lab1_select,17)
					TrayTip("Room No.: "& $room[$n],"點選""緊急檢查室""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$lab2_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlSubCategory") ;最常用項目
				If Not IsObj($lab2_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""檢驗醫令次類別""，操作中止")
					Return
				EndIf
				If Not ($lab2_select.value=1) Then
					_IEFormElementSetValue($lab2_select,1)
					TrayTip("Room No.: "& $room[$n],"點選""最常用項目""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$date_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlPlanDate")   ;選明天的日期
				$sNewDate = _DateAdd('d',1, _NowCalcDate())
				If Not IsObj($date_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""預計日期""，操作中止")
					Return
				EndIf
				If Not ($date_select.value=$sNewDate) Then
					_IEFormElementSetValue($date_select,$sNewDate)
					TrayTip("Room No.: "& $room[$n],"點選""預計日期"": "& $sNewDate,30)
					load_wait()
				EndIf	
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				
				check_lab($chk,$n)      ;勾選檢驗單
				
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$submit1 = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_btnSelect2")   ;暫存勾選醫令
				If IsObj($submit1) Then 
					$submit1.click
					TrayTip("Room No.: "& $room[$n],"點選""暫存勾選醫令""",30)
				Else	
					TrayTip("ICU開單 ERROR!!","未找到診療醫令視窗之""暫存勾選醫令""?",30)
				EndIf
				
				If $others[$n]=1 Then
					MsgBox(0,"ICU開單","請手動點選項目"&@CRLF&"「點選完再按確定」!!")
					load_wait()
				EndIf
				
				load_wait()
			EndIf
			If $chk[$n][0]>0 Then   ;影醫
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR_radio = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_rblOrderType_3")   ;點選影醫
				If Not IsObj($XR_radio) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""影醫""醫令，操作中止")
					Return
				EndIf
				If Not $XR_radio.checked Then
					$XR_radio.click
					TrayTip("Room No.: "& $room[$n],"點選""影醫""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR1_radio = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_rblRadSubTypes_0")   ;None
				If Not IsObj($XR1_radio) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之影醫醫令細項，操作中止")
					Return
				EndIf
				If Not $XR1_radio.checked Then
					$XR1_radio.click
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR2_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlMainCategory")   ;Plain Film
				If Not IsObj($XR2_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""影醫醫令主類別""，操作中止")
					Return
				EndIf
				If Not ($XR2_select.value=1) Then
					_IEFormElementSetValue($XR2_select,1)
					TrayTip("Room No.: "& $room[$n],"點選""Plain Film""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$XR3_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlSubCategory")   ;Chest
				If Not IsObj($XR3_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""影醫醫令次類別""，操作中止")
					Return
				EndIf
				If Not ($XR3_select.value=2) Then
					_IEFormElementSetValue($XR2_select,2)
					TrayTip("Room No.: "& $room[$n],"點選""Chest""",30)
					load_wait()
				EndIf
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$date_select = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_ddlPlanDate")   ;選明天的日期
				$sNewDate = _DateAdd( 'd',1, _NowCalcDate())
				If Not IsObj($date_select) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""預計日期""，操作中止")
					Return
				EndIf
				If Not ($date_select.value=$sNewDate) Then
					_IEFormElementSetValue($date_select,$sNewDate)
					TrayTip("Room No.: "& $room[$n],"點選""預計日期"": "& $sNewDate,30)
					load_wait()
				EndIf	
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				check_XR($chk,$n)		;勾選X光單
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$submit1 = _IEGetObjById($oIE2,"NWeb1_OrderSearch1_btnSelect2")   ;暫存勾選醫令
				If Not IsObj($submit1) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""暫存勾選醫令""，操作中止")
					Return
				EndIf
				$submit1.click
				TrayTip("Room No.: "& $room[$n],"點選""暫存勾選醫令""",30)
				load_wait()
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
				$bedside_chk = _IEGetObjById($oIE2,"NWeb1_EditTempOrders1_RadTempOrders1_lvwOrders_ctrl0_cbxIsBedSide")  ;勾portable
				If Not IsObj($bedside_chk) Then
					MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""床邊攝影選項""，操作中止")
					Return
				EndIf
				$bedside_chk.click
			EndIf
			
			If $test_mode=1 Then ContinueLoop									;測試模式: 不做"確定帶入勾選醫令"及"醫師確認"
			
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			$submit2 = _IEGetObjById($oIE2,"NWeb1_EditTempOrders1_btnConfirm")    ;確定帶入勾選醫令
			If IsObj($submit2) Then
				$submit2.click
				TrayTip("Room No.: "& $room[$n],"點選""確定帶入勾選醫令""",30)
			Else
				MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""確定帶入勾選醫令""?")
			EndIf
			
			load_wait()
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			$back_main = _IEGetObjById($oIE2,"NWeb1_OrderEntryCommonSelection1_BackToOrigin")   ;回主畫面
			If IsObj($back_main) Then
				$back_main.click
				TrayTip("Room No.: "& $room[$n],"點選""回主畫面""",30)
			Else
				MsgBox(0,"ICU開單 ERROR!!","未找到診療醫令視窗之""回主畫面""?")
			EndIf
			While 1
				sleep(500)
				$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")        ;病人主畫面
				If @error=0 Then
					Global $oIE2 = $temp
					ExitLoop
				EndIf
			WEnd
			sleep(500)
			
;~ 			$oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL")     ;重整病房首頁
;~ 			$ward_search = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_QueryAccountNoByWardInput")
;~ 			If Not IsObj($ward_search) Then
;~ 				MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之IE視窗?")
;~ 				Return
;~ 			EndIf
;~ 			$ward_search.click
			
;~ 			_IELoadWait($oIE2,0,60000)
;~ 			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
;~ 			$Dr_confirm = _IEGetObjById($oIE2,"NWeb1_PageLinkAndPrintControl1_DRVSConfirm")   ;醫師確認
;~ 			$Dr_confirm.click
			
			While 1
				sleep(500)
				$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
				$Dr_confirm = _IEGetObjById($oIE2,"NWeb1_PageLinkAndPrintControl1_DRVSConfirm")   ;醫師確認
				If @error=0 Then
					If IsObj($Dr_confirm) Then
						$Dr_confirm.click
						TrayTip("Room No.: "& $room[$n],"點選""醫師確認""",30)
					Else
						MsgBox(0,"ICU開單 ERROR!!","未找到病人首頁之""醫師確認""?")
					EndIf
					ExitLoop
				EndIf
			WEnd
			
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
	MsgBox(0,"ICU開單","批次開單完工!!")
EndFunc

Func print()
	ToolTip("批次補摺中…",0,0,"","",1)
	Global $print_order[16]
	For $i=0 to 15 step 1
		If GUICtrlRead($chkbox[$i][14])=1 Then
			$print_order[$i] = 1
		Else
			$print_order[$i] = 0
		EndIf
	Next
	
	GUISetState(@SW_MINIMIZE,$this_gui)
	if_debug()
	
	Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
	$DrMainColumn = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_CheckBoxShowDrMainColumn")
	If Not IsObj($DrMainColumn) Then
		MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之IE視窗，操作中止")
		Return
	EndIf
	If Not $DrMainColumn.checked Then $DrMainColumn.click
	While 1
		sleep(500)
		$temptext = _IEBodyReadText($oIE)
		If StringInStr($temptext,"醫護專用") then ExitLoop
	WEnd
	
	Global $x
	
	For $x=0 to 15 step 1
		Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
		$pt_table = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList")
		$pt_arr = _IETableWriteToArray($pt_table)
		$pts = Ubound($pt_arr,2)-1
		Global $pt_room[$pts]
		For $i=0 to $pts-1 step 1
			$pt_room[$i] = Int($pt_arr[1][$i+1])
		Next
		Global $y = _ArraySearch($pt_room,Int($room[$x]),0,0,0,1,1)                ;病床->病房中的序號
		If ( $print_order[$x]>0 and $y>=0 ) Then                ;有勾選項目的病床
;~			Local $date_changed=0
			Local $temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/DoctorEnterOrder.aspx","URL")
			If @error=0 Then $temp.quit
			$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
			If @error=0 then $temp.quit
			Global $oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL") 
			If $y<=7 Then 
				$PatientMain = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl0" & ($y+2) & "_LinkConfirmDiagnosisOrder");病人主畫面
			Else
				$PatientMain = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_DataGridAccountList_ctl" & ($y+2) & "_LinkConfirmDiagnosisOrder")
			EndIf
			If Not IsObj($PatientMain) Then
				MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之""病人首頁""文字連結，操作中止")
				Return
			EndIf
			$PatientMain.click
			TrayTip("Room No.: "& $room[$x],"病人主畫面視窗開啟中...",30)
			While 1
				sleep(500)
				$temp = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")         ;病人主畫面視窗
				If @error=0 Then
					Global $oIE2 = $temp
					ExitLoop
				EndIf
			WEnd
			sleep(500)
			_IELoadWait($oIE2,0,60000)
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
			$continue_print_order = _IEGetObjById($oIE2,"NWeb1_PatientAccountWholeInfo1_btnContinuePrintOrderSheet")  ;點選補摺
			If Not IsObj($continue_print_order) Then
				MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之""醫囑補摺""，操作中止")
				Return
			EndIf
			$continue_print_order.click
			TrayTip("Room No.: "& $room[$x],"點選""醫囑補摺""",30)

			
;~ 			$oIE = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/OpenWard.aspx","URL")     ;重整病房首頁
;~ 			$ward_search = _IEGetObjById($oIE,"NWeb1_QueryInPatientPersonAccountControl1_QueryAccountNoByWardInput")
;~ 			If Not IsObj($ward_search) Then
;~ 				MsgBox(0,"ICU開單 ERROR!!","未找到病房首頁之IE視窗?")
;~ 				Return
;~ 			EndIf
;~ 			$ward_search.click
			
			WinWait("[class:#32770]","帳號為:",30)
;			ControlClick("[class:#32770]","帳號為:","[classnameNN:Button1]")
				
			
			
			
			
			
			$oIE2 = _IEAttach("ihisaw.hospital-n.local/WebApplication/InPatient/Ward/ConfirmDiagnosisOrder.aspx","URL")
			_IELoadWait($oIE2,0,60000)

		EndIf
	Next
	MsgBox(0,"ICU批次補摺","完工!!")
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
		For $j=0 to 14 step 1
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



Func item_txt_def($i)
	GUICtrlSetFont($item_txt[$i],8,400,0,"Verdana")
	_Timer_KillTimer($this_gui,$x_timer[$i])
EndFunc

global $prev_pos[2]=[0,0]
while 1
;~ 	sleep(500)
	$msg = GUIGetMsg()
	Select
		case $msg = $GUI_EVENT_CLOSE
			Exit
		case $msg = $button[0]
			gogogo()
			WinSetState("ICU 批次開單","",@SW_RESTORE)
			ToolTip("")
		case $msg = $button[1]
			clear_all()
		case $msg = $button[2]
			print()
			WinSetState("ICU 批次開單","",@SW_RESTORE)
			ToolTip("")
		case $msg = $button[3]
			MsgBox(0,"ICU開單說明", _
			"1. 實習於6PE時設計，原則上可用在其他ICU"&@CRLF& _
			"  (1) 檢驗皆為""緊急檢查室""之項目"&@CRLF& _
			"  (2) CXR為AP view、portal"&@CRLF& _
			"  (3) 預計日期為隔天0時"&@CRLF& _
			"  (4) others中填入小數點(.)時，執行過程中會暫停以利手動點選"&@CRLF& _
			"2. 使用前建議留下單一IE視窗(病房首頁)，並以醫師帳號登入"&@CRLF& _
			"3. 測試模式: 不點選""確定帶入勾選醫令""及""醫師確認"""&@CRLF& _
			"4. 批次補摺功能不建議使用(容易送紙失誤)"&@CRLF& _
			"5. ESC: 暫停/繼續，Alt+Q: 結束程式"&@CRLF&@CRLF& _
			"       scsnake@gmail.com   2010/2/7")
		case $msg = $option[0]
			If GUICtrlRead($option[0])=1 Then
				$test_mode = 1
			Else
				$test_mode = 0
			EndIf
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
		case $msg = $chk_all[14]
			toggle_all(14)
	EndSelect
	
	
	
;~ 	$cursor = GUIGetCursorInfo($this_gui)	
;~ 	$x_position = Floor($cursor[0]/40)-1
;~ 	Switch $x_position
;~ 		case 14 to 16
;~ 			$x_position = 14
;~ 		case 17
;~ 			$x_position = 15
;~ 	EndSwitch
;~ 	
;~ 	$y_position = Floor($cursor[1]/20)-2
;~ 	Global $x_timer[16]
;~ 	Global $y_timer[16]
;~ 	If Not ($prev_pos[0]=$x_position) Then
;~ 		Switch $x_position
;~ 			case 0 to 15
;~ 				GUICtrlSetFont($item_txt[$x_position],8,600,4,"Verdana")
	;~ 			$x_timer[$x_position] = _Timer_SetTimer($this_gui,3000,item_txt_def($x_position),$x_timer[$x_position])
;~ 			case 14 to 16
;~ 				GUICtrlSetFont($item_txt[14],8,600,4,"Verdana")
;~ 			case 17
;~ 				GUICtrlSetFont($item_txt[15],8,600,4,"Verdana")
	;~ 			_Timer_SetTimer($this_gui,3000,item_txt_def(15),$x_timer[15])
;~ 		EndSwitch
;~ 		Switch $prev_pos[0]
;~ 			case 0 to 15
;~ 				GUICtrlSetFont($item_txt[$prev_pos[0]],8,400,0,"Verdana")
;~ 			case 14 to 16
;~ 				GUICtrlSetFont($item_txt[14],8,400,0,"Verdana")
;~ 			case 17
;~ 				GUICtrlSetFont($item_txt[15],8,400,0,"Verdana")
;~ 		EndSwitch
;~ 		Switch $x_position
;~ 			case 0 to 13
;~ 				$prev_pos[0] = $x_position
;~ 			case 14 to 16
;~ 				$prev_pos[0] = 14
;~ 			case 17
;~ 				$prev_pos[0] = 15
;~ 		EndSwitch
;~ 		$prev_pos[0] = $x_position
;~ 	EndIf
		
;~ 	If Not ($prev_pos[1]=$y_position) Then
;~ 		Switch $y_position
;~ 			case 0 to 15
;~ 				GUICtrlSetFont($pt[$y_position],10,600,4,"Verdana")
	;~ 			$y_timer[$y_position] = TimerInit()
;~ 		EndSwitch
		
;~ 	For $i=0 to 14 step 1
;~ 		If TimerDiff($x_timer[$i])>3000 Then
;~ 			GUICtrlSetFont($item_txt[$i],8,400,0,"Verdana")
;~ 			$x_timer[$i] = TimerInit()
;~ 		EndIf
;~ 	Next
;~ 	
;~ 			
;~ 		Switch $prev_pos[1]
;~ 			case 0 to 15
;~ 				GUICtrlSetFont($pt[$prev_pos[1]],10,400,0,"Verdana")
;~ 		EndSwitch
;~ 		$prev_pos[1] = $y_position
;~ 	EndIf

;~ 	For $i=0 to 15 step 1
;~ 		If TimerDiff($y_timer[$i])>3000 Then
;~ 			GUICtrlSetFont($pt[$i],10,400,0,"Verdana")
;~ 			$y_timer[$i] = TimerInit()
;~ 		EndIf
;~ 	Next
;~ 	

;~ 	Global $chk[16][14]
;~ 	For $i=0 to 15 step 1
;~ 		For $j=0 to 13 step 1
;~ 			If GUICtrlRead($chkbox[$i][$j])=1 Then
;~ 				$chk[$i][$j] = 1
;~ 			Else
;~ 				$chk[$i][$j] = 0
;~ 			EndIf
;~ 		Next
;~ 	Next
;~ 	global $sum[16]
;~ 	For $i=0 to 15 step 1
;~ 		Local $temp = 0
;~ 		For $j=0 to 13 step 1
;~ 			$temp = $temp + $chk[$i][$j]
;~ 		Next
;~ 		$sum[$i] = $temp
;~ 	Next
;~ 	For $i=0 to 15 step 1
;~ 		If StringInStr(GUICtrlRead($inputbox[$i]),".") Then
;~ 			$others[$i] = 1
;~ 			$sum[$i] = $sum[$i] + 1
;~ 		Else
;~ 			$others[$i] = 0
;~ 		EndIf
;~ 	Next

;~ 	For $i=0 to 15 step 1
;~ 		If $sum[$i] Then
;~ 			GUICtrlSetState($chkbox[$i][14],$GUI_CHECKED)
;~ 		EndIf
;~ 	Next

	if_debug()
WEnd
