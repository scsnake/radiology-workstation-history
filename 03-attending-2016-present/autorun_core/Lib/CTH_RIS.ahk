﻿#include <ReportImpression>
#include <WinHook>
#include <LineBreakConvert>
#include <SetTimerClass>
#include <WM_COPYDATA>
#include <JXON>
;~ #include <SCI>
DetectHiddenWindows, On
SetBatchLines,-1

;~ OnMessage(0x4a, "ON_WM_COPYDATA")
;~ global __debug:=true
;~ CTH_RIS:=r:=new CTH_RIS_REPORT()
;~ esc::ExitApp
;~ global CTH_RIS_REPORT_OBJ:=new CTH_RIS_REPORT()
 /*
 On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	
	try
		j:=JXON_load(lpData)
	catch
		return
	
	switch j.do {
		case "set_exam":
			Edit_SetText(CTH_RIS_REPORT_OBJ.gui.exam_edit, j.value)
			,CTH_RIS_REPORT_OBJ.flush()
		case "set_impression":
			Edit_SetText(CTH_RIS_REPORT_OBJ.gui.impression_edit, j.value)
			,CTH_RIS_REPORT_OBJ.flush()
		case "get":
			value:="0920aec4e4"
			for k,v in j.fields
				if k=1
					value:=CTH_RIS_REPORT_OBJ[v]
				else
					value:=value[v]
			
	}
}
 */

class CTH_RIS_SYSTEM {
	__New(){
		
		this.hook_new_win()
		,this.auto_login_ris:=true
		,this.ris_login_wbs:=[]
		,this.ris_list_wbs:=[]
		,this.ris_report_wbs:=[]
		,this.scan_IEs()
	}
	
	hook_new_win(){
		
		this.ShellHook:=this.new_win_created.bind(this)
		WinHook.Shell.Add(this.ShellHook,,, "iexplore.exe",1) 

	}
	
	new_win_created(hWnd, win_title, win_class, win_exe, win_event){
		Sleep 500
		if ris_login_wb:=this.is_ris_login(hWnd){
			this.ris_login_wbs.push(ris_login_wb)
			if (this.auto_login_ris)
				this.login_ris(ris_login_wb)
		}
	}
	
	is_ris_login(hWnd){
		wb:=this.wb_hwnd(hWnd)
		if InStr(wb.LocationURL, "/webcvis/comm/log") && wb.document.getElementById("loginButton").id
			return wb
	}
	
	is_ris_list(hWnd){
		wb:=this.wb_hwnd(hWnd)
		
		try {
			MsgBox %  wb.currentSessionID
		}
		
		if InStr(wb.LocationURL, "/webcvis/comm/log") 
			&& (RegExMatch(wb.LocationURL, "jsessionid=(\w+)", jsid) ) {
			this.jsid:=jsid1
			return wb
		}
	}
	
	wb_hwnd(hWnd_or_wb){
		if !IsObject(hWnd_or_wb)
			return WBGet("ahk_id " hWnd_or_wb)
		else 
			return hWnd_or_wb
	}
	
	login_ris(wb=0, wait=true){
		if (wb=0)
			for k,v in this.ris_login_wbs {
				wb:=v
				break
			}
		
		if !wb
			return
		wb.document.getElementsByName("userid")[0].value:=test_userid
		,wb.document.getElementsByName("password")[0].value:=test_pw
		,wb.document.getElementById("loginButton").Click()
		if(wait){
			Loop 
				Sleep 50
			until (!wb.busy && this.is_ris_list(wb)) || A_Index>100
			if this.is_ris_list(wb)
				this.ris_list_wbs[wb.hwnd]:=wb
				,this.ris_login_wbs.delete(wb.hwnd)
			else{
				this.ris_login_wbs[wb.hwnd]:=wb
				return -1
			}
		}
	}
	
	scan_IEs(){
		for wb in ComObjCreate("Shell.Application").Windows() {
			if !InStr(wb.FullName, "iexplore.exe")
				continue
			
			if this.is_ris_list(wb)
				this.ris_list_wbs[wb.hwnd]:=wb
			else if this.is_ris_login(wb)
				this.ris_login_wbs[wb.hwnd]:=wb
		}
		if (this.auto_login_ris)
			this.login_ris(0)
	}
}


class CTH_RIS_REPORT extends SetTimerClass  {
	__New(wb=""){
		this.inputElements:={}
		,this.pid:=DllCall("GetCurrentProcessId")
		,this.create_gui()
		,this.pacs_hx:={colNo:{hospitalBranch: 1, EIO: 2, ReportVS: 3, examname: 4, examtype: 5, accNo: 6, examdate: 7, Report: 12}}
		,this.auto_ahk_change:=true
		
		
		if (wb=""){
			this.update_wb()
		}else
			this.wb:=wb
			,this.setTimer("update_wb", -500)
		
		
		Hotkey,~!Tab,disableCTHRISfocus,on
		;~ this.get_fields()
		;~ this.Parse_pacs_hx()
		;~ this.get_elements()

		
		;~ this.settimer("refresh_info", 500)
		;~ this.hook_new_win()
		
		
	}
	
	reset(){
		return this.reset_gui()
	}
	
	activate(){
		this.showWb()
		WinActivate,% "ahk_id " this.wb.hwnd
		;~ WinWaitActive,% "ahk_id " this.wb.hwnd,,2
		this.inputElements.reportText.Focus()
	}
	
	check_wb(){
		if !WinExist("ahk_id " this.wb.hwnd)
			this.update_wb()
	}
	
	update_wb(){
		if !WinExist("ahk_id " this.wb.hwnd){
			this.reset_gui()
			for wb in ComObjCreate("Shell.Application").Windows()
			if (WinGetTitle(wb.hwnd)~="i)\/webcvis\/MJB[\w\W]+index=") {
				try {
					__ :=wb.document.getElementById("exam").id
					this.wb:=wb
					break
				}
			}
			
		}
		;~ this.get_fields()
		;~ ToolTip % this.accno
		;~ return
		
		try{
			inputs:=this.wb.document.getElementsByTagName("input")
			Loop % inputs.length 
				try
				if ((input:=inputs[A_Index-1]).name="referno"){
					wb_accno:=Trim(input.value)
					break
				}
			if(wb_accno!="" && wb_accno!=this.accno){
				this.Pause_refresh:=true
				this.get_fields(inputs)
				this.Parse_pacs_hx()
				this.get_elements()
				this.Pause_refresh:=false
				this.refresh_info(true)
				
				PostMessage,0x2024,,,,simpleRIS_main ahk_class AutoHotkeyGUI
				;~ PostMessage,0x2024,,,,simpleRIS__main ahk_class AutoHotkeyGUI
				;~ PostMessage,0x2020,,,,simpleRIS_main ahk_class AutoHotkeyGUI
			}else if(wb_accno="")
				this.reset_gui()
		}catch{
			this.accno:=""
			this.reset_gui()
		}
		
		this.setTimer("update_wb", -500)
	}
	
	hook_new_win(){
		
		this.ShellHook:=this.new_win_created.bind(this)
		WinHook.Shell.Add(this.ShellHook,,, "iexplore.exe",1) 
		WinHook.Shell.Add(this.ShellHook,"webcvis/MJB",, "iexplore.exe",2) 

	}
	
	new_win_created(hWnd, win_title, win_class, win_exe, win_event){	
		switch win_event {
			case 1:
				Sleep 500
				found:=false
				for wb in ComObjCreate("Shell.Application").Windows()
					if (wb.hwnd=hwnd) && (WinGetTitle(hwnd)~="i)\/webcvis\/MJB[\w\W]+index=") {
						found:=true
						break
					}
				
				if (found){
					
					;~ this.Pause_refresh:=true
					this.wb:=wb
					this.update_wb()
					;~ this.Pause_refresh:=false
					
					
					PostMessage,0x2024,,,,simpleRIS_main ahk_class AutoHotkeyGUI
					;~ PostMessage,0x2024,,,,simpleRIS__main ahk_class AutoHotkeyGUI
					;~ PostMessage,0x2020,,,,simpleRIS_main ahk_class AutoHotkeyGUI
						
				}
			case 2:
				winactivate,-C醫院 ahk_exe iexplore.exe
		}
	}
	
	get_fields(ByRef inputs=""){
		if !inputs
			try
				inputs:=this.wb.document.getElementsByTagName("input")
			catch
				throw Exception("can't get wb inputs")
		
		temp:={}
		Loop % inputs.length 
			try
			if ((v:=(input:=inputs[A_Index-1]).value)!="") && (k:=input.name)!=""
				temp[k]:=v
		
		if (temp.patno!="" && temp.referno!="" && temp.gender!="" && temp.mciname!="" && temp.checktime!=""){
			for k,v in temp
				this[k]:=v
			lastaccNo:=this.accNo
			if (lastaccNo!=this.accNo)
				this.reset_gui()
			this.chartNo:=this.patno
			,this.accNo:=this.referno
			,this.gender:=this.gender=1?"M":"F"
			,this.examname:=this.mciname
			,this.examtime:=this.checktime
			,this.examdate:=RegExReplace(SubStr(this.examtime,1,10), "\-", "")
			
			if (lastaccNo!=this.accNo){
				disableCTHRISfocus()
				if (this.auto_ahk_change) {
					this.change_ahk()
				}
				
				;~ MsgBox,% is_ych_ahk "," monitorInfo().length()
				
				if (this.is_ych_ahk() && monitorInfo().length()=1){
					;~ MsgBox % WinGetTitle(this.wb.hwnd)
					;; todo: settimer not effect if changed ahk, winshow but not overlap pacs
					;~ WinHide,% "ahk_id " this.HiddenWbHwnd:= this.wb.hwnd
					;~ Hotkey,~#space,ShowWbSub,on
					;~ this.SetTimer("showWb", -6000)
				}
				return true
			}
			
		}
	}
	
	is_ych_ahk(){
		return WinExist("YCH_AHK_main ahk_pid " this.pid) || WinExist("YCH_XR_main ahk_pid " this.pid) || WinExist("YCH_MAMMO_AHK_main ahk_pid " this.pid) || WinExist("YCH_BMD_main ahk_pid " this.pid)
	}
	
	change_ahk(){
		exam_type:=this.parse_exam_type(this.examname)
		is_ych_ahk := this.is_ych_ahk()
		
		if !is_ych_ahk
			return
		
		;~ MsgBox % this.examname "," exam_type
		if (this.examname~="i)Bone age"){
			t:=e:=""
			if !h:=WinExist("ahk_exe boneage_CTH.exe")
				run % A_ScriptDir "\boneage_CTH.exe"
			else 
				winactivate,% "ahk_id " h
		}else if(this.examname~="i)density|\bBMD\b|骨密")
			t:="YCH_BMD_main", e:="YCH_BMD.ahk"
		else if(this.examname~="I\.?V\.?P\.?")
			t:="YCH_AHK_main", e:="YCH_Enh.ahk"
		else
			switch exam_type {
				case "CT", "MR":
					t:="YCH_AHK_main", e:="YCH_Enh.ahk"
				case "Mammo":
					t:="YCH_MAMMO_AHK_main", e:="YCH_Mammo_Enh.ahk"
				case "X-Ray":
					t:="YCH_XR_main", e:="YCH_XR_Enh.ahk"
				
			}
		
		if(t="" || e="")
			return
		;~ MsgBox % WinExist(t " ahk_pid " this.pid) "," t
		if WinExist(t " ahk_pid " this.pid)
			return
		
		dir:=A_ScriptDir
		;~ MsgBox % Commands(dir "\" SubStr(e,1,-4) ".exe", dir "\" e)
		
		
		try{
			this.reset_gui()
			run,% Commands(dir "\" SubStr(e,1,-4) ".exe", dir "\" e),% dir
		}
	}
	
	Parse_pacs_hx(){
		
		this.pacs_hx.element:=tb:=this.wb.document.getElementById("row_beforereport")
		
		data:=[]
		Loop % (rows:=tb.rows).length {
			if A_Index=1
				continue
			row_data:=[]
			row:=rows[A_Index-1]
			Loop % (cells:=row.cells).length {
				if (A_Index=12)
					try
					row_data[A_Index]:=(Trim(RegExReplace(cells[A_Index-1].childNodes[0].value, "s)<br *\/>", "`n")))
				else
					try
					row_data[A_Index]:=(Trim(cells[A_Index-1].innerText))
			}
			data.push(row_data)
		}
		
		this.pacs_hx.data:=data
		
		this.get_last_report()
	}
	
	parse_exam_type(examname){
		
		if(examname~="\bCT\b"){
			return "CT"
		}else if(examname~="\bMRI|MRCP|MRA\b"){
			return "MR"
		}else if(examname~="超音波"){
			return "US"
		}else if(examname~="i)mammo|乳"){
			return "Mammo"
		}else{
			return "X-Ray"
		}
	}
	
	get_last_report(){
		examtype:=this.parse_exam_type(this.examname)
		
		for k,v in this.pacs_hx.data {
			if InStr(v[this.pacs_hx.colNo.examtype], examtype) && (v[this.pacs_hx.colNo.ReportVS]!="") {
				last_report:=new ReportImpression(v[this.pacs_hx.colNo.Report])
				,Edit_SetText(this.gui.old_exam_edit, last_report.exam)
				,Edit_SetText(this.gui.old_impression_edit, last_report.impression)
			}
		}
	}
	
	get_elements(){
		;~ this.check_wb()
		this.inputElements.examRemark:=this.wb.document.getElementById("remarktx")
		,this.inputElements.chiftComplaints:=this.wb.document.getElementById("memotx")
		,this.inputElements.icdInfo:=this.wb.document.getElementById("icdtx")
		,this.inputElements.openImage:=this.wb.document.getElementById("ImageButton")
		,this.inputElements.saveReport:=this.wb.document.getElementById("saveSelectButton")
		,this.inputElements.priorExam:=this.wb.document.getElementById("prerow")
		,this.inputElements.nextExam:=this.wb.document.getElementById("nextrow")
		,this.inputElements.followPatho:=this.wb.document.getElementById("Chkpatdata")
		,this.inputElements.autoExamName:=this.wb.document.getElementById("isAutoMciname")
		,this.inputElements.reportText:=this.wb.document.getElementById("exam")
	}
	
	
	create_gui(){
		this.gui:={}
		gui,CTH_RIS_GUI:new,+hwnd__guiHwnd +toolwindow -caption
		WinSetTitle,ahk_id %__guiHwnd%,,CTH_RIS_GUI
		WinHide,ahk_id %__guiHwnd%
		gui,CTH_RIS_GUI:Add,Edit,hwnd__editHwnd1 g__6d241884ad75fa6
		gui,CTH_RIS_GUI:Add,Edit,hwnd__editHwnd2 g__6d241884ad75fa6
		Loop 11
			gui,CTH_RIS_GUI:Add,Edit,% " g__6d241884ad75fa6 hwnd__editHwnd" A_Index+2
		Loop 3
			gui,CTH_RIS_GUI:Add,Edit,% " g__6d241884ad75fa6 hwnd__editHwnd" A_Index+13
		Loop 2
			gui,CTH_RIS_GUI:Add,Edit,% " g__6d241884ad75fa6 hwnd__editHwnd" A_Index+16
		
		this.gui.guihwnd:=__guihwnd
		,this.gui.exam_edit:=__editHwnd1
		,this.gui.impression_edit:=__editHwnd2
		
		;; ,this.[attr name]_edit_auto will auto update value of ,this.[attr name]
		,this.gui.patname_edit_auto:=__editHwnd3
		,this.gui.accno_edit_auto:=__editHwnd4
		,this.gui.gender_edit_auto:=__editHwnd5
		,this.gui.age_edit_auto:=__editHwnd6
		,this.gui.examname_edit_auto:=__editHwnd7
		,this.gui.examtime_edit_auto:=__editHwnd8
		,this.gui.patidno_edit_auto:=__editHwnd9
		,this.gui.source_edit_auto:=__editHwnd10
		,this.gui.depname_edit_auto:=__editHwnd11
		,this.gui.referdrname_edit_auto:=__editHwnd12
		,this.gui.birthday_edit_auto:=__editHwnd13
		,this.gui.remark_edit_auto:=__editHwnd14
		,this.gui.memo_edit_auto:=__editHwnd15
		,this.gui.icd_edit_auto:=__editHwnd16
		,this.gui.old_exam_edit:=__editHwnd17
		,this.gui.old_impression_edit:=__editHwnd18
		,this.last_reset:=A_TickCount
		
		gui,CTH_RIS_GUI:Add,button,hwnd__hideButtonHwnd,Hide
		method := ObjBindMethod(this, "hide_gui")
		GuiControl +g, %__hideButtonHwnd%, %method%
		
		if (__debug){
			this.show_gui()
		}
			
		
	}
	
	show_gui(){
		gui,CTH_RIS_GUI:Show
		winset,AlwaysOnTop,on,ahk_id %__guiHwnd%
	}
	
	hide_gui(){
		gui,CTH_RIS_GUI:hide
		
	}
	
	HideWb(){
		WinHide,% "ahk_id " this.HiddenWbHwnd:=this.wb.hwnd
	}
	
	ShowWb(){
		WinShow,% "ahk_id " this.HiddenWbHwnd
	}
	
	refresh_info(bypass_get_fields=false){
		;~ if (this.Pause_refresh) || (A_TickCount-this.last_reset<1500)
			;~ return
			
		
		this.doing_refresh:=true
		if (this.accNo!="")
			this.lastaccNo:=this.accNo
		if (!bypass_get_fields || this.accno=""){
			this.doing_refresh:=false
			 if this.get_fields()
				return this.refresh_info(true)
		}
		;~ if(this.accNo!="" && this.accNo!=ControlGetText(this.gui.accno_edit_auto)){
			try{
			
			reports:=this.split_report(this.report:=this.inputElements.reportText.value)
			Edit_SetText(this.gui.accno_edit_auto, this.accno)
			,Edit_SetText(this.gui.exam_edit, this.exam:=reports[1])
			,Edit_SetText(this.gui.impression_edit, this.impression:=reports[2])
			for var_edit, edit_hwnd in this.gui {
				if (i:=InStr(var_edit, "_edit_auto")){
					var:=SubStr(var_edit,1,i-1)
					,Edit_SetText(edit_hwnd, this[var])
				}
			}
			}catch {
				;~ Edit_SetText(this.gui.accno_edit_auto, "")
				this.reset_gui()
				this.doing_refresh:=false
				return -1
			}
		;~ }
		this.doing_refresh:=false
	}
	
	reset_gui(){
		this.last_reset:=A_TickCount
		for k,v in this.gui {
			if InStr(k, "edit")
				Edit_SetText(v, "")
		}
	}
	
	exam {
		get {
			return Edit_GetText(this.gui.exam_edit)
		}
		set {
			Edit_SetText(this.gui.exam_edit, value)
			return value
		}
	}
	
	impression {
		get {
			return Edit_GetText(this.gui.impression_edit)
		}
		set {
			Edit_SetText(this.gui.impression_edit, value)
			return value
		}
	}
	
	flush(){
		
		this.Pause_refresh:=true
		
		report:=new ReportImpression(Edit_GetText(this.gui.exam_edit), Edit_GetText(this.gui.impression_edit))
		
		;~ ,exam_reports:=this.split_report(Edit_GetText(this.gui.exam_edit))
		;~ ,exam:=RegExReplace(exam_reports[1], "(^[\r\n]+)|([\r\n]+$)", "")
		
		;~ ,imp:=Edit_GetText(this.gui.impression_edit) "`n" exam_reports[2]
		;~ ,imp:=Trim(RegExReplace(Trim(imp), "(\r?\n){2,}", "`n"))
		;~ ,imp:=RegExReplace(imp, "(^[\r\n]+)|([\r\n]+$", "")
		;~ ,reports:=LineBreakConvert(RegExReplace(Trim(exam), "[\r\n]*$", "")  (imp=""?"":"`n`nImpression:`n" imp), "\r\n", "`n")
		;~ ToolTip % "//" exam "//`n//" imp "//"
		;~ if (Trim(exam_reports[2])!="")
			;~ Edit_SetText(this.gui.exam_edit, exam)
			;~ ,Edit_SetText(this.gui.impression_edit, imp)
		report.set_text(this.gui.exam_edit, this.gui.impression_edit)
		this.exam:=report.exam
		this.impression:=report.impression
		this.report:=clipboard:=reports:=report.combine()
		showtooltip(reports, 3000)
		set_text_error:=false
		Loop {
			this.inputElements.reportText.value:=reports
			if (LineBreakConvert(this.inputElements.reportText.value)=LineBreakConvert(reports))
				break
			else if A_Index>100
				;~ MsgBox % "//" this.inputElements.reportText.value "//`n//" reports "//"
				clipboard:=reports, set_text_error:=true
				,Edit_SetText(getSimpleRisEditHwnds()[1], reports)
			else
				this.get_elements()
			Sleep 20
		}
		try
		this.inputElements.reportText.setSelectionRange(-1,-1)
		this.Pause_refresh:=false
		return set_text_error
	}
	
	split_report(txt){
		if i:=RegExMatch(txt, "i)(?<=\n)(Impression:|IMP:) *\n?", m){
			return [SubStr(txt,1,i-1), SubStr(txt,i+StrLen(m))]
		}else
			return [txt, ""]
	}
	
	;~ overlay_input(){
		;~ this.create_overlay_input()
		;~ this.move_overlay_input()
	;~ }
	
	;~ create_overlay_input(){
		;~ if WinExist("ahk_id " this.overlay.guihwnd)
			;~ return
		;~ gui,CTH_RIS_OVERLAY:default
		;~ gui,+hwnd__guiHwnd +toolwindow -caption +lastfound
		;~ this.overlay.guihwnd:=__guihwnd
		;~ WinSetTitle,ahk_id %__guihwnd%,,CTH_RIS_OVERLAY
		;~ gui,color,EEAACC,black
		;~ winset,TransColor,EEAACC
		;~ gui,font,s14 csilver,Georgia
		;~ gui,add,button,w0 h0 g__6d241884ad75fa6
		;~ gui,add,text,vthisAccNoText hwnd__thisAccNoTextHwnd w0 h0
		;~ this.overlay.accNoTextHwnd:=__thisAccNoTextHwnd
		
		
	;~ }
	
	__Delete(){
		this.showWb()
	}
}

ShowWbSub:
WinShow,Internet Explorer
return

disableCTHRISfocus(){
	global CTH_RIS
	if WinExist("ahk_id " CTH_RIS.wb.hwnd){
		js=javascript:setFocus=function(){return 0;};void 0;
		CTH_RIS.wb.navigate(js)
		;~ execJS(CTH_RIS.wb, js)
	}
		
}

__6d241884ad75fa6(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:=""){
	
	return
}


~^#!+s::
;~ global __debug:=true
if CTH_RIS.is_ych_ahk()
	CTH_RIS.show_gui()
return
