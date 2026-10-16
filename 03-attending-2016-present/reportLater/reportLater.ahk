ComObjError(false)
OnExit,OnExit
setbatchlines,-1
CoordMode,mouse,Screen
DetectHiddenWindows,on
SetTitleMatchMode,2
#SingleInstance,force
#include <risimpax>

if !(risPath:=GetRisPath()){
	MsgBox,,, % "Can't find RIS path!",10
	ExitApp
}

ris_id:="000000"
,ris_pw:="@WSX3edc"
,delayHr:=12

SetTimer,routine,200
SetTimer,noidle,300000
SetTimer,main,3600000
gosub main
return



main:
AllRis:=RisOpened(1)
,Abort:=false
if !AllRis[2].maxindex()
	gosub openRis
SetTimer,activateLoginRis,Off
if Abort
	return

AllRis:=RisOpened(1)
if !AllRis[2].maxindex() {
	MsgBox,,,% "Can't login RIS!",10
	return
}
risHwnd:=AllRis[2][1]
,tmpSaveButton:=getNetAcc(risHwnd,"cmdSAVE","WindowsForms10.BUTTON")
,RisListHwnd:=getRisList(RisHwnd)
,RisListAcc:=acc_objectfromwindow(RisListHwnd)
if !tmpSaveButton {
	MsgBox,,,% "Can't find ER button in RIS!",10
	return
}
tmpSaveButton.accDoDefaultAction()
,pListCount:=0
Loop {
	cListCount:=acc_children(RisListAcc).maxindex()
	if (pListCount = cListCount || A_Index>20)
		break
	pListCount:=cListCount
	Sleep 500
}
ReportList:=parseDataGrid2("", risHwnd)
,ExamDateCol:=ReportList.colNos["ExamDate"]
,IOECol:=ReportList.colNos["診別"]
,RisListRows:=acc_children(RisListAcc)
,selected:=0
for k,row in ReportList {
	if k=1 
		continue
	examDate:=RegExReplace(row[ExamDateCol], "\D", "")
	;~ ToolTip % !withinTimeRange(examDate, delayHr) "," row[IOECol]
	if !withinTimeRange(examDate, delayHr) && InStr(row[IOECol],"急診")
		(RisListRows[k]).accSelect((!selected)?ComObj(3,3):ComObj(3,8))
		,selected:=selected?selected:k
	
}
if(selected){
	RisVisible:=WinVisible(risHwnd)
	WinShow,% "ahk_id " risHwnd
	WinActivate,% "ahk_id " risHwnd
	WinWaitActive,% "ahk_id " risHwnd,,3
	tabs:=getNetControl2(risHwnd,"","B_ACTIVE","","WindowsForms10.BUTTON")
	if tabs[2]
		acc_objectfromwindow(tabs[2]).accDoDefaultAction()
	loc:=acc_location(RisListRows[selected])
	Sleep 500
	mouseclick,r,% loc.x+Floor(loc.w/2),% loc.y+Floor(loc.h/2),1,1
	Loop {
		Sleep 100
	}until (MenuHwnd:=getRisSmallMenu()) || A_Index >20
	
	if MenuHwnd
		acc_children(acc_objectfromwindow(MenuHwnd))[2].accDoDefaultAction(0)
	else
		;~ MouseMove,20,30,1,r
		mouseclick,l,20,30,1,1,,r
		
	winwait,kReport ahk_exe Menu.exe,是否確定要發送,3
	if !ErrorLevel
		ControlClick,Button1,kReport ahk_exe Menu.exe,是否確定要發送
	
	if !RisVisible
		WinHide,% "ahk_id " risHwnd
}
main_end:
return

withinTimeRange(time, Range){
	t:=A_Now
	t-=time, Hours
	return t<Range
}

openRis:
if (!AllRis[1].maxindex()){
	run % risPath
	Loop {
		AllRis:=RisOpened(1)
		Sleep 500
	}until AllRis[1].maxindex() || A_Index>20
}
if (!AllRis[1].maxindex()){
	MsgBox,,,% "Can't open RIS",10
	Abort:=true
	return
}
loginRis:=AllRis[1][1]
SetTimer,activateLoginRis,100
SetTimer,activateLoginRis,On
tryLogin:=0
tryLogin:
++tryLogin
RISarr:=getControls(loginRis)
,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)
controlfocus,,ahk_id %RisIdHwnd%
send {home}+{end}
Sleep 200
send % ris_id
send {tab}
Sleep 1000
send {home}+{end}
Sleep 200
send % ris_pw
send {enter}
WinWaitClose,% "ahk_id " loginRis,,3
if (ErrorLevel){
	if (tryLogin<4)
		goto tryLogin
	else 
		Abort:=true
}

return


activateLoginRis:
if !WinExist("ahk_id " loginRis)
	return
WinShow,% "ahk_id " loginRis
WinActivate,% "ahk_id " loginRis
return

OnExit:
ExitApp

routine:
ifwinexist,ahk_class #32770,% "已有程式執行中,是否確定重複開啟程式"
	controlclick,Button1
ifwinexist,ahk_class #32770,% "發送完成"
	controlclick,Button1

return

noidle:
RisNoIdle(risHwnd)
return