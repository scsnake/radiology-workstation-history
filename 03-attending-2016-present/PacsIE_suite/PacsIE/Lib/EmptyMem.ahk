EmptyMem(PIDtoEmpty){   ;http://www.autohotkey.com/forum/topic32876.html (first line removed)
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", PIDtoEmpty)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}