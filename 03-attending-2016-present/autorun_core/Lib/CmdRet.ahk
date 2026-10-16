CmdRet(cmd){
	clipboardOld:=ClipboardAll
	,ComObjCreate("WScript.Shell").Run("cmd /c " cmd " | clip", 0, true).StdOut.ReadAll()
	,ret:=Clipboard
	,clipboard:=clipboardOld
	return ret
}

MsgBox % CmdRet("ping 127.0.0.1")