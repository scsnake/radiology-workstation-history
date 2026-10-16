#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


process,exist,AlwaysSync.exe

if (pid:=errorlevel){
	exePath:=GetModuleFileNameExW(pid)
	regexmatch(exePath,"is)(.+)(?:\/|\\)SyncBack",match)
	iniPath:=match "\scsnakeSync_Settings.ini"
	documentPath:=match1
	fileread,ini,% iniPath
	filedelete,% iniPath
	ini:=regexreplace(ini,"172\.16\.29\.59","10.0.0.100")
	fileappend,% ini,% iniPath,utf-8
	
	
	process,close,% pid
	sleep 1000
	filecopy,% a_scriptdir "\AlwaysSync.exe",% match,1
	filecopy,% a_scriptdir "\AlwaysSync.exe",% documentPath "\scsnake",1
	filecopy,% a_scriptdir "\AlwaysSync.exe",% documentPath "\scsnake\SyncBack",1
	filedelete,% documentPath "\scsnake\tempTask.exe"
	filedelete,% documentPath "\scsnake\lastupdate.txt"
	
	run % match "\AlwaysSync.exe"
	
	
	;proxy change
	if fileexist(proxyIniPath:=documentPath "\Proxifier\Profiles\Default.ppx") {
		
		fileread,proxy,% proxyIniPath
		proxy:=RegExReplace(proxy,"172\.16\.29\.59","10.0.0.100")
		proxy:=RegExReplace(proxy,"172\.17\.29\.50","10.0.0.100")
		FileDelete,% proxyIniPath
		FileAppend,% proxy,% proxyIniPath,utf-8
		
		process,exist,Proxifier.exe
		if (ProxifierPid){
			proxifierPath:=GetModuleFileNameExW(ProxifierPid)
			process,close,Proxifier.exe
			sleep 1000
			run % proxifierPath
		}
		
	}
	
	
	
	
	
}else{
	msgbox % "No existing AlwaysSync.exe"
}

exitapp


return


GetModuleFileNameExW( p_pid ) ; by shimanov -  www.autohotkey.com/forum/viewtopic.php?t=9000

{

   if A_OSVersion in WIN_95,WIN_98,WIN_ME

   {

      MsgBox, This Windows version (%A_OSVersion%) is not supported.

      return

   }



   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )

   if ( ErrorLevel or h_process = 0 )

      return



   name_size = 255

   VarSetCapacity( name, name_size )



   result := DllCall( "psapi.dll\GetModuleFileNameExW", "uint", h_process, "uint", 0, "str"

   , name, "uint", name_size )



   DllCall( "CloseHandle", h_process )



   return, name

}