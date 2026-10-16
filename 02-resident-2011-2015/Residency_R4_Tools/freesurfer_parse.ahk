#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

clipboard:=dateConv(clipboard)

return




dateConv(date1,delim="/"){
	str:=""
	loop,parse,date1,`n`r%a_space%%a_tab%
	{
		Position += StrLen(A_LoopField) + 1
		if RegExMatch(a_loopfield,"(\d+)\" delim "(\d+)\" delim "(\d+)",match)
			str.= RegExReplace(a_loopfield,"(\d+)\" delim "(\d+)\" delim "(\d+)",(match1+1911) delim match2 delim match3) substr(date1,position,1)
		else 
			str.=substr(date1,position,1)
	}
	return str
}