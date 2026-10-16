﻿﻿SetBatchLines,-1
#SingleInstance,force
#Persistent
SetTitleMatchMode,2
DetectHiddenWindows,on
#NoTrayIcon
OnExit,OnExit
;~ put_shortcut:=false
;~ if FileExist(Lnk:=a_startup "\AHK_BG.lnk") {
	;~ FileGetShortcut,% Lnk,target,dir
	;~ if (target = A_ScriptDir "AHK_BG.bat" && dir = A_ScriptDir)
		;~ put_shortcut:=true
;~ }

;~ if (!put_shortcut){
	;~ FileCreateShortcut,% A_ScriptDir "\AHK_BG.bat",% a_startup "\AHK_BG.lnk",% A_ScriptDir
;~ }
;~ SetTimer,runPutty,600000
AllowList=
(
autorun
digisign
boneage report
IVrecord
putShortcut
RisImpaxPolling
scsnakeUpdate
scsPackageManager
searchLab
執行住院醫師
AutoHotkey
AngioConsult
angioSchedule
writeSchedule
AutoNum
changeSchedule
chp
console
console64
diffReport
diffReportOld
DigiSign
DigiSign_noicon
FirefoxLogin
FirefoxLoginApp
FirefoxPortable
sqlite3
crashreporter
firefox
maintenanceservice
maintenanceservice_installer
minidump-analyzer
pingsender
plugin-container
plugin-hang-ui
updater
helper
Hotstring Helper
Hotstring Sort
HotstringFindDuplicate
ImpaxContextServer
LDCTreport
MammoSR
MammoSRprint
MammoSRPrintClient
MammoSRsend
portalMessage
RadTemplate
RFA note
AutoNum
RisHelper
textHotkey
showLungCAD
prettyOldHx
simpleRIS
simpleRIS_patch
AlwaysSync
importContacts
Sleipnir
SleipnirLogin
使用者設定
複製 -SleipnirLogin
AutoUpdate
FeedbackAgent
Restart
Sleipnir
Su
Repair
AlwaysSync
RemBlankPwd
SyncBackFree
textHotkey
TMS reader GUI
TMS reader
updateOpPatho
selectCT
urgentReport
VFSS2
XLiu
ChangeSchedule3
changeSchedule4
fillPath
RadTemplate
AllKill
AltGrabWin
AutoNum
autorun
capslock_remap_alt
EBMpreload
ImpaxContextServer
killUpdate
LDCTreport
RazerNaga
RisImpaxPolling
RisListQuickSearch
searchOpHx
showLungCAD
textHotkey
UIAutomationServer
YCH_BMD
YCH_Enh
YCH_mammo_Enh
YCH_XR_Enh
feedRIS
getAllJpeg
getJpeg
loadOldHx
miniPACS
miniPacsMain
miniPACS_bridge
mirrorRIS
PacsIE
PacsIEMain
prettyOldHx
simpleRIS
simpleRIS_patch
RadTemplate
)

if FileExist(l:=A_ScriptDir "\allowList.txt") {
	fileread,l,% l
	Loop,Parse,l,`n,`r
		AllowList.="`n" Trim(A_LoopField)
}

AllowList.="`n"

SetTimer,routine,100
gosub routine2
SetTimer,routine2,30000


return

!+^#j::
WinShow,myserver.local - PuTTY ahk_exe putty.exe
MsgBox,,,AHK_BG,5
return


!+^#q::
MsgBox, 4, , Exit?
IfMsgBox,Yes
	ExitApp
return

routine2:
if !WinExist("ahk_exe RBTray.exe")
	return
DetectHiddenWindows,Off
for k,v in AltTab_window_list() {
	if !(InStr(v.title,"anydesk"))
		continue
		
	winget,pname,ProcessName,% "ahk_id " v.hwnd
	if (pname~="i)anydesk|ksedyna"){
		winactivate,% "ahk_id " v.hwnd
		WinWaitActive,% "ahk_id " v.hwnd,,2
		send !#{Down}
		WinWaitNotActive,% "ahk_id " v.hwnd,,2
	}
		
}
DetectHiddenWindows,On
return

routine:
;~ ToolTip % A_TickCount
IfWinExist,開啟檔案 ahk_class #32770,確定要執行
{
	ControlGetText,t,SysLink1
	if (RegExMatch(t, "i)([^\\\/]+).exe$", match) && InStr(AllowList, "`n" match1 "`n")) || InStr(t,"autohotkey")
		ControlClick,Button1
	
}
		
IfWinExist,Symantec Endpoint Protection ahk_exe SavUI.exe
{
	ControlGetText,pname,Static7
	pname:=RegExReplace(pname, "i).exe$", "")
	if InStr(AllowList, "`n" pname "`n") || InStr(pname, "autohotkey") {
		ControlClick,Button2,Symantec Endpoint Protection ahk_exe SavUI.exe
	}
}
IfWinExist,ahk_exe rebootMsg.exe
	winclose
return

runPutty:
if !WinExist("ahk_exe putty.exe")
	run, % "D:\Users\raduser\Documents\RemoteList\PuTTY\putty.exe -load ""nas""",% "D:\Users\raduser\Documents\RemoteList\PuTTY"
WinHide,myserver.local - PuTTY ahk_exe putty.exe
return

OnExit:
WinShow,myserver.local - PuTTY ahk_exe putty.exe
ExitApp



AltTab_window_list()
{
  ;~ global
  WS_EX_CONTROLPARENT =0x10000
  WS_EX_APPWINDOW =0x40000
  WS_EX_TOOLWINDOW =0x80
  WS_DISABLED =0x8000000
  WS_POPUP =0x80000000
  AltTab_ID_List :=[]
  AltTab_ID_List_i :=0
  WinGet, Window_List, List ; Gather a list of running programs
  id_list =
  Loop, %Window_List%
    {
    wid := Window_List%A_Index%
    WinGetTitle, wid_Title, ahk_id %wid%
    WinGet, Style, Style, ahk_id %wid%

    If ((Style & WS_DISABLED) or ! (wid_Title)) ; skip unimportant windows ; ! wid_Title or 
        Continue

    WinGet, es, ExStyle, ahk_id %wid%
    Parent := Decimal_to_Hex( DllCall( "GetParent", "uint", wid ) )
    WinGetClass, Win_Class, ahk_id %wid%
    WinGet, Style_parent, Style, ahk_id %Parent%
    
    If ((es & WS_EX_TOOLWINDOW)
        or ((es & ws_ex_controlparent) and ! (Style & WS_POPUP) and !(Win_Class ="#32770") and ! (es & WS_EX_APPWINDOW)) ; pspad child window excluded
        or ((Style & WS_POPUP) and (Parent) and ((Style_parent & WS_DISABLED) =0))) ; notepad find window excluded ; note - some windows result in blank value so must test for zero instead of using NOT operator!
      continue
     AltTab_ID_List_i ++
     wingetclass,cl,ahk_id %wid%
     wingettitle,ti,ahk_id %wid%
     AltTab_ID_List.push({hwnd:wid, title: ti, class: cl})
    }
  return AltTab_ID_List
}

Decimal_to_Hex(var)
{
  SetFormat, integer, hex
  var += 0
  SetFormat, integer, d
  return var
}
