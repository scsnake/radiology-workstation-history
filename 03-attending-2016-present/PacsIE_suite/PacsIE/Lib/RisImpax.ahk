
#include <.NetGetControl>
;~ #include <WM_COPYDATA>
#include <ImpaxContextServer>
#include <SetTimerF>
;~ #include <EditFunctions>
#include <Edit>
#include <JXON>
#include <monitorInfo>
#include <WM_COPYDATA>
#include <WinVisible>
#include <AltTab_window_list>
#include <HasVal>
#include <getFocusedHwnd>
DetectHiddenWindows,on

;~ SendMessage,4388,,,,ahk_id 0x4c2fc0

;~ SetTitleMatchMode,2
;~ clipboard:=ListControls(2______)
;~ ExitApp
;~ msgbox % risopened()[2]
;~ clipboard:=listcontrols(impaxopened()[2,1])
;~ ExitApp

/*
*/
RisImpaxLoadPw(){
	static fileName:="RisImpaxPw.ini"
	ret:={Ris:[], Impax:[]}
	if FileExist(path:=A_ScriptDir "\" fileName)
		|| FileExist(path:=A_ScriptDir "\..\" fileName)
		|| FileExist(path:=SubStr(A_ScriptDir,1,1) ":scripts\Radiology\" fileName) {
		loop {
			IniRead,user,% path,Ris,% "user" A_Index,% "$%^&*"
			IniRead,pw,% path,Ris,% "pw" A_Index
			if(user!="$%^&*")
				ret.Ris.push({user: user, pw: pw})
			else
				break
		}
		
		loop {
			IniRead,user,% path,Impax,% "user" A_Index,% "$%^&*"
			IniRead,pw,% path,Impax,% "pw" A_Index
			if(user!="$%^&*")
				ret.Impax.push({user: user, pw: pw})
			else
				break
		}
		
		return ret
	}
	
}

RisImpaxPollingInit(){
	static exeNAme:="RisImpaxPolling.exe"
	if (hwnd:=WinExist("RisImpaxPolling_Main ahk_class AutoHotkeyGUI")) || (hwnd:=WinExist("ahk_exe " exeName))
		return hwnd
	if FileExist(path:=A_ScriptDir "\" exeName) || FileExist(path:=A_ScriptDir "\..\" exeName) || FileExist(path:=A_ScriptDir "\RisImpaxPolling\" exeName) || FileExist(path:=A_ScriptDir "\..\RisImpaxPolling\" exeName) || FileExist(path:=SubStr(A_ScriptDir,1,1) ":\scripts\Radiology\RisServer\" exeName)  || FileExist(path:=A_ScriptDir "\..\simpleRIS\" exeName) {
		Run % path
		winwait,% "ahk_exe " exeName,,3
		if !ErrorLevel
			return RisImpaxPollingInit()
	}
	return 0
}

/*
infoJson := [ {app: "Ris"
					, type: "State/AccNo/OldReport"
					, hwnd: thisHwnd
					, msg: {msg: returnMsg, wParam: returnWParam, lParam: returnLParam}
					, func: "funcName"
					, initStart: 1/0/delayMiliSec } 
					, {app: "Impax", type: "State/AccNo", hwnd: thisHwnd, msg: {msg: returnMsg, wParam: returnWParam, lParam: returnLParam}} ]
*/
RisImpaxRegister(infoJson){
	if !(hwnd:=RisImpaxPollingInit()){
		ToolTip % "RisImpaxPolling.exe not found!"
		return 1
	}
	thisHwnd:=WinExist("Ahk_PID " thisPid:=DllCall("GetCurrentProcessId"))
	
	for k,v in infoJson {
		if (v.msg.msg && v.func && v.func!=OnMessage(v.msg.msg))
			OnMessage(v.msg.msg, v.func)
		if (v.func && v.initStart)
			SetTimerF(v.func, (-1)*v.initStart)
		if !WinExist("ahk_id " v.hwnd)
			infoJson[k, "hwnd"]:=thisHwnd
	}
	
	Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))
	,SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])
	
}

RisImpaxRegisterMonitor(hwnd, infoJson){
	if !WinExist("ahk_id " hwnd)
		if (hwnd:=RisImpaxPollingInit())
			Send_WM_COPYDATA(hwnd, 0, JXON_Dump(infoJson))
			,SetTimerF("RisImpaxRegisterMonitor", 0)
			,SetTimerF("RisImpaxRegisterMonitor", 30000, [hwnd, infoJson])
}

RisImpaxMsgProtocol(){
	global
	local k,v
	registerRisChangeMsg:=[0x1000, 0x1003]
	,registerRisChangeItem:=["ris", "risAcc", "risReport", "risOldReport"]
	,registerImpaxChangeMsg:=[0x2000,0x2001]
	,registerImpaxChangeItem:=["impax", "impaxAcc"]
	,RisImpaxChangeMsg2Item:=[]
	,RisImpaxChangeItem2Msg:=[]
	
	loop % registerRisChangeMsg.2-registerRisChangeMsg.1+1 {
		RisImpaxChangeMsg2Item[registerRisChangeMsg.1+A_Index-1]:=registerRisChangeItem[A_Index]
		,RisImpaxChangeItem2Msg[registerRisChangeItem[A_Index]]:=registerRisChangeMsg.1+A_Index-1
	}
	loop % registerImpaxChangeMsg.2-registerImpaxChangeMsg.1+1 {
		RisImpaxChangeMsg2Item[registerImpaxChangeMsg.1+A_Index-1]:=registerImpaxChangeItem[A_Index]
		,RisImpaxChangeItem2Msg[registerImpaxChangeItem[A_Index]]:=registerImpaxChangeMsg.1+A_Index-1
	}

}


checkRIS(byref RisState,refresh=1){
	SetTitleMatchMode,2
	winget,winList,list,放射線資訊管理系統(Radiology Information System)
	match:=0
	loop % winList
	{
		wingetclass, winClass,% "ahk_id " id:=winList%a_index%
		if instr(winClass,"WindowsForms10.Window.8.app.") && id=RisState[2] {
			match:=1
			break
		}
	}
	if (!match && refresh){
		if !IsObject(RisState)
			RisState:=[]
		for k,v in RisOpened()
			RisState[k]:=v
	}
	return match
}



/* check if RIS opened
	[0, 0]: no
	[1, HWND]: wait for login
	[2, HWND]: opened
	
	
	for multiple RIS
		1: [HWNDs]
	2: [HWNDs]
*/

;~ MsgBox % exploreobj(risOpened())
;~ ExitApp
;~ msgbox % dllcall("IsHungAppWindow", "UInt", risopened()[2])

RisOpened(allRis=0)
{
	;~ if (A_TitleMatchMode!=2){
		;~ oldTitleMatchMode:=A_TitleMatchMode
		;~ SetTitleMatchMode,2
	;~ }
	;~ if( A_DetectHiddenWindows!="on" ){
		;~ oldDetectHiddenWindows:=A_DetectHiddenWindows
		;~ detectHiddenWindows,on
	;~ }	
	
	alttabList:=AltTab_window_list()
	if(allRis=0){
		
		
		for k,v in alttabList
			if InStr(v.title, "放射線資訊管理系統(Radiology Information System)"){
				winget,pname,ProcessName,% "ahk_id " v.hwnd
				if (pname="Menu.exe"){
					return Array(2, v.hwnd)
				}
			}
		;~ for k,v in alttabList
			;~ if InStr(v.title, "RIS系統登入<<陽明資訊>>"){
				;~ winget,pname,ProcessName,% "ahk_id " v.hwnd
				;~ if (pname="Menu.exe"){
					;~ return Array(1, v.hwnd)
				;~ }
			;~ }
		
		
		winget,winList,list,放射線資訊管理系統(Radiology Information System)
		winget,activeWin,id,A
		loop % winList
		{
			if !winvisible(winList%a_index%)
				continue
			wingetclass, winClass,% "ahk_id " winList%a_index%
			if instr(winClass,"WindowsForms10.Window.8.app."){
				return array(2,winList%a_index%)
				
			}
		}
		
		winget,winList,list,RIS系統登入<<陽明資訊>>
		loop % winList
		{
			if !winvisible(winList%a_index%)
				continue
			wingetclass, winClass,% "ahk_id " winList%a_index%
			if instr(winClass,"WindowsForms10.Window.8.app."){
				return array(1,winList%a_index%)
				
			}
		}
		
		return array(0,0)
	}else{
		
		
		ret:=[[],[]]
		;~ ,arr1:=[], arr2:=[]
		;~ ,ret[2]:=[]
		for k,v in alttabList
			if InStr(v.title, "放射線資訊管理系統(Radiology Information System)") {
				winget,pname,ProcessName,% "ahk_id " v.hwnd
				if(pname="Menu.exe")
					ret[2].push(v.hwnd)
			}
		
		winget,winList,list,放射線資訊管理系統(Radiology Information System) ahk_exe Menu.exe
		loop % winList
			;~ if dllcall("IsHungAppWindow", "Ptr", winList%a_index%)
				;~ process,close,% "ahk_id " winList%a_index%
		;~ else if(winvisible(winList%a_index%))
			;~ arr1.push(winList%a_index%)
		;~ else
			;~ if !winvisible(winList%a_index%)
			if !HasVal(ret[2], hwnd:=winList%a_index%)
				ret[2].push(hwnd)
		
		;~ ret[2]:=[]
		;~ for k,v in arr1
			;~ ret[2].push(v)
		;~ for k,v in arr2
			;~ ret[2].push(v)
		
		;~ ret[1]:=[]
		for k,v in alttabList
			if InStr(v.title, "RIS系統登入<<陽明資訊>>") {
				winget,pname,ProcessName,% "ahk_id " v.hwnd
				if(pname="Menu.exe")
					ret[1].push(v.hwnd)
			}
		winget,winList,list,RIS系統登入<<陽明資訊>> ahk_exe Menu.exe
		loop % winList
			if !HasVal(ret[1], hwnd:=winList%a_index%)
				ret[1].push(hwnd)
		
		
	}
	
	;~ if(oldTitleMatchMode)
		;~ SetTitleMatchMode,% oldTitleMatchMode
	;~ if(oldDetectHiddenWindows)
		;~ DetectHiddenWindows,% oldDetectHiddenWindows
	
	
	return ret
	
	
}

GetControls(hwnd, controls="")
{
	if !isobject(controls)
		controls:=[]
	
	if isobject(hwnd){
		for k,v in hwnd 
			controls:=GetControls(v, controls)
		return controls
	}
	
	winget,classnn,ControlList,ahk_id %hwnd%
	winget,controlId,controllisthwnd,ahk_id %hwnd%
	loop,parse,classnn,`n
	{
		controls[a_index]:=[]
		controls[a_index]["ClassNN"]:=a_loopfield
	}
	
	loop,parse,controlId,`n
	{
		controls[a_index]["Hwnd"]:=a_loopfield
		controlgetText,txt,,ahk_id %a_loopfield%
		controls[a_index]["text"]:=txt
	}
	return controls
}

GetOtherControl(refHwnd,shift,controls,type="hwnd"){
	for k,v in controls
		if v[type]=refHwnd
			return controls[k+shift].hwnd
}

/* check if IMPAX opened
	arr[1]=0	no IMPAX
	arr[1]=1, arr[2,1]=hwnd of login window
	arr[1]=2, arr[2,1]=hwnd of image window
	arr[1]=2, arr[2,2]=hwnd of list & text window
	arr[1]=2, arr[2,3]=hwnd of list window
	arr[1]=2, arr[2,4]=which type of active IMPAX window (1:image, 2:list, 3:text)
	arr[1]=2, arr[2,5]=which configuration of IMPAX windows (1 for one window, 2 for double window)
*/
ImpaxOpened()
{
	winget,ImpaxIdList,list,ahk_class WindowsForms10.Window.8.app.0.2bf8098
	winget,activeWin,id,A
	arr:=[],ind1:=ind2:=ind3:=0,a1:=a2:=a3:=0
	arr[1]:=0
	loop 5
		arr[2,a_index]:=0
	
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if ind:=instr(text,"STUDY_NAV_TOOLBAR0"){
			ind1:=ind,a1:=a_index,arr[2,1]:=id
			;~ if((arr[2,1]:=id)=activeWin)
				;~ arr[2,4]:=1
			
		}
		if((instr(text,"工作清單")&&instr(text,"相關性")&&instr(text,"更新"))||(instr(text,"Worklists")&&instr(text,"Relevance")&&instr(text,"Refresh"))){
			if((instr(text,"臨床資訊")&&instr(text,"RIS 狀態")&&instr(text,"病患 HIS 代碼"))||(instr(text,"Clinical Information")&&instr(text,"RIS Status")&&instr(text,"Patient HIS Code"))){
			ind2:=instr(text,"臨床資訊")|instr(text,"Clinical Information")
				a2:=a_index,arr[2,2]:=id
				;~ if((arr[2,2]:=id)=activeWin)
					;~ arr[2,4]:=2
			}else{
				ind3:=instr(text,"工作清單")|instr(text,"Worklists")
				a3:=a_index,arr[2,3]:=id
				;~ if((arr[2,3]:=id)=activeWin)
					;~ arr[2,4]:=3
				
			}
		}
		wingetpos,,,,h,ahk_id %id%
		if (maxH<h)
			maxH:=h
	}
	
	h:=maxH
	h-=41
	
	
	if (arr[2,1]||arr[2,2]||arr[2,3]){
		
		arr[1]:=2
		if(arr[2,1]=(arr[2,2]|arr[2,3])){
			arr[2,5]:=1
			
			if ((bar:=impaxBar(arr[2,2]|arr[2,3])).h>h){
				arr[2,4]:=2
			}else if(ind1<(ind2|ind3)){
				arr[2,4]:=1
			}else {
				arr[2,4]:=3
			}
			
			
		}else{
			arr[2,5]:=2
			
			;~ if(arr[2,4]>1&&(impaxBar(arr[2,2]|arr[2,3]).h>h)){
				;~ arr[2,4]:=2
			;~ }else if (arr[2,4]>1&&(impaxBar(arr[2,2]|arr[2,3]).h<=h)){
				;~ arr[2,4]:=3
			;~ }else{
				;~ arr[2,4]:=1
			;~ } 
			
			if(a1<(a2|a3)){
				arr[2,4]:=1
			}else if(impaxBar(arr[2,2]|arr[2,3]).h>h){
				arr[2,4]:=2
			}else{
				arr[2,4]:=3
			}
			
			
		}
		return arr
	}
	
	loop % ImpaxIdList
	{
		id:=ImpaxIdList%a_index%
		wingettext,text,ahk_id %id%
		if (instr(text,"登入") && instr(text,"密碼") && instr(text,"選項")) || (instr(text,"Login") && instr(text,"Options") && instr(text,"User ID"))
			return array(1,array(id))
	}
	
	return array(0,0)
}

GetControlIdByText(byref arr,RefControlText,offset=0,UseRegEx=0)
{
	if !isobject(arr)||!arr.maxIndex()
		return
	k=0
	if UseRegEx
	{
		for k,v in arr
			if RegExMatch(v.text,RefControltext)
				break
	}
	else
	{
		for k,v in arr
			if v.text=RefControltext
				break
		if !k
			for k,v in arr
				if instr(v.text,RefControltext)
					break
	}
	
	if !offset
		i:=k
	else
	{
		i:=k+offset
		l:=arr.MaxIndex()
		while i>l
			i-=l
		while i<1
			i+=l
	}
	return (k=0 ? 0 : arr[i]["Hwnd"])
	
}

;~ run % GetRisPath(1)
GetRisPath(direct=0){
	if(direct=0){
		if fileexist(path:=a_desktop "\放射線資訊管理系統(Radiology Information System).appref-ms")
			return path
		
		if fileexist(path:=a_desktop "\RIS.appref-ms")
			return path
		
		if fileexist(path:=A_StartMenu "\Programs\放射線資訊管理系統(Radiology Information System).appref-ms")
			return path
		if fileexist(path:=A_StartMenu "\程式集\放射線資訊管理系統(Radiology Information System).appref-ms")
			return path
		if fileexist(path:=A_StartMenu "\Programs\陽明資訊\RIS.appref-ms")
			return path
		if fileexist(path:=A_StartMenu "\程式集\陽明資訊\RIS.appref-ms")
			return path
	}
	
	loop,HKCU,Software\Microsoft\Windows\ShellNoRoam\MUICache
		if instr(a_loopregname,"Menu.exe") && fileexist(a_loopregname)
			return a_loopregname
	loop,HKCU,Software\Microsoft\Internet Explorer\TypedURLs
	{
		regread,v
		if instr(a,"Menu.exe") && fileexist(v)
			return v
	}
	if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()
		return a[a.maxindex()]
	
	
	return 0
	
}

;~ if (a:=searchFile("Menu.exe",substr(a_windir,1,3) "Documents and Settings\" a_username "\Local Settings\Apps\2.0")).maxindex()
		;~ clipboard:= a[1]

ListControls(hwnd, obj=0, arr="")
{
	if !isobject(arr)
		arr:=[]
	
	if isobject(hwnd){
		for k,v in hwnd
			arr:=ListControls(v, 1, arr)
		goto ListControlsReturn
	}
		
	str=
	arr:=GetControls(hwnd)
ListControlsReturn:
	if obj
		return arr
	
	for k,v in arr
		str.="""" v["Hwnd"] """,""" v["ClassNN"] """,""" v["text"] """,""" getControlNameByHwnd(hwnd,v["Hwnd"]) """`n"
	return str
}

/* 
	return switch bar: hwnd, x,y,w,h
*/
ImpaxBar(impaxStateOrHwnd){
	if isobject(impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]
	else
		hwnd:=impaxStateOrHwnd
	
	for k,v in (impaxControls:=getcontrols(hwnd)) {
		if ((v.text="登出"||v.text="Logout") && instr(v.classNN,"WindowsForms10.BUTTON.app") && instr(impaxControls[k-2].classNN,"WindowsForms10.Window.8.app")) {
			controlgetpos,x,y,w,h,,% "ahk_id " barId:=impaxControls[k-2].hwnd
			break
		}
	}
	return {hwnd:barId, x:x, y:y, w:w, h:h}
}

/*
	ImpaxStateArr[1]=image window (in  monitor), ImpaxStateArr[2]=search window
	which=0, switch to search page
	which=1, switch to image page
*/
ImpaxSwitchPage(ImpaxStateArr,which=0,bar=""){
	if !bar
		bar:=ImpaxBar(ImpaxStateArr[2])
	wingetpos,winx,winy,,,% "ahk_id " ImpaxStateArr[2]
	if (which=0){
		winactivate,% "ahk_id " ImpaxStateArr[2]
		controlclick,,% "ahk_id " bar.hwnd
	} else if (which=1) {
		if(ImpaxState[1]) {
			winactivate,% "ahk_id " ImpaxStateArr[1]
		}else if !(bar.h>100) {
			mouseclick,,% winx+bar.x+bar.w/3,% winy+bar.y+10,,0
		}
		
	}
}

/*
	arr[1,1]=main findings
	arr[1,2]=main impression
	arr[1,3]=main suggestion
	arr[2,1]=prior findings
	arr[2,2]=prior impression
	arr[2,3]=prior suggestion
	to be editted!!
*/
;~ msgbox % controlgettext(getRisReports(RisOpened()[2])[1,1])
;~ ExitApp
getRisReports(risHwnd=""){
	if !WinExist(RisHwnd)
		RisHwnd:=risOpened()[2]
	
	arr:=[]
	for k,v in risControls:=getcontrols(risHwnd) {
		if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {
			temp:=k
			break
		}
	}
	for k,v in risControls {
		if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app")) {
			if(abs(k-temp)<18){
				arr[1]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])
			}else if (risControls[k-13,"text"]="歷史報告") || (risControls[k-12,"text"]="歷史報告") {
				arr[2]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"],risControls[k+7]["hwnd"])
			}else if (risControls[k-12,"text"]="報告版本查詢") || (risControls[k-11,"text"]="報告版本查詢") {
				arr[3]:=array(risControls[k+1]["hwnd"],risControls[k+4]["hwnd"])
			}
		}
	}
	return arr
}

getRisReportsHwnd(risHwnd){
	for k,v in risControls:=getcontrols(risHwnd) {
		if (instr(v.text,"下筆") && instr(v.classNN,"WindowsForms10.BUTTON")) {
			temp:=k
			break
		}
	}
	for k,v in risControls {
		if (v.text="Exam." && instr(risControls[k+1]["classNN"],"WindowsForms10.EDIT.app") && abs(k-temp)<13) {
			return array(risControls[k+1]["hwnd"])
			break
		}
		
	}	
	return []
	
}




getTextByHwnd(id){
	controlgettext,t,,ahk_id %id%
	return t
}

;~ getChartNo(id){
	;~ for k,v in risControls:=getcontrols(id) {
		;~ if RegExMatch(v.text,"(\w)\w{5}\d") && instr(v.classNN,"WindowsForms10.EDIT.app") && risControls[k-1].text="???" && risControls[k+2].text="??" {
			;~ return v.text
		;~ }
	;~ }
;~ }
;~ info:=getImpaxInfo("",["chartNo"])
;~ b=1
getImpaxInfo(ByRef impaxState, ByRef items){
	params:=[]
	if !IsObject(impaxState)
		for k,v in impaxOpened()
			if isobject(v)
				for x,y in v
					impaxState[k,x]:=y
			else
				impaxState[k]:=v
	for k,v in items
		if IsFunc(FuncName:="getImpax" v){
			func:=func(FuncName), param:=[impaxState]
			Loop % func.MaxParams-2
				param.push("")
			param.push(true)
			,params.push(func.call(param*))
		}
	result:=getNetControls(params)
	info:=[]
	for k,v in items
		info[v]:=ControlGetText(result[k].1)
	return info
	
}
;~ getImpaxExamDate(impaxOpened()[2,1])
getImpaxExamDate(impaxHwnd){
	arr:=[], sort:=[]
	for k,v in ret:=getNetControl2(impaxHwnd,"","studyDateTimeLabel","","WindowsForms10.STATIC.app","","","",0)
		arr.push(ControlGetText(v))
		,loc:=Acc_Location(acc_ObjectFromWindow(v))
		,sort[loc.x]:=k
	arr2:=[]
	for k,v in sort
		arr2.push(arr[v])
	return arr2
}

getImpaxChartNo(impaxStateOrHwnd="", returnFilter=false){
	
	if isobject(impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd[2,1] 
	else if (impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd 
	else
		hwnd:=impaxopened()[2,1]
	if (returnFilter)
		return {winHwnd: hwnd, controlName: "patientIdLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
	
	controlgettext,chartNo,,% "ahk_id " getNetControl2(hwnd,"","patientIdLabel","","WindowsForms10.STATIC.app","","","",0)[1]
	
	if(chartNo="")
		return
	
	while strlen(chartNo)<7
		chartNo:="0" chartNo
	
	return chartNo
}
getImpaxUserId(impaxStateOrHwnd="", returnFilter=false){
	
	if isobject(impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd[2,2] | impaxStateOrHwnd[2,3]
	else if (impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd 
	else
		hwnd:=impaxopened()[2,1]
	if (returnFilter)
		return {winHwnd: hwnd, controlName: "userIDLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
	controlgettext,UserId,,% "ahk_id " getNetControl2(hwnd,"","userIDLabel","","WindowsForms10.STATIC.app","","","",0)[1]
	
	return UserId
}

;~ msgbox % getImpaxAccNo()

getImpaxAccNo(impaxStateOrHwnd="",leftUpper=1, returnFilter=false){
	if isobject(impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd[2,1] 
	else if (impaxStateOrHwnd)
		hwnd:=impaxStateOrHwnd 
	else
		hwnd:=impaxopened()[2,1]
	if (returnFilter)
		return {winHwnd: hwnd, controlName: "accessionNumberLabel", ClassNN: "WindowsForms10.STATIC.app", getNonEmpty: 1}
	
	
	if(leftUpper="")
		leftUpper:=1
	
	con:=getNetControl2(hwnd,"","accessionNumberLabel","","WindowsForms10.STATIC.app","","","",0)
	controlgettext,AccNo,,% "ahk_id " selectControlByPos(con)
	
	return AccNo
}
;~ getTopParent(0x1C0BB2)
;~ winget,class,processname,ahk_id 1______
;~ msgbox % class
;~ getTopParent(hwnd){
	;~ while (hwnd!=(parent:=DllCall("GetParent", "int" , hwnd))) && parent
		;~ hwnd:=parent
	;~ return hwnd
;~ }

selectControlByPos(byref controlArr,mostLeft=1,mostUpper=0,first=1){
	selected:=[],ind:=1
	selected[ind]:=controlArr[1]
	controlgetpos,cx,cy,,,,% "ahk_id " controlArr[1]
	
	if(mostLeft=0&&mostUpper=0)
		mostLeft:=1
	
	for k,v in controlArr {
		if k=1
			continue
		controlgetpos,x,y,,,,ahk_id %v%
		if (x=cx && y=cy)
			selected[++ind]:=v
		else if  (((mostLeft=1 && x<cx) || (mostLeft=-1 && x>cx)) && mostUpper=0)
			|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && mostLeft=0)
			|| (((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)) && ((mostUpper=1 && y<cy) || (mostUpper=-1 && y>cy)))
			|| ((x=cx) && mostUpper=0 && y<cy)
			|| ((y=cy) && mostLeft=0 && x<cx)
			selected:=[],ind:=1,selected[1]:=v
		
		
		cx:=x,cy:=y
	}
	
	if(first)
		return selected[1]
	else
		return selected
	
}


;~ msgbox % getRisChartNo(RisOpened()[2])
;~ ExitApp
getChartNo(id){
	return getRisChartNo(id)
}
getRisChartNo(hwnd){
	;~ controlgettext,chartNo,,% "ahk_id " (ids:=getNetControl2(hwnd,"???","FID_LABEL","???","WindowsForms10.STATIC.app.0.378734a","","","",1))[2]
	;~ if chartNo=
		;~ controlgettext,chartNo,,% "ahk_id " ids[1]
	;~ while strlen(chartNo)<7
		;~ chartNo:="0" chartNo
	
	;~ return chartno
	
	static prvHwnd
	for k,v in controls:=getcontrols(hwnd)
		if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"
			chartNo:=v.text, prvHwnd:=v.hwnd
	
	if(chartNo="")
		chartNo:=ControlGetText(prvHwnd)
	
	if chartNo!=
		while strlen(chartNo)<7 
			chartNo:="0" chartNo
	
	return chartNo
	
	for k,v in getcontrols(hwnd)
		if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"
		{
			controlgettext,str,,% "ahk_id " v.hwnd
			return str
		}
}
getRisChartNoHwnd(hwnd){
	static prvHwnd
	for k,v in controls:=getcontrols(hwnd)
		if RegExMatch(v.text,"^\w{6}\d$") && controls[k-1].text="病歷號"
			chartNo:=v.text,prvHwnd:=id:=v.hwnd
	
	;~ if chartNo!=
		;~ while strlen(chartNo)<7 
			;~ chartNo:="0" chartNo
	
	return prvHwnd
	
	for k,v in getcontrols(hwnd)
		if instr(v.classNN,"WindowsForms10.EDIT") && acc_objectfromwindow(v.hwnd).accName="病歷號"
		{
			;~ controlgettext,str,,% "ahk_id " v.hwnd
			return v.hwnd
		}
	
}

getRisAccNo(hwnd){
	return getRisSheetNo(hwnd)
}
getRisSheetNo(hwnd){
	static prvHwnd
	for k,v in controls:=getcontrols(hwnd)
		if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")
		{
			;~ controlgettext,str,,% "ahk_id " v.hwnd
			prvHwnd:=v.hwnd
			return v.text
		}
		
	return ControlGetText(prvHwnd)
}

getRisAccNoHwnd(risHwnd){
	static prvHwnd
	for k,v in controls:=getcontrols(risHwnd)
		if controls[k-1].text="照會單號" && regexmatch(v.text,"^\w{11}$") && instr(v.classNN,"WindowsForms10.EDIT")
		{
			;~ controlgettext,str,,% "ahk_id " v.hwnd
			return prvHwnd:=v.hwnd
		}
	return prvHwnd
}


getRisHistoryId(hwnd){
	static prvHwnd
	for k,v in controls:=getControls(hwnd)
		if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="歷史報告" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){
			if (controlId:=controls[k+3,"hwnd"])
				return prvHwnd:=controlId
			
		}
	return prvHwnd
}

/*
	getRisHistory(hwnd,byref arr="",n=""){
		if !isobject(arr)
			arr:=[]
		
	;~ if !controlId:=getNetControl(hwnd,controlName:="dgHisReport",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")
		;~ return arr
		
	;~ for k,v in controls:=getControls(hwnd)
		;~ if (instr(v.classNN,"WindowsForms10.Window.8.app") && v.text="????" && instr(controls[k+3,"classNN"],"WindowsForms10.Window.8.app")){
			;~ controlId:=controls[k+3,"hwnd"]
			;~ break
		;~ }
		
		if !(controlId:=getRisHistoryId(hwnd)) || !(acc:=acc_objectfromwindow(controlId))
			return
		
		acc:=acc_objectfromwindow(controlId)
		
		colNo:=[]
		loop % acc_children(acc_get("Object",1,0,acc)).maxindex()-1
			colNo["" acc_get("Value","1." a_index+1,0,acc)]:=a_index+1
		
		loop % (n=""?(acc_children(acc).maxindex()-1):1) {
			i:=(n=""?(a_index+1):n),arr2:=[]
			arr2["ExamDate"]:="" acc_get("Value",i "." colNo["???"],0,acc)
			arr2["DrName"]:="" acc_get("Value",i "." colNo["????"],0,acc)
			arr2["ExamName"]:="" acc_get("Value",i ".4" colNo["????"],0,acc)
			arr2["SheetNo"]:="" acc_get("Value",i ".5" colNo["????"],0,acc)
			arr2["ChartNo"]:="" acc_get("Value",i ".6" colNo["????"],0,acc)
			arr2["ReportIndex"]:="" acc_get("Value",i ".7" colNo["????"],0,acc)
			arr2["Hospital"]:="" acc_get("Value",i ".8" colNo["??"],0,acc)
			arr.push(arr2.clone())
		}
	;~ arr[0]:=acc
		return arr
	}
*/
getRisHistoryIndex(dgHisReportAcc,rowAcc){
	loop % acc_children(dgHisReportAcc).maxIndex()-1 {
		check:=true
		i:=a_index+1
		loop % acc_children(acc_get("Object",1,0,dgHisReportAcc)).maxindex()-1 {
			j:=A_Index
			check:=check & (acc_get("Value",i "." j,0,dgHisReportAcc)=acc_get("Value",j,0,rowAcc))
		}
		if (check)
			return i
	}	
	return 0
}

searchFile(f,dir){
	arr:=[]
	originalWorkingDir:=A_WorkingDir
	SetWorkingDir,% dir
	loop,% f,0,1
		arr.push(a_loopfilelongpath)
	SetWorkingDir,% originalWorkingDir
	return arr
}


searchRisChartNo(hwnd,AccNoOrChartNo, chartNo=""){
	static prvHwnd
	for k,v in controls:=getControls(hwnd)
		if (instr(v.text,"查詢單號") && instr(v.classNN,"WindowsForms10.STATIC")){
			thisHwnd:=prvHwnd:=controls[k+1].hwnd
			break
		}
	
	if(!thisHwnd)
		for k,v in controls
			if (instr(v.text,"病歷號") && instr(v.classNN,"WindowsForms10.STATIC") && !instr(controls[k-3].text,"照會單號")){
				thisHwnd:=prvHwnd:=controls[k+1].hwnd
				, useChartNo:=true
				break
			}
		
	if(!thisHwnd || (thisHwnd:=prvHwnd)){
		controlfocus,,% "ahk_id " thisHwnd
		controlsettext,,% useChartNo&&chartNo!=""?chartNo:AccNoOrChartNo,% "ahk_id " thisHwnd
		controlsend,,{Enter},% "ahk_id " thisHwnd
		return true
	}
	return false
}

;~ parseDataGrid2(getRisList(risOpened()[2]))
;~ ExitApp
parseDataGrid2(listHwnd){
	clipboardOld:=ClipboardAll
	,clipboard:=""
	loop 3 {
		controlsend,,^a,ahk_id %listHwnd%
		Sleep % 100*(A_Index)*2
		controlsend,,^c,ahk_id %listHwnd%
		ClipWait,1
		if !ErrorLevel 
			break
	}
	data:=Clipboard
	,clipboard:=clipboardOld
	
	output:=[]
	Loop,parse,data,`n
	{
		row:=[]
		;~ ,txt:=RegExReplace(A_LoopField, "^\t+", "")
		,txt:=A_LoopField
		loop,parse,txt,`t
			row.push(Trim(A_LoopField))
		output.push(row)
	}
	return new DataGridTable(output)
}	
	

;~ a:=new DataGridTable([[1,2,3,4], [5,6,7,8]])
;~ for k,v in a
	;~ MsgBox % k
;~ ExitApp
class DataGridTable {
	__New(ByRef data){
		this.titles:=data[1]
		,this.colNos:=[]
		,this.data:=data.clone()
		for k,v in this.titles
			if (v!="")
				this.colNos[v]:=k
		
		this.colNos["AccNo"]:=this.colNos["照會單號"]
		,this.colNos["ChartNo"]:=this.colNos["病歷號"]
		,this.colNos["ExamName"]:=this.colNos["檢查名稱"]
		,this.colNos["Status"]:=this.colNos["狀態"]
		,this.colNos["ExamDate"]:=this.colNos["檢查日"]
		
		
		,data.base:=this
		return data
	}
	
	_NewEnum(){
		this.enum_ind:=0
		,this.data_ind_max:=this.data.maxIndex()
		return this
	}
	
	Next(ByRef k, ByRef v){
		k:=++this.enum_ind
		,v:=new this.base.base.DataGridRow(this.base.data[k], this.base.colNos, k)
		return k<=this.data_ind_max
	}
		
	class DataGridRow {
		__New(ByRef data, colNos, rowNo){
			this.colNos:=colNos
			,this.data:=data.clone()
			,this.rowNo:=rowNo
			,data.base:=this
			return data
		}
		getColNo(colName){
			return this.colNos[colName]
		}
		getCell(colName){
			return this[this.getColNo(colName)]
		}
	}
	
	getColNo(colName){
		return this.colNos[colName]
	}
	
	getCell(row, colName){
		return this[row][this.getColNo(colName)]
	}
	
	getRow(rowOrColName, value=""){
		if (value!="")
			return this.getRowByVal(rowOrColName, value)
		else
			return new this.DataGridRow(this[rowOrColName], this.colNos, rowOrColName)
		
	}
	
	getRowByVal(colName, value){
		col:=this.getColNo(colName)
		for k,v in this {
			if (v[col]=value) && (k!=1){
				return new this.DataGridRow(v, this.colNos, k)
			}
		}
	}
	
	getRowsByVal(colName, value){
		col:=this.getColNo(colName)
		,ret:=[]
		for k,v in this {
			if (v[col]=value) && (k!=1){
				ret[k]:=new this.DataGridRow(v, this.colNos)
			}
		}
		return ret
	}
}



	; limit can be range: [2, 5] or [7, ] or [8]
; callback: func(rowIndex, rowAcc, cellsAcc)
parseDataGrid(hwnd,byref output="",is_acc=0,limit=0,sleep=0,start="",callback=""){
	
	if(is_acc=0)
		acc:=acc_ObjectFromWindow(hwnd)
		,rows:=acc_children(acc)
	else if(is_acc=1)
		rows:=hwnd
	rowsCount:=rows.maxIndex()
	;~ callback:=func(callback)
	
	if (output="")
		output:=[]
	;~ tmpArr:=[]
	;~ msgbox % start.1 "," 0+start.1 "," start.2
	;~ msgbox % acc_children(acc).maxindex()
	if (isobject(start) && !isobject(limit)){
		for k,v in rows {
			;~ if(!controlexist(hwnd,is_acc) && !acc_windowfromobject(acc_parent(hwnd[1]))){
				;~ OutputDebug, % "Data grid not exist!"
				;~ return output
			;~ }
			
			cells:=acc_children(v)
			if(cells[0+start.1].accValue=start.2)
				found:=k
			else if(limit && found && k-found>limit-1) 
				break
			
			tmp:=[]
			for x,y in cells
				tmp[x]:=y.accValue
			output[x,y]:=tmp
			%callback%(k, v, cells, tmp)
			
			if (sleep)
				sleep % sleep
		}
	}else if (!isobject(limit)){
		if (start="" || start=0)
			start:=1
		;~ for k,v in rows:=acc_children(acc) {
		
		loop {
			if (limit && a_index>limit)
				break
			
			;~ if(!controlexist(hwnd) && !acc_windowfromobject(acc_parent(hwnd[1]))){
				;~ OutputDebug,  % "Data grid not exist!"
				;~ return output
			;~ }
			
			if (k:=start+a_index-1)>rowsCount
				break
			;~ if (limit && k<=limit){
			tmp:=[]
			for x,y in cells:=acc_children(row:=rows[k])
				tmp[x]:=y.accValue
			output[k]:=tmp
			;~ }
			%callback%(k, row, cells, tmp)
			
			if (sleep)
				sleep % sleep
		}
	}else{
		
		k1:=limit.1&&limit.1>=1&&limit.1<=rows.maxIndex()?limit.1:1
		if(limit.maxIndex()=1)
			k2:=k1
		else
			k2:=limit.2&&limit.2<=rows.maxindex()&&limit.2>=1?limit.2:rows.maxIndex()
		loop % abs(k2-k1)+1 {
			;~ if(!controlexist(hwnd) && !acc_windowfromobject(acc_parent(hwnd[1]))){
				;~ msgbox % "Data grid not exist!"
				;~ return output
			;~ }
			
			ind:=k2>=k1?a_index-1+k1:k1-a_index+1
			if (ind> rowsCount)
				break
			tmp:=[]
			for x,y in cells:=acc_children(row:=rows[ind])
				tmp[x]:=y.accValue
			output[ind]:=tmp
			
			%callback%(ind, row, cells, tmp)
			if(sleep)
				sleep % sleep
		}
		
	}
	
	return rowsCount
}
;~ msgbox % getRisMenu()
getRisMenu(){
	global menuHwnd=0
	EnumAddress := RegisterCallback("EnumProc") 
	DllCall("EnumWindows", "Ptr", EnumAddress, "Ptr", 0)
	return menuHwnd
}

EnumProc(hwnd, lParam)
{
	global menuHwnd
	
	if (DllCall("GetWindowLong",Ptr,hwnd,Int,-20)=0______){
		;~ msgbox % hwnd "," acc_children(acc_objectfromwindow(hwnd))[1].accName
		;~ STYLE:=DllCall("GetWindowLong",Ptr,hwnd,Int,-16)
		if ((acc:=acc_children(acc_objectfromwindow(hwnd))).maxindex()=6 && acc[1].accName="瀏覽影像"){
			menuHwnd:=hwnd
			;~ msgbox % DllCall("GetWindowLong",Ptr,hwnd,Int,-16)
			return false
		}
	}
	
	return true  ; Tell EnumWindows() to continue until all windows have been enumerated.
}

getRisExamItems(hwnd){
	;~ arr:=[]
	;~ if !controlId:=getNetControl(hwnd,controlName:="EXAMITEM",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")
		;~ return arr
	static prvHwnd
	for k,v in getcontrols(hwnd) {
		;~ if instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAM"){
		if (instr(name:=getControlNameByHwnd(hwnd,v.hwnd),"EXAMITEM")) {
			return prvHwnd:=v.hwnd
			;~ acc:=acc_objectFromWindow(v.hwnd)
			;~ break
		}
	}	
	
	return prvHwnd
	
	
	;~ ExitApp
	
	;~ controlgetpos,x,y,w,h,,ahk_id %controlId%
	;~ winactivate,ahk_id %hwnd%
	;~ mousemove,% x,% y
	;~ mousemove,% x+w,% y+h
	;~ pause
	
}

/*
	arr[1]: active exams done this time
	arr[2]: all exams done this time
*/
parseRisExamItems(hwnd){
	arr:=[[],[]]
	
	acc:=acc_objectFromWindow(hwnd)
	
	if !acc
		return arr
	
	loop % acc_children(acc).maxindex()-1 {
		i:=a_index+1
		str:=acc_get("Value",i ".2",0,acc)
		if(str="")
			continue
		if instr(str,"※")
			arr[1].push(RegExReplace(str,"※"))
		arr[2].push(RegExReplace(str,"※"))
	}
	return arr
}
parseRisHistory(hwnd){
	arr:=[]
	
	if !acc:=acc_objectfromwindow(hwnd)
		return arr
	
	;~ col:=[]
	;~ for k,v in acc_children(acc_get("Object",1,0,acc))
		;~ col[k]:="" acc_get("Value","1." k+1,0,acc)
	
	
	for i,j in rows:=acc_children(acc) {
		if i=1
			continue
		for x,y in acc_children(v)
			arr[i-1,x]:=y.accValue
	}
	
	
	;~ loop % acc_children(acc).maxIndex()-1 {
		;~ i:=a_index+1
		;~ loop % k
			;~ arr[a_index,"" col[k]]:=acc_get("Value",i "." k,0,acc)
	;~ }
	return arr
	
}


getRisHistory(hwnd){
	
	;~ if !controlId:=getNetControl(hwnd,controlName:="dgHisReport",accName:="DataGridView",classNN:="WindowsForms",accHelp:="")
		;~ return arr
	static prvHwnd
	for k,v in getcontrols(hwnd) {
		if (getControlNameByHwnd(hwnd,v.hwnd)="dgHisReport") {
			return prvHwnd:=v.hwnd
			
		}
	}	
	return prvHwnd
	
	
}



LineBreakConvert(str){
	return regexreplace(regexreplace(str,"\r",""),"\n","`r`n")
}
;~ Sleep 2000
;~ t:=getSEIM()
;~ a:=1
getSEIM(ImpaxState="", recur=0){
	if !impaxstate
		impaxstate:=impaxOpened()
	if IsObject(impaxState)
		impaxImageHwnd:=impaxState[2,1]
	else 
		impaxImageHwnd:=impaxState
	
	SEIM:=getNetControl2(impaxImageHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)
	for k,v in SEIM
		if RegExMatch(text:=controlgettext(v),"i)S:\s+(\d+)\s+I:\s+(\d+)",match)
			break
	;~ controlgettext,t,,ahk_id %impaxImageHwnd%
	;~ msgbox % t
	if (match1="" && recur<3){
		mousemove,-1,-1,1,R
		mousemove,1,1,1,R
		return getSEIM(ImpaxState, recur+1)
	}
	
	return [match1,match2]
}


RisExamEditInfo(RisHwnd="",RisExamHwnd=""){
	if !rishwnd && !risexamhwnd
		risHwnd:=risOpened()[2]
	
	if !risexamhwnd
		risexamhwnd:=getRisReports(risHwnd)[1,1]
	
	Edit_GetSel(risexamhwnd,start,end)
	
	return {id: risexamhwnd, start: start,end: end}
	
}

getReportHint(risHwnd){
	static prvHwnd
	return ControlGetText((h:=acc_windowfromobject(getNetAcc(risHwnd,"REPORT_HINT","WindowsForms10.STATIC")))?(prvHwnd:=h):prvHwnd)
}

getIndication(RisHwnd,filter=1){
	static prvHwnd
	
	thisHnwd:=(indication:=getNetControl2(RisHwnd,"","REPORT_HINT","","WindowsForms10.STATIC.app","","","",0))[1]?indication[1]:prvHwnd
	
	if regexmatch(controlgettext(thisHwnd),"Indication:([^\n\r]*)",match) {
		str:=match1
	}else{
	
		for k,v in getControls(RisHwnd)
			if regexmatch(v.text,"Indication:([^\n\r]*)",match) {
				str:=match1
				break
			}
	}
	
	str:=RegExReplace(trim(str),"[^\w\+\)]+$","")
	
	if(filter=1){
		str:=RegExReplace(str,"is)(.+?)(有.+)?","$1")
	}
	return trim(str)
}

getRisClinicalInfoHwnd(RisHwnd){
	static prvHwnd
	return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?(prvHwnd:=h):prvHwnd
}



getIndicationText(RisHwnd){
	clinicalHx:=getClinicalInfo(RisHwnd)
	indication:=getIndication(RisHwnd)
	if(indication="" && RegExMatch(clinicalHx,"is)\[The Others\]:([^\r\n\※]+)",match)){
		indication:=Trim(match1)
	}
	if(indication="")
		indication:="N/A"
	return indication
	
}



;~ a:=getSeriesList()
;~ for k,v in a
	;~ msgbox % acc_location(a.1).x
/*
	return arr:	(screen1): [hwnd of series window, hwnd of series control]
	(screen2):
*/
getSeriesList(){
	winget,impaxList,list,ahk_exe impax-client-main.exe ahk_class #32770,Slider1
	SeriesList:=[]
	loop % impaxList {
		;~ acc:=acc_objectfromwindow(id:=impaxList%a_index%)
		;~ if (acc_children(acc).maxindex()=10)
			SeriesList.push(id:=impaxList%a_index%)
	}
	
	if impaxList && !seriesList.maxIndex() 
		return -1
	
	
	;~ sysget,mon,monitor,2
	;~ sysget,mon2,monitor,3
	monitorInfo:=monitorInfo()
	
	List:=[]  
	;~ Series:=[]
	for k,v in SeriesList {
		for x,y in getControls(v)
			if (y.ClassNN="SysListView321" && y.text="List1") {
				WinGetPos,x,y,,,% "ahk_id " hwnd:=y.hwnd
							
				Loop % (monitorInfo.maxIndex())
					if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){
						List[A_Index]:=[v, hwnd]
						break, 2
					}
		
				;~ wingetpos,x,,,,% "ahk_id " y.hwnd
				;~ if (x<=monRight)
					;~ List[1]:=[v,y.hwnd]
				;~ else
					;~ List[2]:=[v,y.hwnd]
				;~ break
			}
	}
	
	;simple sort of two screen list according to x 
	;~ pos:=[]
	;~ for k,v in List {
		;~ wingetpos,x,y,,,ahk_id %v%
		;~ pos.push(x)
	;~ }
	;~ sortedList:=[]
	;~ if pos[2]<pos[1]
		;~ sortedList:=[List[2],List[1]]
	;~ else
		;~ sortedList:=List
	
	return List
	
}

;~ a:=getSeriesName()
;~ b:=1

getSeriesName(list="",screen=2){
	if list=
		list:=getSeriesList()
	
	if isobject(list)
		listAcc:=acc_objectfromwindow(listHwnd:=list[screen,2])
	else  
		listAcc:=acc_objectfromwindow(list)
	
	seriesName:=[],ch:=acc_children(listAcc),count:=ch.maxindex()
	for k,v in ch {
		if (k=count)
			break
		RegExMatch(acc_get("Name","",k,listAcc),"is)(\d+)\s*:\s*(\d+)\s*:\s*(.*)",match)
		seriesName.push([match3,match2])
	}
	return seriesName
}


;~ a:=getViewFrame("",2)
;~ b=1
/*
	axis:
	(1,1) (1,2)
	(2,1) (2,2)
	
	return arr:	screen:	hwnd of frame at (x,y)
*/
getViewFrame(ImpaxHwnd="", whichScreen=""){
	if impaxHwnd=
		impaxHwnd:=impaxOpened()[2,1]
	
	if !impaxHwnd
		return
	
	if(whichScreen="")
		whichScreen:=[1,2]
	
	arr:=[]
	;~ screen:=0,x:=0,y:=0,xMax:=0,yMax:=0
	for k,v in getControls(impaxHwnd)
		if RegExMatch(v.ClassNN,"AfxWnd90u\d+") && RegExMatch(v.text,"Screen_(\d+)_format_\d+_Position_(\d)_(\d)",match) {
			screen:=match1+1,x:=match2+1,y:=match3+1
			if (!IsObject(whichScreen) && screen!=whichScreen) 
				|| (IsObject(whichScreen) && !eleInArr(screen, whichScreen))
				continue
			if !isobject(arr[screen])
				arr[screen]:=[]
			arr[screen,x,y]:=v.hwnd
		}
	
	return arr
}

eleInArr(e, a){
	for k,v in a
		if(v=e)
			return true
	return false
}
;~ CoordMode,mouse,screen
;~ dragSeries(9,1,2,2)

/*
	seriesInd: 0 as cursor position
	frameX, frameY: axis of frame, one dimension axis if frameY=0
*/

dragSeries(frameX,frameY=0,seriesInd=0,screen=2,ByRef seriesList="",frame=""){
	CoordMode,mouse,screen
	if (frame="")
  		frame:=getViewFrame()
	if (seriesList="")
		seriesList:=getSeriesList()
	
	frameFlat:=[]
	for k,v in frame[screen]
		for m,n in v
			frameFlat.push(n)
	
	if !(frameHwnd:=frame[screen,frameX,frameY]) && !(frameHwnd:=frameFlat[frameX+frameY])
		return
	
	listAcc:=acc_objectfromwindow(listHwnd:=seriesList[screen,2])
	,listWin:=seriesList[screen,1]
	mousegetpos,mX,mY
	
	
	if(seriesInd=0){
		seriesLoc:={x:mX,y:mY,w:0,h:0}
	}else if IsObject(seriesInd){
		seriesLoc:={x: seriesInd.x, y: seriesInd.y}
	}else{
		seriesLoc:=acc_location(listAcc,seriesInd)
		if (!seriesLoc.x || !seriesLoc.y)
			return
	}
	
	
	
	if (seriesInd!=0 && !IsObject(seriesInd)){
		wingetpos,x,y,w,h,ahk_id %listWin%
		
		xMax:=0,columns:=0
		loop % (seriesNum:=acc_children(listAcc).maxindex()-1) {
			loc:=acc_location(listAcc,a_index)
			;~ if loc.x>xMax
				;~ xMax:=loc.x
			if(loc.x>xMax){
				xMax:=loc.x
			}else{
				columns:=a_index-1
				break
			}
		}
		
		controlsend,,{home},ahk_id %listHwnd%
		Loop % floor(seriesInd/columns)
			controlsend,,{down},ahk_id %listHwnd%
		sleep 500
		seriesLoc:=acc_location(listAcc,seriesInd)
	}
	
	
	wingetpos,fX,fY,fW,fH,% "ahk_id " frameHwnd
	
	;~ sysget,mon1,monitor,% screen
	;~ sysget,mon2,monitor,% screen+1
	;~ if (fX<mon2Left){
		;~ fX+=mon1Right-mon1Left
	;~ }
	winactivate,ahk_id %listWin%
	mousemove,% seriesLoc.x+seriesLoc.w/2,% seriesLoc.y+seriesLoc.h/2,0
	;~ controlsend,,{lbutton down},ahk_id %listHwnd%
	send {lbutton down}
	sleep 100
	
	mousemove,% fX+fW/2,% fY+20,2
	;~ controlsend,,{lbutton up},ahk_id %frameHwnd%
	send {lbutton up}
	
	mousemove,% mX,% mY,0
	
}
mouseDragSeries(originalXY, originalWin, targetFrame){
	WinActivate,ahk_id %originalWin%
	mousemove,% originalXY.x,% originalXY.y,0
	send {LButton Down}
	Sleep 100
	WinGetPos,x,y,w,h,ahk_id %targetFrame%
	MouseMove, % x+w/2, % y+20,2
	send {LButton up}

}


;~ Sleep 1000

;~ toggleSeriesList("", "toggle", "mouse")
;~ Sleep 1000
;~ toggleSeriesList("", "on", 2)
;~ esc::ExitApp
;~ ExitApp
/*
action="on", "off", "toggle"
for="all", 1, 2, "mouse"
return= seriesListStored
*/
;~ Sleep 1000
;~ toggleSeriesList(ImpaxState, "toggle", "all", monitorInfo)
;~ Sleep 1000
;~ ti:=A_TickCount
;~ toggleSeriesList(ImpaxState, "toggle", "all", monitorInfo)
;~ MsgBox % A_TickCount-ti
;~ ExitApp
toggleSeriesList(impaxState="", action="toggle", for="all", ByRef monitorInfo="", activate=false){
	static seriesListStored:=[] ; button1, seriesList1, button2, seriesList2
		, impaxControlList:=[]
	;~ ti:=A_TickCount
	if !IsObject(impaxState)
		impaxState:=impaxOpened()
	
	if !WinExist("ahk_exe impax-client-main.exe") || (impaxState[1]!=2 && impaxState[2,4]!=1)
		return
	
	if IsObject(for){
		for k,v in for
			ret:=toggleSeriesList(impaxState, action, v, monitorInfo, activate)
		return ret
	}
	
	screenNo:=(for+0)*2-1
	if screenNo is number
	{
		if WinExist("ahk_id " seriesListStored[screenNo]) && winvisible(seriesListStored[screenNo]) && WinExist("ahk_id " seriesListStored[screenNo+1]) {
			if (((winvisible(seriesListStored[screenNo+1]))=(action="off")) || (action="toggle")){
				ControlClick,,% "ahk_id " seriesListStored[screenNo]
				;~ ToolTip test
			}
			;~ MsgBox % A_TickCount-ti
			return seriesListStored
		}else{
	
			if !IsObject(monitorInfo)
				monitorInfo:=monitorInfo()
			;~ winget,impaxList,list,ahk_exe impax-client-main.exe
			seriesListButton:=[]
			;~ loop % impaxList {
			
			loop 2 {
				for k,hwnd in impaxControlList {
					impaxId:=hwnd
					for k,v in (impaxControls:=getcontrols(impaxId)){
						if v.text="BMP_VIRTUAL_SCREEN_BUTTON" && instr(v.ClassNN,"WindowsForms10.BUTTON") {
							
							WinGetPos,x,y,,,% "ahk_id " v.hwnd
								
							Loop % (monitorInfo.maxIndex())
								if(x<=monitorInfo[a_index].r && x>=monitorInfo[a_index].l && y>=monitorInfo[a_index].t && y<=monitorInfo[a_index].b){
									seriesListButton[A_Index]:=v.hwnd
									break
								}
							
						}
					}
				}
			
				if (!seriesListButton.maxIndex()){
					winget,impaxListCount,list,ahk_exe impax-client-main.exe
					;~ MsgBox % A_TickCount-ti
					impaxControlList:=[]
					loop % impaxListCount
						impaxControlList.push(impaxListCount%a_index%)
				}else
					break
			}
			
			for k,v in seriesListButton
				seriesListStored[k*2-1]:=v
			for k,v in seriesList:=getSeriesList()
				seriesListStored[2*k]:=v.1
			
			if (winvisible(sHwnd:= seriesListStored[screenNo+1])=(action="off")) || (action="toggle") {
				ControlClick,,% "ahk_id " seriesListStored[screenNo]
				if(action="off")
					WinHide, % "ahk_id " sHwnd
				else if(action="on")
					WinShow, % "ahk_id " sHwnd
			}
			;~ MsgBox % A_TickCount-ti
			return seriesListStored
		}
		
	}else{
		if !IsObject(monitorInfo)
				monitorInfo:=monitorInfo()
		
		whichMonitor:=whichMonitor("","",monitorInfo)
		,which:=whichMonitor.1
		
		 if (for="mouse"){
		
			return toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)
		}else if(for="all"){
			;~ ti:=A_TickCount
			if (!impaxControlList.maxIndex()){
				winget,impaxListCount,list,ahk_exe impax-client-main.exe
				;~ MsgBox % A_TickCount-ti
				impaxControlList:=[]
				loop % impaxListCount
					impaxControlList.push(impaxListCount%a_index%)
			}
			;~ MsgBox % A_TickCount-ti
			ret:=toggleSeriesList(impaxState, action, which+0, monitorInfo, activate)
			
			,others:=[]
			Loop % monitorInfo.maxIndex()-1
				if(A_Index+1!=which){
					others.push(A_Index+1)
					
				toggleSeriesList(impaxState, action, A_Index+1, monitorInfo, activate)	
				}
			;~ SetTimerF("toggleSeriesList", -1, [impaxState, action, others, monitorInfo, activate])
			return ret
		}
		return
	}
	
	if(activate)
		winactivate,% "ahk_id " ImpaxState[2,1]

}



;~ a:=parseDataGrid(getRisList())
;~ b=1
;~ msgbox % getRisList()
getRisList(hwnd=""){
	if !hwnd
		hwnd:=risOpened()[2]
	
	static prvHwnd
	
	return (h:=getNetAcc(hwnd,"DataGridView1","WindowsForms",0,0,"",""))?(prvHwnd:=h):prvHwnd
	
}

RisAddToDisplayList(risHwnd="",list=""){
	if !risHwnd
		risHwnd:=risOpened()[2]
	
	if !list || !isobject(list)
		list:=parseDataGrid(getRisList(risHwnd))
	
	str:=""
	i:=list.maxIndex()
	
	for k,v in list.1
		if (v="照會單號") {
			ind:=k
			break 
		}
	
	if !ind
		return
	arr:=[]
	for k,v in list
		if (k!=1 && k!=i)
			str.="ADD_TO_DISPLAY_LIST """" " v[ind] " """" "
	,arr.push(v[ind])
	
	str.="SYNC_DISPLAY """" " list[2,ind] " """""
	
	return arr
	
}
;~ impaxCyclicListDo()
impaxCyclicListDo(next=1,hwnd=""){
	if !hwnd
		hwnd:=impaxOpened()[2,1]
	controlclick,,% "ahk_id " getNetAcc(hwnd,next=1?"nextButton":"previousButton","WindowsForms10.BUTTON",0,0,"","")
}

controlexist(hwnd, acc=false){
	if !hwnd
		return 
	if acc
		hwnd:=acc_windowfromobject(hwnd)

	controlget,id,hwnd,,,ahk_id %hwnd%
	return id
}


RisSearchResultCount(risHwnd){
	static RisSearchResultTextHwnd
	if !controlexist(RisSearchResultTextHwnd)
		RisSearchResultTextHwnd:=getNetAcc(risHwnd,"lblSearchResult","WindowsForms10.STATIC",0,0,"","")
	text:=controlgettext(RisSearchResultTextHwnd)
	regexmatch(text,"共搜尋到\s*(\d+)\s*筆資料",match)
	return match1
	
}

getRisExamDate(risHwnd){
	if IsObject(risHwnd)
		risHwnd:=risHwnd[2]
	static prvHwnd
	return ControlGetText((h:=getNetControl2(risHwnd,"","EXAM_DATE_TIME","","WindowsForms10.EDIT")[1])?(prvHwnd:=h):prvHwnd)
}

getImpaxListAcc(impaxState){
	impaxHwnd:=impaxState[2,2] | impaxState[2,3]
	return getNetAcc(impaxHwnd, "grid", "windowsForms")
}

;~ acc:=getImpaxList(impaxOpened())
;~ parseDataGrid(acc_children(acc), arr:=[], 1)

;~ ExitApp
;~ MsgBox % getRisLoginName(risOpened()[2])
;~ ExitApp


getRisLoginName(risHwnd){
	WinGetTitle,title,% "ahk_id " risHwnd
	RegExMatch(title,"^([^\-])+", match)
	return match
}

resetRisReports(RisHwnd="", RisReports=""){
	
	if(RisReports=""){
		if !WinExist("ahk_id " RisHwnd)
			RisHwnd:=risOpened()[2]
	
		RisReports:=getRisReports(RisHwnd)
	}
	
	
	
	ControlSetText,,,% "ahk_id " RisReports[1,1]
	ControlSetText,,,% "ahk_id " RisReports[1,2]
}

; replaceFindings: 0->two new lines, 1->replace, -1->append
setReportText(findings, impression, RisReports="", replaceFindings=0, replaceImpression=true, caretToEnd=true){
	if (RisReports="" || !IsObject(RisReports)) || !WinExist("ahk_id " RisReports[1,1])
		RisReports:=getRisReports(risOpened()[2])
	if(simpleRis:=WinExist("ahk_exe simpleRIS.exe")){
		controlget,EditHwnd,hwnd,,Scintilla1,simple RIS ahk_class AutoHotkeyGUI
	}
	
	oldReport:=EditHwnd?edit_getText(EditHwnd):ControlGetText(RisReports[1,1])
	
	if (replaceFindings=0)
		findings:=oldReport (oldReport=""?"":"`n`n") findings
	else if (replaceFindings=-1)
		findings:=(oldReport) findings
	if !(replaceImpression)
		impression:=Trim(ControlGetText(RisReports[1,2])) "`n" impression
	
	findings:=Trim(RegExReplace(findings, "(?<!\r)\n", "`r`n"))
	
	if (EditHwnd)
		Edit_SetText(EditHwnd, findings)
	
	ControlSetText,,% findings,% "ahk_id " RisReports[1,1]
	ControlSetText,,% impression:=Trim(RegExReplace(impression, "(?<!\r)\n", "`r`n")),% "ahk_id " RisReports[1,2]
	
	if(caretToEnd){
		Edit_SetSel(RisReports[1,1], len:=StrLen(findings), len)
		Edit_SetSel(RisReports[1,2], len:=StrLen(impression), len)
	}
}

getRisTechName(risHwnd){
	static prvHwnd
	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"放射師","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}

getRisPtName(risHwnd){
	static prvHwnd
	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"姓名","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisPtGender(risHwnd){
	static prvHwnd
	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"性別","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}
getRisPtAge(risHwnd){
	static prvHwnd
	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"年齡","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}

getRisStudyState(risHwnd){
	static prvHwnd
	return (t:=(acc:=getNetAcc(risHwnd,"FID_TEXT","WindowsForms10.EDIT",0,true,"狀態","")).accValue)!="" && (prvHwnd:=acc_windowfromobject(acc))?t:acc_ObjectFromWindow(prvHwnd).accValue
}

getClinicalInfo(RisHwnd){
	static prvHwnd
	return (h:=getNetControl2(risHwnd,"","txtALL","","WindowsForms10.EDIT.app","","","",0)[1])?controlgettext(prvHwnd:=h):ControlGetText(prvHwnd)
}

getImpaxContextServerPath(){
	if FileExist(path:=A_ScriptDir "\ImpaxContextServer.exe")
		return path
	else if FileExist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")
		return path
	else if FileExist(path:=RegExReplace(A_ScriptDir, "is)[\/\\][^\/\\]+$", "") "\ImpaxContextServer\ImpaxContextServer.exe")
		return path
	
}
;~ risSendReport(risOpened()[2])
;~ ExitApp

;~ MsgBox % acc_windowfromobject(getNetAcc(risOpened()[2],"cmdRunSave","WindowsForms10.BUTTON",0,true))
;~ ExitApp
risSendReport(risHwnd, type=3){
	static prvHwnd1, prvHwnd2, prvHwnd3
	if !WinExist("ahk_id " risHwnd)
		risHwnd:=risOpened()[2]
	while !(button:=getNetAcc(risHwnd,type=1?"cmdRunSave":type=2?"cmdRunVerify":"cmdRunVerifySend","WindowsForms10.BUTTON",0,true))
	&& !(button:=acc_objectfromwindow(getNetControl2(risHwnd,type=1?"暫存":type=2?"存檔":"存檔發送" ,"","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd%type%) && A_Index<4
		Sleep 50
	if(!button){
		if controlexist(prvHwnd%type%)
			button:=acc_ObjectFromWindow(prvHwnd%type%)
		else {
			MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
			return 1
		}
	}
	
	prvHwnd%type%:=acc_windowfromobject(button)
	return button.accDoDefaultAction()
}

risNextStudy(RisHwnd, next=true){
	static nextHwnd0, nextHwnd1
	next:=!!next
	
	while !(button:=getNetAcc(risHwnd, next?"cmdRunNext":"cmdRunFoword","WindowsForms10.BUTTON",0,true))
	 && !controlexist(nextHwnd%next%) && A_Index<4
	;~ && !(button:=acc_objectfromwindow(getNetControl2(risHwnd,type=1?"暫存":type=2?"存檔":"存檔發送" ,"","","WindowsForms10.BUTTON")[1])) && !controlexist(nextHwnd%next%) && A_Index<4
		Sleep 50
	if(!button){
		if controlexist(nextHwnd%next%)
			button:=acc_ObjectFromWindow(nextHwnd%next%)
		else {
			MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
			return 1
		}
	}
	nextHwnd%next%:=acc_windowfromobject(button)
	return button.accDoDefaultAction()
}

;~ MsgBox % !( openImpax:=getNetAcc(risOpened()[2],"cmdDs3000","WindowsForms10.BUTTON"))
;~ risOpenStudyImpax(RisOpened()[2])
;~ ExitApp
risOpenStudyImpax(risHwnd=""){
	static prvHwnd
	if !WinExist("ahk_id " risHwnd)
		risHwnd:=risOpened()[2]
	while !(openImpax:=getNetAcc(risHwnd,"cmdDs3000","WindowsForms10.BUTTON")) && !(openImpax:=acc_objectfromwindow(getNetControl2(risHwnd,"IMPAX6","","","WindowsForms10.BUTTON")[1])) && !controlexist(prvHwnd) && A_Index<4
		Sleep 50
	
	if(!openImpax){
		if controlexist(prvHwnd)
			openImpax:=acc_ObjectFromWindow(prvHwnd)
		else{
			MsgBox,,,% "Can't get RIS button, suggest re-open RIS!",3
			return 1
		}
	}

	prvHwnd:=acc_windowfromobject(openImpax)
	return openImpax.accDoDefaultAction()
}

RisHistoryQueryByAccNo(AccNo, RisHwnd="", RisHistoryAcc=""){
	static prvRisHistoryAcc, prvRisHwnd
	if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {
		if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)
			prvHwnd:=RisHwnd:=risOpened()[2]
		prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))
	}
	prvRisHistoryAcc:=RisHistoryAcc
	
	for k,v in rows:=acc_children(RisHistoryAcc){ 
		cells:=acc_children(v)
		if(k=1){
			for x,y in cells {
				if (y.accValue="照會單號"){
					AccNoCol:=x
				}else if (y.accValue="檢查日"){
					examDateCol:=x
				}else if (y.accValue="檢查名稱"){
					examNameCol:=x
				}
			}
		}else if (cells[AccNoCol].accValue=AccNo){
			return {examDate: cells[examDateCol].accValue, examName: cells[examNameCol].accValue}
		}
	}
}

;~ risOpenOldStudy(RisOpened()[2])
;~ ExitApp
risOpenOldSingleStudy(AccNo, ExamDate="", ExamName="", RisHwnd="", RisHistoryAcc=""){
	static prvRisHistoryAcc, prvRisHwnd
	if (!RisHistoryAcc) && !controlexist(acc_windowfromobject(RisHistoryAcc:=prvRisHistoryAcc)) {
		if !WinExist(RisHwnd) && !WinExist(RisHwnd:=prvHwnd)
			prvHwnd:=RisHwnd:=risOpened()[2]
		prvRisHistoryAcc:=RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(prvHwnd:=RisHwnd))
	}
	prvRisHistoryAcc:=RisHistoryAcc
	
	if(examDate="" || examName="")
		res:=RisHistoryQueryByAccNo(AccNo, RisHwnd, RisHistoryAcc)
		, examDate:=res.examDate, examName:=res.examName
	
	examType:=InStr(examName,"CT")?"CT":InStr(examName,"MRI")?"MRI":examName
	
	for k,v in rows:=acc_children(RisHistoryAcc){ 
		cells:=acc_children(v)
		if(k=1){
			for x,y in cells {
				if (y.accValue="照會單號"){
					AccNoCol:=x
				}else if (y.accValue="檢查日"){
					examDateCol:=x
				}else if (y.accValue="檢查名稱"){
					examNameCol:=x
				}
			}
		}else if InStr(cells[examNameCol].accValue, examType) && (Trim(cells[examDateCol].accValue)=examDate){
			ImpaxContextServer_Add(Trim(cells[AccNoCol].accValue))
		}
	}
}

/*
origin.x .y .z: upper left corner of first slice
spacing.x .y .z
coord.x .y .z: lesion
dimension.x .y
framePos.x .y .w .h
*/
coordToPacs(framePos, coord, dicomInfo){
	origin:=dicomInfo.origin
	, spacing:=dicomInfo.spacing
	, dimension:=dicomInfo.dimension
	
	if IsObject(coord.pacsPos)
		pacsPos:=coord.pacsPos
	else{	
		pacsPos:=coordToPacsPos(origin, coord, spacing)
	}
	
	target:=[]
	if(framePos.w/framePos.h > dimension.x*spacing.x/dimension.y/spacing.y){ ;image height = frame height
		target.y:=Floor(framePos.h * pacsPos.y / dimension.y ) + framePos.y -1
		, imageW:=framePos.h * dimension.x / dimension.y
		, target.x:=Floor(imageW * pacsPos.x / dimension.x ) + framePos.x -1 
	}else{ ;image width = frame width
		target.x:=Floor(framePos.w * pacsPos.x / dimension.x ) + framePos.x -1
		, imageH:=framePos.w * dimension.y / dimension.y
		, target.y:=Floor(imageH * pacsPos.y / dimension.y ) + framePos.y -1 
	}
	
	return {x: target.x, y: target.y}
	;~ impaxSelectImage(pacsPos.z, seriesNo, {x: target.x, y: target.y})
}

coordToPacsPos(origin, coord, spacing){
	pacsPos:=[]
	for k,v in coord
		pacsPos[k]:=Floor((v-origin[k])/spacing[k])+1
	return pacsPos
}
PacsToCoord(impaxHwnd="", aspectRatio=1){
	if !WinExist("ahk_id " impaxHwnd)
		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
			return
	static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"
	MouseGetPos,mX,mY,win,frameHwnd,2
	SEIM:=getSEIM(impaxHwnd)
	
	;~ for k,v in clientImNo:=getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
		;~ if ((t:=ControlGetText(v))!="" && RegExMatch(t, clientImNoReg, match)){
			;~ allImNo:=match2
			;~ break
		;~ }	
	WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%
	if(fW/fH > aspectRatio){ ; image height = frame height
		coordY:=(mY-fY)/fH
		,coordX:=(mX - (fW-fH*aspectRatio)/2) / (fH*aspectRatio)
	}else{
		coordX:=(mX-fX)/fW
		,coordY:=(mY-(fH-fW/aspectRatio)/2) / (fW/aspectRatio)
	}
	SEIM.push(Floor(coordX*1024)), SEIM.push(Floor(coordY*1024))
	return SEIM
}

getImpaxAllImNo(impaxHwnd){
	static clientImNoReg:="i)S: \d+\/(\d+) +I: \d+\/(\d+)"
	if !WinExist("ahk_id " impaxHwnd)
		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
			return
	
	for k,v in getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
		if ((t:=ControlGetText(v))!="" && RegExMatch(t, clientImNoReg, match)){
			return match2
		}	
	
}

;~ impaxSelectImage(35,8)
;~ a:=1
;~ esc::ExitApp

/*
move to series (using nextKey, prvKey), scroll to specific image
MouseMoveCoord default = {x: 0.8, y: 0.5} (relative to frame width/height of that series)
*/
impaxSelectImageCurrent(xratio, yratio, slice_number){
	return impaxSelectImage(slice_number, "", {x: xratio, y:yratio}, "", "", "", "", true)
}
;~ Sleep 2000
;~ impaxSelectImage(22, "", {x: 0.8, y:0.5}, "", "", "", "", true)
impaxSelectImage(im, SeriesNoOrFrameCoord="", MouseMoveCoord="", whichScreen="", impaxHwnd="", nextKey="{Right}", prvKey="{Left}", current=false){
	CoordMode,mouse,screen
	static SEIMReg:="i)DICOM S: (\d+) +I: (\d+)", clientImNoReg:="i)S: (\d+)\/\d+ +I: (\d+)\/(\d+)"
	static lastFoundFrameHwnd
	
	if !WinExist("ahk_id " impaxHwnd)
		if !WinExist("ahk_id " impaxHwnd:=impaxOpened()[2,1])
			return
	
	winactivate, % "ahk_id " impaxHwnd
	WinGetPos,wx,wy,,,% "ahk_id " impaxHwnd
	
	SEIM:=getNetControl2(impaxHwnd,"","DicomImageNumbers","","WindowsForms10.STATIC.app","","","",0)
	,clientImNo:=getNetControl2(impaxHwnd,"","ClientImageNumbers","","WindowsForms10.STATIC.app","","","",0)
	if (current){
		frameHwnd:=getFocusedHwnd(), matched:=false
		for screen, v1 in frames:=getViewFrame(impaxHwnd)
			for x, v2 in v1
				for y, hwnd in v2 
					if(hwnd=frameHwnd){
						matched:=true
						break, 3
					}
					
		if !matched
			return
		
		ControlGetPos,cx,cy,cw,ch,,% "ahk_id " frameHwnd
		ControlFocus,,% "ahk_id " frameHwnd
		MouseMove,% mX:=wx+cx+Floor(cw*3/4),% wy+cy+Floor(ch/2),0
		Sleep 50
	}else if IsObject(seriesNoOrFrameCoord){
		frameHwnd:=getViewFrame(impaxHwnd)[seriesNoOrFrameCoord[1], seriesNoOrFrameCoord[2], seriesNoOrFrameCoord[3]]
		if !frameHwnd
			return
		ControlGetPos,cx,cy,cw,ch,,% "ahk_id " frameHwnd
		ControlFocus,,% "ahk_id " frameHwnd
		MouseMove,% mX:=wx+cx+Floor(cw*3/4),% wy+cy+Floor(ch/2),0
		Sleep 50
	}else{ ;specify SE
		se:=seriesNoOrFrameCoord, matched:=false, recordFrameSe:=""
		Loop 15 {
			if controlexist(lastFoundFrameHwnd){
			
				v3:=lastFoundFrameHwnd
			
				ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3
				ControlFocus,,% "ahk_id " v3
				MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0
				Sleep 100
				
				for k,v in SEIM
					if ((t:=ControlGetText(v))!=""){
						if RegExMatch(t, SEIMReg, match){
							;~ if(recordFrameSe=match1) ; full loop, not found
								;~ return
							;~ if (LoopInd=2 && recordFrameSe="")
								;~ recordFrameSe:=match1
							if(match1=se){
								frameHwnd:=v3, matched:=true
								break, 2
							}
						}
						break
					}
			}
			
			LoopInd:=A_Index
			for k1,v1 in frames:=getViewFrame(impaxHwnd, whichScreen)
				for k2,v2 in v1
					for k3,v3 in v2 {
						;~ if(v3=lastFoundFrameHwnd)
							;~ continue
						
						ControlGetPos,cx,cy,cw,ch,,% "ahk_id " v3
						ControlFocus,,% "ahk_id " v3
						MouseMove,% mX:=wx+cx+Floor(cw*3/4),% mY:=wy+cy+Floor(ch/2),0
						Sleep 100
						
						for k,v in SEIM
							if ((t:=ControlGetText(v))!=""){
								if RegExMatch(t, SEIMReg, match){
									;~ if(recordFrameSe=match1) ; full loop, not found
										;~ return
									;~ if (LoopInd=2 && recordFrameSe="")
										;~ recordFrameSe:=match1
									if(match1=se){
										lastFoundFrameHwnd:=frameHwnd:=v3, matched:=true
										break, 5
									}
								}
								break
							}
							
						for k,v in clientImNo
						if ((t:=ControlGetText(v))!=""){
							if RegExMatch(t, clientImNoReg, match){
								if(recordFrameSe=match1) ; full loop, not found
									return
								if (LoopInd=2 && recordFrameSe="")
									recordFrameSe:=match1
								
							}
							break
						}
					}
			
			if(!matched){
				winactivate,% "ahk_id " impaxHwnd
				ControlFocus,,ahk_id %v3%
				send % nextKey
				Sleep 200
			}
		}
	}
	
	if(!matched)
		return
	
	;~ for k,v in SEIM
		;~ if ((t:=ControlGetText(v))!=""){
			;~ SEIMhwnd:=v
			;~ ,SEIMtext:=t
			;~ break
		;~ }
		
	for k,v in clientImNo
		if ((t:=ControlGetText(v))!=""){
			clientImNoHwnd:=v
			,clientImNoText:=t
			break
		}	
	
	
	if RegExMatch(clientImNoText, clientImNoReg, match){
		allImNo:=match3
		send {LButton Down}
		
		MouseMove,% mX, % mY:=impaxImNoToMousePos(im, wy+cy, ch, allImNo),3
		send {LButton up}
	}
	if im>allImNo
		im:=allImNo
	winactivate,% "ahk_id " impaxHwnd
	ControlFocus,,ahk_id %frameHwnd%
	wheelWay:=1, dist:=confirmPos:=0
	loop {
		if !RegExMatch(ControlGetText(clientImNoHwnd), clientImNoReg, match)
			break
		;~ ToolTip % match2
		if(match2=im && ++confirmPos>1)
			break
		if(dist && Abs(match2-im)>dist)
			wheelWay:=!wheelWay
		if (match2-im)*(wheelWay-0.5)>0
			send % "{WheelUp " Abs(match2-im) "}"
		else
			send % "{WheelDown " Abs(match2-im) "}"
		dist:=Abs(match2-im)
		Sleep 100
		
		;~ mousemove,-1,-1,1,R
		;~ mousemove,1,1,1,R
	}
	
	if(MouseMoveCoord="" || !MouseMoveCoord.x || !MouseMoveCoord.y)
		MouseMoveCoord:={x:0.8, y:0.5}
	
	; assume square image, eg 512*512
	WinGetPos,fX,fY,fW,fH,ahk_id %frameHwnd%
	if(fW>=fH)
		MoveCoordX:=Floor(fX+(fW-fH)/2+fH*MouseMoveCoord.x)
		,MoveCoordY:=Floor(fY+fH*MouseMoveCoord.y)
	else
		MoveCoordY:=Floor(fY+(fH-fW)/2+fW*MouseMoveCoord.y)
		,MoveCoordX:=Floor(fX+fW*MouseMoveCoord.x)
	mousemove,% MoveCoordX,% MoveCoordY,1
	return [MoveCoordX, MoveCoordY]
}

;~ a:=impaxMousePosToImNo(469, 1, 936,21)
;~ b:=impaxMousePosToImNo(468, 1, 936,21)
;~ MsgBox % a "," b
;~ a:=impaxImNoToMousePos(1, 1, 936, 21, true)
;~ MsgBox % a.1 "," a.2
;~ ExitApp

impaxMousePosToImNo(mouseY, frameY, frameH, allImNo){
	return Floor((mouseY-frameY)*allImNo/frameH + 0.5)+1
}
impaxImNoToMousePos(k, frameY, frameH, allImNo, interval=false){
	range:=[k=1?frameY:impaxImNoToMousePos(k-1, frameY, frameH, allImNo)+1,k=allImNo?frameY+frameH-1:Ceil(frameH*(2*k-1)/2/allImNo)+frameY-1]
	if !interval
		return Floor((range.1 + range.2)/2)
	else 
		return range
}


risOpenOldStudy(risHwnd){
	;~ static openOldStudyRule:={CT:{}, MR: {}, XR:{}, other:{}}
	
	regEx:=""
	for k,v in (ExamItems:=parseRisExamItems(getRisExamItems(RisHwnd)))[1]
		if RegExMatch(v, "i)(CT|MRI)[^-]+-+([\w ]+)", match)
			regEx.="((CT|MRI)[^-]+-+" match2 ")|"
		else if (v="Perfusion CT")
			regEx.="((CT|MRI)[^-]+-+Brain)|(Perfusion CT)|"
		
		
	regEx:="i)" SubStr(regEx,1,-1)
	if(regEx="")
		return

	examDate:=getRisExamDate(risHwnd)
	;~ ,thisAccNo:=getRisAccNo(risHwnd)
	
	for k,v in rows:=acc_children(RisHistoryAcc:=acc_ObjectFromWindow(getRisHistoryId(RisHwnd))){ 
		if(k=1){
			for x,y in cells:=acc_children(v) {
				if (y.accValue="照會單號"){
					AccNoCol:=x
				}else if (y.accValue="檢查日"){
					examDateCol:=x
				}else if (y.accValue="檢查名稱"){
					examNameCol:=x
				}
			}
		}else if regexmatch(ExamName:=acc_children(v)[examNameCol].accValue, regEx) {
			priorDate:=acc_children(v)[examDateCol].accValue
			if RegExReplace(priorDate,"\W","")>SubStr(RegExReplace(examDate,"\W",""),1,8)
				continue
			else if RegExReplace(priorDate,"\W","")=SubStr(RegExReplace(examDate,"\W",""),1,8){
				isSameStudy:=false
				for x,y in ExamItems[1]
					if(y=ExamName){
						isSameStudy:=true
						break
					}
				if(isSameStudy)
					continue
			}
			
			
			v.accSelect(ComObj(3,3),0)
			
			if(impaxContextServerHwnd:=winexist("ahk_exe ImpaxContextServer.exe")){
			;~ if(0){
				;~ sendStr:="SYNC_DISPLAY || " thisAccNo " || "
				ImpaxContextServer_Add(Trim(acc_children(v)[AccNoCol].accValue))
				Loop {
					if !(RegExReplace(priorDate,"\W","")=RegExReplace(test:=(nearRow:=acc_children(rows[k-A_Index]))[examDateCol].accValue,"\W","") && InStr(test2:=nearRow[examNameCol].accValue,"CT"))
						break
					ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))
				}
				Loop {
					if !(RegExReplace(priorDate,"\W","")=RegExReplace((nearRow:=acc_children(rows[k+A_Index]))[examDateCol].accValue,"\W","") && InStr(nearRow[examNameCol].accValue,"CT"))
						break
					ImpaxContextServer_Add(Trim(nearRow[AccNoCol].accValue))
				}
				;~ sendStr.="ADD_TO_DISPLAY_LIST_WITH_PRIORS || " thisAccNo " || "
				;~ SetTimerFn("cmdContextServer", -1, [sendStr, impaxContextServerHwnd])
				;~ Send_WM_COPYDATA(impaxContextServerHwnd, 0, sendStr)
			}else{
				sleep 200
				loc:=Acc_Location(v)
				mouseclick,r,% loc.x+50,% loc.y+5,1,0
				sleep 200
				mouseclick,l,10,10,1,0,,R
			}
			break
		}
	}
	
}

;~ MsgBox % ExploreObj(parseOldSEIM())
;~ ExitApp

parseOldSEIM(RisHwnd=""){
	if !WinExist("ahk_id " RisHwnd)
		RisHwnd:=risOpened()[2]
	
	RisReports:=getRisReports(RisHwnd)
	, oldReportText:=ControlGetText(RisReports[2,1])
	, ret:=[]
	if Trim(oldReportText)=""
		return ret
	
	i:=0, j:=1
	while i:=RegExMatch(oldReportText, "i)\(([^\)\n]+)\)", match, j) {
		thisSE:=""
		if (k:=RegExMatch(match1, "i)SE *(\d+) *[\/\\]?", SE)) || (k:=RegExMatch(match1, "i)^(\d+) *[\/\\]", SE)) 
			IMtext:=SubStr(match1, k+StrLen(SE)), thisSE:=SE1
		else 
			IMtext:=match1
		
		if (k:=InStr(IMtext, "IM")) && (RegExReplace(IMtext:=SubStr(IMtext,k), "i)IM|[\,\; ]", "") ~= "^\d+$"){
			IMs:=RegExReplace(IMtext, "i)IM|[\,\; ]", ","), IMarr:=[]
			loop,parse,IMs,`,
				if RegExMatch(A_LoopField, "\d+", imMatch)
					IMarr.push(imMatch)
			
			if (IMarr.maxIndex()>0){
				if !(thisSE ~= "^\d+$")
					thisSE:=lastSE
				
				if thisSE!=
					for x,im in IMarr
						ret.push([thisSE, im])
					
				lastSE:=thisSE
			}
		}
		
		j:=i+StrLen(match)
	}
	return ret
	
}
/*
class RisClass extends Polling {
	
	refresh(){
		this.base.state:=RisOpened()
		if this.compareState() && this.callback
			this.callback.call()
	}
}

;~ Ris:=CriticalObject(new Ris), Impax:=CriticalObject(new Impax), RisChanged:=false
;~ ,Ris.changeCallback("t")
;~ ,impax.StartPoll()

;~ th:=ahkthread("
;~ (%
;~ #Persistent
;~ Ris:=CriticalObject(" (&Ris) ")
;~ settimer,test,500
;~ return
;~ test:
;~ ToolTip % "","" Ris.state[1,2]
;~ return
;~ )")
;~ i:=CriticalObject(new Ris)
;~ i.changeCallback("t")

;~ t(){
	;~ MsgBox
;~ }
;~ esc::ExitApp
class ImpaxClass extends Polling  {
	
	refresh(){
		this.base.state:=impaxOpened()
		if this.compareState() && this.callback
			this.callback.call()
	}
	
}

class Polling {
	__New(){
		this.callback:=""
		,this.base.state:=[]
		,this.base.priorState:=[]
		,this.refresh()
		
	}
StartPoll(interval=500, timeout=-1) {
		this.StopPoll()
		,this.refresh()
		,this.SetTimer(this.base.refresh,interval,[AllRis])
		if(timeout>0){
			 this.SetTimer(this.base.StopPoll, Floor(timeout)*(-1))
		}
	}
	
  StopPoll() {
    this.SetTimer(this.base.refresh)
	,this.SetTimer(this.base.StopPoll)
  }
  changeCallback(func, interval=500, timeout=-1){
		this.callback:=IsObject(func)?func:func(func)
		,this.base.priorState:=this.base.state
		,this.StartPoll(interval, timeout)
	}
	
	
  compareState(){
		state1:=this.base.state, state2:=this.base.priorState
		,ret:=true
		for k,v in state1
			if IsObject(v)
				for x,y in v
					ret&= (y=state2[k][x])
			else
				ret &= (v=state2[k])
		this.base.priorState:=this.base.state
		return !ret
	}
  SetTimer( Function, Period=0, ParmObject=0, Priority=0 ) { 
    Static tmrs:=[] ; will hold timers that are currently running
    If IsFunc( Function ) {
      if IsObject(tmr:=tmrs[this]) ;destroy timer before creating a new one
        ret := DllCall( "KillTimer", "Ptr",0, "UPtr", tmr.tmr)
        , DllCall("GlobalFree", "Ptr", tmr.CBA)
        , ObjRemove(tmrs,this)
      if (Period = 0 || Period = "off")
        return ret ;Return as we want to turn off timer
      ; create object that will hold information for timer, it will be passed trough A_EventInfo when Timer is launched
      tmr:=tmrs[this]:={func:Function,ref:this,Period:Period="on" ? 250 : Period,Priority:Priority
                        ,OneTime:Period<0,params:IsObject(ParmObject)?ParmObject:[],Tick:A_TickCount}
      ,tmr.CBA := RegisterCallback(this.base.SetTimer,"F",4,&tmr)
      return !!(tmr.tmr  := DllCall("SetTimer", "Ptr",0, "Ptr",0, "UInt"
            , (Period && Period!="On") ? Abs(Period) : (Period := 250)
            , "Ptr",tmr.CBA)) ;Create Timer and return true if a timer was created
            , tmr.Tick:=A_TickCount
   }
  if IsObject(tmr := Object(A_EventInfo)) { ;A_Event holds object which contains timer information
    DllCall("KillTimer", "Ptr",0, "UPtr",tmr.tmr) ;deactivate timer so it does not run again while we are processing the function
    ,tmr.tick:= ErrorLevel := A_TickCount ;update tick to launch function on time
    ,func:=tmr.func,%func%(tmr.ref,tmr.params*) ; call function
    if (tmr.OneTime) ;One time timer, deactivate and delete it
      return DllCall("GlobalFree", "Ptr",tmr.CBA)
            ,ObjRemove(tmrs,tmr.ref?tmr.ref:tmr.func)
   tmr.tmr := DllCall("SetTimer", "Ptr",0, "Ptr",0, "UInt" ;reset timer
            ,((A_TickCount-tmr.Tick) > tmr.Period) ? 0 : (tmr.Period-(A_TickCount-tmr.Tick)), "Ptr",tmr.CBA)
  }
  }

}
*/


getEBMChartNo(all=false){
	if (!all){
		WinGetTitle,title,% "病歷號: ahk_class TViewerForm"
		RegExMatch(title, "病歷號: ([^ ]+) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d{4})\/(\d\d)\/(\d\d) 存取編號: ([^ ]+)", match)
		return match1	
	}
	
	winget,list,list,% "病歷號: ahk_class TViewerForm"
	ret:=[]
	loop % list {
		WinGetTitle,title,% "ahk_id " list%a_index%
		if RegExMatch(title, "病歷號: ([^ ]+) 姓名: ([^ ]+) (\d+)(M|F) 日期: (\d{4})\/(\d\d)\/(\d\d) 存取編號: ([^ ]+)", match)
			ret.push(match1)
	}
	return ret
}

;~ selectRisListItem("", "", "J003615", true)
;~ ExitApp
selectRisListItem(index="", AccNo="", chartNo="", ByRef ReportList="", ByRef RisListHwndAcc="", ByRef RisState="",MultiSelect=false){
	if (RisState="")
		RisState:=risOpened()
	
	if (RisListHwndAcc="")
		RisListHwnd:=getRisList(RisState[2])
		,RisListAcc:=acc_ObjectFromWindow(RisListHwnd)
	else if IsObject(RisListHwndAcc)
		RisListAcc:=RisListHwndAcc, RisListHwnd:=acc_windowfromobject(RisListAcc)
	else
		RisListHwnd:=RisListHwndAcc, RisListAcc:=acc_ObjectFromWindow(RisListHwnd)
	
	
	
	if (!index && AccNo="" && chartNo ="")
		index:=1
	
	if (AccNo chartNo = ""){
		if IsObject(index){
			acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0) ;unselect
			for k,v in index
				selectRisListItem(v, "", "", doubleClick, ReportList, RisListAcc, true)
		}else{
			item:=acc_children(RisListAcc)[index+1]
			if !IsObject(item)
				return -1
			
			item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
			
			
		}
	}else{
		if (ReportList="")
			ReportList:=parseDataGrid2(RisListHwnd)
		
		
		for k,v in reportList[1] {
			if (v="照會單號") {
				AccNoCol:=k
			}
			if (v="病歷號") {
				chartNoCol:=k
			}
		}
		
		if (AccNo){
			if IsObject(AccNo){
				acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0) ;unselect
				for k,v in AccNo
					selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)
			}else{
				
				for k,v in ReportList 
					if (v[AccNoCol]=AccNo){
						item:=acc_children(RisListAcc)[k]
						if !IsObject(item)
							return -1
						
						item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
						break
					}
			}
		}else{
			if IsObject(ChartNo){
				acc_children(RisListAcc)[2].accSelect(ComObj(3,16),0) ;unselect
				for k,v in ChartNo
					selectRisListItem("", v, "", doubleClick, ReportList, RisListAcc, true)
			}else{
				
				for k,v in ReportList 
					if (v[ChartNoCol]=ChartNo){
						item:=acc_children(RisListAcc)[k]
						if !IsObject(item)
							return -1
						
						item.accSelect(MultiSelect?ComObj(3,8):ComObj(3,3),0)
						break
					}
			}
		}
	
	
	}
	
	;~ if (doubleClick && !MultiSelect){
		;~ loc:=Acc_Location(item)
		
		;~ acc_children(item)[3].accDoDefaultAction()
		;~ ControlClick,% "x510 y510",% "ahk_id " RisState[2],,L,10
	;~ }
	return item
	
}