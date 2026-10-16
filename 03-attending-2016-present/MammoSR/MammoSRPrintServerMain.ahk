#SingleInstance,force
#NoTrayIcon
#Persistent
SetTitleMatchMode,2
DetectHiddenWindows,on

;~ SetTimer,HideMammoSRPrintServer,10000

SetTimer,keepRunMammoSRPrintServer,3000

return 


keepRunMammoSRPrintServer:
if !WinExist("ahk_exe MammoSRPrintServer.exe")
	try
		run % A_ScriptDir "\MammoSRPrintServer.exe"
return

;~ ~^#!+s::
;~ NoHide:=true
;~ WinShow,ahk_exe MammoSRPrintServer.exe
;~ SetTimer,hideAgain,-60000
;~ return


;~ hideAgain:
;~ NoHide:=false
;~ gosub HideMammoSRPrintServer
;~ SetTimer,HideMammoSRPrintServer,10000
;~ return

;~ HideMammoSRPrintServer:
;~ if(!NoHide)
	;~ WinHide,ahk_exe MammoSRPrintServer.exe
;~ return