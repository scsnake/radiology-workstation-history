#include <WM_COPYDATA>

OnMessage(0x4a, "getControlNameByHwnd64_On_WM_COPYDATA")

getControlNameByHwnd64(winHwnd, controlHwnd){
	SetBatchLines,-1
	DetectHiddenWindows,on
	process,Exist,getControlNameByHwnd64.exe
	if(!ErrorLevel){
		ToolTip % "Please run ""getControlNameByHwnd64.exe"""
		return
	}
	
	processID:=ErrorLevel
	
	bufSize=65536
	VarSetCapacity(var1,bufSize)
	,getName:=DllCall( "RegisterWindowMessage", "str", "WM_GETCONTROLNAME" )
	,dwResult:=DllCall("GetWindowThreadProcessId", "UInt", winHwnd)
	,hProcess:=DllCall("OpenProcess", "UInt", 0x8 | 0x10 | 0x20, "Uint", 0, "UInt", processID)
	,otherMem:=DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "PTR", bufSize, "UInt", 0x3000, "UInt", 0x0004, "Ptr")

	SendMessage,%getName%,%bufSize%,%otherMem%,,ahk_id %controlHwnd%
	DllCall("ReadProcessMemory","UInt",hProcess,"UInt",otherMem,"Str",var1,"UInt",bufSize,"UInt *",0)
	,DllCall("VirtualFreeEx","Ptr", hProcess,"UInt",otherMem,"UInt", 0, "UInt", 0x8000)
	,DllCall("CloseHandle","Ptr",hProcess)
	return var1
	
}

getControlNameByHwnd64_On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
; dwData = Command
; cbData = String lenght
; lpData = String
	dwData := NumGet(lParam+0, 0)
	,cbData := NumGet(lParam + A_PtrSize)
	,lpData := NumGet(lParam + 2*A_PtrSize)
	,lpData := StrGet(lpData)
	
	;~ str:=lpData
	
	If  (dwData = 0x50000007) ; CMD_CURRENTPOSITION
	{
		
	}
}