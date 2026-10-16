/*
20130125
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

#include <portalLib>
;~ #include <httprequest>

askForPortalIdPw()
sid:=Login(loginId,loginPw)






guiclose:
~esc::
;~ msgbox,1,,Exit?
;~ ifmsgbox,OK
	exitapp
return