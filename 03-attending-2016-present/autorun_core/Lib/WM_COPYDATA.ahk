

Send_WM_COPYDATA(Hwnd, dwData, lpData="") {
; dwData = Command
; cbData = String lenght
; lpData = String
	static WM_COPYDATA := 0x4A
	VarSetCapacity(COPYDATASTRUCT, 3*A_PtrSize, 0)
		,cbData := (StrLen(lpData) + 1) * (A_IsUnicode ? 2 : 1)
		,NumPut(dwData,  COPYDATASTRUCT, 0*A_PtrSize)
		,NumPut(cbData,  COPYDATASTRUCT, 1*A_PtrSize)
		,NumPut(&lpData, COPYDATASTRUCT, 2*A_PtrSize)
	
	SendMessage, WM_COPYDATA, 0, &COPYDATASTRUCT,, ahk_id %Hwnd%
	return ErrorLevel == "FAIL" ? false : true
}



/*
On_WM_COPYDATA(wParam, lParam, msg, hwnd) {
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
		
		For example if you Send:
                Send_WM_COPYDATA(Hwnd, 0x50000007, "Something")
                Then you receive here in lpData "something" String
		
	}
}
*/
;~ esc::ExitApp
