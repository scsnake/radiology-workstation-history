FileEncoding,utf-8
#include <Socket>
#include <Args>
#NoTrayIcon
#SingleInstance,Off
DetectHiddenWindows,On
SetTitleMatchMode,2
;~ #NoTrayIcon
;~ argv:=Args( "", ( A_IsCompiled ? 1 : 2 ) )

ComObjError(false)
param:=[]

if %0%
	Loop %0%
	{
		arg:=%a_index%
		param.push(arg)
	}
else 
	ExitApp

if !FileExist(printClient:=A_ScriptDir "\MammoSRPrintClient.exe")
	return

gosub serverInfo

;~ MsgBox % param.maxindex()
;~ MsgBox % sortFileListByTime(param).maxIndex()
;~ ExitApp
for k,file in sortFileListByTime(param)  {
	SplitPath,file,fileName
	Loop 3 {
		Sleep 500
		WinClose,ahk_exe MammoSRPrintClient.exe,% "Failed to sent " fileName
		;~ run % """" printClient """ " ip " " port " """ file """"
		run % runAhkExe("MammoSRPrintClient.exe") commands(ip,port,file)
		winwait,ahk_exe MammoSRPrintClient.exe,% "Successfully sent: " fileName,6
		if(!ErrorLevel){
			Loop 3
				WinClose,ahk_exe MammoSRPrintClient.exe,% "Failed to sent " fileName
			break
		}
	} 
;~ ToolTip % file
	;~ Loop 
		;~ Sleep 500
	;~ until WinExist("ahk_exe MammoSRPrintClient.exe","Successfully sent: " fileName) || !WinExist("ahk_exe MammoSRPrintClient.exe") || A_Index>20
}
ExitApp
return 

serverInfo:
IniRead,ip,% iniPath:=A_ScriptDir "\MammoSR.ini",server,ip,localhost
IniRead,port,% iniPath,server,port,54321
return

sortFileListByTime(dir, fileType="html", sortedBy="C"){
	if IsObject(dir){
		arr:=dir, sort:=[]
		for k,v in arr {
			FileGetTime, time, % v, % sortedBy
			sort[time fill0(k)]:=A_Index
		}
	}else{
		arr:=[], sort:=[]
		Loop % dir "\*." fileType {
			arr.push(A_LoopFileFullPath)
			FileGetTime, time, % A_LoopFileFullPath, % sortedBy
			sort[time fill0(A_Index)]:=A_Index
		}
	}
	ret:=[]
	for k,v in sort
		ret.push(arr[v])
	return ret
}

fill0(str, n=2){
	while StrLen(str)<n
		str:="0" str
	return str
}