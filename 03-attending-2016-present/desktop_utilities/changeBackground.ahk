COLOR_DESKTOP = 1
WHITE = 16777215 ; 0xFFFFFF in decimal
; Color values is specified in RGB as 0xbbggrr (note it's backwards)

DllCall("SetSysColors", "Int", 1, "Int*", 2, "UInt*", WHITE)