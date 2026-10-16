Opt("TrayIconHide",1)
Opt("WinTitleMatchMode", 1)
Opt("WinDetectHiddenText",1)

GUICreate("error_monitor")

HotKeySet("^!z","_exitscript")

AdlibEnable("_error_occur",200)

While 1
	Sleep(200)
WEnd


Func _error_occur()
	If WinExists("AutoIt","ERROR") Then
		BlockInput(1)
		WinActive("AutoIt","ERROR")
		Send("{ENTER}")
		BlockInput(0)
		ShellExecute("copyppt.exe")				;au3->exe
	EndIf
EndFunc

Func _exitscript()
	ShellExecute("_exit.exe")		;
	Exit 
EndFunc