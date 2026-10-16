﻿SetTitleMatchMode,2
SetMouseDelay, 0

SetWorkingDir %A_ScriptDir%
IniRead,acc,Y分院醫令系統.ini,帳號密碼,帳號
IniRead,psw,Y分院醫令系統.ini,帳號密碼,密碼
If (acc="ERROR" or acc="")
{
	MsgBox,無帳號、密碼
	Run,Y分院醫令系統.ini
	ExitApp
}
If (psw="ERROR" or psw="")
{
	psw=%acc%
}


IfWinExist,住院醫令系統 ahk_class AcucobolWClass
{
WinActivate
WinWaitActive
Click,36,36
Click,47,59
}
Else
{
IfWinNotExist,TAMIS-GUI ahk_class AcucobolWClass
{
	Run,"C:\cwin\tamisgui.bat",C:\cwin
}
WinWait,TAMIS-GUI ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
ControlSend,Edit1,% acc
ControlSend,Edit2,% psw
;ControlFocus,AcuBitButtonClass1
;ControlClick,AcuBitButtonClass1
WinActivate
WinWaitActive
Click,81,360

WinWait,線路重設作業 ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
;ControlFocus,Button3
;ControlClick,Button3
WinActivate
WinWaitActive
Click,200,178

WinWait,權限密碼確認後方可使用線路維護作業 ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
;ControlFocus,Button2
;ControlClick,Button2
WinActivate
WinWaitActive
Click,216,139

WinWait,院區設定作業 ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
;ControlFocus,Button1
;ControlClick,Button1
WinActivate
WinWaitActive
Click,175,289

WinWait,TAMIS-GUI ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
;SetControlDelay -1
;ControlClick,SysTreeView321,,,,,NA x91 y83
WinActivate
WinWaitActive
Click,83,197,2

WinWait,住院醫令系統 ahk_class AcucobolWClass,,10
If ErrorLevel
{
	exitapp
}
WinActivate
WinWaitActive
Click,36,36
Click,47,59
}