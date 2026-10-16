PathCombine(abs, rel="") {
    VarSetCapacity(dest, (A_IsUnicode ? 2 : 1) * 260, 1) ; MAX_PATH
    ,DllCall("Shlwapi.dll\PathCombine", "Ptr", &dest, "Ptr", &abs, "Ptr", &rel)
    Return, dest
}

;~ MsgBox % PathCombine("C:\test", "file.exe")

;~ List =
;~ (lTrim c
;~ ..\folder\.\folder\..\folder
;~ .\res\folder
;~ \Pictures
;~ ..\..\CCleaner.exe
;~ C:\hello\world\..\test.ahk
;~ folder\..\folder
;~ D:\..\file.ahk
;~ )
;~ Loop, Parse, List, `n, `r
    ;~ MsgBox, % A_LoopField . "`n" . PathCombine(A_LoopField)