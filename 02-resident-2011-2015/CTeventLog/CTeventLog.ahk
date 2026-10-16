/*
20130408
scsnake@gmail.com
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance,off
SetBatchLines, -1
coordMode,mouse,screen
coordMode,pixel,screen
coordMode,tooltip,screen
SetTitleMatchMode,2
SetControlDelay,-1
DetectHiddenWindows,on

#include <portalLib>

WinGetText,t,Portal Login Info
if regexmatch(t,"SESSION: ([a-zA-Z0-9]{32})",match) {
	sid:=match1
	loginId:=getUserId(sid)
}else {

	askForPortalIdPw()
	sid:=login(loginId,loginPw)
}






return


guiclose:
~esc::
;~ msgbox,1,,Exit?
;~ ifmsgbox,OK
	exitapp
return