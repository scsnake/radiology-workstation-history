EmptyMem(PIDtoEmpty=""){   ;http://www.autohotkey.com/forum/topic32876.html (first line removed)
    if(PIDtoEmpty="")
        PIDtoEmpty:=DllCall("GetCurrentProcessId")
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", PIDtoEmpty, "Ptr")
    ,DllCall("SetProcessWorkingSetSize", "Ptr", h, "Int", -1, "Int", -1)
    ,DllCall("CloseHandle", "Ptr", h)
}