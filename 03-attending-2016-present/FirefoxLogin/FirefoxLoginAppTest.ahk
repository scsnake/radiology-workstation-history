#include <JXON>
#include <_Struct>
#include <WM_COPYDATA>

;~ testJson:={test: ["123", "/", "\"], test2: {1: 256}}
testJson:={"searchChartNo": chartNo}
Send_WM_COPYDATA(WinExist("ahk_exe FirefoxLoginApp.exe"), 0, clipboard:=jxon_dump(testJson))
ExitApp
return

esc::ExitApp


^e::
Send_WM_COPYDATA(WinExist("ahk_exe FirefoxLoginApp.exe"), 0, jxon_dump(testJson))
return

byteSize:=VarSetCapacity(str:=jxon_dump(testJson))
VarSetCapacity(msg, byteSize+4)
NumPut(byteSize, msg, 0, "UInt")
NumPut(str, msg, 4, "WStr")
FileAppend,% msg,*,utf-8
;~ FileAppend,% str,*,utf-8
MsgBox % msg
return