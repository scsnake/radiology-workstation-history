#MaxMem 4095
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,Ignore
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on
ComObjError(false)
#notrayicon
;~ onexit,onexit
#persistent
#include <CryptFileRead>
#include <WM_COPYDATA>
#include <RisImpax>
#include <JXON>
#Include %A_ScriptDir%
#include jpegDirName.ahk
OnExit,OnExit
if CryptFilePW()
	ExitApp


OnMessage(0x4a, "On_WM_COPYDATA")
OnMessage(0x10101, "exit")
,reportDir:=A_MyDocuments "\feedRIS"
,decrypted:=[]
;~ MsgBox % __CryptStr("w9NUmEZOkhoSpaL2fPrcb4FkIlbhD3Dp26LlZLM6LkCka34I7d8=",____,0)
;~ ExitApp
;~ reportList:=ParseDataGrid2().data
;~ decryptAll()

gui,main:Default
gui,+hwndguihwnd
WinSetTitle,% "ahk_id " guihwnd,,decryptJpeg_main
;~ ToolTip % guihwnd
return 

exit(){
	ExitApp
}


On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	Critical
	global AccNoCol, examDateCol, examNameCol, ChartNoCol, statusCol, loadSavedReportInfo, fastMode, thisReportListIndex, thisAccNo, thisChartNo, reportList, fastReportQ, turboMode, start_ind, reportDir
	;~ static lastTick
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,str := StrGet(lpData)
	
	if (dwData=17){
		try
			j:=jxon_load(str)
		catch e
			return
		;~ MsgBox % exploreobj(j)
		if(j.haskey("start_from")){
			start_ind:=j.start_from
		}else if(j.haskey("reportList")){
			reportList:=j.reportList
			;~ MsgBox % ExploreObj(reportList)
			SetTimer,decryptAll,-1
			
		}else if(j.haskey("reportDir")){
			reportDir:=j.reportDir
		}
	}

}


decryptAll(){
	global reportList, reportListCount, start_ind, reportDir, ____, decrypted
	reportList:=new DataGridTable(reportList)
	,reportListCount:=reportList.maxindex()
	, start_ind:=start_ind?start_ind:2
	
	for k, row in reportList {
		if(k<start_ind) || k==1
			continue
		accNo:=row.getCell("AccNo")
		,chartNo:=row.getCell("ChartNo")
		if FileExist(reportDir "\" accNo " " chartNo "\" accNo " " chartNo " 1.jpeg")
			continue
		
		crypt_acc_chart:=__CryptStr(accNo " " chartNo,____)
		FileCreateDir,% reportDir "\" accNo " " chartNo
		noFile:=true
		Loop, Files, % reportDir "\" crypt_acc_chart "\*.jpeg_"
		{
			if !RegExMatch(A_LoopFileName, "is)^(.+) (\d+)\.([^\.]+)", match)
				continue
			if !FileExist(decrypt_path:=reportDir "\" accNo " " chartNo "\" (match1==crypt_acc_chart?(accNo " " chartNo):__CryptStr(match1,____, 0)) " " match2 "." SubStr(match3,1,-1))
				Crypt.Encrypt.FileDecrypt(A_LoopFileLongPath, decrypt_path,____,7,6)
			noFile:=false
		}
		if noFile
			FileRemoveDir,% reportDir "\" accNo " " chartNo
		else
			decrypted.push(reportDir "\" accNo " " chartNo)
	}
	
	for k, row in reportList {
		if(k>=start_ind)
			break
		if(k==1)
			continue
		accNo:=row.getCell("AccNo")
		,chartNo:=row.getCell("ChartNo")
		if FileExist(reportDir "\" accNo " " chartNo "\" accNo " " chartNo " 1.jpeg")
			continue
		
		crypt_acc_chart:=__CryptStr(accNo " " chartNo,____)
		FileCreateDir,% reportDir "\" accNo " " chartNo
		noFile:=true
		Loop, Files, % reportDir "\" crypt_acc_chart "\*.jpeg_"
		{
			if !RegExMatch(A_LoopFileName, "is)^(.+) (\d+)\.([^\.]+)", match)
				continue
			if !FileExist(decrypt_path:=reportDir "\" accNo " " chartNo "\" (match1==crypt_acc_chart?(accNo " " chartNo):__CryptStr(match1,____, 0)) " " match2 "." match3)
				Crypt.Encrypt.FileDecrypt(A_LoopFileLongPath, decrypt_path,____,7,6)
			noFile:=false
		}
		if noFile
			FileRemoveDir,% reportDir "\" accNo " " chartNo
		else
			decrypted.push(reportDir "\" accNo " " chartNo)
	}
}

OnExit:
for k,v in decrypted
	FileRemoveDir,% v, 1

ExitApp