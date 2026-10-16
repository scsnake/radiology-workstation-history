#include <WinClose>
WinFade(hwnd, total_time=400, WinClose=true){
	DllCall("AnimateWindow","Ptr",hwnd,"UInt",total_time,"UInt",0x90000)
	if WinClose
		SetTimerF("WinClose", (-1)*Abs(total_time), [hwnd])
}


;~ gui,new,+hwndhwnd
;~ gui,Show,w500 h500,test
;~ Sleep 1000
;~ WinFade(hwnd)

;~ esc::ExitApp