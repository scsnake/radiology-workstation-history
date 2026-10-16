/*
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
#include <portalLib>
#include <RISIMPAX>
#include <SetBtnTxtColor>
#include <EditFunctions>
;~ #include <Scrollable GUI>
InitWorkerThread()
onexit,onexit


;~ goto main

gui,font,s10,微軟正黑體
gui,font,s10,Verdana
gui,add,text,,Portal帳號
gui,add,edit,vloginid xp+120,
gui,add,text,xs,Portal密碼
gui,add,edit,vloginpw xp+120 Password,
gui,add,text,xs,檢查室
gui,add,DropDownList,vexamType xp+120,CT||MRI
gui,add,button,xs ggo,登入


gui,show,autosize,Portal登入


return

#ifwinactive,Portal登入 ahk_class AutoHotkeyGUI
go:
numpadenter::
enter::
gui,submit,nohide
loginId:=trim(loginId),loginPw:=trim(loginPw)
if (loginId=""){
	guicontrol,focus,loginid
	return
}
if (loginpw=""){
	guicontrol,focus,loginpw
	return
}
gui,hide
if(!sid:=login(loginid,loginpw)){
	gui,show,autosize
	guicontrol,focus,loginId
	return
}else{
	settimer,renewSid,600000
	gui,destroy
	gosub main
}
return
#ifwinactive

main:
patients:=[]
settimer,routine,-1
;~ settimer,updateGrid,60000
return

renewSid:
sid:=renewSid(sid,loginid,loginpw)
return




routine:
risstate:=risopened()
if (risstate:=risopened())[1]!=2 {
	tooltip % "RIS not opened !!"
	settimer,tooltip,-2000
	gosub updateGUI
	return
}

if (pRisState[2]=RisState[2] || !(pRisState:=RisState.clone()))
	return
	
regList:=getNetControl2(risstate[2],"","fRegistryList","登錄作業清單")
if regList.maxIndex()<1 {
	tooltip % "登錄作業清單 not opened !!"
	settimer,tooltip,-2000
	gosub updateGUI
	return
}
regList:=regList[1]
settimer,routine,-10000
if (pregList=regList || !(pregList:=regList))
	return
updateGrid:
if (risstate[1]=2){
	grid:=getNetControl2(regList,"","B","DataGridView")
	if grid.maxIndex()<1 {
		tooltip % "登錄作業清單 not found !!"
		return
	}
	grid:=acc_objectfromwindow(grid[1])

	table:=parseGrid(grid)

	if (equal(ptable,table) || !(pTable:=table.clone())) && !(refreshing)
		return
	else
		gosub updateGUI
}else{
	gosub updateGUI
}
return

refresh:
refreshing:=1
gosub updateGrid
return

tooltip:
ToolTip
return

;~ GuiSize:
;~ if scrollable
    ;~ UpdateScrollBars(A_Gui, A_GuiWidth, A_GuiHeight)
;~ return


analyzeSavedSheetNo(workerThread,patients,sid,ind,lst){
	for k,v in patients {
		if (a_index<ind)
			continue
		else if (a_index>lst)
			break
		
		status:=0
		for x,y in v.2 {
			if a_index=1
				activeSheetNo:=x
			httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportSheet.aspx?SystemID=17&SheetNo=" x "&cid=btnQuery&SESSION=" sid,post:="",header:="","charset: utf-8")
			if(instr(post,"已儲存尚未發報告")){
				activeSheetNo:=x
				status:=1
				;~ break
			}else if RegExMatch(post,"lblStatus[^<]+住院醫師確認"){
				activeSheetNo:=x
				status:=2
				break
			}
		}
		;~ msgbox % activeSheetNo "," status
		patients[k,4]:=activeSheetNo
		patients[k,5]:=status
	}
	return [patients,ind,lst]
}
analyzeSavedSheetNo_onFinish(workerThread,result){
	global 
	
	for k,v in result.1 {
		if (a_index<result.2)
			continue
		else if (a_index>result.3)
			break
		
		patients[k,4]:=result[1,k,4]
		patients[k,5]:=result[1,k,5]
		
		if(v.5=2)
			SetBtnTxtColor2(a_index,"green")
		else if (v.5=1)
			SetBtnTxtColor2(a_index,"red")
		else if(v.3>0 && v.3<3)
			SetBtnTxtColor2(a_index,"888888")
		else if (v.3>2)
			SetBtnTxtColor2(a_index,"AAAAAA")
	}
	;~ tooltip % result.2 "," result.3
}

SetBtnTxtColor2(buttonNo,newcolor){
	global
	SetBtnTxtColor(buttonId%buttonNo%,newcolor)
	GuiControl, MoveDraw,button%buttonNo%
}

updateGUI:
refreshing:=0

;~ patients:=[]
chartNoCol:=ptable["columns","病歷號"]
nameCol:=ptable["columns","姓名"]
sheetNoCol:=ptable["columns","照會單號"]
cnt:=0

/*
patients[chartNo]=	name,
					[sheetNo1,sheetNo2,...],
					clickTimes,
					savedSheetNo,
					status: 0, 1(temp), 2(saved)
					
*/

for k,v in ptable
	if (k!="columns" && trim(v[chartNoCol])!="" && trim(v[nameCol])!="" && trim(v[sheetNoCol])!="" && !instr(v[nameCol],"null")){
		if ! patients[v[chartNoCol]]
			patients[v[chartNoCol]]:=[v[nameCol], [], 0, 0, 0]
		patients[v[chartNoCol],2,"" v[sheetNoCol]]:=1
	}

cnt:=0
for k,v in patients
	++cnt

ind:=1
loop % 10 {
	lst:=ind+floor(cnt/10)
	if lst>cnt
		lst:=cnt
	if ind>cnt
		break
	WorkerThread%a_index%:=new CWorkerThread("analyzeSavedSheetNo", 0, 0, 1)
	WorkerThread%a_index%.OnFinish.Handler := "analyzeSavedSheetNo_onFinish"
	WorkerThread%a_index%.Start(patients,sid,ind,lst)	
	ind:=lst+1
}
;~ WorkerThread:=new CWorkerThread("analyzeSavedSheetNo", 0, 0, 1)
;~ WorkerThread.OnFinish.Handler := "analyzeSavedSheetNo_onFinish"
;~ WorkerThread.Start(patients,sid)

	
shown:=guihwnd=""||winactive("ahk_id " guihwnd)?"":"minimize"
gui,destroy
gui,+hwndguihwnd 

;~ if (scrollable:=cnt>20?1:0) {
	;~ OnMessage(0x115, "OnScroll") ; WM_VSCROLL
	;~ Gui, +Resize +0x200000 +hwndguihwnd 
	
	;~ hotkey,ifwinactive,ahk_group MyGui
	;~ hotkey,WheelUp,scrollGUI,on
	;~ hotkey,WheelDown,scrollGUI,on
	;~ hotkey,ifwinactive,

;~ }else{
	;~ gui,+hwndguihwnd 
	;~ OnMessage(0x115, "") 
	;~ hotkey,ifwinactive,ahk_group MyGui
	;~ hotkey,WheelUp,scrollGUI,off
	;~ hotkey,WheelDown,scrollGUI,off
	;~ hotkey,ifwinactive,
;~ }
;~ GroupAdd, MyGui, % "ahk_id " guiHwnd



links:=[]
for k,v in patients {
	
	
	if mod(a_index-1,8)=0
		xset:="xs yp+30"
	else
		xset:="xp+150 yp"
	
	gui,add,button,glink vbutton%a_index% %xset% hwndbuttonId%a_index%,% strlen(s:=fill0(k,7) " " v.1)>13?substr(s,1,13) "...":s

	;~ if(v.5=2)
		;~ SetBtnTxtColor(buttonId%a_index%,"green")
	;~ else if (v.5=1)
		;~ SetBtnTxtColor(buttonId%a_index%,"yellow")
	;~ else if(v.3>0 && v.3<3)
		;~ SetBtnTxtColor(buttonId%a_index%,"888888")
	;~ else if (v.3>2)
		;~ SetBtnTxtColor(buttonId%a_index%,"AAAAAA")

	links.push([k, v.2])

}



gui,font,s8,Verdana
gui,add,text,xs y+25,病歷號
gui,add,edit,vchartNo yp xp+80,
gui,add,button,gquery yp xp+150 default,查詢
guicontrol,focus,chartNo

gui,add,button,grefresh vrefresh yp x+200,更新清單(60)
countSec:=60
settimer,countDown,1000
settimer,refresh,60000
gui,show,autosize %shown%,已報到病人清單


return

scrollGUI:
;~ if scrollable
    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
    ;~ OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, 0x115, WinExist())
return


countDown:
guicontrol,,refresh,% "更新清單(" --countSec ")"
return

query:
gui,submit,nohide
chartNo:=trim(chartNo)
sch:=new parseRisSchedule(getRisSchedule(sid,ChartNo))
formattime,todayDate,% a_now,yyyy/MM/dd
sch:=sch.query([["Date",todayDate],["OrderName",examType " with"]])
if(sch.maxIndex()<1){
	msgbox,,,無今日檢查,5
	run % "iexplore.exe http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx?SESSION=" sid
	settimer,setfocus,-1
}else
	run % "iexplore.exe http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportSheet.aspx?SystemID=17&SheetNo=" sch[1,"SheetNo"] "&cid=btnQuery&SESSION=" sid
return

setfocus:
Loop
	sleep 200
until (targetIE:=IEGet("檢查報告系統","hisaw.hospital-n.local/WebApplication/InspectionReport/ReportOfCase.aspx")) || a_index>50
if !targetIE
	return
loop 
	sleep 200
until !targetIE.busy
targetIE.document.getElementById("ucQueryHandler_QueryTab_QueryFromScheduling_txbQueryPat").focus()
return


link:
clicked:=++patients[links[which:=substr(a_guicontrol,7),1],3]
;~ gosub updateGUI
if(clicked=1)
	SetBtnTxtColor(buttonId%which%,"888888")

if !(activeSheetNo:=patients[links[which,1],4]){
	this_status:=0
	for x,y in links[which,2] {
		if a_index=1
			activeSheetNo:=x
		httprequest("http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportSheet.aspx?SystemID=17&SheetNo=" x "&cid=btnQuery&SESSION=" sid,post:="",header:="","charset: utf-8")
		if(instr(post,"已儲存尚未發報告")){
			activeSheetNo:=x
			this_status:=1
			;~ break
		}else if RegExMatch(post,"lblStatus[^<]+住院醫師確認"){
			activeSheetNo:=x
			this_status:=2
			break
		}
	}
	patients[links[which,1],4]:=activeSheetNo
	patients[links[which,1],5]:=this_status
}


if (IE:=IEGet("檢查報告系統",activeSheetNo))
	winactivate,% "ahk_id " IE.hwnd
else 
	run % "iexplore.exe http://hisaw.hospital-n.local/WebApplication/InspectionReport/ReportSheet.aspx?SystemID=17&SheetNo=" activeSheetNo "&cid=btnQuery&SESSION=" sid
return

equal(byref a,byref b){
	arr1:=[]
	arr2:=[]
	chartNoColA:=a["columns","病歷號"]
	chartNoColB:=b["columns","病歷號"]
	for k,v in a
		if k is number
			arr1["" v[chartNoColA]]:=1
	for k,v in b
		if k is number
			arr2["" v[chartNoColB]]:=1
	
	str1:=str2:=""
	for k,v in arr1
		str1.=k ","
	for k,v in arr2
		str2.=k ","
	
	return str1=str2?1:0
	
}


parseGrid(acc){
	arr:=[]
	
	for k,v in rows:=acc_children(acc) {
		if (k=1) {
			for x,y in cells:=acc_children(v)
				if x>1
					arr["columns",y.accValue]:=x
		}else{
			for x,y in cells:=acc_children(v)
				if x>1
					arr[k-1,x]:=y.accValue
		}
	
	}
	
	return arr
}


;~ parseGrid(acc){
	;~ global __count,__outputArr
	;~ __outputArr:=[]
	
	;~ rows:=acc_children(acc)
	;~ __count:=rows.maxIndex()
	
	;~ for k,v in rows {
		;~ if (k=1) {
			;~ for x,y in cells:=acc_children(v)
				;~ if x>1
					;~ __outputArr["columns",y.accValue]:=x
		;~ }else{
			;~ settimerF("parseRow",-1,[k,v,__outputArr,__count],0)
		;~ }
	
	;~ }
	
	;~ Loop {
		;~ sleep 200
		;~ tooltip % __count
	;~ }until __count=0
	
	;~ return __outputArr
;~ }

;~ parseRow(k,byref rowAcc){
	;~ global __count,__outputArr
	
	;~ for x,y in cells:=acc_children(rowAcc)
		;~ if x>1
			;~ __outputArr[k-1,x]:=y.accValue
		
	;~ --__count
				
;~ }


parseChild(obj){
	global target
	if (acc_windowfromobject(obj)=target){
		msgbox % test:=acc_windowfromobject(acc_parent(obj))
		return test
	}
	if acc_children(obj).length>0 {
		loop % acc_children(obj).length
			if parseChild(acc_children(obj)[a_index])
				break
	}
	
}

~^c::
if(a_thishotkey=a_priorhotkey && a_timesincepriorhotkey<500 && winexist("ahk_id " guihwnd) && regexmatch(trim(clipboard),"\w{6}\d",match)){
	guicontrol,,chartNo,% match
	winactivate,ahk_id %guihwnd%
	guicontrol,focus,chartNo
	EditFunc_Select(0,-1,"Edit1","ahk_id " guihwnd)
}
return




guiclose:
MsgBox, 8244, , 確定離開?
ifmsgbox,no
	return
;~ esc::
ExitApp
return



onexit:
ExitApp
return

#include <WorkerThread>
