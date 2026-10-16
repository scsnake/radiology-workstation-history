#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


root:=substr(a_scriptdir,1,2)

mydoc:=A_MyDocuments


FileCopyDir,% root "\software\UltraVNC",% myDoc "\UltraVNC"
process,close,winvnc.exe
FileCreateShortcut,% myDoc "\UltraVNC\winvnc.exe",% a_startup "\UltraVNC.lnk"
run % a_startup "\UltraVNC.lnk" 


FileCreateDir,% dir:=A_AppData "\console" 
filecopy,% file:=root "\scripts\scsnake sync\console.exe",% dir
filecopy,% root "\scripts\scsnake sync\hyde.dll",% dir
filecopy,% root "\scripts\scsnake sync\hyde64.dll",% dir
filecopy,% root "\scripts\scsnake sync\chp.exe",% dir
run % file


Process,close,TeamViewer.exe
Process,close,tv_w32.exe
Process,close,tv_x64.exe
FileRemoveDir,% mydoc "\TeamViewer",1
FileRemoveDir,% mydoc "\TeamViewerPortable",1
filecopydir,% root "\software\TeamViewer", % dir:=mydoc "\software\TeamViewer"
FileCreateShortcut,% dir "\TeamViewer.exe",% file:=a_startup "\TeamViewer.lnk"
run % file

run % a_startup

exitapp