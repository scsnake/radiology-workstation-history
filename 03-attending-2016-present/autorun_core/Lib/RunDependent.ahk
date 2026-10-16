RunDependent(target, workingdir:="", options:="", RunWait:=false){
	Try{
		If !RunWait
			Run, % target, % workingdir, % options, cPid
		Else
			RunWait, % target, % workingdir, % options, cPid
	}Catch
		Return
	sPid := DllCall("GetCurrentProcessId"), q := Chr(0x22)	;q = quote char
	If !A_IsCompiled{
		childMonitor := "Process Exist," sPid . "`nWhile ErrorLevel" . "`n{" . "`nsleep 100" . "`nProcess Exist," cPid . "`nIf !ErrorLevel" . "`nBreak" . "`nProcess Exist," sPid . "`n}" . "`nProcess Close," cPid
		,shell := ComObjCreate("WScript.Shell"),exec := shell.Exec("AutoHotkey.exe /ErrorStdOut *"),exec.StdIn.Write(childMonitor),exec.StdIn.Close()
	}Else{
		_exit := Comspec " /q /c for /L %n in (1,0,10) do (timeout /t 1 1>NUL && (tasklist /FI " q "PID eq "
		. sPid q " 2>NUL | find /I /N " q sPid  q " 1>NUL || TASKKILL /PID "
		. cPid " /F 2>NUL) & (tasklist /FI " q "PID eq " cPid q " 2>NUL | find /I /N " q cPid q " 1>NUL || exit))"
		Run % _exit,,Hide
	}
	Return cPid
}
