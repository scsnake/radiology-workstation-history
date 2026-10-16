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
;~ onexit,onexit
ComObjError(false)

#include <portalLib>
#include <jxon>
#include <ParseTable>


clip:=Parsetable()
sid:=askForPortalIdPw()
for k,v in clip {
	chartNo:=v[1]
	,accNo:=v[2]
	
	
}