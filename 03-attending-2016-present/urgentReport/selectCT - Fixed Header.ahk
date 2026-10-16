﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Off
SetBatchLines, -1
coordMode,mouse,screen
CoordMode,caret,screen
DetectHiddenWindows,on
SetTitleMatchMode,2
SetControlDelay,-1
#NoTrayIcon
comobjerror(false)
onexit,onexit

#include <portallib>
#include <RisImpax>
#include <JXON>
#include <WM_COPYDATA>
#include <LVA>
;~ #include <HtmlLib>
;~ #include <indexOf>
OnMessage(0x4a, "ON_WM_COPYDATA")
,OnMessage("0x4E", "LVA_OnNotify")
;~ #include <JoinScript>
;~ #include <ExploreObj>

RisActiveInfo:=[]
SetTimer,activeInfoCheck,1000
;~ #include <LVA>
gosub Main
return

activeInfoCheck(){
	global RisActiveInfo,colNo, grayRowInfo, wb
	grayRow:=[]
	for activeAccNo, activeStudyState in RisActiveInfo {
		if (activeStudyState="已發報告")
			grayRow[activeAccNo]:=1
		RisActiveInfo.delete(activeAccNo)
	}
	if !(grayRow.SetCapacity(0)>0)
		return
	
	Loop % (rows:=wb.document.getElementsByTagName("TR")).length {
		row:=rows[A_Index-1]
		,AccNo:=row.cells[colNo.AccNo].innerText
		if (grayRow.haskey(AccNo)){
			grayRowInfo[AccNo]:=1
			,setRowColor(row, AccNo)
			,grayRow.delete(AccNo)
			
			if !(grayRow.SetCapacity(0)>0)
				return
		}
	}
	return
}

On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	global ThreadCount
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str:= StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 0x17) {
		
		try 
			info:=jxon_load(str)
		catch
			return
		
		if info.fail
			--ThreadCount
		else{
			newSearchThread_onFinish(info)
			SendMessage,0x8001,,,,% "ahk_id " info.hwnd
			
		}
	}
}

WM_KEYDOWN(wParam, lParam, nMsg, hWnd)
{
   global wb
   static fields := "hWnd,nMsg,wParam,lParam,A_EventInfo,A_GuiX,A_GuiY"
   WinGetClass, ClassName, ahk_id %hWnd%
   if  (ClassName = "Internet Explorer_Server")
   {
   ;// Get the in place interface pointer
      pipa := ComObjQuery(wb.document, "{00000117-0000-0000-C000-000000000046}")
   ;// Build MSG Structure
      VarSetCapacity(Msg, 48)
      Loop Parse, fields, `,             ;`
         NumPut(%A_LoopField%, Msg, (A_Index-1)*A_PtrSize)
   ;// Call Translate Accelerator Method
      TranslateAccelerator := NumGet(NumGet(1*pipa)+5*A_PtrSize)
      Loop 2 ;// only necessary for Shell.Explorer Object
         r := DllCall(TranslateAccelerator, "Ptr",pipa, "Ptr",&Msg)
      until wParam != 9 || wb.document.activeElement != ""
   ;// Release the in place interface pointer
      ObjRelease(pipa)
		
      if r = 0 ;// S_OK: the message was translated to an accelerator.
         return 0
   }
}
embedIE:
	;// Create a gui	
   Gui, +LastFound -Resize +OwnDialogs +hwndGuihwnd
   
   ;// create an instance of Internet Explorer_Server
   ;// store the iwebbrowser2 interface pointer as *WB* & the hwnd as *ATLWinHWND*
   Gui, Add, ActiveX,% "w" A_ScreenWidth-100  " h600 x0 y0 vWB hwndATLWinHWND", Shell.Explorer
   
   ;// disable annoying script errors from the page
   ;~ WB.silent := true
   
   ;// necesary to accept enter and accelorator keys
   ;http://msdn.microsoft.com/en-us/library/microsoft.visualstudio.ole.interop.ioleinplaceactiveobject(VS.80).aspx
   ,IOleInPlaceActiveObject_Interface:="{00000117-0000-0000-C000-000000000046}"
   
   ;// necesary to accept enter and accelorator keys
   ;// get the in place interface pointer
   ,pipa := ComObjQuery(WB, IOleInPlaceActiveObject_Interface)
   
   ;// necesary to accept enter and accelorator keys
   ;// capture key messages
   ,OnMessage(WM_KEYDOWN:=0x0100, "WM_KEYDOWN")
   ,OnMessage(WM_KEYUP:=0x0101, "WM_KEYDOWN")
   
   ;//Display the GUI
   gui,add,Checkbox,vAutoOpen,Auto Open Next
	gui,Show,,Select CT

   
return


main:
FileDelete,rislistinfo.txt
askForPortalIdPw()
,RisListQue:=[]
,RisListNewResult:=[]
,OnMessage(0x1001, "urgentReportClick")
;~ ,test:=20
;~ ,OnMessage("0x4E", "LVA_OnNotify")
gosub pointsDef
gosub loadHx
SetTimer,refreshAll,-1000

gosub embedIE
gui,Font,s12,微軟正黑體
;~ url:="file:///" RegExReplace(A_ScriptDir "\datatable_min.html", "\\", "/")
url:="file:///G:\scripts\Radiology\urgentReport\index2.html"
,WB.Navigate(url)
loop
	Sleep 100
until !WB.busy
colNames:="Type|Chart No|Exam Date|Exam Name|Acc No|OPD Date|Clinician|Pay|Points|Mets|Op|Stable"
,colWidth:=[30, 80, 150, 100, 130, 130, 80, 30, 80, 60, 60, 60]
,cols:=[], colNo:=[]
,js:="javascript:var cols = ['" RegExReplace(colNames, "\|", "','") "'];var colWidth=["
Loop,parse,colNames,|
{
	cols.push(A_LoopField)
	,colNo[RegExReplace(A_LoopField, " ", "")]:=A_Index-1
	,js.=colWidth[A_Index] ","
}
js:=SubStr(js,1,-1) "];setColumnHeaders(cols, colWidth);"
;~ Sleep 500
;~ MsgBox % wb.document.getElementById("dataTable").outerHTML
;~ js.="document.oncontextmenu=function(){return false;};void 0;"
js.="void 0;"
wb.Navigate(clipboard:=js)
loop
	Sleep 100
until !WB.busy

doc := wb.document.getElementByTagName("table")[1]
,ComObjConnect(doc, "Doc_")
,grayRowInfo:=[]
,needRefresh:={}
GroupAdd,Self,ahk_id %guihwnd%
gosub routine 
return 




gui,+hwndGuihwnd
gui,Font,s12,微軟正黑體
gui,Add,ListView,% "r20 w1000 backgroundBlack cwhite AltSubmit vlv gLVClick",% s:="Type|Chart No|Exam Date|Exam Name|Acc No|OPD Date|Clinician|Pay|Points|Mets|Op|Stable"
colNo:={}

Loop,Parse,s,|
	colNo[RegExReplace(A_LoopField, " ", "")]:=A_Index
for k,v in [30, 80, 150, 100, 130, 130, 80, 30, 80, 60, 60, 60]
	LV_ModifyCol(k, v)
LV_ModifyCol(colNo.Points, "Float")
,LV_ModifyCol(colNo.Mets, "Integer")
,LV_ModifyCol(colNo.Op, "Integer")
,LV_ModifyCol(colNo.Stable, "Integer")
,LVA_ListViewAdd("LV")
,grayRowInfo:=[]
,needRefresh:={}
	
;~ gui,add,button,gAddRisList,Add RIS List
gui,add,Checkbox,vAutoOpen,Auto Open Next
gui,Show,,Select CT
GroupAdd,Self,ahk_id %guihwnd%
gosub routine
;~ SetTimer,routine,300000
;~ SetTimer,impaxContextServer,-1

return

urgentReportClick(){
	global urgentReportClick:=1
}


#IfWinActive,ahk_group Self
F5::
MsgBox, 260, ,Reload?
IfMsgBox,Yes
	gosub routine
;~ SetTimer,routine,300000
return
#IfWinActive

strAbbr(str, patternArr, abbrArr){
	for k,v in patternArr
		if RegExMatch(str, v) 
			return abbrArr[k]
	return str
}


addRisList:
;~ ReportList:=[]
;~ ,reportListCount:=parseDataGrid(RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd:=getRisList(RisOpened()[2]))),reportList, 1, 1)
;~ ,parseDataGrid(RisListRowsAcc,reportList, 1, test?10:"", "", "", "reportListProgress")

reportList:=parseDataGrid2(RisListHwnd:=getRisList(RisOpened()[2]))
,reportListCount:=acc_children(acc_objectfromwindow(RisListHwnd)).maxindex()
,extractTitleCol(reportList[1], reportListTitleCol:=[])
for k,v in reportList
	reportListProgress(k, "", "", v)
ToolTip 
return

reportListProgress(k, ByRef rowAcc, ByRef cellsAcc, ByRef rowValue){
	local haskey
	;~ tooltip % "Get list from RIS: " k-1 " / " reportListCount-1 " ..."
	
	if(k=1){
		priorKey:=k
		return
	}
		
	
	if !((ChartNo:=rowValue[reportListTitleCol["病歷號"]])~="\w{6}\d") 
			|| !((ExamName:=Trim(rowValue[reportListTitleCol["檢查名稱"]]), "CT")~="is)CT.+with.*contrast|low dose (lung|chest)")
			|| (Trim(rowValue[reportListTitleCol["狀態"]])="已發報告")
			|| studyTooOld(rowValue[reportListTitleCol["檢查日"]])
		return
	
	if RisListInfo.haskey(AccNo:=rowValue[reportListTitleCol["照會單號"]]){
		data:=RisListInfo[AccNo]
	}else{
		data:=[], toBeSearch.push(k)
	}

	row:=dt_add(""
		, strAbbr(rowValue[reportListTitleCol["診別"]], ["門診", "住院", "急診"], ["門", "住", "急"])
		, Trim(rowValue[reportListTitleCol["病歷號"]])
		, (Trim(rowValue[reportListTitleCol["檢查日"]]))
		, abr:=data.ldct?"LDCT":strAbbr(ExamName:=rowValue[reportListTitleCol["檢查名稱"]], ["i)with\/without contrast-chest", "i)with contrast-chest", "i)without contrast-chest", "i)low dose (lung|chest)"], ["-+C", "+C", "-C", "LDCT"]) 
		, Trim(AccNo)
		;~ , StrLen(t:=RegExReplace(SubStr(Trim(rowValue[reportListTitleCol["回診日期"]]), 1, 10), "-", "/"))>9?t:""
		, data.OpdDate?dateConv(data.OpdDate):(StrLen(t:=RegExReplace(SubStr(Trim(rowValue[reportListTitleCol["回診日期"]]), 1, 10), "-", "/"))>9?t:"")
		, OpdDr:=Trim(rowValue[reportListTitleCol["開單醫師"]])
		, strAbbr(Pay:=rowValue[reportListTitleCol["保險別"]], ["自費", "健保"], ["自", "健"])
		, point:=data.ldct?pointsArr["Low dose lung cancer screening CT"]/10*0.2:pointsArr[ExamName]/data.parts/10*0.2*(InStr(Pay, "自費")?1.3:1)
		, data.mets
		, data.Op
		, data.Stable)
		
	
	
		

}
esc::ExitApp


studyTooOld(d){
	d:=RegExReplace(d, "\D", "")
	n:=A_Now
	n-=d, Days
	return n>250
}

setRowColor(ByRef row, AccNo){
	if grayRowInfo.haskey(AccNo) {
		row.classList.add("grayText")
	}else{
		row.classList.remove("grayText")
	}
}


routine:
if routineRunOnce
	Reload
ToolTip % "Loading RIS list ..."
;~ SetTimer,searching,Off
SetTimer,RisListRefresh,Off
dt_delete()
,LVA_EraseAllCells("LV")
,toBeSearch:=[]
SetFormat,FloatFast,0.1
gosub addRisList
;~ for k, v in reportList {
	
;~ }
;~ LV_ModifyCol(colNo.Urgency, "Sort")
toBeSearchInd:=1
;~ SetTimerF("searching", -1)
;~ search(searchInd)
if (toBeSearch.maxindex()>0) {
	;~ renewSid(sid, loginId, loginPw)
	sid:=login(loginId, loginPw)
	,RisListNewResult:=[]
	SetTimer,search,-1
	SetTimer,RisListRefresh,-1000
}
ToolTip
routineRunOnce:=true
return

test:
	MsgBox
return

search:
	;~ global reportList, reportListTitleCol, sid, RisListInfo, pointsArr, hxFile, colNo, stop, errorInds, searchingTh, ThreadCount
	;~ for k,v in reportList {
	searchInd:=toBeSearch[toBeSearchInd]
	if searching[searchInd] {
		if(++toBeSearchInd<=toBeSearch.maxindex()){
					SetTimer,search,-500
				}
		return
	}
	searching[searchInd]:=true
	
	;~ row:=reportList[searchInd]
		;~ if ((ChartNo:=row[reportListTitleCol["病歷號"]])~="\w{6}\d") 
			;~ && ((ExamName:=Trim(row[reportListTitleCol["檢查名稱"]]), "CT")~="is)CT.+with.*contrast|low dose (lung|chest)"){
			
		
		;~ Pay:=row[reportListTitleCol["保險別"]]
		;~ , ExamDate:=SubStr(RegExReplace(row[reportListTitleCol["檢查日"]], "\D", ""), 1, 8)
		;~ if(RisListInfo.haskey(AccNo:=row[reportListTitleCol["照會單號"]])){
			;~ SetFormat, FloatFast, 0.1
			;~ data:=RisListInfo[AccNo]
			;~ LV_Edit(colNo.AccNo, AccNo, colNo.Points
					;~ , pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/data.parts/10*0.2)
			;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Mets, data.mets)
			;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Op, data.Op)
			
		;~ }else{
			;~ RisListQue[AccNo]:=k
			if(ThreadCount>20){
				settimer,search,-500
				return
			}else {
				info:={"row": reportList[searchInd], "hwnd": guihwnd}
				for k,v in ["searchInd", "reportListTitleCol", "sid"]
					info[v]:=%v%
				run,% """" A_ScriptDir "\selectCT_Query.exe"" """ RegExReplace(jxon_dump(info), """", """""") """"
				,++ThreadCount
					;~ newSearchThread(searchInd)
				
			}
		;~ }
	
	;~ }
	

				if(++toBeSearchInd<=toBeSearch.maxindex()){
					SetTimer,search,-2000
						;~ SetTimerF("search", -500, [searchInd+1])
				}
	;~ }
return

newSearchThread_onFinish(result){
	global ThreadCount, RisListInfo, colNo, hxFile, pointsArr, grayRowInfo,needRefresh
	;~ global ThreadCount, RisListNewResult
	Critical
	--ThreadCount
	
	for k,v in ["AccNo", "searchInd", "parts", "ExamName", "mets", "op", "pay", "ldct", "opdDate", "examDate", "Stable"]
		%v%:=result[v]
	
	;~ RisListNewResult[result[1]]:=[result[2], result[3], result[4], result[5], result[6]]
	;~ return
	;~ AccNo:=result[1]
	if (AccNo="")
		return
	;~ v:=[]
	;~ Loop % result.maxindex()-1
		;~ v.push(result[A_Index+1])
	;~ tmp:=[]
	;~ ,tmp[colNo.Points]:=v[3]
	;~ ,tmp[colNo.mets]:=v[4]
	;~ ,tmp[colNo.Op]:=v[5]
	;~ ,LV_Edit(colNo.AccNo, AccNo, tmp)
	RisListInfo[AccNo]:={ldct: ldct, parts: parts, mets: mets, op: op, OpdDate: OpdDate, Stable: Stable
		, points: (point:=ldct?pointsArr["Low dose lung cancer screening CT"]/10*0.2 :pointsArr[ExamName]/parts/10*0.2* (InStr(Pay, "自費")?1.3:1))}
	,needRefresh[AccNo]:= AccNo "," parts "," mets "," op "," ldct "," ExamDate  "," OpdDate "," Stable  "`n"
	
}

refreshAll(){
	global colNo, RisListInfo, needRefresh, hxFile, no_wrt, wb
	Critical
	;~ ToolTip % needRefresh.SetCapacity(0)
	if !needRefresh.SetCapacity(0) {
		SetTimer,refreshAll,-1000
		return
	}
	Loop % (rows:=wb.document.getElementById("dataTable").rows).length {
		table_row:=rows[A_Index-1]
		,cells:=table_row.cells
		if no_wrt
			return
		AccNo:=cells[colNo.AccNo].innerText
		mets:=cells[colNo.mets].innerText
		if (mets!="" || !RisListInfo.haskey(AccNo))
			continue
		
		;~ MsgBox % exploreobj(RisListInfo[AccNo])
		row:=RisListInfo[AccNo]
		,dt_modifyCell(a_index-1,colNo.points, row.points)
		,dt_modifyCell(a_index-1,colNo.mets,row.mets)
		,dt_modifyCell(a_index-1,colNo.Stable,row.Stable)
		,dt_modifyCell(a_index-1,colNo.op,row.op)
		,dt_modifyCell(a_index-1,colNo.OpdDate,dateConv(row.OpdDate))
		if needRefresh.haskey(AccNo){
			if no_wrt
				return
			FileAppend,% needRefresh[AccNo],% hxFile,utf-8
			needRefresh.delete(AccNo)
		}
	}
	SetTimer,refreshAll,% WinExist("ahk_exe selectCT_Query.exe")?-1000:-10000
}


dateConv(str, del="/"){
	return SubStr(str,1,4) del SubStr(str,5,2) del SubStr(str,7,2)
}

newSearchThread(WT, searchInd, RisListInfo, reportList, reportListTitleCol, sid, pointsArr, colNo){

<searching:

Loop 3 {
		row:=reportList[searchInd]
		,ChartNo:=row[reportListTitleCol["病歷號"]]
		, AccNo:=row[reportListTitleCol["照會單號"]]
		, Pay:=row[reportListTitleCol["保險別"]]
		, ExamName:=Trim(row[reportListTitleCol["檢查名稱"]])
		, ExamDate:=SubStr(RegExReplace(row[reportListTitleCol["檢查日"]], "\D", ""), 1, 8)

				;~ ToolTip % "Loading PACS history: " ChartNo
				;~ 6______
				PacsCTHx:=patientBasicInfoWebTree(patientBasicInfoWeb(chartNo, sid)).getNodeByNames("置頂","報告","影核醫報告").arr
				, parts:=0
				for k,v in PacsCTHx {
					RegExMatch(v.innerText,"is)^([\d\/]{10})\_(.+)", match)
					,match1:=RegExReplace(match1, "\D", "")
					
					if (ExamDate=match1 && match2~="^CT") || ((ExamName~="i)low dose (lung|chest)") && (match2~="i)low dose (lung|chest)"))
						parts++
					else if (ExamDate>match1)
						break
				}
				;~ MsgBox % parts
				if(parts!=0){
					;~ clipboard:=ChartNo
					;~ MsgBox % "error"
					;~ if stop
						;~ ExitApp
					;~ else 
						;~ SetTimer,<searching,-100
					;~ Pacs2YrHx:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))
					Pacs2YrHx:=(RisReport2Yr(sid, chartNo))
					if(Pacs2YrHx~="i)(bone|lung|pulmonary) +metastas")
						mets:=true
					if(Pacs2YrHx~="i)operative|post[- ]?op|lobectomy|(wedge +resection)|segmentectomy|pneumonectomy")
						op:=true
					 
					;~ RisListNewResult[AccNo]:=[searchInd, parts, pointsArr[ExamName]*(InStr(Pay, "自費")&&!(ExamName~="i)low dose (lung|chest)")?1.3:1)/parts/10*0.2, !!mets, !!op]
					return [AccNo, searchInd, parts, pointsArr[ExamName]*(InStr(Pay, "自費")&&!(ExamName~="i)low dose (lung|chest)")?1.3:1)/parts/10*0.2, !!mets, !!op]
					
					
					break
				}
				;~ MsgBox % ExploreObj(ahkSelf)
				;~ ahkSelf.Func("searching_onData", jxon_dump([parts, AccNo, pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/parts/10*0.2]))
				;~ ahkSelf.sub("test")
				;~ RisListInfo[AccNo]:=parts
				;~ ,LV_Edit(colNo.AccNo, AccNo, colNo.Points
					;~ , pointsArr[ExamName]*(InStr(Pay, "自費")?1.3:1)/parts/10*0.2)
				;~ FileAppend,% AccNo "," parts "`n",% hxFile,utf-8
				;~ ToolTip
				;~ Pacs2YrHx:=parseRisReport2Yr(RisReport2Yr(sid, chartNo))

		;~ if !(++searchInd > reportList.maxindex()) || (stop)
			;~ ExitApp
		;~ else
			;~ SetTimer,<searching,-100
			ToolTip
		}
return 
searching>:
return

}


; not used
RisListRefresh(){
	global RisListNewResult, colNo, RisListInfo, hxFile
	SetFormat,FloatFast,0.1
	
	;~ ToolTip % clipboard:=ExploreObj(RisListNewResult)
	
	if(RisListNewResult.SetCapacity(0)=0){
		SetTimer,RisListRefresh,-1000
		return
	}
	
	toBeDel:=[]
	for AccNo, v in RisListNewResult {
		if AccNo=
			continue
		ToolTip % "Set value for AccNo: " AccNo
		,tmp:=[]
		,tmp[colNo.Points]:=v[3]
		,tmp[colNo.mets]:=v[4]
		,tmp[colNo.Op]:=v[5]
		,tmp[colNo.OpdDate]:=dateConv(v[7])
		,tmp[colNo.Stable]:=v[8]
		,LV_Edit(colNo.AccNo, AccNo, tmp)
		,toBeDel.push(AccNo)
		,RisListInfo[AccNo]:={parts: v[2], mets: v[4], op: v[5], ldct: v[6], OpdDate: v[7], Stable: v[8]}
		FileAppend,% AccNo "," v[2] "," v[4] "," v[5] "," v[6] "," v[7] "," v[8]  "`n",% hxFile,utf-8
	}
	ToolTip 
	for k,v in toBeDel
		RisListNewResult.delete(v)
	
	SetTimer,RisListRefresh,-500
}

LV_Edit(matchCol, matchValue, ColValPair){ ;EditCol, EditValue){
	local v, x, y, dr
	static lastInd:=0
	Critical
	
	SetFormat,FloatFast,0.1	
	if matchValue=
		return
	Loop % LV_GetCount()-lastInd+1 {
		LV_GetText(v, A_Index + lastInd -1, matchCol)
		
		if(v=matchValue){
			lastInd:=A_Index + lastInd -1
			for x,y in ColValPair
				LV_Modify(lastInd, "Col" x, y)
			return lastInd
		}
	}
	Loop % lastInd-1 {
		LV_GetText(v, A_Index, matchCol)
		if(v=matchValue){
			lastInd:=A_Index + lastInd -1
			for x,y in ColValPair
				LV_Modify(lastInd, "Col" x, y)
			return lastInd
		}
	
	}
}

shortenTime(timeStr){ ; yyyy/mm/dd hh:mm
	str:=""
	if !RegExMatch(timeStr, "(\d+)/(\d+)/(\d+) (\d+):(\d+)", match)
		return
	
	datefrom := match1 match2 match3
	,distance := dateto := A_YYYY a_mm a_dd
	,distance -= datefrom, days
	
	if (distance =0 || (datefrom=A_YYYY a_mm a_dd))
		return match4 ":" match5
	else if (distance<4)
		return match2 "/" match3 " " match4 ":" match5
	else if (distance<30)
		return match2 "/" match3
	else
		return match1 "/" match2
		
}


RowEvent(src_row, eventName){
	global cols, colNo, RisActiveInfo
	static priorRow
	for k,v in colNo
		%k%:=Trim(src_row.cells[v].innerText)
	cells:=src_row.cells
	,RisActiveInfo[getRisAccNo((RisState:=RisOpened())[2])]:=getRisStudyState(RisState[2])
	
	if InStr(eventName, "DblClick"){
		SetTimerF("singleClick", 0)
		urgentReportClick:=-1
		PostMessage,0x1001,,,,ahk_exe urgentReport.exe
		
		if (RisState[1]=2){
			winactivate,% "ahk_id " RisState[2]
			thisAccNo:=AccNo, thisChartNo:=chartNo
			,searchRisChartNo(RisState[2],AccNo=""?chartNo:AccNo, chartNo)

			if(AccNo!=""){
				GuiControlGet,AutoOpen,,AutoOpen
				if (autoopen && ics_hwnd:=WinExist("ahk_exe ImpaxContextServer.exe" )){
					ImpaxContextServer_Add(AccNo, true, ics_hwnd)
					,ImpaxContextServer_Show(AccNo, ics_hwnd)
				}
				SelectCTClick:=1
				,ClickFirstResult(AccNo)
			}
				
				
		}else{
			clipboard:=ChartNo
			ToolTip % "Chart No copied!"
			settimer,ToolTip,-2000
		}
	}else if InStr(eventName, "ContextMenu"){
		
	}else if InStr(eventName, "Click"){
		SetTimerF("singleClick",-400,[src_row])
	}
}



LVClick:
;~ ToolTip % A_GuiEvent
;~ Sleep 500
EventInfo:=A_EventInfo
, guievent:=A_GuiEvent
LVClick1:
if !EventInfo 
	return

LV_GetText(getAccNo, EventInfo, colNo.AccNo)
,LV_GetText(getChartNo, EventInfo, colNo.ChartNo)
,priorRow:=EventInfo
,RisActiveInfo[getRisAccNo((RisState:=RisOpened())[2])]:=getRisStudyState(RisState[2])
if (guiEvent="DoubleClick" ){
	SetTimer,singleClick,Off
	urgentReportClick:=-1
	PostMessage,0x1001,,,,ahk_exe urgentReport.exe
	if (RisOpened()[1]=2){
		winactivate,% "ahk_id " RisOpened()[2]
		thisAccNo:=getAccNo, thisChartNo:=getChartNo
		,searchRisChartNo(RisOpened()[2],getAccNo=""?getChartNo:getAccNo, getChartNo)
		if EventInfo
			thisRow:=EventInfo
		;~ FileAppend,% EventInfo "," guiEvent "," A_EventInfo "," A_GuiEvent "," thisRow "," getAccNo "," getChartNo "`n", test.log,utf-8
		;~ ToolTip % thisRow
		if(getAccNo!=""){
			GuiControlGet,AutoOpen,,AutoOpen
			if (autoopen && ics_hwnd:=WinExist("ahk_exe ImpaxContextServer.exe" )){
				ImpaxContextServer_Add(getAccNo, true, ics_hwnd)
				,ImpaxContextServer_Show(getAccNo, ics_hwnd)
			}
			SelectCTClick:=1
			,ClickFirstResult(getAccNo)
		}
			
			
	}else{
		clipboard:=getChartNo
		ToolTip % "Chart No copied!"
		settimer,ToolTip,-2000
	}
	
}else if (guiEvent="RightClick"){
	
}else if (guiEvent="Normal"){
	SetTimer,singleClick,-500
}else if (guiEvent="ColClick"){
	SetTimer,RedrawColor,-500
}else{
	ToolTip
}
return

RedrawColor(){
	global wb
	js=javascript:$('table tbody tr').removeClass('grayText');void 0;
	wb.Navigate(js)
}

quitPwb(pwb){
	try 
		pwb.quit()
}



ClickFirstResult(AccNo){
	global reportListTitleCol
	WinWaitActive,% "ahk_id " RisOpened()[2],,3
	parseDataGrid(RisListRowsAcc:=acc_children(acc_objectfromwindow(RisListHwnd:=getRisList(RisOpened()[2])))
		,reportListTmp:=[], 1, 2)
	if (Trim(reportListTmp[2, reportListTitleCol["照會單號"]])=AccNo){
		loc:=acc_location(RisListRowsAcc[2])
		mouseclick,l,% loc.x+100,% loc.y+10,2,0
	}
}

singleClick(row){
	global colNo
	ToolTip % row.cells[colNo.ExamName].innerText
	SetTimer, ToolTip, -2000
	
}

singleClick:
ToolTip % priorRow.cells[colNo.ExamName].innerText
SetTimer, ToolTip, -2000
return

WrapText(str, WrapLen=25){
	s:="", l:=StrLen(str)
	Loop % q:=Floor(l/WrapLen) 
		s.=SubStr(str, WrapLen*(A_Index-1)+1, WrapLen) "`n"
	
	if (l-q*WrapLen<4)
		s:=SubStr(s, 1, -1)
	s.= SubStr(str, WrapLen*q+1) 
	return s
}

~LButton:
ToolTip
return

ToolTip:
ToolTip
return

GuiClose:
gui,Destroy
OnExit:
ObjRelease(pipa)
ExitApp
no_wrt:=true
;~ esc::
searchingTh.terminate()
while WinExist("ahk_exe selectCT_Query.exe")
	WinClose,ahk_exe selectCT_Query.exe
for k,v in openedIE
	try
	v.quit()
;~ FileGetSize,filesize,% RisListInfoPath:=A_ScriptDir "\RisListInfo.txt",k
;~ if (filesize>100){
	;~ ToolTip % "Clean up RisListInfo.txt"
	;~ str1:=str2:=""
	;~ fileread,RisInfoTxt,% RisListInfoPath
	;~ Loop,parse,RisInfoTxt,`n,`r
	;~ {
		;~ str2.=A_LoopField "`n"
		;~ if(A_Index=3000)
			;~ str1:=str2, str2:=""
	;~ }
	;~ FileDelete,% RisListInfoPath
	;~ FileAppend,% str2,% RisListInfoPath,utf-8
	;~ FileAppend,% str1,% A_ScriptDir "\RisListInfo_" a_now,utf-8
;~ }
for AccNo, lineText in needRefresh
	FileAppend,% lineText,% hxFile,utf-8
ExitApp


extractTitleCol(ByRef reportListFirstRow, ByRef reportListTitleCol){
	for k,v in reportListFirstRow
		if Trim(v)!=""
			reportListTitleCol[v]:=k
}


pointsDef:
pointsArr:={"CT With/Without Contrast-Chest": 5035
	, "CT With Contrast-Chest": 4560
	, "CT Without Contrast-Chest": 3800 
	, "Low dose lung cancer screening CT": 6000 
	, "Low dose lung cancer screening CT for employee(N Hospital)": 6000 
	, "CT Without Contrast for low dose lung cancer screening": 6000 }

return


loadHx:
hxFile:=A_ScriptDir "\RisListInfo.txt"
fileread,RisListInfoTxt,% hxFile
RisListInfo:=[]
cleaned:=""
i:=0
Loop,parse,RisListInfoTxt,`n,`r
	if RegExMatch(A_LoopField, "i)([TY]\w{9}\d),(\d+),(\d),(\d),(\d),(\d+),([^,]*)(?:,(\d))?", match)
		if (match2!="" && match3!="" && match4!="" && match5!="") && (match6="" || !studyTooOld(match6))
			RisListInfo[match1]:={parts: match2, mets: match3, op: match4, ldct: match5, ExamDate: match6, Stable: match8, OpdDate: match7}
			;~ ,cleaned.=(match7=""? A_LoopField :SubStr(A_LoopField,1,(-1)*StrLen(match7)) cleanedOpd) "`r`n"
			,i++
		else
			i++

return


~*F3::
SetTimer,activateCheck,-500
return


AutoOpenNext:
GuiControlGet,AutoOpenNext,,AutoOpen
if !AutoOpenNext 
	return
SetTimer,clickNext,-100
return

clickNext:
guiEvent:="DoubleClick"
,EventInfo:=NextRow:=thisRow+1
gosub LVClick1

LV_Modify(thisRow, "Select")
,LV_Modify(thisRow, "focus")
,LV_Modify(thisRow-1, "-Select")
,LV_Modify(thisRow-1, "-focus")
SetTimer,setNextRow,-500
return
setNextRow:
thisRow:=NextRow
return

activateCheck:
RisActiveInfo[getRisAccNo((RisState:=RisOpened())[2])]:=getRisStudyState(RisState[2])
winget,ProcessName,ProcessName,A
;~ ToolTip % ProcessName
if((ProcessName~="Menu.exe|simpleRIS.exe") && SelectCTClick){
	SelectCTClick:=0
	SetTimer,autoopennext,-1
	gosub activate
}
return

;~ #IfWinActive,ahk_exe Menu.exe
;~ ~*F3::
;~ F3:
;~ if (urgentReportClick=1 || !SelectCTClick)
	;~ return
;~ settimer,activate,-500
;~ SelectCTClick:=0
;~ return
;~ #IfWinActive

;~ #IfWinActive,simple RIS ahk_class AutoHotkeyGUI
;~ ~*F3::
;~ gosub F3
;~ return
;~ #IfWinActive


activate:
winactivate,ahk_id %guihwnd%
WinGetPos,x,y,w,h,ahk_id %guihwnd%
MouseMove,% x+Floor(w/2),% y+30,0
return


dt_add(row, col_data*){
	global wb, cols
	
	js=javascript:addRow([
	Loop % cols.maxindex()
		js.="'" col_data[A_Index] "',"
	js:=SubStr(js,1,-1) "]);void 0;"
	wb.Navigate(js)
	loop
	 Sleep 100
	until !WB.busy
}
;~ dt_add(row, col_data*){
	;~ global wb, cols, updateJs
	;~ js=javascript:$('table tbody').append('<tr>
	;~ Loop % cols.maxindex()
		;~ js.="<td>" col_data[A_Index] "</td>"
	;~ js.="</tr>');" updateJs "void 0;"
	;~ wb.Navigate(js)
;~ }
dt_delete(rowNumber=""){
	global wb, cols
	js=javascript:dt.find('tbody tr').remove();void 0;
	wb.Navigate(js)
	loop
	  If !WB.busy
		 break
}


Doc_OnClick(doc) {
	;~ ToolTip LButton
    src:=doc.parentWindow.event.srcElement
	if (src.tagName="TD")
		src:=src.parentNode
	if(src.tagName="TR"){
		RowEvent(src, A_ThisFunc)
	}
}
Doc_OnDblClick(doc) {
	;~ ToolTip double click
    src:=doc.parentWindow.event.srcElement
	if (src.tagName="TD")
		src:=src.parentNode
	if(src.tagName="TR"){
		RowEvent(src, A_ThisFunc)
	}
}
Doc_OnContextMenu(doc) {
	;~ ToolTip RButton
    src:=doc.parentWindow.event.srcElement
	if (src.tagName="TD")
		src:=src.parentNode
	if(src.tagName="TR"){
		RowEvent(src, A_ThisFunc)
	}
	return false
}




dt_modifyCell(rowNo, colNo, value){
	global WB
	
	;~ js:="javascript:(function(){var td=__rows.eq(" rowNo ").find('td').eq(" colNo ");dt.cell(td.get()).data('" value "');})();void 0;"
	js:="javascript:$('#dataTable tbody tr:nth-child(" rowNo+1 ") td:nth-child(" colNo+1 ")').text('" value "');void 0;"
	;~ js:="javascript:dt.cell(" rowNo "," colNo ").data('" value "');void 0;"
	WB.Navigate(js)
	ToolTip % js
	Sleep 100
}
