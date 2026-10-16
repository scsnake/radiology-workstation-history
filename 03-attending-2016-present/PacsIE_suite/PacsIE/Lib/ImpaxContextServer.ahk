#include <WM_COPYDATA>
DetectHiddenWindows,on

;~ ImpaxContextServer_Add("T__________")

ImpaxContextServer_Init(hwnd=""){
	static prvHwnd
	if WinExist("ahk_id " hwnd) || WinExist("ahk_id " hwnd:=prvHwnd){
		winget,ProcessName,ProcessName,ahk_id %hwnd%
		if(ProcessName="ImpaxContextServer.exe")
			return hwnd
	}
	
	process,Exist,ImpaxContextServer.exe
	if (!ErrorLevel){
		root:=SubStr(A_ScriptDir, 1, 2)
		if  FileExist(path:=root "\scripts\Radiology\MammoSR\ImpaxContextServer\ImpaxContextServer.exe")
			;~ || FileExist(path:=root "\send string by windows message\bin\Release\ImpaxContextServer.exe")
			|| fileexist(path:=A_ScriptDir "\ImpaxContextServer.exe")
			|| fileexist(path:=A_ScriptDir "\ImpaxContextServer\ImpaxContextServer.exe")
			||  fileexist(path:=a_mydocuments "\ImpaxContextServer\ImpaxContextServer.exe") 
			contextServerPath:=path
		run % contextServerPath
		winwait,ahk_exe ImpaxContextServer.exe,,5
		winminimize,ahk_exe ImpaxContextServer.exe
	}
	return (h:=WinExist("ahk_exe ImpaxContextServer.exe"))?(prvHwnd:=h):0
}

ImpaxContextServer_SendCommand(str, hwnd=""){
	Send_WM_COPYDATA(ImpaxContextServer_Init(hwnd), 0, str)
}

ImpaxContextServer_Show(AccNo, hwnd=""){
	ImpaxContextServer_SendCommand("SYNC_DISPLAY || " Trim(AccNo) " || ", hwnd)
}

ImpaxContextServer_Add(AccNo, withPrior=false, hwnd=""){
	ImpaxContextServer_SendCommand("ADD_TO_DISPLAY_LIST" (withPrior?"_WITH_PRIORS":"") " || " Trim(AccNo) " || ", hwnd)
}