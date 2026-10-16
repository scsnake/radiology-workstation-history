﻿#include <RisImpax>
#include <ParseArg>
#MaxMem 4095
#NoEnv
#SingleInstance,force
SetBatchLines,-1
DetectHiddenWindows, On
SetTitleMatchMode,2
coordmode,mouse,screen

ComObjError(false)
onexit,onexit

args:=ParseArg()
;~ args[1]:="20180101"
;~ args[2]:="20180102"
;~ if (args.length()<2)
	;~ ExitApp

gosub main
ExitApp


return



main:

for k, arg in args {
	if yr=
		yr:=A_YYYY
	if RegExMatch(arg, "(\d{4,8})\-(\d{4,8})", match){
		startDate:=StrLen(match1)=4? yr match1:match1
		,endDate:=StrLen(match2)=4? yr match2: match2

		Loop {
			yr:=SubStr(startDate,1,4)
			,mn:=SubStr(startDate,5,2)+0
			,dy:=SubStr(startDate,7,2)+0
			,saveReportRecords(yr,mn,dy)
			if(startDate>=endDate)
				break
			startDate+=1,Days
			startDate:=SubStr(startDate,1,8)
		}

	}else if (RegExMatch(arg, "\d{4,8}", match)){
		startDate:=StrLen(match)=4?yr match: match
		,yr:=SubStr(startDate,1,4)
		,mn:=SubStr(startDate,5,2)+0
		,dy:=SubStr(startDate,7,2)+0
		,saveReportRecords(yr,mn,dy)
	}
}


return

^q::
KeyWait,esc,D T2
if ErrorLevel
	return
;~ esc::
ExitApp

saveReportRecords(yr,mn,dy){
	Loop {
		if winHwnd:=WinExist("報告數量統計 ahk_exe Menu.exe")
			break
		Loop {
			if (ReportCountButton:=getNetAcc(RisOpened(1)[2,1], "cmdReportCount", "BUTTON",0,0)){
				ControlFocus,,ahk_id %ReportCountButton%
				ControlClick,,ahk_id %ReportCountButton%
				winwait,報告數量統計 ahk_exe Menu.exe,,3
				Sleep 1000
				break
			}
			Loop {
				;~ test:=risopened(1)
				;~ ToolTip % test[2,1]
				if RisOpened(1)[2,1]
					break
				Loop {
					ifwinexist,ahk_class #32770,% "已有程式執行中,是否確定重複開啟程式"
					{ 
						controlclick,Button1
						Sleep 1000
					}
					if (RisOpened(1)[1,1]) {
						RISarr:=getControls(risid:=risopened(1)[1,1])
						,RisIdHwnd:=GetControlIdByText(RISarr,"Password",-1)
						controlfocus,,ahk_id %RisIdHwnd%
						winactivate,% "ahk_id " risId
						winwaitactive,% "ahk_id " risId,,3
						if(!errorlevel){
							controlfocus,,ahk_id %RisIdHwnd%
							send {home}+{end}
							Sleep 200
							winactivate,% "ahk_id " risId
							winwaitactive,% "ahk_id " risId,,3
							send % "000000"
							send {tab}
							Sleep 1000
							winactivate,% "ahk_id " risId
							winwaitactive,% "ahk_id " risId,,3
							send {home}+{end}
							Sleep 200
							winactivate,% "ahk_id " risId
							winwaitactive,% "ahk_id " risId,,3
							send % "6YHN7ujm"
							send {enter}
							Sleep 15000
							break
						}
					}else{
						;~ RisPath:=getrispath(1)
						if FileExist(RISpath:="C:\Users\IDI\AppData\Local\Apps\2.0\TMPKWD4G.D6R\9ABX4LL4.YG8\menu..tion_0000000000000000_0001.0000_f43d6f3ff364bce9\Menu.exe") 
							|| FileExist(RISpath:="D:\Users\raduser\AppData\Local\Apps\2.0\3KV2DJ69.MYO\624QHN9A.HDM\menu..tion_0000000000000000_0001.0000_f43d6f3ff364bce9\Menu.exe")
							run,% risPath,% RegExReplace(RISpath, "\\Menu\.exe$")
						Sleep 5000
					}
				}
			}
		}
	}


	winactivate,% "ahk_id " winHwnd
	WinWaitActive,% "ahk_id " winHwnd,,3
	
	
	Loop {
		startDateHwnd:=getNetAcc(winHwnd,"StartDate","WindowsForms10.SysDateTimePick32.app",0,false)
		,EndDateHwnd:=getNetAcc(winHwnd,"EndDate","WindowsForms10.SysDateTimePick32.app",0,false)
		,date:=yr "/" mn "/" dy
		,RisSetDate(startDateHwnd, date)
		,RisSetDate(EndDateHwnd, date)
		,cboVS:=getNetAcc(winHwnd, "cboVS", "COMBOBOX",0,0)
		,cboVSEdit:=getNetAcc(winHwnd, "cboVS", "COMBOBOX",1,0)
		ControlFocus,,% "ahk_id " cboVS
		ControlSetText,,% "",%  "ahk_id " cboVS
		controlsend,,{Space},%  "ahk_id " cboVS
		ControlFocus,,% "ahk_id " cboVSEdit
		ControlSetText,,% "",%  "ahk_id " cboVSEdit
		controlsend,,{Space},%  "ahk_id " cboVSEdit
		dg:=getNetAcc(winHwnd, "DataGridView1", "WindowsForms",0,1)
		,p_results:=acc_children(acc_children(dg)[2])[4].accValue
		search:=getNetAcc(winHwnd, "cmdSearch", "BUTTON",0,0)
		ControlFocus,,% "ahk_id " search
		ControlClick,,% "ahk_id " search
		winwait,kReport ahk_class #32770,起迄日期錯誤,1
		if ErrorLevel 
			break
		WinClose,kReport ahk_class #32770,起迄日期錯誤
		Sleep 500
	}

	error:=false
	Loop {
		Sleep 5000
		this_results:=acc_children((dg_rows:=acc_children(dg))[2])[4].accValue
		;~ ToolTip % this_results
		if InStr(this_results, yr "/" mn "/" dy)
			break
		;~ p_results:=this_results
		if(A_Index>24){
			error:=true
			break
		}
	}
	if(error)
		clipboard:=""
	else
		parseDataGrid2(acc_windowfromobject(dg), winHwnd, dg_rows, false, false, false, true, false, true)
	FileDelete,% f:=yr format("{:02}", mn) format("{:02}", dy) ".txt"
	FileAppend,% clipboard,% f, utf-8
}



RisSetDate(controlHwnd, dateStr){
	ControlFocus,,ahk_id %controlHwnd%
	controlsend,,% dateStr "{Right}",ahk_id %controlHwnd%
}


OnExit:
ExitApp

