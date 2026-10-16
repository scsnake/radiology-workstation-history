process_listening_port(port){
	o:=StdoutToVar_CreateProcess(a_ComSpec " /c ""netstat -abno | findstr " port """")
	Loop,Parse,o,`n,`r
	{
		if InStr(o,"LISTENING") && RegExMatch(A_LoopField, "\d+$", m)
			return m
	}
}
