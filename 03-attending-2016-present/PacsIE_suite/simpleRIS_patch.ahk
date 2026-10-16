#Persistent
#NoTrayIcon
#SingleInstance,force

SetTimer,routine,500
return

routine:
ifwinexist,ahk_exe dwwin.exe,simpleRIS
{
	controlclick,Button1
	sleep 100
	run % A_ScriptDir "\simpleRIS.exe"
}
ifwinexist,simpleRIS.exe ahk_exe WerFault.exe
{
	winclose
	process,close,simpleRIS.exe
	run % A_ScriptDir "\simpleRIS.exe"
}
IfWinExist,Handle is NULL,buffer
	WinClose
IfWinExist,OpenProcess Failed,Unable
	WinClose
if !WinExist("ahk_exe simpleRIS.exe")
	ExitApp
return


~!#q::
if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey<500){
	WinClose,ahk_exe simpleRIS.exe
	ExitApp
}
return